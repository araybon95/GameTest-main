# Expedition screen clarity

The estate selection screen gives most of the screen to an illustrated map. A fading dark mission column keeps the selected dungeon readable without boxing in the scenery. Selecting a landmark reveals three pronounced circular dungeon buttons beneath it; unreleased choices use simple lock silhouettes. The party strip is only 135 pixels tall and retains hero inspection, class/level, gold and inventory count.

The overview presents availability, theme, floor count/difficulty and possible party-class guardian rewards. Floor names and guardian silhouettes move behind an explicit View floor route / Back to overview toggle. All three floors still belong to one dungeon run; region hotspots sit on their associated landmarks, and existing release/progression checks control Embark.

The new original map illustration uses heavy ink outlines, angular shadows and subdued sunset accents. See `assets/presentation/expedition/README.md` for its generation prompt and reference provenance. Reviewed village/path, future dungeon and expanded-route renders at 1920×1080 and 1280×720. `tests/expedition_clarity_smoke.gd` uses native input to verify the route toggle and party inspection, then checks compact circular hit areas, region selection, future locks and unchanged gold/RNG. No gameplay rules changed.
