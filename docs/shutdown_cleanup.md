# Resource and shutdown cleanup — 2026-10-16

## Confirmed causes and fixes

- Combat layout and preview routines could retain shader/material resources when a scene was freed before a frame-awaited coroutine resumed. Node-bound, one-shot callbacks preserve the existing layout delays and disconnect when their controller is freed.
- Replacing heading fonts could release the previous font while a synchronous theme notification still reshaped cached text. Keep that font alive through replacement, preserving the existing font families and styling.
- The settlement music test left its final title-screen music fixture running. Dispose that scene before ending the test.
- The Windows export preset lacked the legacy `runnable` field read by the pinned editor. Supply it alongside the existing runnable-presets configuration.

No artwork, combat damage, skill costs, rewards or balance were changed. Engine diagnostics remain enabled.

## Evidence and limits

The new `scene_cleanup_smoke` reproduces heading replacement and checks that ordinary, boss and skill-preview scenes release their nodes and layout materials when immediately freed. Before the fixes, the actual event-screen fixture emitted invalid font-data errors and the combat cases retained their materials. After the fixes, this regression passes without diagnostics. A focused 24-test run passed; editor import completed without errors; all eight runner contract tests passed.

Intermittent shutdown resource reports remain under investigation. The full run reported them in apothecary-flow, passage-combat, visual-foundation and Witch Hunter; earlier targeted runs also reported corridor. The baseline had diagnostics in 19 tests versus five in this full run (one of the five is deliberate guild-hall corruption output). These are run observations, not a deterministic leak-rate measurement. Verbose reproductions named `scripts/passage_events.gd` in passage combat and WAV playback/stream resources in Witch Hunter; this alone does not establish a production ownership defect. Additional fixture settling did not reliably eliminate the reports, so those speculative changes were discarded. The guild-hall tests deliberately exercise corrupt configuration files and retain their expected parse-error output.

The full local suite passed **102/102 smoke scripts**, including the longer expedition lifecycle check. All eight Python runner tests passed, and editor import completed without errors. Hosted CI is linked from the commit’s Actions run. This work reduces reproduced diagnostics; it does not certify universal leak-free engine shutdown.

## Follow-up: remaining travel and audio reports

The passage report came from `resume_map_travel()` retaining its local passage-events script across `await travel.finished`. An ambush changes scenes without emitting that signal. A one-shot callback bound to the dungeon node now releases the continuation when that scene is freed, while retaining run/floor validation and normal arrival handling. It is connected before adding the travel node so completion during initialization is also observed.

The other reproduced reports were test shutdown timing. Settlement music intentionally survives scene changes, and stopped WAV playback is released by the audio thread rather than synchronously with a render frame. A probe observed playback references release after 34 ms; adding render frames alone was insufficient. The affected tests now stop players, dispose their fixtures, and wait for weak playback references to clear with a two-second deadline. A timeout fails the test. This helper is test-only and does not suppress engine diagnostics or change in-game sound behavior.

Before these changes, verbose passage-combat, apothecary-flow and visual-foundation runs reproduced the script/MP3 reports, and the earlier Witch Hunter run reproduced WAV reports. Afterward, all seven focused checks passed with zero diagnostics, and verbose reruns of those first three tests were clean. Editor import completed without errors. This identifies and fixes the reproduced causes; future regressions remain visible in CI logs.

## Stress follow-up: voices retired before teardown

The initial helper could return success while playbacks stopped or replaced before teardown remained alive: those objects were no longer exposed by their players. The new `audio_teardown_smoke` starts and stops a WAV 20 times, retains only weak playback references, and verifies that every reference is cleared after cleanup. Against the old helper it failed with all 20 references still alive; with the revised helper it passes with zero remaining.

The helper now starts a silent, looping, signed-16-bit zero-sample playback **after** issuing the existing stop requests. It stops that playback and includes its weak reference in the existing deadline-based wait. Starting it before the other stop requests was insufficient in stress testing. This is a test-only synchronization aid; it does not change game audio, disable logging, or establish a universal audio-server drain guarantee. Item, status-visual and survivor-XP fixtures now use the same helper.

The final strict stress run passed **20/20 isolated processes with zero diagnostics**: four repetitions each of audio-teardown, corridor, unique-items, status-visual and survivor-XP. Each used fresh XDG directories, Godot's Dummy audio driver and verbose output; a nonzero exit, missing PASS or any warning/error/failure output failed the case. [Structured results and source hashes](audio_teardown_stress.json) record this run. These bounded timing observations do not certify every platform or future run. Guild-hall corruption diagnostics remain intentional and excluded from this focused stress selection.

To repeat a group with the existing runner, choose a fresh output directory each time:

```sh
python3 tools/run_smoke_tests.py audio_teardown corridor items_unique status_visual survivor_xp --output artifacts/audio-repeat-1
```

Inspect both pass results and diagnostic counts in `summary.json`: the general runner preserves diagnostics without treating every engine warning as failure. The dedicated retired-playback regression itself fails when its weak references remain alive.
