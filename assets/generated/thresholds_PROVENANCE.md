# Illustrated dungeon thresholds

Built-in image_gen tool; original game assets used as style references. No third-party sampled art or Python raster editing.

Intended resources: `threshold_bandit.tres`, `threshold_keep.tres`, `threshold_beast.tres`, `threshold_medical.tres`. Each resource selects one complete entrance from a shared alpha PNG atlas. Existing SVGs remain fallback assets.

Reference assets: `hero_warden.png`, `bandit_battle_stage.png`, `keep_battle_stage.png`, `beast_battle_stage.png`, `apothecary_battle_stage.png`.

Initial output: `C:/Users/ronal/.codex/generated_images/01a126a9-2eaa-7ee2-a17d-8bfb4d16e494/exec-439fa195-6f35-409b-8295-6ab7a5d2ac76.png`. A spacing refinement preserves the complete artwork while adding large transparent gutters.

## Exact generation prompt

Use case: stylized-concept.
Asset type: original transparent game sprite atlas for four large dungeon entrances.
Input images: image 1 (our Warden) is the MAIN STYLE reference: bold black ink contours, angular flat dark shadow shapes, restrained painted texture, tiny pale edge highlights. Images 2–5 are supporting environment references ONLY for material and dungeon themes, in order bandit village, ruined keep, body-horror worship sanctuary, medieval infested medical ward. Do not reproduce any figures.
Primary request: create ONE square transparent atlas containing EXACTLY FOUR DIFFERENT COMPLETE DOOR/GATE SPRITES in a strict TWO-COLUMN, TWO-ROW grid. Top-left bandit gate, top-right keep portcullis, bottom-left Beast stitched worship gate, bottom-right medieval medical ward doors.
Each quadrant is an independent equal-size cell. Each entire entrance must fit inside the central 60% of its own cell, leaving at least 20% real empty transparent margin on every side. Absolutely no architecture, bars, candles, debris, banners or shadows may cross a cell boundary. No visible grid or labels. All entrances are viewed front-on with a slight three-quarter depth, compatible with a side-view gothic RPG stage, with the full top arch, both jambs and a small complete stone or timber sill/base visible. Door openings are dark; leaves or bars are partially ajar to suggest a passage that can be entered. All four sprites have comparable visual height and ground baseline relative to their individual cell.
Top-left: an outlaw palisade gateway built from damaged rough timber, worn spiked iron straps, a ragged dark burgundy pennant, one broken wooden door leaf ajar. Grim ruined village, muted ochre wood, rust, tiny warm amber edge glints.
Top-right: a ruined medieval keep's pointed stone arch, heavy raised/jagged portcullis and partly opened iron grille, chains and damaged carved wolf heraldry without lettering. Cold slate-gray stone, aged steel, very small pale blue moonlight highlights.
Bottom-left: an original grim body-horror religious arch of rib-like dirty ivory supports, dark burgundy tissue stretched across the gate and closed by coarse sacred stitches, visibly parted at the center; a small thorn halo above the arch and tiny candle niches. No people or creatures. Despair and worship of remaking, muted flesh and bone with restrained crimson accents.
Bottom-right: medieval apothecary ward entrance, worn dark wood double doors partially open, grim carved stone surround, barred inspection windows, small alchemical etched symbols without lettering, a dirty ivory cloth marker and a few sparse moth cocoons attached to the jambs. Medieval plague-hospital mood, charcoal, desaturated sickly sage, dirty ivory, tiny muted green edge glints; no modern hospital fixtures.
Style/medium: dark hand-painted gothic ink sprite artwork matching image 1, heavy uneven black outlines, angular highlights and flat shadows, readable chipped materials and restrained crosshatching; no photorealism, no smooth 3D rendering, no flat simplistic vector icons.
Constraints: genuine alpha transparency everywhere outside the four entrances, no surrounding room scene, no colored or black backdrop, no paper texture outside sprites, no cast floor shadows, no vignette. No text, numbers, logos, labels, figures or extra objects. Preserve extremely generous transparent gutters and whole uncut architecture.

## Exact spacing refinement prompt

Use case: precise-object-edit.
The supplied image is an original four-door transparent game sprite atlas. Preserve the appearance, complete architecture, colors, proportions, textures and bold black ink style of ALL FOUR doors exactly. Change ONLY their size and spacing within the atlas.
Create a STRICT 2-column by 2-row equal-cell square transparent sprite sheet: bandit gate upper-left, keep gate upper-right, stitched bone-and-flesh worship gate lower-left, medieval apothecary doors lower-right. Reduce EACH WHOLE door to occupy AT MOST 60% of its own cell width and height. Center it within that cell with at least 20% EMPTY alpha margin on EVERY side. This means LARGE transparent gutters between the four doors and generous transparent canvas borders. All details including banners, top spikes/halo, full stone bases and cocoon edges must remain complete and contained in their own cell. No door may touch another door's cell or the canvas edge.
Real alpha transparency everywhere outside the four doors and inside their dark open passage where already transparent. Do not add any backgrounds, cast shadows, text, labels or grid lines. Preserve original artwork; only shrink and separate the four entire door sprites.

## Integrated output

Final tool output: `C:/Users/ronal/.codex/generated_images/01a126a9-2eaa-7ee2-a17d-8bfb4d16e494/exec-96a7e8bc-1e16-4ca0-9d8f-f64c35c622b1.png`.
Copied unchanged as `dungeon_threshold_sheet.png` (1254 × 1254 RGBA). All four complete doors remain inside their 627 × 627 cells; actual illustrated widths occupy 65–70% of cells. The prompt's 20% margins were approximate in the generated result, but no sprite crosses its cell or touches the canvas edge. Each AtlasTexture selects the alpha bounding box with eight pixels of safety padding. Python was used only for read-only alpha inspection. Native file copying preserved the PNG, and the Atlas resources contain text metadata only; no pixels were changed.

| Resource | Atlas region (x, y, width, height) |
| --- | --- |
| `threshold_bandit.tres` | 119, 128, 438, 399 |
| `threshold_keep.tres` | 706, 133, 424, 394 |
| `threshold_beast.tres` | 104, 669, 456, 446 |
| `threshold_medical.tres` | 689, 713, 454, 399 |

`DungeonScenery.threshold_path()` selects these resources and preserves the existing original SVG doorways as fallback. No enemy, hero, or backdrop sprite was replaced.
