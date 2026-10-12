# Equipment feedback and playtest — 12 October 2026

Guarded companions now have a gold link beneath the party, showing protector, recipient, expiry and whether the once-only retaliation remains ready. Links hide during cinematics and when either participant dies. Formation controls show the scouting free move, its used/reset state, or the heavy plate's 2 AP movement cost.

Signature skills use thorn arrow clusters, a flowing soul tether and healing transfer, candle-gold cleansing rings, and blood/metal barbs on the Crusader's charge. Shapes follow existing release/contact timing, preserve miss/block suppression, and use no gameplay randomness. Original individually replaceable weapon artwork remains in use.

Legendary equipment found in combat now receives a reveal with lore and, for class weapons, the unlocked skill, AP cost and cooldown. Details scroll rather than covering the buttons. The reveal only displays already awarded loot. Class fittings decorate its frame.

## Playtest method

Ran 12 matched controlled cases: Old Road and Path of the Beast, each with Warden/Ranger plus Occultist, Healer or Crusader, starting with common or legendary class weapons and armour. Layout seed 2026, cautious routing, boss objective interactions enabled. Fixed equipment is an explicit test fixture; these cases do not model acquiring legendary gear as a new player. Legal actions, AP, cooldowns, damage, camp use, events and shop spending remain production behaviour. The loadout stays fixed for comparison.

Also ran a two-dungeon campaign with ordinary starting equipment, earned drops, shop purchases and level training. Repeated both legendary Crusader cases after tuning: 16 runs total. Compact results are in `relic_feedback_balance.json`; raw local logs are in `C:/GAME/Ashen/relic-balance-2026-10-12` and `C:/GAME/Ashen/relic-balance-tuned-2026-10-12`.

## Findings and adjustment

All six Old Road loadouts completed the three floors. All three legendary Beast loadouts completed. Common Occultist and Healer parties retreated after casualties on floor two; the common Crusader party completed, with the Crusader at Death's Door. The ordinary campaign completed both expeditions using earned equipment and training.

The original Unending Charge had the same base damage, less Block, a longer cooldown and an HP payment compared with Thornbound Charge. It was never selected. Increased its base damage from 8 to 12 and Block from 4 to 6; allowed it from P1 as well as P2/P3. It still pays 2 HP, requires more than 2 HP, costs 2 AP and has a three-turn cooldown. The repeated legendary Beast run used it five times and completed. Other skill values and rewards remain unchanged.

These results establish a useful equipment difference on one layout seed and one automated policy. They do not establish final balance across random layouts or human play. Healing, guard and cleansing skills remain situational; their usage differs by encounter pressure.

## Verification

All 72 smoke checks passed. Targeted relic, position and animation checks passed again after tuning. Native 1280×720 captures verified guard links, formation hints, thorn flight, drain contact, cleansing rings, charge impact and the scrollable legendary reveal. Screenshots are `C:/GAME/Ashen/tactics-*.png`. Player save data was isolated for every test and preview.
