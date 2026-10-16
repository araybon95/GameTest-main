# Automated regression checks

The **Regression checks** GitHub Actions workflow runs on pushes, pull requests and manual dispatch. Its **Godot smoke suite** job installs Godot **4.6.3** from the official Linux release, verifies its pinned SHA-512 checksum, checks the Python runner, imports the project and executes every root `tests/*_smoke.gd` script.

The job uses Ubuntu 24.04, read-only repository permissions and pinned action revisions. It caches imported artwork by engine/assets/import settings, then always runs the editor import to refresh changed resources. It does not need project secrets or deploy the game.

## Results

Open the repository's **Actions → Regression checks** page, select a run and inspect the job summary. Download its `regression-logs-…` artifact for:

- `godot-version.txt`, `runner-tests.log` and `import.log`;
- `smoke/summary.json` and `smoke/summary.md`;
- one log per Godot smoke script under `smoke/logs/`.

Logs/results are retained for 14 days, including failed runs when the job reaches the upload step. Canceled or timed-out runs can have partial results; compare completed count with total. A missing setup/report is not a successful test run.

Each test runs in a separate process with fresh temporary application-data/config/cache directories. Those temporary save directories are removed afterward; logs and summaries are retained. The Beast test's progression fixture uses its isolated `user://` directory rather than the source tree.

A test passes only when it exits zero, prints a delimited `PASS` signal (including legacy labels such as `ECONOMY_SMOKE_PASS`), and has no `SCRIPT ERROR:` or explicit `FAIL`/`FAILED` marker. A timeout fails even if a PASS was printed first. Tests have a 180-second limit; the multi-expedition `run_milestone_smoke` has at least 600 seconds. Two workers keep CPU/memory use bounded. The entire job has a 35-minute limit; a newer run of the same Git ref cancels an older run.

Existing non-script engine/config/shutdown diagnostics remain visible and counted in summaries. They do not by themselves make a test fail: the guild-hall corruption tests intentionally print configuration parse errors. Previously reproduced resource teardown reports are addressed by the shutdown follow-up; any future engine diagnostics remain visible. The font replacement and export-preset warnings were corrected in the [shutdown cleanup](shutdown_cleanup.md). This workflow does not certify clean shutdown or replace human visual/balance review.

## Run locally on Linux

Use Godot 4.6.3 on `PATH`, Python 3 and an imported checkout:

```sh
python3 -m unittest discover -s tests/ci -v
godot --headless --audio-driver Dummy --editor --path . --import
python3 tools/run_smoke_tests.py --output artifacts/smoke
```

Choose an empty output directory for each invocation to prevent stale reports. To select a few tests or another executable:

```sh
python3 tools/run_smoke_tests.py save_runtime_validation beast --godot /path/to/godot --output artifacts/focused
```

Reports and Python caches are ignored by Git. The runner uses only the Python standard library. CI checks required artwork through the existing project-art and art-library resource smoke scripts.

The eight runner contract tests launch small external child-process fixtures to verify isolation, timeout and failure detection; they do not simulate game correctness. The Godot suite supplies the game checks.

To update Godot, change `GODOT_VERSION`, the import-cache version and `.github/godot-linux.sha512` together, obtaining the archive hash from the new official release's `SHA512-SUMS.txt`. Verify the new engine and run the suite before publication.

Branch protection is not modified by this workflow. A repository owner can separately require **Godot smoke suite** before merging if desired.
