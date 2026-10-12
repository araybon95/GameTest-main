# Boss clarity, playback, campaign economy and saved journeys

12 October 2026. Implements the requested steps 4–8. Available validation runtime: Godot 4.6.3.

## Boss clarity

A persistent tactics panel now covers passive bosses as well as clickable objectives:

- The Undying Lord shows whether living support can restore up to 8 HP each enemy turn, then switches to **TRIBUTE STOPPED** after support dies.
- The Son and Oleander show **GUARDING**, **HEAVY STRIKE** or **EXPOSED**, explaining the current damage modifier and next opening.
- Coterie shows the current form out of three and whether its rite is intact, awaiting suppression or spent. A disabled action explains that a living hero needs 1 AP.
- Giant chains show remaining protection and the effect of severing a chain. The Head's idol shows the current Prayer stress/Chill cost. Exuvia shows the live cocoon's remaining enemy turns before hatching.

These cues read existing battle state. Passive bosses receive no clickable prop or AP action. Fixed an existing objective-state cleanup issue: consuming an action on an empty objective previously added a stray suppression flag. Empty passive objectives now stay empty, and the UI requires an actual objective kind before displaying a prop. Combat numbers and boss effects are unchanged.

## Combat pacing

**F10 → Combat playback** offers **1× Original**, **1.5× Brisk** and **2× Fast**. The choice persists and applies to attack animation and boss-reveal clocks; the default remains 1×. Release/contact sounds and feedback remain tied to the same animation boundaries. The current action continues to block combat shortcuts until its presentation completes. HP, AP, cooldowns, turn order and RNG are not accelerated or altered.

Measured a queued heavy strike, bow shot and spell with actual presentation processing:

| Playback | Profile duration | Measured wall time |
| --- | ---: | ---: |
| 1× | 2.89 s | 2.902 s |
| 1.5× | 2.89 s | 1.942 s |
| 2× | 2.89 s | 1.462 s |

These are one sequence per speed on this worker, not a frame-rate benchmark or full human expedition. Popup readability, cinematic feel and audio still benefit from human review. Corridor travel, turn rules and unrelated UI transitions retain their existing timing.

## Broader earned-equipment campaigns

Extended `ordinary_playthrough.gd` so `campaign` accepts a seed, third hero and route. Defaults remain seed 2026, Occultist and cautious routing. Healer and Crusader campaigns train earned points before Path of the Beast; the harness now respects each training stat's six-upgrade cap and falls back to another legal stat. Crusader test campaigns start with that class unlocked.

Ran **12 fresh campaigns**: Warden/Ranger plus Healer or Crusader, on seeds **7, 27, 42, 62, 99 and 2026**, using prepared routing and earned gear. This produced **16 expedition runs**: 12 Old Road attempts and four progressed Path attempts. There are no starting gear fixtures, forced kills, damage/HP/gold grants or mid-run training. Presentation waits are skipped. The planner knows generated camp, merchant and encounter locations while actual moves still validate discovered legal routes. One combat seed is used per layout. These are exploratory automated cases, not human player win rates; the three known route outliers are deliberately included.

| Seed | Healer Old Road | Healer progressed Path | Crusader Old Road | Crusader progressed Path |
| --- | --- | --- | --- | --- |
| 7 | Complete | Complete | Retreat after casualty, floor 2 | Not attempted |
| 27 | Retreat after casualty, floor 3 | Not attempted | Defeat, floor 3 | Not attempted |
| 42 | Retreat after casualty, floor 2 | Not attempted | Retreat after casualty, floor 2 | Not attempted |
| 62 | Retreat after casualty, floor 3 | Not attempted | Retreat after casualty, floor 2 | Not attempted |
| 99 | Complete | Complete | Retreat after casualty, floor 2 | Not attempted |
| 2026 | Complete | Complete | Complete | Complete |

All retained campaign processes exited 0 without script/assertion failures; noncompletions are valid outcomes. Preliminary additional runs with the passive-prop UI error or the harness training-cap error were excluded and rerun. Initial 27/62/99 cases precede the presentation changes and detailed shop ledger; their combat/price tables are unchanged. The report identifies this distinction rather than attributing their results to final UI-file bytes. Retained logs can still contain the harness's ObjectDB/resource shutdown warnings and are not clean leak checks.

The Crusader party completes only seed 2026 in this sample, while the Healer party completes three seeds. That identifies a focused survival/tactics follow-up, not proof that Crusader needs a universal buff. Prepared routing adds fights and can increase attrition; the greedy policy is not an optimal human strategy. Once earned progression is established, all four observed Veteran attempts complete.

See [campaign traces, economy fields and final source hashes](boss_pacing_campaign_save_review.json).

Reproduce after import, isolating application data for each run:

```sh
XDG_DATA_HOME=/tmp/ashen-review-7-healer godot --headless --path . \
  --script res://tests/ordinary_playthrough.gd -- campaign 7 healer prepared
XDG_DATA_HOME=/tmp/ashen-review-2026-crusader godot --headless --path . \
  --script res://tests/ordinary_playthrough.gd -- campaign 2026 crusader prepared
```

## Economy review

Prices remain basic weapon/armour **8 gold each**, healing potion **8**, rare equipment **40**, epic **100** and unique **150**. Equipment sales remain 25% of value, rounded down. A full three-person basic weapon/armour set costs 48 gold before consumables, so a fresh zero-gold party must equip gradually from purchases and drops.

Added actual before/after transaction telemetry to shop visits. Purchases are recorded only when the handler succeeds; failed potion purchases stop the stocking loop. This does not change successful shopping decisions. Initial cases lack the added totals and are marked `null`, not zero.

For successful cases with the detailed ledger:

| Expedition / party / seed | Starting gold | Shop spending | Sale income | Other net gold* | Ending gold |
| --- | ---: | ---: | ---: | ---: | ---: |
| Old Road / Healer / 7 | 0 | 40 | 10 | 50 | 20 |
| Old Road / Healer / 2026 | 0 | 64 | 68 | 56 | 60 |
| Old Road / Crusader / 2026 | 0 | 64 | 62 | 53 | 51 |
| Path / Healer / 7 | 20 | 64 | 172 | 91 | 219 |
| Path / Healer / 2026 | 60 | 72 | 167 | 111 | 266 |
| Path / Crusader / 2026 | 51 | 16 | 2 | 98 | 135 |

*Other net gold = ending − starting + shop spending − sales. It captures net gold movement outside shop purchases/sales, not a claim of gross income from a particular source.

Early failures end with 1–35 gold across the retained cases; successful progressed Path runs end with 135–266. Some veteran surpluses are driven heavily by selling accumulated equipment. However, the policy only buys missing basics and healing potions, and keeps earned improvements. It does not weigh optional rare/epic/unique purchases, restoration spending or alternate human budgets. A surplus under this policy therefore does not establish that prices are too low, and an early loss does not establish that all gear is too expensive.

**Decision:** keep price, payout and sale values unchanged. The next economy-specific measurement should compare players' higher-tier purchases and preparation budgets against retained loot, rather than tuning from ending gold alone.

## Save/resume usability

Saved slots now preview their party classes/levels alongside the existing time, expedition/floor and gold summary. F10 explains why saving is unavailable during a hallway, encounter or title screen. Replacing an occupied manual slot prompts with that slot's summary; canceling preserves its contents. Load confirmation identifies the chosen journey, and AUTO pauses while settings/previews are open so it cannot change under the confirmation.

Unreadable files, unsupported versions and invalid journey structures are distinguished from empty slots, with loading disabled and an explanatory tooltip. The title's Continue button requires a loadable checkpoint. Load validation checks party uniqueness, typed lists/records/numbers, equipment and hero details, current maps/locations, hero state and status shapes before applying any saved state. Rejection leaves the current journey and file unchanged.

Version-1 saves lacking later optional fields remain supported: formation positions normalize and an active journey gets the existing legacy fallback when absent. This is not a migration for unsupported versions. Equipment, modifications, wounds, status and loot RNG remain saved; mid-combat saving is not introduced. Atomic file replacement and the existing memorial merge behavior are retained.

## Verification

Nine relevant checks passed: boss clarity/playback, save validation, boss objectives, combat performance, presentation, settings/saves, economy, controls guide and the full run milestone. The full lifecycle covers three floors, rewards, camps/orbs, checkpoint/RNG round trips, retreat, defeat, memorials and Coterie phases. A concurrent 180-second lifecycle attempt timed out; a longer retry completed. Its controlled victories test state consistency rather than ordinary difficulty.

Some presentation/campaign checks retain ObjectDB/resource shutdown warnings. Functional assertions pass; this review does not establish leak-free shutdown.

The new save test includes corrupt active and inactive hero records, repeated party members, bad map/position/equipment/progression/inventory/status/detail types, unsupported versions, older optional fields, equipment modifications, overwrite cancellation, paused AUTO previews and a normal UI load with preserved wounds and gear.

Native 1280×720 captures were inspected for the Lord's live/stopped tribute, guarded/exposed Son, Coterie rite, playback/settings layout and overwrite confirmation. The source screenshot fixtures place bosses in a controlled stage and do not establish encounter balance or a complete human playtest.
