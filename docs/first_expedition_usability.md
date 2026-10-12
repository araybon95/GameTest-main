# First-expedition guidance and campaign samples

12 October 2026.

## Player-facing changes

Preparation now checks each hero's actual skill set against the selected position, including a signature skill unlocked by an equipped legendary weapon. A Warden/Ranger/Occultist formation with the Occultist at P3 shows one blocked skill and suggests P2; swapping to P2 clears that warning. Hover the hint for blocked skill names and use/reach rules. This is a position check, not a promise that every target, AP cost or cooldown will allow the skill. It never rearranges the party or prevents embarkation. Equipment lists remain scrollable above the hint.

Press **I** on preparation to open its own field guide. It explains free preparation swaps, shared turns, optional supplies, training, scouting, one-use camp recovery and the first keep descent. Exploration and combat guides now explain camp detours, retreat, individual AP, ending the party turn, movement costs and the Undying Lord's support.

The first Old Road descent identifies living level-1 heroes. If the journey has no defeated enemies, it also reports that no battles have been won. It explains that optional fights provide XP and equipment and that stairs do not require clearing the floor. Recovery warnings stay first. With no discovered unused camp, advice points to the map's SCOUT control; it does not expose hidden camps. Veteran preparation and later descents retain their existing advice. Guidance changes no combat statistics, generation, rewards, saves or departure rules.

## Campaign sampling

Ran four fresh Warden/Ranger/Occultist campaigns with seeds **2026, 20, 27 and 52**. Each starts with zero gold and empty equipment/inventory, uses cautious routing, earns drops, buys supplies when affordable and trains earned points between expeditions. A completed Old Road carries its actual equipment, inventory and progression into Path of the Beast with boss objectives enabled. No legendary starting fixture, damage grant, forced kill or HP grant was used.

These are automated actual-action samples using Godot **4.6.3**, the available compatible runtime. They skip presentation waits and use a route planner that knows camp locations. They are not human playtests, do not measure the effect of the new guidance on player behavior and cannot establish general win rates. No gameplay tuning was made. See [sample results and source hashes](first_expedition_campaign_samples.json).

| Seed | Old Road | Fights / rounds | Camp visits | Remaining gold | Progressed Path | Fights / rounds | Camp visits | Remaining gold |
| --- | --- | ---: | ---: | ---: | --- | ---: | ---: | ---: |
| 2026 | Complete | 8 / 33 | 6 | 30 | Complete | 10 / 38 | 5 | 156 |
| 20 | Complete | 9 / 36 | 6 | 29 | Complete | 12 / 39 | 4 | 167 |
| 27 | Defeat on floor 3 | 3 / 20 | 6 | 49 | Not attempted | — | — | — |
| 52 | Complete | 5 / 23 | 4 | 16 | Complete | 11 / 46 | 3 | 129 |

Camp visits include visits without a rest. Remaining gold is after actual purchases, not gross income. All four processes exited 0 without script/assertion failures; the harness records defeat as a valid gameplay outcome. Seeds 2026 and 27 logged one resource still in use at shutdown, so those are not clean leak checks.

Seed 27 won one floor-one Raider fight for **6 XP per hero**, then defeated the floor-two Son at level 1. All heroes were level 2 entering floor three. The first floor-three Wolfguard/Footman/Crossbow group defeated the party in 13 rounds. The party had 49 gold, had visited no merchants and had no weapons or armour equipped; only the Ranger had an earned keepsake charm. Camp recovery alone did not compensate for this sparse route's progression. This is a concrete follow-up for route, merchant and preparation discoverability, not justification for a blanket enemy nerf.

Reproduction after asset import, with isolated user-data directories:

```sh
XDG_DATA_HOME=/tmp/ashen-campaign-27 godot --headless --path . \
  --script res://tests/ordinary_playthrough.gd -- campaign 27
```

`campaign` still defaults to seed 2026; its optional second argument selects the same seed for both expeditions. The JSON is written to Godot's isolated `user://ordinary_playthrough_results.json`.

## Verification

- Readiness smoke covers blocked skills, live swaps, signature skills, advisory-only behavior, level-1 and no-victory warnings, later-floor suppression, camp secrecy and unchanged journey/RNG state.
- Controls smoke covers preparation context, I/Escape, exploration/combat guidance and existing modal/input behavior.
- Floor-entrance, combat-controls, depth-tactics and relic-feedback checks cover adjacent behavior.
- The full three-floor lifecycle regression covers AP/turns, camp/orb routing, rewards, XP, save/RNG round trips, retreat, defeat and Coterie phases. Its first run exceeded a 60-second timeout while campaign processes were running; rerunning with a 180-second allowance passed.
- Rendered preparation before/after a swap, the scrollable preparation guide and the dangerous first descent at **1280×720**. Hints and buttons remained readable without overlap. This checks these screens, not sustained combat pacing or audio quality.

Next human check: play seed 27 with fog and full animations, use the new guide, and see whether optional fights and merchant detours are discoverable before the keep. Compare direct travel against deliberate XP/equipment preparation; record HP, camp use and retreat decisions before changing difficulty.
