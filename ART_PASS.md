# First ink art pass

The Old Road's first-floor scenery, Warden and Ash Raider are the visual pilot. Other heroes, enemies and dungeon themes still use their existing artwork. This deliberately establishes the treatment on a small set before extending it to the roster.

## Artwork

Production PNGs are in `assets/generated/`:

- `hero_warden.png`: darker idle Warden with a tiny cyan mace rune.
- `enemy_ash_raider.png`: darker idle raider with small ember visor and blade highlights.
- `combat_pose_warden.png` and `combat_pose_raider.png`: illustrated attack on the left, hurt on the right. Measured atlas splits live in `scripts/combat_pose_regions.gd`.
- `hero_warden_walk.png`, `hero_ranger_walk.png`, `hero_occultist_walk.png`, `hero_healer_walk.png`, and `hero_crusader_walk.png`: two traveling frames for each of the five classes. The runtime trims alpha padding for each frame.
- `bandit_combat.png` and `bandit_battle_stage.png`: the matching Old Road village scenery; the combat stage consumes the latter.

These assets were created with the built-in image generation tool, referencing our existing original project art. Production prompt set:

1. Preserve the Warden's closed greathelm, iron plate, red tabard/cape, rectangular shield and spiked mace. Full body facing right, real transparency. Bold hand-inked graphic contours, broad angular flat black shadows, sparse scratches, readable silhouette. Darken iron to charcoal steel and cloth to burgundy; preserve narrow ivory highlights and add one small cyan mace rune.
2. Preserve the Ash Raider's iron face mask, scarred arms, red sash, patchwork leathers, cleaver and chain. Full body facing left, real transparency. Match the Warden's ink style, charcoal armor, muted skin and burgundy cloth. Small ember visor and cleaver accents.
3. For each fighter, create two separated full-body poses: left attack, right hurt. Preserve character identity, equipment and facing. Use darker flat shadows and tiny bright accents, with all weapons and boots visible against transparency.
4. All five classes walking: two consistent side-facing travel frames, stepping forward in alternating phases, same head height and foot baseline. Retain each class's original equipment and dark colors: Warden cyan rune, Ranger lime bow charm, Occultist violet magic, Healer warm lantern, Crusader crimson armor accents. Real transparency, no ground or text.
5. Old Road: preserve ruined timber village, bandit banners, stakes, gallows, distant keep and orange dusk. Simplify to thick black contours and flat angular shadows. Broad horizontal cobblestone fighting ground, empty stage, small bright torch accents, no text or characters.

No Workshop artwork was imported. Immersive Area Backgrounds is a visual reference for layered movement and fog: https://steamcommunity.com/sharedfiles/filedetails/?id=3404150724. Its page describes edits to game and other creators' backgrounds and does not supply a general reuse license.

## Items

All 58 editable SVG item assets received stepped material shading, darker contour shadows and narrow colored edge gleams. Existing licensed geometry and credits remain intact in `assets/items/CREDITS.md`. Rarity borders remain separate UI elements. Each item can still be replaced independently with an SVG or a same-name PNG override. Item brightness amplification was reduced to avoid bleaching the new shading.

## Hallway travel

Accepted map movement opens `scenes/expedition/hallway_travel.gd` for a short side-on travel view before resolving the destination. It uses the current floor's own scenery, slow fog and faster foreground movement. All five hero classes have dedicated illustrated travel frames, combined with subtle stride sway. This is an initial walk animation pass, rather than a complete skeletal animation system.

Skip resolves presentation once. Repeated input is blocked during travel. Movement voting, provisions, event rewards and encounter resolution remain in their existing authority. The overlay changes no health, gold or loot itself. Fallen heroes are omitted and workshop palette choices are preserved.

## Validation

27 smoke checks passed, including real Apothecary combat/camp/return flow, sprite grounding and pose restoration, inventory/loot rules, movement, safe travel skip and survivor visibility. Visual previews are generated with `tests/ink_art_preview.gd` for combat, impact, hallway travel and the entire item set.
