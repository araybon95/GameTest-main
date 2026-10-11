# Visual overlays and character settings

The artwork loader reads the editable images in `assets/presentation` first, including the panel frame, map backing and attack banner. These PNGs are included in the repository and source archive. Installed artwork remains an optional fallback. The F10 artwork switch applies to both sources. See [the replacement guide](../assets/presentation/README.md) for individual image paths and atlas regions.

Panel borders use only the outer 18-pixel frame segments, excluding the inventory's internal slots and right-hand tabs. This keeps every existing UI layout and text area intact. Compact maps use a faint cropped map grid behind their encounter symbols. Skill cinematics have a painted crimson announcement band. Active heroes and enemy targets have restrained gold and red underlines that disappear with their source portrait during an attack spotlight. Scene shading is confined to the outer edges of the upper 600-pixel stage; lower HUD text remains unaffected. Every decorative control ignores mouse input.

Without local PNGs, the existing drawn iron corner fittings and a drawn crimson banner remain available. There is no dependency on legacy Spine animation files for these overlays.

Character records no longer use camp artwork behind the hero. Existing project images provide separate class settings: the Warden's keep, Ranger's woodland, Occultist's forbidden sanctuary, Healer's reclaimed infirmary and Crusader's crypt. These backgrounds remain independent of the current dungeon and its camp state.

`visual_overlay_smoke.gd` checks fallback decoration, input transparency, selected-marker visibility, distinct available class backdrops and untouched gameplay RNG. Character-sheet, navigation and combat presentation checks cover the surrounding flows. Graphical checks use the character-record and cinematic previews.
