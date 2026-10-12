# Expedition screen clarity

The selection screen now has one quiet backdrop, a larger region map, a single dungeon overview and three compact dungeon options. Future regions use short muted labels; unreleased dungeons use smaller locks and subdued frames. A compact party manifest retains hero inspection, class/level, gold and inventory count.

The overview presents a room illustration, availability, theme, floor count/difficulty and guardian reward summary. Floor names and guardian silhouettes move behind an explicit View floor route / Back to overview toggle. All three floors still belong to one dungeon run; region hotspots still sit on their associated landmarks, and existing release/progression checks control Embark.

No new raster assets or gameplay changes. Existing map and recreated room art remain the visual foundation. Reviewed village/path, future dungeon and expanded-route renders at 1920×1080 and 1280×720. `tests/expedition_clarity_smoke.gd` uses native input to verify the route toggle and party inspection, then checks region selection, future locks and unchanged gold/RNG.
