"""Exercise the CLI against real child processes, independent of Godot fixtures."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

RUNNER = Path(__file__).resolve().parents[2] / 'tools/run_smoke_tests.py'
CHILD = '''import json, os, pathlib, sys, time
p = pathlib.Path(sys.argv[sys.argv.index('--script') + 1])
mode = p.read_text()
if mode == 'timeout':
 print('PASS before hanging', flush=True); time.sleep(20)
elif mode == 'legacy_pass': print('ECONOMY_SMOKE_PASS completed')
elif mode == 'legacy_fail': print('ECONOMY_SMOKE_FAIL failure\\nPASS')
elif mode == 'script_error': print('PASS\\nSCRIPT ERROR: fixture failure')
elif mode == 'nonzero': print('PASS'); sys.exit(3)
elif mode == 'missing_pass': print('Finished without a success marker')
elif mode == 'explicit_fail': print('FAIL: fixture failure\\nPASS')
elif mode == 'isolated':
 for key in ['XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME']:
  p = pathlib.Path(os.environ[key]) / 'sentinel'; assert not p.exists(); p.write_text('test')
 print('PASS: isolated child')
else: print('WARNING: known teardown diagnostic\\nPASS: completed')
'''


class SmokeRunnerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / 'tests').mkdir()
        self.engine = self.root / 'engine'
        self.engine.write_text('#!' + sys.executable + '\n' + CHILD)
        self.engine.chmod(0o755)
        self.output = self.root / 'output'

    def run_case(self, modes, **kwargs):
        self.assertTrue(RUNNER.exists(), 'Reusable CI runner has not been implemented')
        for name, mode in modes.items():
            (self.root / 'tests' / (name + '_smoke.gd')).write_text(mode)
        return subprocess.run([sys.executable, str(RUNNER), '--project', str(self.root),
                               '--godot', str(self.engine), '--output', str(self.output),
                               '--timeout', '0.5', '--jobs', '2'], capture_output=True,
                              text=True, timeout=15, **kwargs)

    def report(self):
        return json.loads((self.output / 'summary.json').read_text())

    def test_records_diagnostics_without_hiding_success(self):
        result = self.run_case({'valid': 'valid'})
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.report()['passed'], 1)
        self.assertEqual(self.report()['tests'][0]['diagnostics'], 1)
        self.assertIn('WARNING:', (self.output / 'logs/valid_smoke.log').read_text())
        self.assertIn('valid_smoke', (self.output / 'summary.md').read_text())

    def test_rejects_each_false_success_signal(self):
        result = self.run_case({m: m for m in ['script_error', 'nonzero', 'missing_pass', 'explicit_fail']})
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.report()['passed'], 0)
        self.assertEqual(self.report()['failed'], 4)

    def test_accepts_existing_underscore_delimited_pass(self):
        result = self.run_case({'economy': 'legacy_pass'})
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(self.report()['passed'], 1)

    def test_rejects_underscore_delimited_failure_even_with_pass(self):
        result = self.run_case({'economy': 'legacy_fail'})
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.report()['failed'], 1)

    def test_timeout_fails_even_after_pass_marker(self):
        result = self.run_case({'slow': 'timeout'})
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.report()['tests'][0]['reason'], 'timeout')

    def test_parallel_children_get_fresh_isolated_data(self):
        result = self.run_case({'one': 'isolated', 'two': 'isolated'})
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(self.report()['passed'], 2)

    def test_empty_suite_is_not_success(self):
        result = self.run_case({})
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('No smoke scripts', result.stderr)

    def test_missing_engine_is_reported_as_failure(self):
        self.engine.unlink()
        result = self.run_case({'valid': 'valid'})
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.report()['failed'], 1)
        self.assertIn('launch', self.report()['tests'][0]['reason'])


if __name__ == '__main__':
    unittest.main()
