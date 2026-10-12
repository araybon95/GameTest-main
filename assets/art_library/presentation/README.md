# Editable presentation images

These 74 PNG files are the project's primary source for the current painted UI, blood splatter and layered dungeon scenes. Replace an individual file at the same path, and Godot will reimport it. Restart a running debug session after changing an image; running scenes cache their textures.

| Folder / file | Visible use |
| --- | --- |
| `ui/panel_frame.png` | Worn borders around HUDs and character/inventory panels |
| `ui/map_backing.png` | Faint dungeon-map grid |
| `ui/attack_banner.png` | Crimson strip behind attack names |
| `ui/status_burn.png`, `status_bleed.png`, `status_poison.png` | Combat status icons |
| `fx/blood_splatter_atlas.png` | Animated blood impact attachment |
| `dungeons/village/` | Bandit floor scenery |
| `dungeons/keep/` | Stronger-bandit keep scenery |
| `dungeons/apothecary/` | Infested medical dungeon scenery |
| `dungeons/remade_floor_1/` through `remade_floor_3/` | Each Path of the Beast floor |

Each dungeon folder has separate background, midground, wall, doorway and foreground images. Keep their dimensions and alpha transparency when replacing them. Wall textures are 720×720, with the floor strip at y=600–720. The apothecary reference has no wall 04; the loader simply uses the other available walls.

For the panel frame, only the border around x=0–668, y=0–360 is drawn, using 18-pixel edge slices. The map uses x=20, y=20, width=630, height=320. Blood uses the atlas region x=2, y=2, width=309, height=282. Changing atlas geometry requires updating those regions in the corresponding scripts.

`art_catalog.gd` maps the renderer's existing names to these editable files. `image_catalog.json` lists their dimensions, source references and initial hashes. The loader prefers project copies, so a separate game installation is not required. The Settings artwork switch can still select the original drawn fallback.

Hero, creature, item and character-sheet background art remains individually editable in `assets/art_library/generated/`, `assets/art_library/items/` and `assets/ui/`. Motion, shader lighting, particle trajectories and procedural slash/flame drawing remain controlled by scripts and shaders; the PNGs control the painted image components.

Godot's game window defaults to monitor 2 (`initial_screen=1`, `initial_position_type=3` to center on the selected screen); Godot falls back to an available screen on machines without a second monitor.
