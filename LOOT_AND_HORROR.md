# Loot and adult horror update

Spell scrolls are universal party consumables. Fire Bolt deals 12 damage;
Lightning Bolt deals 18 and ignores Block; Sunfire deals 28 and ignores Block.
All cost 1 AP and consume exactly one item. They are independent bonus drops
with a 15% chance per first-time encounter victory or treasure-room search.
Scrolls stack in the shared inventory and can be bought with Gold from the Emporium in the Hamlet or through one
unlocked merchant orb per floor. Legendary items and scrolls are loot-only.

Rarity weights are common 60%, rare 25%, epic 10%, legendary 5%, conditional on an item
being generated. Ordinary encounter victories have a 40% equipment chance.
Treasure rooms always yield equipment. Bosses always yield one legendary
equipment item for a class in the active party, plus the independent scroll roll.
Each room can award loot only once. These rates are initial tuning values.

Class equipment is original Ashen content: swords/shields for Warden,
bows/leathers for Ranger, staves/grimoires for Occultist, maces/holy symbols for
Healer. Gear changes damage, Block, healing, maximum health, regeneration, poison chance, poison resistance, reflection and life drain. Epic Storm Lance scrolls deal 22 damage ignoring Block. Select a hero
on the map and click compatible inventory gear to equip it; click an equipped
slot to remove it. Replaced gear returns to inventory. Maximum-health changes
preserve current health and clamp it when necessary; equipping never revives
or heals a hero. Gear and inventory survive expeditions during the session.
Disk saves are still future work.

The Old Road is now the human bandit dungeon, populated by original Ash Raiders
and Gallows Scouts, ending with the Gallows Chieftain. The Bestiarum Bandit Clans
collection informed the broad grimdark direction; no model files, product images,
names, or lore were copied into the game. The three new sprites use the built-in
image generation tool. Existing artwork remains intact.

The title screen states 18+ adult grimdark horror and asks for age confirmation
before entering the Hamlet. This is a self-declaration, not an official rating
or verified-age system. Creative direction includes blood, violence, ragged
equipment, brutal outlaws and unsettling horror.

Validation: tests/loot_smoke.gd checks shopping, consumption, gear restrictions,
replacement and bonuses, rarity distribution, scroll frequency, 2,000 boss
guarantees, duplicate-loot prevention and live combat/inventory/merchant scenes.
The existing 100-seed dungeon/turn-flow smoke test also remains available.
