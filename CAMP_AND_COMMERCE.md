# Camps, orbs and commerce

Every procedural floor contains at least one camp and exactly one merchant orb in a normal combat room. Defeat that room's enemies to unlock the orb. It can be entered from the victory screen or revisited on the dungeon map. Travel preserves the floor, room, party state and run progress. Returning from the Emporium lands in the same dungeon room.

Each camp offers one free rest. Living heroes recover their full equipment-adjusted maximum health, clear burn/bleed/poison/chill and affliction penalties, leave Death's Door, and retain at most 10% of their current stress (whole points rounded down). Slain heroes stay slain. The used state belongs to the room and remains spent across visits. Leaving without resting preserves the rest for later.

Gold replaces Embers for rewards, purchases and Forge upgrades. Existing reward amounts and upgrade costs are unchanged. The Emporium has category filters and sells equipment for current party classes plus universal scrolls. Legendary gear and Legendary scrolls are loot-only; both UI and purchase rules exclude them.

| Rarity | Normal loot rarity roll | Merchant gear price |
| --- | --- | --- |
| Common | 60% | 8 Gold |
| Rare | 25% | 18 Gold |
| Epic | 10% | 30 Gold |
| Legendary | 5% | Not sold |

Scrolls still have an independent 15% chance to accompany loot. Common/Rare/Epic scroll prices are 6/12/20 Gold. The Epic Storm Lance deals 22 damage ignoring Block for 1 AP, once, usable by any hero. Each hero class now has Epic gear. Bosses always drop Legendary equipment for a party class.

The new backdrop is `assets/generated/camp_ruins.png`. Existing hero art remains unchanged. Epic icons have separate replaceable SVG files in `assets/items/`; individual same-ID PNG files override their SVGs after Godot imports them. Attribution and sources remain in `assets/items/CREDITS.md` and `SOURCES.json`.

Validation: `tests/camp_merchant_smoke.gd` checks recovery, repeated-rest rejection, stress and debuff reset, slain heroes, 200 generation seeds, orb gating, actual merchant/return scene travel, gold transactions, Epic purchases and Legendary exclusion. Existing RPG, loot-distribution and multiple-enemy suites pass. `tests/camp_merchant_preview.gd` renders camp, merchant, orb and map previews.
