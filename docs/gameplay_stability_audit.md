# Gameplay stability audit — 2026-10-16

The audit found and fixed a save-validation defect: malformed saves could be advertised as loadable, then partially replace the active journey before a script error. The fix rejects the reproduced malformed records before any state assignment. Artwork and gameplay balance values were preserved.

## Confirmed defect and correction

**GSA-001 — incomplete validation before loading.** A version-1 save with an integer `run_id` passed the original validator. Loading changed gold from 91 to 19 before failing to assign the run identity. Additional nested hero, status, buff, journey, journal, report and enemy-roster shapes could also reach consumers without sufficient checks.

`scripts/save_files.gd` now checks those consumer-required types and record fields at the existing validation boundary. The save format, serialization and gameplay rules are unchanged. A fresh code review reproduced two related hallway failures: missing traversal `event_done`, and a curio without `room.event_id`. Both are included in the correction.

`tests/save_runtime_validation_smoke.gd` covers 30 malformed variants. Rejected loads must return false, preserve the active state (including inventory, equipment, heroes, journey, progression and RNG), and leave the file untouched. Compatibility controls cover older optional-field omissions, valid damage-over-time variants, minimal Chill, buffs, complete hallway records, wounds and RNG continuation. The initial 26 cases failed before the first fix; the four review cases failed before the hallway correction.

## Verification

- Engine: Godot 4.6.3, headless, with separate application-data/config/cache directories for each test.
- Baseline: all 100 existing root smoke scripts passed.
- Focused verification: six save/journey/history tests passed after the first correction; five save/hallway tests passed after review corrections.
- Final full suite: **101/101 passed**, including the new 30-case regression; no script errors or timeouts. 18 scripts emitted engine/config/teardown diagnostics, versus 16 at baseline. Results are recorded in `review-output/2026-10-16-gameplay-audit/final-results.json`.
- Existing coverage exercises save/resume, equipment and inventory transactions, exactly-once rewards, expedition completion/retreat/defeat, cooldowns and targeting. Witch Hunter tests verify Binding Sigil applies Weakness, guarding does not consume it, and exactly two enemy attack actions consume it.

Two additional bounded automated playthroughs used actual actions, earned equipment and prepared routes through Old Road (seed 2026), with Warden/Ranger plus:

| Third hero | Outcome | Fights | Ending floor |
| --- | --- | ---: | ---: |
| Healer | Expedition complete | 12 | 3 |
| Witch Hunter (`crusader` internal ID) | Retreat after casualty | 8 | 2 |

These use the existing playthrough harness and skip cinematic waits. They are functional checks, not human playtests or balance/win-rate estimates. The separate lifecycle regression uses controlled encounters to verify progression and reward ownership.

## Limits and preservation

This audit does not certify every possible corrupt save or profile-progression file. It addresses reproduced load-boundary failures and their related consumer shapes. Headless font/resource teardown diagnostics are recorded separately from functional results; leak-free shutdown is not claimed. The final run had diagnostics in 18 scripts versus 16 at baseline: `apothecary_flow_smoke` and `corridor_smoke` additionally reported ObjectDB/resource teardown warnings. Those shutdown warnings were not investigated or attributed to the save correction. No artwork, ability values, prices, AP costs, cooldown durations or RNG rules were tuned. Prior pending art/presentation repairs remain intact. The audit originally completed locally; its reviewed fixes are included in the subsequent repository cleanup publication.

The [compact evidence record](gameplay_stability_evidence.json) preserves counts, outcomes and tested source hashes. Raw logs, reviewer reproductions and agent plans remain in the ignored local `review-output/` directory rather than the published tree.

## Automated follow-up

The recommended GitHub Actions regression gate is now implemented. See [Automated checks](automated_checks.md) for the pinned Godot version, isolated save directories, required PASS/error/timeout rules and downloadable logs. It checks the existing suite without changing gameplay values. Shutdown/resource diagnostics remain a separate scoped investigation.
