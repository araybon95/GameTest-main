# Controls and character records

**I** opens or closes a contextual controls guide on any screen. Its candle, charcoal panel, worn brass dividers and red close button use original native Godot drawing. **F10** opens the existing sound, brightness and save settings. Keyboard shortcuts leave text fields available for typing hero names.

Right-click a hero portrait/card or press **C** to open the selected hero's record. **Q / E** and the prominent previous/next buttons cycle available heroes. In exploration, **Tab** alternates between the current map/hallway view and party inventory. Inventory filters, stacked consumables and equipment slots remain interactive outside combat. Combat character inspection is read-only, so it cannot bypass skill actions or change equipment during a battle.

The dungeon opens on the party standing in its current room, with a compact clickable map below. Party buttons select the hero whose skills appear in the HUD. **W / Enter** opens the room's available camp, merchant orb or descent. During combat, **Tab** alternates the lower-right **Map / Log** panels; **Items** opens inventory inspection without changing the action rules.

The character sheet arrangement uses the [Amara's Character UI reference](https://steamcommunity.com/sharedfiles/filedetails/?id=3456637826): a narrow equipment/base-stat column, a large central hero with an atmospheric backdrop, and skills and resistances on the right. Lore and deeds use the space appropriate to Ashen's existing systems. The UI is built from project art and Godot controls; Workshop assets are not bundled. Dungeon light, quirks and persistent injuries remain excluded.

In combat, **1–5** (or keypad equivalents) selects and previews a skill for the active hero. Clicking an enemy changes the target; **Enter** confirms the selected available skill. AP, cooldown, hero rank, valid target, cinematic and modal checks all apply. Number keys alone do not perform an attack. Skill cards display their key and the confirmation hint. Victory loot is already collected automatically.

Hallway controls and deferred room progression are documented in [Dynamic hallways](dynamic_hallways.md). Settings, hero records and the guide block hallway movement; manual held keys must be pressed again after closing a panel. The corresponding focused checks are `controls_guide_smoke.gd`, `combat_controls_smoke.gd` and `hallway_navigation_smoke.gd`.
