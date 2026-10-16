"""Run Godot smoke scripts with isolated user data and reviewable results (Linux)."""
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import tempfile
import time


def stop(process):
    if process.poll() is not None:
        return
    try:
        os.killpg(process.pid, signal.SIGTERM)
        process.wait(timeout=2)
    except subprocess.TimeoutExpired:
        os.killpg(process.pid, signal.SIGKILL)
        process.wait()
    except ProcessLookupError:
        process.wait()


def run_test(script, args, output):
    log = output / 'logs' / (script.stem + '.log')
    started = time.monotonic()
    reason = ''
    code = None
    limit = max(args.timeout, 600) if script.stem == 'run_milestone_smoke' else args.timeout
    with tempfile.TemporaryDirectory(prefix=script.stem + '-') as folder:
        env = dict(os.environ)
        for key, part in [('XDG_DATA_HOME', 'data'), ('XDG_CONFIG_HOME', 'config'),
                          ('XDG_CACHE_HOME', 'cache')]:
            target = Path(folder) / part
            target.mkdir()
            env[key] = str(target)
        with log.open('w') as stream:
            try:
                process = subprocess.Popen([args.godot, '--headless', '--audio-driver', 'Dummy',
                                            '--path', str(args.project), '--script', str(script)],
                                           cwd=args.project, env=env, stdout=stream,
                                           stderr=subprocess.STDOUT, start_new_session=True)
            except OSError as error:
                stream.write('Unable to launch Godot: ' + str(error) + '\n')
                reason = 'launch_error'
            else:
                try:
                    while process.poll() is None:
                        if 'SCRIPT ERROR:' in log.read_text(errors='replace'):
                            reason = 'script_error'
                            break
                        if time.monotonic() - started > limit:
                            reason = 'timeout'
                            break
                        time.sleep(0.1)
                finally:
                    stop(process)
                code = process.returncode
    content = log.read_text(errors='replace')
    if not reason:
        if 'SCRIPT ERROR:' in content:
            reason = 'script_error'
        elif code != 0:
            reason = 'exit_' + str(code)
        elif re.search(r'(?<![A-Za-z0-9])FAIL(?:ED)?(?![A-Za-z0-9])', content):
            reason = 'failure_marker'
        elif not re.search(r'(?<![A-Za-z0-9])PASS(?![A-Za-z0-9])', content):
            reason = 'missing_pass_marker'
    return {'test': script.stem, 'passed': not reason, 'reason': reason,
            'exit_code': code, 'seconds': round(time.monotonic() - started, 2),
            'diagnostics': sum(line.lstrip().startswith(('ERROR:', 'WARNING:', 'SCRIPT ERROR:'))
                               for line in content.splitlines()),
            'log': 'logs/' + log.name}


def write_summary(output, results, total):
    ordered = sorted(results, key=lambda row: row['test'])
    passed = sum(row['passed'] for row in ordered)
    report = {'total': total, 'completed': len(ordered), 'passed': passed,
              'failed': len(ordered) - passed, 'tests': ordered}
    (output / 'summary.json').write_text(json.dumps(report, indent=2) + '\n')
    lines = ['# Godot smoke tests', '', f'{passed}/{total} passed; {len(ordered)}/{total} completed.', '',
             'Engine warnings/errors remain in logs; script errors and explicit failure markers fail the run.', '',
             '| Test | Result | Seconds | Diagnostics |', '| --- | --- | ---: | ---: |']
    for row in ordered:
        status = 'PASS' if row['passed'] else 'FAIL: ' + row['reason']
        lines.append(f"| {row['test']} | {status} | {row['seconds']} | {row['diagnostics']} |")
    (output / 'summary.md').write_text('\n'.join(lines) + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('tests', nargs='*', help='Optional test names, e.g. save_validation')
    parser.add_argument('--project', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--godot', default='godot', help='Godot executable')
    parser.add_argument('--output', type=Path, default=Path('artifacts/smoke'))
    parser.add_argument('--jobs', type=int, default=2)
    parser.add_argument('--timeout', type=float, default=180)
    args = parser.parse_args()
    args.project = args.project.resolve()
    if args.jobs < 1 or args.timeout <= 0:
        parser.error('Jobs and timeout must be positive')
    directory = args.project / 'tests'
    if args.tests:
        tests = [directory / (name if name.endswith('.gd') else name + '_smoke.gd')
                 for name in args.tests]
        if any(p.parent != directory or not p.is_file() for p in tests) or len(set(tests)) != len(tests):
            parser.error('Choose existing, unique test names from the project tests directory')
    else:
        tests = sorted(directory.glob('*_smoke.gd'))
    if not tests:
        parser.error('No smoke scripts found')
    output = args.output.resolve()
    if output.exists() and any(output.iterdir()):
        parser.error('Use an empty output directory to avoid stale results')
    (output / 'logs').mkdir(parents=True, exist_ok=True)
    results = []
    write_summary(output, results, len(tests))
    print(f'Running {len(tests)} smoke scripts with {args.jobs} isolated workers', flush=True)
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        pending = [pool.submit(run_test, script, args, output) for script in tests]
        for future in as_completed(pending):
            row = future.result()
            results.append(row)
            write_summary(output, results, len(tests))
            print(f"{len(results)}/{len(tests)} {row['test']}: "
                  f"{'PASS' if row['passed'] else 'FAIL ' + row['reason']} ({row['seconds']}s)", flush=True)
    passed = sum(row['passed'] for row in results)
    print(f'RESULT: {passed}/{len(tests)} passed; reports: {output}', flush=True)
    return 0 if passed == len(tests) else 1


if __name__ == '__main__':
    raise SystemExit(main())
