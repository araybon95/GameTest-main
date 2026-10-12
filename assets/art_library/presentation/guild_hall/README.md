# Adventurers' guild artwork

The game loads these originals directly. Generated with the session's OpenAI image-generation tool; no source pixels were rescaled or repainted after generation. The interior's central banner was removed through an image-generation edit so the game can supply customizable cloth and heraldry there.

| Source | Canvas | Replacement requirements |
| --- | --- | --- |
| `interior.png` | 1672 × 941 | Opaque room. Preserve the central stone pier, open party floor, and notice-board position. The scene maps it into the game's 1920 × 1080 layout. |
| `banner.png` | 1024 × 1536 | Transparent cutout, neutral cloth, blank emblem area. The game tints it and draws the chosen heraldry. |
| `decor.png` | 1536 × 1024 | Transparent 3 × 2 sheet of 512 × 512 tiles. Preserve tile boundaries and floor/base alignment. |

`decor.png` top row: tankards/stools/barrel, weapon rack, book/map lectern. These are the three current gathering-corner options. Bottom row: brazier, supply chest, helmet pedestal, retained within the same original sheet for future hall furnishings; they are not unlockable trophies in this first pass.

To replace an asset with your hand-drawn version, export a PNG with the same filename, dimensions, and transparency, overwrite it here, and reimport in Godot. Keep transparent margins around cutouts. Do not bake guild names, expedition labels, or the selectable banner emblem into the illustrations: these are live UI.

The selected lighting affects room, banner, furnishing, and heroes together. Reference positions and clickable regions live in `scenes/hub/guild_hall.gd`. All originals are indexed in the parent art library's `manifest.json` and `catalog.html`.

Art direction: a sociable adventurers' headquarters with background patrons, tankards, maps, and firelight, illustrated in the game's somber ink-and-paint style. The anime influence is the lively guild atmosphere, rather than a change to the character rendering style.
