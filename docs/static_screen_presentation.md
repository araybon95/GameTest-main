# Static-screen presentation

The chapel/archive, barracks, forge, restored workshop, appearance workshop, infirmary/watchtower restoration rooms, apothecary shop and emporium share an input-transparent scenery system. Three new original generated interior PNGs replace the reused exterior backdrop; existing reclaimed apothecary art remains the medical setting. Supplied reference attendants and quest seals are individual PNG layers. Sources and generation prompts are in assets/art_library/presentation/settlement/README.md and reference_assets.json.

The ten presentation steps are implemented as follows:

1. Distinct chapel, barracks, workshop/forge and medical interiors.
2. Independent foreground silhouettes, warm/cool illumination, candle/dust/ember atmosphere.
3. Location outlines, illustrated selected dungeon seals and chains over future dungeons.
4. Serif headings, painted frames, themed button states and readable body text.
5. Parchment, devotional, scorched-iron and medical panel palettes, with translucent workspace panels.
6. Reference attendants with subtle idle motion, room-specific names and short lore.
7. Occupied rooms omit attendants/furnishings; reclaimed services restore them. Existing expedition completion adds relic pictures, field captions and completion crests. No new progression or reward is granted by decoration.
8. Illustrated dungeon dossiers show entrance scenery, guardian silhouettes, three floor summaries and a representative class reward icon. Future dossiers remain clearly sealed.
9. Brief entrance fades, gently appearing captions and a small book-panel slide. Transactions and roster rebuilds do not restart the screen entrance.
10. Reviewed actual 1920x1080 and 1280x720 renders, fixed image bounds and container frames, preserved paper text without heavy shadows, and standardized minimum text/button spacing.

GameSettings includes an independent persisted `ambient_motion` flag. It stops scenery/attendant animation and makes entrances nearly immediate. Presentation consumes no gameplay RNG. The existing brightness slider still applies to the complete scene.

`tests/static_screens_smoke.gd` covers restored rooms, distinct imagery, bound portraits/dossiers, earned relics, motion disabling, quiet shop refreshes, expedition locks and unchanged gold/progression/RNG. The full suite covers surrounding navigation, commerce, saves, music and gameplay.
