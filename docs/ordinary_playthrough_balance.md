# Ordinary expedition balance audit â€” 10 October 2026

The measured change preserves the Apprentice completion rate while adding tactical options. Old Road completed in 7 of 8 fresh-party runs both before and after the new systems; every cautious run completed. Fresh parties failed all four Veteran Path trials in each version. A party that honestly completed Old Road, retained its earned items and trained between expeditions then completed all three Path floors, including the Coterie's three forms. These results support keeping base enemy HP, damage, XP, prices and recovery values unchanged for this pass.

This is an **automated ordinary-mechanics playthrough**, not a human playtest or a measured player win rate. The earlier `run_progression_audit.md` lifecycle fixture used controlled lethal damage; it is a separate test and is not evidence for these balance findings.

## Method and reproducibility

`tests/ordinary_playthrough.gd` executes production card/AP/cooldown and position checks, consumables, enemy turns, random status applications, room movement, floor entrance prompts, event investigations, loot/equipment, merchant purchases, camps, death and return/retreat. It never grants HP, gold, equipment, training points or damage, never forces a kill, and never changes production statistics. It skips only travel/reveal/attack presentation time. Each fresh run starts with zero gold, empty inventory/equipment, level 1 heroes, no training or forge upgrades, and three normal departure rations.

Two dungeon seeds (2026 and 20) are paired with Warden/Ranger/Occultist and Warden/Ranger/Healer. Preparation puts Warden first, the caster second and Ranger third through the normal position API. Combat uses a deterministic greedy policy: legally target attacks, prioritize achievable kills/supports, estimate visible enemy pressure, guard or weaken when useful, heal before lethal pressure, remove damaging statuses, and use owned scrolls/potions. Actual global combat randomness is seeded with dungeon seed + 5000; loot uses the game's normal separate seed. The policy can pay movement AP to restore a displaced archer/warden. It does not peek at random outcomes or event seeds.

Direct routing takes a shortest geometric path toward the exit and uses encountered camps. Cautious routing detours toward an unused camp when a living hero falls below 75% HP or exceeds 40 Stress. Rest is used only when health/stress/status recovery is useful; watch and sharpen spend normal camp points. Inventory upgrades are equipped between encounters; merchants buy affordable missing basic weapons before stocking up to two healing potions. All purchases use earned gold. Events choose an available low-cost class option with enough HP to pay, otherwise a healthy investigator or leave option.

The geometric planner knows generated connectivity and camp locations, although each actual move still must use a revealed legal route. This is more informed than a new player exploring fog, and the greedy combat policy is less capable than a strong human player. Camp detours are geometric, not an optimal combat-risk search. Bounds are 32 combat rounds and 100 navigation decisions; all final cases finished or retreated/defeated before a bound. A preliminary AI event-selection mistake at 0 HP was fixed and its results excluded.

The baseline snapshot's 133 production scripts/scenes match commit `d52769f55ece14da90ab31aa01f1a11b45fd3883` after line-ending normalization. Its item catalog was restored directly from that commit because eight new matchup items arrived during snapshot copying. An additional matchup module is present but unreferenced by the baseline runtime. Current results include the new boss objectives, matchup equipment and creature resistances. SHA256 hashes and full action/HP/status/gold/XP/item traces are in `ordinary_playthrough_results.json`; the captured current hashes identify the measured revision. After the runs, `scenes/combat/combatscene.gd` and `scenes/hub/bestiary.gd` changed; the JSON records both captured and final hashes without replacing the captured values. Root shared the same pre-Block direct-hit math between hit resolution and previews, made status application return a success bool with invalid-status rejection and conditional success logging, corrected interrupted-rite intent/nonhealing presentation, and adjusted bestiary wording. Root reports focused smoke regressions confirming expected mechanics. The balance matrix was not rerun on those final source bytes. Current loot selection can differ because the item pool expanded, so individual item or HP changes cannot be attributed solely to boss mechanics.

To reproduce after Godot imports are available, set an isolated APPDATA directory and run:

```powershell
& 'C:/GAME/Ashen/tools/Godot_v4.7.2-stable_win64_console.exe' --headless --path 'C:/GAME/Ashen/latest/GameTest-main' --script res://tests/ordinary_playthrough.gd
# Four fresh Veteran cases, using objective actions:
& 'C:/GAME/Ashen/tools/Godot_v4.7.2-stable_win64_console.exe' --headless --path 'C:/GAME/Ashen/latest/GameTest-main' --script res://tests/ordinary_playthrough.gd -- path_matrix objectives
# One earned progression campaign:
& 'C:/GAME/Ashen/tools/Godot_v4.7.2-stable_win64_console.exe' --headless --path 'C:/GAME/Ashen/latest/GameTest-main' --script res://tests/ordinary_playthrough.gd -- campaign
```

Each invocation writes `user://ordinary_playthrough_results.json`. Single cases accept `-- <seed> <occultist|healer> <direct|cautious> [old_road|path_beast] [objectives]`. The harness reports gameplay outcomes rather than asserting every party must win. The archived matrix processes exited 0 without script/assertion errors; Godot also reported two ObjectDB instances/one resource retained at shutdown, so those logs are not clean leak checks.

## Fresh Old Road results

### Frozen baseline

| Seed / third hero / route | Outcome | Fights / rounds | Rests | Final HP: W / R / third | Gold | Healing potions used |
|---|---|---:|---:|---|---:|---:|
| 2026 / occultist / direct | complete | 8 / 29 | 3 | 38 / 50 / 38 | 19 | 3 |
| 2026 / occultist / cautious | complete | 8 / 33 | 5 | 37 / 50 / 38 | 19 | 3 |
| 2026 / healer / direct | complete | 8 / 30 | 3 | 53 / 49 / 46 | 25 | 3 |
| 2026 / healer / cautious | complete | 8 / 38 | 5 | 50 / 50 / 46 | 25 | 3 |
| 20 / occultist / direct | retreat after casualty | 4 / 20 | 1 | 0 dead / 1 / 34 | 19 | 0 |
| 20 / occultist / cautious | complete | 9 / 34 | 4 | 9 / 52 / 38 | 35 | 0 |
| 20 / healer / direct | complete | 8 / 35 | 1 | 0 dead / 50 / 8 | 36 | 0 |
| 20 / healer / cautious | complete | 8 / 28 | 3 | 4 / 46 / 46 | 39 | 0 |

### Current mechanics

| Seed / third hero / route | Outcome | Fights / rounds | Rests | Final HP: W / R / third | Gold | Healing potions used |
|---|---|---:|---:|---|---:|---:|
| 2026 / occultist / direct | complete | 8 / 29 | 3 | 18 / 42 / 41 | 19 | 3 |
| 2026 / occultist / cautious | complete | 8 / 33 | 5 | 31 / 42 / 41 | 19 | 3 |
| 2026 / healer / direct | complete | 8 / 32 | 3 | 33 / 37 / 50 | 25 | 3 |
| 2026 / healer / cautious | complete | 8 / 41 | 5 | 43 / 42 / 50 | 25 | 3 |
| 20 / occultist / direct | retreat after casualty | 5 / 20 | 1 | 0 dead / 2 / 21 | 21 | 0 |
| 20 / occultist / cautious | complete | 8 / 28 | 3 | 0 Door / 40 / 38 | 33 | 0 |
| 20 / healer / direct | complete | 8 / 35 | 1 | 9 / 42 / 46 | 36 | 0 |
| 20 / healer / cautious | complete | 8 / 28 | 3 | 8 / 42 / 46 | 39 | 0 |

`Door` means HP 0 but still living at Death's Door, not a casualty. Current seed 20 cautious Occultist completed in that state; this is a close survival result, not a comfortable victory. Rests count actual useful rest visits, excluding camps passed at full HP and zero Stress. Gold is the remaining balance after purchases, not gross income. Spell scroll usage and equipment changes are retained in the JSON.

Old Road floor 1 has stairs and no mandatory guardian. Seed 20's direct route contains no combat and reaches floor 2 with 0 combat XP and 13 gold from events/treasure. Seed 2026 encounters one three-enemy battle, taking seven Occultist-party rounds or ten Healer-party rounds; it earns 12 XP per living eligible hero, and reaches floor 2 with 6 or 12 gold depending on class event rewards. Both remain level 1. This explains why rushing that first floor can produce an abrupt change to Keep enemies without proving the generator is defective. On seed 20, cautious recovery improves completion without requiring extra starting stats. On seed 2026, the direct party faces a floor-2 ordinary fight before its recovery opportunity and drops Warden to 8 HP in the baseline Occultist case; this remains survivable.

The baseline/current totals are both 61 won combats across eight Old Road cases. The only noncompletion is seed 20 direct Occultist, which loses Warden and retreats after the remaining party wins the encounter. Current it reaches floor 3 rather than floor 2. Boss support removal is used naturally, stopping the Undying Lord's tribute healing. Final survivors usually reach level 3; baseline seed 20 cautious Occultist reaches level 4. Earned XP remains per hero: a living hero at HP 0 is excluded by the current XP eligibility rule and can lag its companions.

## Fresh Veteran stress tests

| Seed / third hero | Baseline | Current, with objectives |
|---|---|---|
| 2026 / occultist | retreat after casualty on floor 2 | defeat on floor 2 |
| 2026 / healer | retreat after casualty on floor 2 | retreat after casualty on floor 2 |
| 20 / occultist | retreat after casualty on floor 3 | retreat after casualty on floor 2 |
| 20 / healer | retreat after casualty on floor 2 | retreat after casualty on floor 2 |

Both versions have 0/4 completions here. The fresh compositions can defeat the first-floor Giant. The current policy severs both chains for their real 1 AP costs. Later dense ordinary encounters generally cause the casualty/defeat before the later bosses; these results do not show that the Coterie or Howling Head is unbeatable. No blanket Veteran nerf is supported by fresh-party stress tests.

## Earned progression campaign

One current Warden/Ranger/Occultist campaign completes Old Road seed 2026 cautiously and then enters Path seed 2026 with the same earned inventory/equipment and 19 gold. All three are level 3. Four earned training points each are spent while no expedition is active: Warden +2 Guard and +6 maximum HP, Ranger +16% skill damage, Occultist +2 healing and +6 maximum HP. No mid-run training occurs; later earned points remain unspent. Training itself has no gold cost in the current design; retained purchases still pay normal prices.

The Path run completes twelve actual fights, including Giant in five rounds, all three Coterie forms in six rounds total, and Howling Head in five rounds. The party pays 2 AP to sever the chains, 3 AP to interrupt the three form-specific rites when their attacks/rituals warrant it, and 1 AP to silence the idol. Its cautious route makes seven useful rests across eight camp visits. It uses owned/earned consumables and equipment without granting them. Warden reaches Death's Door during floor 2 but survives to camp. Final HP is 48/89, 46/46 and 52/52; Stress is 20, 14 and 22; all three finish level 5 with 103 gold. This confirms one viable intended progression path, not universal Veteran balance across parties or seeds.

## Targeted follow-ups and limits

- **Preserve base numbers now.** The measured Apprentice completion rate is unchanged; recovery remains consequential and the intended progressed Veteran run succeeds. More HP/damage/economy changes would obscure the new tactical systems without evidence of a specific tuning fault.
- **Make preparation and recovery expectations readable.** Floor-1 stairs currently allow a zero-XP rush; showing the party's level/health and the next floor's danger at descent would explain the risk. Keep camps visible once discovered and encourage spending earned training before Veteran departure. A mandatory extra floor-1 battle is not justified by these two seeds.
- **Review Death's Door XP policy separately.** Current XP excludes living HP-0 heroes. This can penalize a surviving front-line hero that absorbed the party's damage; retain or change it deliberately rather than disguising the difference as a general leveling-speed issue.
- **Human playtest remains necessary.** Check discoverability of camp detours, understanding of positional skills, objective prop clarity and moment-to-moment pacing with fog and full animations enabled. The automated policy lacks human anticipation and these seeds do not estimate a player win rate, cover every party composition or prove that all procedural layouts are fair.
