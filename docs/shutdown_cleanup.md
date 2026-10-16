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
