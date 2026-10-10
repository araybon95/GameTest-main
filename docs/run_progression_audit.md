# Expedition milestone and progression audit

Audited 10 October 2026. Reference implementation: `game_data.gd`, `encounter_rules.gd`, `dungeon_depth.gd`, `item_data.gd`, combat, preparation, camp, shop, floor entrance, aftermath and save scenes.

## Automated milestone

`tests/run_milestone_smoke.gd` is a deterministic lifecycle integration test. It starts from the settlement, buys a provision in preparation, embarks through the production handler and explores Old Road's three floors through the dungeon's actual navigation/scene routing. Timed hallway overlays are finished by their normal completion signal to keep the test practical.

Coverage:

- Shared-party AP expenditure, incoming enemy action and new-round AP reset.
- Combat, room and corridor events, treasure, camps and merchant orb routes.
- Full equipped maximum-health camp recovery, status removal, 90% stress relief, once-only rest and watch preparation.
- Orb travel preserves party state and map position; buying deducts gold and adds stock; merchants reject legendary equipment.
- Once-only combat gold, loot and survivor XP, including a new party-compatible legendary for each boss victory.
- Floor-two coffin rescue stays part of the same three-floor run.
- Guardian support must be defeated; stay, reopen entrance and descend preserve the journey.
- Three active-run checkpoint round trips preserve generated rooms, consumed encounter flags, party HP/status, inventory, XP, deeds and the exact loot RNG continuation.
- Final victory records the expedition unlock and aftermath; the inactive completed save round-trips the report.
- Return to settlement restores its music; departure stops it.
- A separate retreat preserves inventory and reports survivors without a victory unlock.
- A separate defeat uses the actual two-step Death's Door damage path, records chosen names/deeds in three graves and preserves fallen heroes in a saved aftermath.
- Path of the Beast's Giant → three-form Coterie → Howling Head chain gives no intermediate-form reward and completes as one run.

The test uses **controlled lethal enemy damage** to exercise the production victory and phase pipeline. It deliberately wounds heroes at camp to verify recovery. It does **not** measure whether an ordinary player can win these encounters, and should not be described as a human playtest or a combat balance simulation. Give this integrated test a 45-second process timeout; the individual feature tests remain shorter.

## Numeric sampling

Generated 100 fresh seeds (`0` through `99`) for each released three-floor dungeon, using a fresh starter party without equipment or training. These are map/stat samples, not simulated wins. Gold excludes all event outcomes, corridor gold, optional roamers/ambushes, starting gold and spending. XP assumes each ordinary battle and boss is won with every hero alive and above zero HP; an optional roamer or camp ambush can add more. Shortest route is a geometric breadth-first route to the exit, without optimizing camp access, safety or rewards.

| Dungeon / floor | Ordinary fights, mean (range) | Normal enemies, mean | Camps, mean (minimum) | Gold without events, mean | Survivor XP, mean | Shortest-route survivor XP, mean |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Old Road / Bandit Road | 4.63 (2–7) | 8.88 | 2.09 (1) | 13.01 | 55.56 | 30.84 |
| Old Road / Outer Ward | 4.81 (2–8) | 9.54 | 2.13 (1) | 18.40 | 115.96 | 80.76 |
| Old Road / Undying Court | 4.90 (2–8) | 9.61 | 1.93 (1) | 18.55 | 141.00 | 101.00 |
| Beast / Halls of Anguish | 4.77 (2–8) | 9.61 | 2.09 (1) | 28.14 | 92.24 | 66.20 |
| Beast / Choir of Remaking | 4.72 (2–7) | 9.20 | 2.19 (1) | 28.37 | 114.52 | 80.44 |
| Beast / Altar of the Beast | 4.85 (2–8) | 9.72 | 2.13 (1) | 28.15 | 140.00 | 95.80 |

Rooms average about 14 per floor, with 3–5 event spaces and one merchant orb per floor. Each floor has at least one camp; using every available camp can be a significant strategic resource.

Current runtime ordinary enemies (HP / base attack, before move multipliers and round escalation):

| Floor | Old Road pool | Beast pool |
| --- | --- | --- |
| 1 | Raider 58 / 8; Scout 46 / 10 | Penitent 48 / 7; Vessel 54 / 8 |
| 2 | Footman 64 / 10; Crossbowman 58 / 11 | Penitent 58 / 9; Vessel 64 / 10 |
| 3 | Wolfguard 82 / 13; Footman 74 / 12; Crossbowman 68 / 13 | Penitent 68 / 11; Vessel 74 / 12 |

| Boss | Runtime HP | Base attack | Additional enemy |
| --- | ---: | ---: | --- |
| Last Honorable Son, floor 2 | 160 | 13 | Crossbow support: 17 HP / 3 attack |
| Undying Lord, floor 3 | 220 | 15 | Crossbow support: 20 HP / 4 attack |
| Harrowed Slave Giant, floor 1 | 152 | 11 | Penitent support: 14 HP / 2 attack |
| Coterie, floor 2 | 76 → 88 → 100 (264 total) | 10 → 11 → 12 | None |
| Howling Head, floor 3 | 208 | 15 | Penitent support: 20 HP / 3 attack |

The Son alternates 50% incoming-damage reduction, a heavy strike, then a round with 50% increased incoming damage. A living support restores the Lord by 8 HP each enemy turn. Coterie forms advance immediately in the same combat; one final reward belongs to the complete encounter. Supports are rounded to 30% of their normal dungeon HP and attack; move multipliers, escalating rounds and statuses affect their realized damage afterward.

## Progression implications and targeted playtest priorities

1. **Explore before the keep.** A shortest-route Old Road run averages only 30.84 XP before descending from floor one, below the first level's 40 XP requirement. Five of the 100 sampled seeds (`20`, `27`, `52`, `62`, `99`) even have a shortest geometric route with no normal fights. This is a route/reward outlier, not evidence that every first-floor fight needs a stat buff. The preparation and descent guidance should encourage optional fights and equipment before the keep. A future generation constraint or required first-floor encounter should be considered only if human testing confirms that new players routinely rush into an unmanageable ward.
2. **Camp visibility matters more than guaranteed count.** About 40–43% of shortest routes omit a camp, despite camps existing on every floor. Human playtests should check that scouting/map icons make detours discoverable, and that the player understands the one-use rest before committing to a boss.
3. **Keep support-first tactics explicit.** The Lord's 8 HP regeneration can erase much of an untrained hero's action. Verify that the support tooltip and boss cue make this relationship clear. Keep support damage at the requested 30%; improve the explanation before changing the numbers.
4. **Treat Coterie as the endurance pivot.** Its 264 cumulative HP exceeds the Howling Head plus support's 228 HP, although phase attacks are lower and later forms have non-damaging turns. Test status persistence, available potions and readable transitions across all three forms. HP totals alone cannot determine which boss is harder.
5. **Do not tune prices from gold alone.** A full-clear Old Road run averages 49.96 non-event gold, compared with 84.66 on the Veteran Beast dungeon. Common gear costs 8, rare 18, epic 30, unique 38; healing potions cost 8. Equipment additionally drops at a 40% ordinary battle roll, scrolls at an independent 15%, potions at 20%, and bosses guarantee party-class legendary gear. Event gold and loot widen the actual income distribution. Test purchases and equipped loot together before increasing gold payouts.
6. **Levels improve capacity without a free heal.** Thresholds are 40 / 65 / 90 / 115 XP for levels 2–5. The sampled mean full-clear XP totals (312.52 Old Road; 346.76 Beast) reach level five from a fresh hero, while mean shortest-route totals reach level four. Every level adds 2 maximum HP and 2 settlement training points; current damage/healing training requires returning home. Confirm the player understands this and that camp uses the new maximum. An HP refill on level-up would weaken the expedition's resource choices and is not recommended without playtest evidence.

No broad HP, damage, rarity or price change is justified by this sampling alone; it supplies concrete locations for the next balance playtest.

## Item correctness findings

Two small correctness issues were identified for targeted fixes:

- `roll_scroll()` returned the first scroll matching a rolled rarity. Because Healing Scroll was the first rare entry, Lightning Bolt could not be looted. It now picks from all scrolls of the selected rarity. `scroll_pool_smoke.gd` verifies every scroll appears, rare designs share the existing combined 25% tier weight, and restoring RNG state repeats the same pool selections.
- Septic Physician's Seal previously embedded `curse_dot = 1` in status damage when applying Burn/Bleed/Poison. Equipping or removing the seal afterward did not change an existing status's cost. Application now stores the natural status damage; ticking reads the currently equipped curse. Reading stored `base_damage × stacks` also removes an embedded cached curse from existing ordinary saves without a schema rewrite. Legacy/manual effects without `base_damage` keep their supplied damage as fallback. Verify each harmful tick adds exactly one current curse cost, Chill still deals no tick damage, and poison resistance acts after the curse cost.

These are behavioral correctness fixes, rather than a global difficulty change.

## Creature taxonomy

Each creature has an explicit `creature_class` in data and a class label in its discovered bestiary page. The bandit Raider, Scout and Chieftain are **Human**. The Path congregation is **The Remade**. The moth cult's metamorphs, knight and queen are **Insect**. Keep revenants and other supernatural monsters are **Corrupted**. Existing undead, faction and boss traits still govern combat; hero classes are unchanged. Unrecorded pages conceal their class with the other field notes. `creature_classes_smoke.gd` covers every data mapping and all four book labels.

## Creature artwork integration

Seventeen creatures now use independently replaceable hand-inked sprite sheets and idle `AtlasTexture` resources. Eight ordinary creatures have idle/attack/hurt poses; nine bosses have those poses plus a separate roar or ritual reveal, for 60 measured frames. `ink_sprite_regions.gd` and texture metadata use the actual creature IDs so attack, hurt, casting and boss reveals resolve consistently. Original artwork remains available beside the new resources.

`docs/creature_art_provenance.json` records each generated source, original prompt, corrective layout prompt, production paths, source hashes and measured regions. The Son's entry also records its anatomy replacement and final attack-facing correction. Sheets are copied byte for byte. Regions use alpha ≥48 bounds plus three pixels, separated by transparent gutters; no raster trimming or recoloring occurs.

`tests/creature_atlas_smoke.gd` verifies all 17 production routes and 60 poses, stable state selection, boss roar/reveal mapping, old-art preservation and source hashes. It scans the actual imported texture alpha in every recorded cell, verifies tight bounds and proves full-sheet coverage without overlapping cells or crop regions. The atlas, taxonomy, scroll-pool and existing ink-expansion regressions passed headlessly with separate test storage. This checks resource correctness; visual anatomy and scene composition still require the human review described below.

## Human playtest checklist

Run the Old Road both with the starter Warden/Ranger/Occultist party and a Healer party, without debug damage. Test one cautious route with camp detours, one direct route, and one return expedition with earned equipment/training. Record HP and Stress before/after each fight; potions spent; actions to finish; deaths/retreats; camp locations; gold bought/saved; XP at each descent.

During the same uninterrupted run, check creature size/ground contact, attack focus and camera recovery, projectiles/impacts, hallway arrivals, boss introduction/phase transition, camp/event readability, orb return position, final rewards, and save/resume. Try narrow-party losses and Death's Door healing explicitly. Repeat seeds `20` and `2026` to compare the route outlier and the integrated milestone's world.

Acceptance should combine the automated lifecycle regression with these observed ordinary-play runs. Automation proves state consistency; the human run decides difficulty, pacing and visual feel.
