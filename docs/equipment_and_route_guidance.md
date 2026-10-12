# Equipment and route guidance

12 October 2026.

## Descent advice

The descent screen lists living heroes missing an equipped weapon or armour. Owned inventory alone does not satisfy the check: equip it through **Tab**. Fallen heroes are excluded. When gear is missing, advice explains basic class equipment prices and lists only discovered merchant rooms on the current floor, with map coordinates and whether their encounter still needs to be won. With no known merchant, it suggests scouting or exploration rather than revealing a hidden location.

Health, Death's Door and status warnings remain first. The advice area scrolls when there are many warnings; the stay/descend buttons remain outside it. Missing equipment never disables legal descent and advice never changes equipment, HP, map discovery or loot RNG.

## Map cues

Discovered merchants now have a cyan **M diamond** instead of a small orb ring on the shared stationary/passage map artwork. The stationary map includes the diamond in the room's click target. Unfinished ordinary battles have brighter sword frames; the map legend explains merchant marks and the XP/loot opportunity represented by fights.

Hover a discovered merchant room to see whether to win the encounter or enter its ready orb. Ordinary unfinished fights explain that victory earns XP and a **chance** of equipment, with a reminder to inspect enemies and party health. Existing scouting still controls enemy-detail visibility. Cleared fights receive no repeat-XP suggestion, hidden rooms receive no hint or button, and existing route validation still blocks paths through unfinished intermediate encounters. A cue does not promise that a fight is safe or a merchant is immediately reachable.

## Paired seed 27 sample

Re-ran Old Road with fresh Warden/Ranger/Occultist parties, seed 27, identical greedy combat choices and no starting gold/equipment, debug damage, forced loot or healing grants. Compared the existing cautious route with a new test-only **prepared** route. Production statistics, rewards, prices and map generation are unchanged.

The prepared policy keeps the existing recovery detours. When healthy, it seeks an affordable merchant if weapons/armour are missing, otherwise ordinary encounters while equipment is missing or heroes are below the next floor's suggested level (level 2 before the keep, level 3 thereafter). It makes at most one deliberate shopping visit per merchant per floor, uses earned drops and purchases, and continues exploring before descent when a preparation opportunity remains. Like the existing camp planner, it knows generated layout locations; each actual move must still follow a revealed legal route. Presentation waits are skipped. See [results and source hashes](seed27_preparation_comparison.json).

| Route | Outcome | Fights / rounds | Camp visits / rests | Merchant visits | Level entering floor 3 | Remaining gold |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Cautious | Defeat on floor 3 | 3 / 20 | 6 / 2 | 0 | 2 | 49 |
| Prepared | Complete, all three survive | 12 / 57 | 8 / 5 | 3 | 3 | 44 |

The cautious sample reproduces the previous failure: one floor-one fight earns 6 XP, the Son is defeated at level 1, and a Wolfguard/Footman/Crossbow encounter defeats the level-2 party in 13 rounds. It buys no equipment.

The prepared sample buys Warden/Ranger basic weapons on floor one, the Occultist staff on floor two, and a potion plus Warden/Occultist armour on floor three. Drops provide further equipment. It reaches level 2 before the keep and level 3 before floor three. The same three-enemy encounter remains dangerous: it takes 14 rounds and leaves Warden at 11 HP and Ranger at 15 HP. Subsequent camp recovery helps the party finish the expedition, with final HP 29/78, 50/52 and 22/42 for Warden/Ranger/Occultist.

This supports a viable **combined exploration, XP, shopping and recovery strategy on this seed**. It does not isolate equipment's effect, establish a human win rate, prove that map cues change player behavior or justify a global difficulty change. Both processes exited 0 with valid gameplay outcomes and no script/assertion errors; both retained the harness's ObjectDB/resource shutdown warnings.

Reproduce with separate user-data directories after import:

```sh
XDG_DATA_HOME=/tmp/ashen-27-cautious godot --headless --path . \
  --script res://tests/ordinary_playthrough.gd -- 27 occultist cautious old_road
XDG_DATA_HOME=/tmp/ashen-27-prepared godot --headless --path . \
  --script res://tests/ordinary_playthrough.gd -- 27 occultist prepared old_road
```

The new route is opt-in; existing `cautious`, `direct` and `campaign` behavior is retained.

## Verification

Six relevant checks passed on Godot 4.6.3: equipment/route guidance, expedition readiness, continuous dungeon, merchant orb event, floor entrance and full run milestone. Coverage includes owned-but-unequipped gear, fallen heroes, hidden merchants, cleared fights, merchant click bounds, unchanged route/descent gates, map/log/inventory navigation, orb return, rewards, saved journey/RNG, camps, retreat, Death's Door and boss phases.

Rendered the map, merchant hover, ordinary equipment advice and a critical-party descent at 1280×720. The legend, diamond, scrollable warnings and fixed buttons were inspected. These captures check UI layout rather than audio or sustained combat feel.

Next human playtest: try seed 27 with fog and full animations, locate an M-marked merchant and use the warnings to choose equipment/XP detours. Record whether those cues are understood without explaining them to the player.
