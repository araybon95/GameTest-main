# Trinkets and room/hallway map

Twelve original trinkets join the existing equipment pool. Ordinary trinkets use the Trinket slot; Legendary class relics use the Charm slot. Items have separate editable SVG icons in `assets/items/<item_id>.svg`, following the existing item icon system. Individual PNG replacements at the same basename take priority automatically. The supplied reference artwork was not copied.

| Item | Class | Rarity | Bonuses |
|---|---|---|---|
| Clotting Seal | Universal | Common | 30% chance to resist Bleed |
| Vitality Locket | Universal | Rare | +10% maximum health |
| Warding Eye | Universal | Rare | 20% chance to resist a timed debuff |
| Hunter's Compass | Universal | Epic | +10% skill damage, +10 accuracy points |
| Bastion Medal | Warden | Epic | +15% maximum health, 25% Bleed resistance |
| Falcon Sight | Ranger | Epic | +15% skill damage, +15 accuracy points |
| Veiled Sigil | Occultist | Epic | +15% skill damage, 20% debuff resistance |
| Merciful Beads | Healer | Epic | +2 healing, 25% debuff resistance |
| Last Watch Relic | Warden | Legendary | +20% maximum health, 25% debuff resistance |
| Unerring Talon | Ranger | Legendary | +20% skill damage, +20 accuracy points |
| Black Covenant | Occultist | Legendary | +25% skill damage, 25% debuff resistance |
| Dawn Reliquary | Healer | Legendary | +3 healing, +15% maximum health, 25% debuff resistance |

Universal gear can be equipped by any active party hero. Class gear retains restrictions. Merchants sell Common, Rare and Epic trinkets, with a dedicated Trinkets filter; Legendary relics remain loot-only. Regular loot and equipment events may award universal trinkets. Guaranteed boss Legendary drops remain specific to a party class.

Percentage health bonuses add together and multiply base health plus flat equipment health, rounding down. Equipping health gear changes maximum health without granting free healing; removing it clamps current health to the new maximum. Percentage damage multiplies skill damage after flat bonuses, before Chill reduction, rounding down. Spell scrolls retain their fixed spell damage.

Attack skills normally have 100% accuracy. Chill and an active affliction each impose a 10-point accuracy penalty. Trinket accuracy offsets these penalties, capped at 100%; missed attacks still consume the skill's AP and cooldown. Spell scrolls retain guaranteed hits. Generic debuff resistance checks before Burn, Bleed, Poison or Chill is applied by an event or enemy; Bleed resistance adds to that check for Bleed, capped at 100%. Resistance prevents a new application; it does not cleanse existing effects. The existing poison-resistance equipment continues to reduce poison tick damage separately.

The inventory has a Trinkets filter and displays the equipped trinket bonuses. Tooltips show restrictions, rarity and effects.

The dungeon map now displays framed square rooms and narrow tiled hallway connections against unexplored darkness. Room types use different colors, icons and labels. Corridor event tiles have a narrow shape, and the current location has a gold frame and marker. Procedural connectivity, fog, adjacent movement and multiplayer voting authority remain in place.

Validated by `tests/trinkets_smoke.gd` plus the RPG, loot, multi-enemy, camp/merchant, event and Beast tests. Rendered previews cover the map, equipment view and merchant trinket filter. No lock-and-key mechanic was added from the map reference.
