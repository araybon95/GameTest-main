# Expedition readiness and attack timing

10 October 2026. This pass implements preparation guidance, survivor XP and distinct attack presentation.

## Before departure and descent

Preparation shows each hero's chosen name, class, level, maximum health, equipped items and unspent training points. Veteran expeditions suggest level 3 or higher, trained stats and equipment earned in earlier expeditions. These suggestions do not block embarking. Supply purchases and formation choices retain their existing behavior.

The floor entrance shows the actual party health, Stress, Death's Door, fallen companions and active debuffs alongside the next floor's threats. Recovery advice lists only discovered, unused camps on the current floor. Unexplored camps remain hidden. Staying preserves the current floor; descending advances once. Camp recovery remains a single use that restores living heroes to full health, removes debuffs and reduces their current Stress by 90%.

## Survivor XP

Living heroes earn victory XP even at 0 HP/Death's Door. Dead, missing and nonparty heroes remain excluded. XP amounts, the once-per-encounter award, Coterie's final-form reward and training rules are unchanged. See [survivor_xp.md](survivor_xp.md) for focused tests and one ordinary-action run confirming the new eligibility rule.

## Distinct attacks

The controller passes skill identifiers to a presentation-only timing registry. Light cuts have a short windup; heavy strikes pull back longer and hold contact. The Crusader braces before advancing for a charge, the Ranger draws and recoils on release, and spells prepare before casting. Each sequence recovers to the original planted stance. Existing portraits and measured pose assets are reused.

| Profile | Release | Contact | Total duration |
|---|---:|---:|---:|
| Light | 0.12 s | 0.25 s | 0.66 s |
| Heavy | 0.36 s | 0.50 s | 1.06 s |
| Charge | 0.23 s | 0.39 s | 1.00 s |
| Bow | 0.31 s | 0.46 s | 0.86 s |
| Spell | 0.35 s | 0.51 s | 0.97 s |

Boss actions using these profiles extend the timings by 12%. Attack sounds play at release and fully blocked impacts sound at contact. Each multi-hit action owns its cues. Skipping a visible sequence emits each remaining cue once; leaving combat or discarding a queued action with a freed participant cancels its cues. Status ticks remain distinct from fresh attacks, and blocked hits and misses keep their existing harmless reactions. The charge settles the exchanged formation before its portrait is staged, avoiding overlap with the displaced ally and a jump when recovery ends.

Damage, accuracy, AP, cooldowns, status calculations and rewards still resolve in the controller. Animation, feedback and sound playback cannot apply them again. Reduced motion retains pose and cue timing while removing travel, rotation and camera movement. Older calls without profile metadata preserve their original presentation clock.

## Verification

Focused regressions cover readiness without progression or map mutation; supplies and formation; hazardous and fallen party states; camp secrecy and recovery; single descent/stay responses; Death's Door XP and persistence; distinct profiles and grounded poses; sound release/contact timing, deduplication, misses, multi-hit queues, skipped actions and cancellation. Graphical captures check preparation/descent readability and attack windup/contact/recovery against the existing stage and fixed HUD. Automated checks establish behavior and resource routing; they do not measure human perception of pacing or loudness.

The complete smoke suite passed all 43 checks. Related Crusader, formation and sound checks were rerun successfully after the final charge layout adjustment. A separate ordinary-action Old Road expedition completed three floors and eight fights with a Death's Door survivor receiving XP; its detailed results and existing shutdown resource-warning limitation are recorded in the survivor XP note.
