# Visual overlays and character settings

The artwork loader reads the editable images in `assets/presentation` first, including the panel frame, map backing and attack banner. These PNGs are included in the repository and source archive. Installed artwork remains an optional fallback. The F10 artwork switch applies to both sources. See [the replacement guide](../assets/presentation/README.md) for individual image paths and atlas regions.

Panel borders use only the outer 18-pixel frame segments, excluding the inventory's internal slots and right-hand tabs. This keeps every existing UI layout and text area intact. Compact maps use a faint cropped map grid behind their encounter symbols. Skill cinematics have a painted crimson announcement band. Active heroes and enemy targets have restrained gold and red underlines that disappear with their source portrait during an attack spotlight. Scene shading is confined to the outer edges of the upper 600-pixel stage; lower HUD text remains unaffected. Every decorative control ignores mouse input.

Without local PNGs, the existing drawn iron corner fittings and a drawn crimson banner remain available. There is no dependency on legacy Spine animation files for these overlays.

Character records no longer use camp artwork behind the hero. Existing project images provide separate class settings: the Warden's keep, Ranger's woodland, Occultist's forbidden sanctuary, Healer's reclaimed infirmary and Crusader's crypt. These backgrounds remain independent of the current dungeon and its camp state.

`visual_overlay_smoke.gd` checks fallback decoration, input transparency, selected-marker visibility, distinct available class backdrops and untouched gameplay RNG. Character-sheet, navigation and combat presentation checks cover the surrounding flows. Graphical checks use the character-record and cinematic previews.

## Class borders and expedition selection

`VisualOverlays.frame(control, hero_id)` uses the shared painted border with original code-drawn ornaments: barbed iron for the Crusader, violet runes for the Occultist, riveted steel for the Warden, green leaves for the Ranger and devotional crosses for the Healer. The ornaments remain inside the outer ten pixels. Buttons brighten their ornaments on hover/focus and dim them when disabled; availability badges and disabled input remain authoritative. Repeated decoration reuses the existing frame, including when cards are built before entering the scene tree.

Frames appear on roster/training cards, character records, party bars, preparation cards and skill buttons/hover cards. Generic older panels and labeled buttons receive the same painted frame through GothicPresentation. The painted source border is sliced into a six-pixel destination margin to preserve smaller labels. Character illustrations and gameplay data are untouched.

The expedition selector keeps the same village/path/future building hotspots, adds a dim landscape backing, painted title banners, framed map and input-transparent edge shading, and gives the two expedition families distinct dungeon borders. Dungeon status, three-floor runs and unreleased locks are unchanged. The Old Road description now names its three current bosses.

`tests/class_ui_smoke.gd` covers all five class styles, detached-card construction, duplicate prevention, transparent decoration, expedition family switching, unreleased locks and unchanged RNG.
