# Ink loot sheets

Generated with OpenAI image generation on 2026-10-12 for Ashen Expedition.
Each PNG is an original generated 1536×1024 RGBA image containing a 6-column,
4-row icon grid. The PNG pixels were copied unchanged from the generation result.
No external icon geometry was supplied to the image generation request.

The art direction specified original medieval grimdark loot, thick black ink
contours, angular readable silhouettes, weathered metal/leather/bone, upper-left
lighting, restrained magic, transparent backgrounds, no labels or baked UI frames.
`layout.json` preserves each tile's stable ID, name, category and design details
in row-major order. Item resources use sheet/row coordinates derived from that
ordering; camp and empty-slot resources select their corresponding tiles.

The output covers 87 item illustrations, five camp illustrations and four empty
equipment-slot symbols. Legacy SVG credits remain in `../CREDITS.md` and apply to
those legacy source files. New sprites do not alter item mechanics or rarity data.

For a single hand-drawn replacement, add a same-name transparent PNG in `items/`
or `camp/`; retain the sheet for other entries. See the library README for examples.
