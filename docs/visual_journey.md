# Character, combat and exploration presentation

The five presentation improvements add a six-state Crusader combat atlas, readable attack preparation, distance-driven walking/footfalls, stronger foreground depth and doorway fades, event investigator/outcome panels, and framed status counters with a target/skill availability caption. Existing camp poses and other hero combat sheets remain in use. All actor poses retain the ground plane; boss scale and gameplay rules are unchanged.

`assets/generated/hero_crusader_combat_v2.png` is a separate replacement file generated with the built-in image-generation tool. The original Crusader standing/camp source remains intact. Alpha bounds are specified in `scripts/ink_sprite_regions.gd`; the idle resource is `hero_crusader_combat_idle.tres`.

Generation prompt: use the original Crusader pose sheet as identity reference; dark grimdark ink illustration, heavy outlines, desaturated silver/deep crimson barbed armor, correct two-arm/two-leg anatomy and weapon grips; six full-body poses in three columns/two rows on transparent background: idle, rightward axe attack, raised heavy windup, shoulder-first braced charge, injured recoil, exhausted fallen crouch. No scenery/text, consistent armor/head scale, generous transparent padding. Follow-up prompt kept the six states and identity while shrinking/spacing them into independent cells with transparent gutters. The final image was visually inspected; measured alpha bounds define the atlas without changing source pixels.

Doorway fades honor Settings → Ambient Motion. Programmatic skip/cleanup remains immediate. Actual interaction commits once after the brief fade. Event result previews use the stored result, so reopening cannot reroll loot or grant it twice. Status text retains stack/tick explanations in tooltips.

Verification: `tests/visual_journey_smoke.gd` exercises Crusader charge posing and ground alignment, preparation/target UI, actual event resolution and repeat protection, stride-triggered audio and one doorway transition. The surrounding smoke tests retain combat, status, hallway, event, shop and progression coverage.

## Brief playtest and next visual priorities

A scripted ordinary Old Road run (seed 20, Warden/Ranger/Occultist, cautious route) completed three floors and eight fights through normal gameplay actions. A separate graphical review sampled combat idle/windup/contact, bow anticipation, an event before/after its actual resolution, camp/rest, walking/doorway arrival, settlement, archive, apothecary and expedition selection. The expedition screen was also checked at 1280x720. This is a scripted playtest and screenshot review, not a manual player session. The ordinary-run harness reported two retained objects at shutdown; no script errors occurred during the run.

Ten next steps, in priority order:

1. Unify scene lighting: use each area's light direction and shadow color on actors, props and foregrounds.
2. Rebalance the combat HUD: smaller persistent party statistics, larger enemy intents, fewer repeated labels, and more breathing room around the action.
3. Give bosses bespoke staging: unique entrance compositions, phase silhouettes and scenery reactions.
4. Replace remaining flat skill/item glyphs with small painted icons, retaining bright rarity accents.
5. Give camp its own visual rhythm: firelight on seated heroes, subtle smoke and stronger separation between rest and preparation controls.
6. Add individual event object states: closed/opened, intact/defiled and empty/looted illustrations.
7. Make archive volumes physical: distinct covers, worn page edges, ink illustrations and restrained page-turn transitions.
8. Redesign equipment inspection around the hero: illustrated slot arrangement, stronger equipped/unequipped distinction and stat comparison emphasis.
9. Add settlement depth: foreground framing, independent chimney/candle layers and individual building approach animations.
10. Standardize motion and typography across older screens, then audit dense layouts at 1280x720 and wide aspect ratios.
