# Hooded Ash Raider

The first enemy variant is a hooded road butcher with patched leather, rusted
iron and a chipped cleaver. It is a cosmetic appearance of the existing Ash
Raider: name, statistics, skills, XP, loot and encounter pools are unchanged.

Open [the animation preview](enemy_variants_preview.html) in a browser to inspect
the idle, attack, hurt and death sequences. It reads the same measured frame
regions and anchors used by Godot. This is an artwork preview, not game playback.

The transparent painted sheet has 12 frames:

| Indices | Sequence |
| --- | --- |
| 0–2 | Painted idle alternatives (retained; live breathing uses pose 0) |
| 3–7 | Early windup, raised cleaver, swing, contact, recovery |
| 8–9 | Hurt recoil |
| 10–11 | Knee collapse, final fallen body |

Original and hooded Raiders are selected from the run seed, floor, room position
and enemy slot, using a cosmetic hash rather than a gameplay random generator.
Reopening the same encounter retains its appearances. Existing saves need no
migration; previously saved runs can display the variant on their next combat.

The combat presentation samples windup and swing frames from its existing attack
profile. Contact remains at the existing impact cue; recovery and death follow
the existing timeline. Upper-body breathing pauses while the actor is hidden, dead, or a
settings/help modal is open. Reduced motion disables upper-body breathing and uses one
frame per combat state; existing combat presentation settings still apply.

Measured atlas regions exclude neighboring sprites. Frames use a common
400-pixel canvas and registered horizontal anchors, with painted bottoms placed
on the canvas baseline. No extra runtime scaling is used to interpolate limbs.
Some painted pose-to-pose differences remain; this is a first frame-based pass.

Verification:

```sh
godot --headless --path . --script res://tests/enemy_variants_smoke.gd
```

The test exercises seeded selection, original-art fallback, all twelve
nonempty frames, grounding, real combat windup/contact/recovery, reduced motion,
defeated-art retention, and unchanged enemy stats/gameplay RNG.

## Validation results (14 October 2026)

All 91 smoke scripts reached their PASS outcome. The initial full run stopped
at the old single-pose death assertion in `combat_performance_smoke`; that
assertion now checks both death frames for the variant and preserves the old
expectation for original enemies. The targeted rerun passed.

The new variant suite and the updated combat suite pass without runtime errors.
The full headless run is not diagnostic-free. The following scripts emitted
messages despite their PASS results; equivalent diagnostic categories were
reproduced against the unchanged HEAD baseline:

| Script | Diagnostic |
| --- | --- |
| `apothecary_flow_smoke` | Resources or renderer objects still live at shutdown |
| `apothecary_smoke` | Resources or renderer objects still live at shutdown |
| `beast_smoke` | Resources or renderer objects still live at shutdown |
| `boss_clarity_pacing_smoke` | Resources or renderer objects still live at shutdown |
| `camp_merchant_smoke` | Resources or renderer objects still live at shutdown |
| `corridor_smoke` | Resources or renderer objects still live at shutdown |
| `events_smoke` | Headless font metrics |
| `exploration_polish_smoke` | Headless font metrics |
| `guild_hall_smoke` | Intentional corrupt-config rejection |
| `items_unique_smoke` | Resources or renderer objects still live at shutdown |
| `keep_smoke` | Resources or renderer objects still live at shutdown |
| `mechanics_smoke` | Resources or renderer objects still live at shutdown |
| `multi_enemy_smoke` | Resources or renderer objects still live at shutdown |
| `passage_combat_smoke` | Resources or renderer objects still live at shutdown |
| `settlement_music_smoke` | Resources or renderer objects still live at shutdown |
| `status_visual_smoke` | Resources or renderer objects still live at shutdown |
| `survivor_xp_smoke` | Resources or renderer objects still live at shutdown |
| `visual_foundation_smoke` | Resources or renderer objects still live at shutdown |
| `visual_journey_smoke` | Headless font metrics |

Shutdown reports vary with teardown timing: `apothecary_flow_smoke` and
`items_unique_smoke` were clean in the baseline rerun, while other baseline
scripts reproduced the resource-leak category. These remain diagnostics to
investigate separately; the functional results are not a claim of clean teardown.
Godot graphical gameplay was not verified in this headless session.

## Grounded breathing revision

Idle uses pose 0 continuously. The shader moves the upper body by up to six
source pixels on a smooth 1.6-second breath, fading the deformation to zero
above the hips. Legs and feet sample unchanged source pixels. Whole-body idle
scaling is disabled for the variant. Attack portraits clear the breathing
uniform so the idle deformation cannot affect action frames.

The dedicated [breathing preview](../experimental/hooded-raider-breathing.gif)
renders the same deformation formula. Its 32 frames are checked for identical
lower-body pixels. This preview isolates breathing from attack/hurt/death pose
changes; those still use the painted action frames.

The grounded-breathing revision passed all 91 functional smoke scripts; 16
scripts still emitted headless/teardown diagnostics. The new variant test was
clean. GPU gameplay rendering remains unverified. The encoded GIF was decoded
and checked: all 32 lower-body regions are byte-identical, while upper-body
pixels change across the cycle.

## Forearm and cleaver refinement

Localized source-pixel masks add up to 0.9 pixels of horizontal sway and 1.8
pixels of vertical movement to the lower arms. The cleaver and gripping hand
share a translation. A feathered diagonal boundary separates the left arm and
blade from the left leg; the right forearm mask ends above the thigh. The torso
breath and its 1.6-second timing are unchanged. Preview verification now checks
protected leg and boot regions rather than every row below the hips, because
the blade itself extends below that line.

The forearm/cleaver revision passed all 91 functional smoke scripts. The new
variant suite is diagnostic-free; 18 existing suites emitted headless/teardown
diagnostics. The decoded GIF also passed protected leg/boot pixel comparisons
and a check that the weapon actually changes position. GPU gameplay output
remains unverified. The approved gameplay implementation uses the same breathing and limb-sway
formula as the experimental preview.
