# Ink art and presentation passes

The darker ink treatment now includes the Warden, Ranger, Occultist, Healer, Ash Raider, Gallows Scout and Gallows Chieftain, with the Old Road's first-floor scenery. The Penitent Crusader keeps his existing combat art. Later-floor enemies and scenery retain their prior artwork. All five hero classes have four-frame hallway walks.

## Roster expansion

The Ranger, Occultist and Healer each have a replaceable `hero_*_combat_sheet.png` with six poses: idle, attack, casting, guard, hurt and alternate idle. The scout and captain have `enemy_gallows_scout_combat_sheet.png` and `enemy_ash_bandit_captain_combat_sheet.png`, each with idle, attack and hurt poses. Production idle resources are matching `.tres` atlas files; older PNGs remain for compatibility.

Measured pose and walk rectangles live in `scripts/ink_sprite_regions.gd`. Atlas extraction preserves transparency and avoids resampling the source art. Combat selects casting, guard or attack for the source and hurt for a damaged target, preserving the floor baseline and body scale. A fully blocked hit keeps the defender braced. Each source sheet can be replaced individually; update its measured regions when changing the layout.

The exact generation and spacing-correction prompts are in `docs/ink_expansion_prompts.json`. These sheets were generated with `image_gen.imagegen`, using the project's existing original assets as references. No external game sprites were imported.

Combat's lower interface uses compact iron corner fittings and a three-column, two-row skill arrangement. All 26 skills have separate original SVG glyphs in `assets/ui/skills/`, with restrained class color accents. Descriptions stay visible in their cards. The hero information and log panels fit alongside the full six-skill Healer set. Burn, bleed, poison and chill have visible glyphs with remaining turns; hover details include stack counts and tick damage.

## Artwork

Production PNGs are in `assets/generated/`:

- `hero_warden.png`: darker idle Warden with a tiny cyan mace rune.
- `enemy_ash_raider.png`: darker idle raider with small ember visor and blade highlights.
- `combat_pose_warden.png` and `combat_pose_raider.png`: illustrated attack on the left, hurt on the right. Measured atlas splits live in `scripts/combat_pose_regions.gd`.
- `hero_warden_walk.png`, `hero_ranger_walk.png`, `hero_occultist_walk.png`, `hero_healer_walk.png`, and `hero_crusader_walk.png`: four traveling frames for each of the five classes, with alternate strides and cloak folds. Measured atlas regions keep the complete silhouettes.
- `bandit_combat.png` and `bandit_battle_stage.png`: the matching Old Road village scenery; the combat stage consumes the latter.

The initial Warden, Raider and scenery assets were created with the built-in image generation tool, referencing our existing original project art. Initial prompt set (the roster and four-frame expansion prompts are in the JSON above):

1. Preserve the Warden's closed greathelm, iron plate, red tabard/cape, rectangular shield and spiked mace. Full body facing right, real transparency. Bold hand-inked graphic contours, broad angular flat black shadows, sparse scratches, readable silhouette. Darken iron to charcoal steel and cloth to burgundy; preserve narrow ivory highlights and add one small cyan mace rune.
2. Preserve the Ash Raider's iron face mask, scarred arms, red sash, patchwork leathers, cleaver and chain. Full body facing left, real transparency. Match the Warden's ink style, charcoal armor, muted skin and burgundy cloth. Small ember visor and cleaver accents.
3. For each fighter, create two separated full-body poses: left attack, right hurt. Preserve character identity, equipment and facing. Use darker flat shadows and tiny bright accents, with all weapons and boots visible against transparency.
4. All five classes walking: two consistent side-facing travel frames, stepping forward in alternating phases, same head height and foot baseline. Retain each class's original equipment and dark colors: Warden cyan rune, Ranger lime bow charm, Occultist violet magic, Healer warm lantern, Crusader crimson armor accents. Real transparency, no ground or text.
5. Old Road: preserve ruined timber village, bandit banners, stakes, gallows, distant keep and orange dusk. Simplify to thick black contours and flat angular shadows. Broad horizontal cobblestone fighting ground, empty stage, small bright torch accents, no text or characters.

No Workshop artwork was imported. Immersive Area Backgrounds is a visual reference for layered movement and fog: https://steamcommunity.com/sharedfiles/filedetails/?id=3404150724. Its page describes edits to game and other creators' backgrounds and does not supply a general reuse license.

## Items

All 58 editable SVG item assets received stepped material shading, darker contour shadows and narrow colored edge gleams. Existing licensed geometry and credits remain intact in `assets/items/CREDITS.md`. Rarity borders remain separate UI elements. Each item can still be replaced independently with an SVG or a same-name PNG override. Item brightness amplification was reduced to avoid bleaching the new shading.

## Hallway travel

Accepted map movement opens `scenes/expedition/hallway_travel.gd` for a short side-on travel view before resolving the destination. It uses the current floor's scenery, slow fog and faster foreground movement. Four illustrated frames, subtle sway and individual frame sizing keep the feet grounded without stretching equipment.

An approaching encounter appears at the end of the passage: an actual creature, event object, campfire or door. The party stops and changes to idle for a 0.6-second arrival pause, then the destination opens. Skip Travel jumps to this stop; Continue proceeds immediately. Cleared rooms show a door instead of an enemy. Hallway gold and lone roaming enemies have their own arrival presentation. Native SVG door, gold and campfire assets live in `assets/ui/`.

Completion resolves presentation once. Repeated movement is blocked during travel. Movement voting, provisions, event rewards and encounter resolution remain in their existing authority. The overlay changes no health, gold or loot itself. Fallen heroes are omitted and workshop palette choices are preserved.

## Validation

All 27 existing smoke checks passed after the expansion. The additional `tests/ink_expansion_smoke.gd` checks distinct hero poses, enemy attack/hurt states, atlas transparency and bounds, destination props, stopped walkers, safe continuation, status durations/stacks and all skill glyphs. Focused checks were repeated after final UI refinements. Visual previews from `tests/ink_expansion_preview.gd` cover the Healer's six skills, three enemies, caster/bow reactions, captain impact and the arrival stop. `tests/ink_art_preview.gd` also covers the item gallery.
