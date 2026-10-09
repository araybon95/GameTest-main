# Expedition gameplay systems

Implemented in the Godot project, using the existing visual style and artwork.

## Formation and class cooperation
Preparation lets players freely assign front/rear ranks; at least one hero must protect the front. During combat a rank change costs 1 AP. Melee enemies target the front, ranged enemies can reach the rear, and keep wolfguards can pull heroes forward. Front heroes gain 2 Block each new party turn.

Rangers gain +1 skill damage in the rear. Wardens gain +2 damage against marked enemies; this combines with the existing mark bonus. Occultist damaging skills inflict Poison. Crusaders gain +2 damage against bleeding foes. Healer party healing also removes Bleed. Existing shared party turns remain in place.

## Boss objectives
Oleander and the Last Honorable Son cycle through guarding (50% damage reduction), a heavy strike, then exposure (+50% incoming damage). Exuvia starts with one 18 HP cocoon; destroy it before two enemy turns to prevent a hatchling. Hatched support has 13 HP and 2 attack (30% of a normal metamorph). Every third round she can replace a fallen support with a cocoon. The Undying Lord receives 8 healing each enemy turn while his support lives. Hints appear inside enemy cards.

## Preparation and scouting
Before entering expeditions, buy optional supplies and arrange ranks. Field Bandages remove Bleed, Field Antidotes remove Poison, and Calming Incense removes 8 stress. Identical consumables stack and cost 1 AP in combat. Scouting costs no gold and has two uses per floor; it reveals nearby rooms and their enemy/event details. The restored Watchtower provides automatic scouting within two rooms, three manual uses per floor, and manual range of three rooms.

## Class event choices
Matching heroes gain a second interaction with explicit costs and risks: Wardens force bandit locks for 2 HP; Rangers disarm those traps; Healers purify supplies; Occultists interpret remade rites; Crusaders pay a 2 HP blood tithe. These actions guarantee a reward with 10–15% debuff risk. Rooms remain single-use, and the spiked-coffin rescue retains its existing rules.

## Settlement restoration
The Watchtower, Infirmary and Workshop each have a three-room quest: an opening fight, a one-use healing camp, and a boss. Both fights must be cleared before permanent unlock. The Infirmary sells two healing potions for 12 gold or cleansing for 8 gold. The Workshop charges 12 gold for either Keen (+1 damage) or Fortified (+2 Block), once per owned equipment design. Modifications persist and apply to that item design, including future copies; they are not individual-instance upgrades.

## Optional cursed equipment
Thornbound Reliquary: +25% damage, but +2 stress each new party turn. Septic Physician Seal: +4 healing, but incoming Burn/Bleed/Poison ticks deal +1 damage. Both are Unique charms, obtained through the existing item pool and equipped voluntarily. Existing effect stacking caps remain in effect.

## Validation and limits
`tests/mechanics_smoke.gd` exercises formations, class cooperation, boss guard/exposure, cocoon hatching, scouting, restoration gates, modifications, curses, supplies, class events and new screens. The full smoke suite also checks existing expedition and apothecary flows. Screens were rendered and visually inspected at 1920×1080. Numerical balance is an initial implementation and still needs playtesting. Cooperative networking is not introduced by these systems.
