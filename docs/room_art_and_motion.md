# Room art and reference-driven motion

Eight independently replaceable PNGs in `assets/art_library/presentation/rooms` rebuild combat and camp scenery for bandit, keep, remade/body-horror and medical/moth themes. The built-in image-generation tool produced them using the supplied dungeon wall as an ink-language reference and the current Crusader atlas as a shading reference. Exact prompts are saved alongside the art. Existing background sources remain available.

Combat now uses a room composition instead of automatically drawing the corridor's wall tiles over the selected background. Travel retains its layered hallways. The camera now follows the visible room background and restores it after the action.

Steps 1–5:

1. Theme-specific ambient tint links actors with the room's warm, cold, ritual-red or medical-sage palette. Ground/contact positions remain fixed.
2. Enemy intentions use 15px type and a larger allocation. Duplicate effect prose is removed; status strips retain durations, stack/tick tooltips and weakening/mark counters. Health and Block remain visible on the health bar. The lower combat HUD dims less during a strike.
3. Guardian reveals use family motifs: gallows for bandit, broken crown for keep, stitched halo for remade and wing vigil for moth. Existing large boss silhouettes, phases and mechanics are retained.
4. Combat and hero sheets use painted skill art, with 26 separate resource files referencing the 25-icon source atlas (Blessing and Solace share the prayer illustration). Per-ability PNG replacement takes precedence, followed by atlas resources and SVG fallback. The generation prompt is in `assets/art_library/skills/PAINTED_PROMPT.md`.
5. Seated heroes breathe around the foot pivot and receive restrained flickering firelight. Spent camps lower that light. Smoke and embers are cosmetic, deterministic and honor the ambient-motion setting; palette customization is retained.

The supplied recording `Recording 2026-10-11 165427.mp4` was inspected at several times through its 21 seconds. It shows combat rather than corridor walking. Its held poses, abrupt contact, recoil, short camera push and participant spotlight informed the animation pass. Melee now adds a bounded gap-sensitive advance into contact; it changes neither rank nor health. The existing pose-based animation remains the underlying method, rather than skeletal animation.

Verification includes the regression suite, the new `tests/room_presentation_smoke.gd`, and actual rendered room/camp scenes at 1920×1080 and 1280×720. The new check covers every painted skill resource, all camp themes, firelight/reduced motion/foot alignment, unchanged HP/RNG, guardian motif, larger intentions and restoration of the visible background after a camera push.
