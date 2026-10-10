# Survivor XP at Death's Door

A hero who finishes a victorious encounter alive earns the normal XP even at 0 HP/Death's Door. Eligibility now checks that the hero has a run-state entry and is not dead; the existing party loop continues to exclude heroes outside the expedition. Dead and missing heroes earn no XP.

This change only removes the positive-HP requirement in `GameData.award_victory_xp()`. It does not revive or heal anyone, change XP rates, award training during a run, or alter the room's once-only award flag. Leveling can increase maximum HP while current HP remains 0 and Death's Door remains active. Earned training points can still be spent only outside an active expedition.

| Encounter | Floor 1 | Floor 2 | Floor 3 |
|---|---:|---:|---:|
| Normal battle | 12 | 16 | 20 |
| Boss | 35 | 39 | 43 |
| Surprised corridor roamer | 6 | 8 | 10 |

`tests/survivor_xp_smoke.gd` uses controlled controller victories to verify all nine unchanged rates, a Death's Door survivor crossing the level-2 threshold without healing, exclusion of dead/missing/nonparty heroes, saved XP and Death's Door state, progression-file persistence, repeat-award prevention after reload, and Coterie rewards only after its final form. These are focused regression fixtures, not ordinary-mechanics balance runs.

The earlier balance report/results retain their historical XP policy and measured outcomes. No prior run is relabeled as using this new rule. A preliminary optional run made during concurrent presentation API integration contained runtime errors and was excluded. After that integration stabilized, the focused test and existing leveling regression both passed. One new actual-action Old Road run (seed 20, cautious Warden/Ranger/Occultist) completed all three floors and eight fights. All three survivors earned 182 encounter XP and reached level 3 (77 XP toward level 4); Warden survived the final boss at 0 HP/Death's Door and still received the normal final boss XP. The run used normal earned loot, camps and purchases; it granted no stats, HP or kills. Its gameplay log had no script/assertion errors, but retained the existing shutdown ObjectDB/resource warning and is not a clean leak check.
