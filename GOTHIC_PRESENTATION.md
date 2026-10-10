# Gothic presentation overhaul

Original scenery receives restrained ink-and-wash tonal bands, desaturation and an edge vignette. Interface frames use angular iron borders, warm parchment lettering, shadowed headings and serif titles. Item rarity borders and bright tooltips remain readable.

Combat stages the party on the left and up to three enemies on the right. The lower interface retains selected hero details, permanent ability descriptions, consumables and the log. Shared party turns, formations, encounter caps, loot and three-floor dungeon progression are unchanged.

Each attack spotlights the attacker and target in their actual battlefield positions. Other combatants and the scenery dim through anticipation, strike, impact and recovery. Melee uses a lunge and slash; arrows travel between combatants; spells use rings and rays; fully mitigated damage produces a shield. Healing and guard skills receive their own effects. Damage, misses, blocks and healing have floating feedback. Inputs beneath the spotlight are blocked until it finishes. Effects queue and never resolve gameplay damage themselves.

Four original themed battle stages share a shallow, horizontal fighting floor. Sprite feet, bottom pivots, ambient light and contact shadows anchor the cast to that floor. The stages are `assets/generated/{bandit,keep,beast,apothecary}_battle_stage.png`.

Dedicated attack and hurt poses cover all five heroes, three bandits, five keep enemies, four Beast creatures and two original enemies. Each character has its own replaceable `assets/generated/combat_pose_<character>.png` containing two poses. The atlas manifest is `scripts/combat_poses.gd`, with measured transparent separation in `scripts/combat_pose_regions.gd`. Alpha bounds are trimmed by Godot and pose changes retain the original foot anchor. The impact pose briefly holds before recoil. Replace an individual asset and adjust its gap measurement without changing combat rules.

The remaining Coterie forms, Howling Head and moth creatures retain their original cutouts with animated anticipation/recoil. Some generated creature pose requests were rejected by the image service. This is a pose-switch animation pass, not a full skeletal animation system.

All new raster artwork was produced with the built-in image generation tool from the project's own art. Prompts are saved in `COMBAT_ART_PROMPTS.json`. No Darkest Dungeon artwork or animations were imported.

Validation: `tests/presentation_smoke.gd`, the existing combat/system smoke suite, and graphical combat/strike previews.
