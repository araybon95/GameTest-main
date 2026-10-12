# Settlement presentation layers

All PNGs here are independently replaceable. The three interior PNGs were generated with the built-in image-generation tool, then inspected and copied into the project. Original generated files remain unchanged.

Prompt set: production game environment, landscape 16:9; no text, UI or people; grimdark ink illustration, thick irregular black outlines, flat angular shadows, distressed painted textures, desaturated colors, tiny bright highlights; distinct focal set dressing at the left quarter, spacious lower-contrast center/right for panels, edge silhouettes and atmospheric depth.

- Chapel: pointed stone arches, weathered books, brass reliquaries, candles, left lectern, warm gold light and wine-black shadows.
- Barracks: timber rafters, spear/shield racks, folded red banners, training armor, left war table and candle alcove, slate/iron with amber light.
- Workshop/forge: left coal forge, hanging tongs/hammers, scorched brick, rough worktables, dyed cloth and armor pieces, copper and soot-black shadows.

Attendants and quest seal layers come from the user's supplied installation. Their exact relative sources are recorded in reference_assets.json. These are separate from the new interior artwork. Apothecary scenery uses the project's existing reclaimed medical ward artwork.

Code: scripts/static_screen_art.gd controls independent scenery, attendants, dust, lights, edge silhouettes, restored-room furnishings and earned relics. Scene-specific service panels use parchment/devotional/scorched/medical materials. scenes/ui/dungeon_dossier.gd and expedition_decoration.gd provide dossiers, seals and location highlights. GameSettings' ambient-motion checkbox pauses scenery/attendant motion and shortens initial transitions. No gameplay RNG is consumed.
