# Review current artwork

1. Download and extract [01-current-frames.zip](01-current-frames.zip).
2. Paste [REVIEW-PROMPT.md](REVIEW-PROMPT.md) into the review chat.
3. Choose one character and outfit. Attach its comparison sheet plus the original transparent PNGs from `native-frames/`, six to eight images per batch.
4. Use [current motion previews](repairs/README.md) for grounding, contact, weapon drops and reduced motion. Attach the exact surrounding frames when a transition is suspect.
5. Record supported findings in [FINDINGS-TEMPLATE.csv](FINDINGS-TEMPLATE.csv), identifying the frame ID and timestamp. Do not infer anatomy from a tiny contact-sheet thumbnail.

The current frame index records paths, states, source hashes and canvas-origin offsets. The Witch Hunter appears as `default-crusader` internally for save compatibility. Compare within one outfit: original, alternate, equipment/relic and Ashen Wolf appearances are intentional differences.

The active Witch Hunter opening pose comes from `execution/assets/uppercut-lead-in.png`; jaw contact uses `uppercut-corrected.png`. Other cells in the source atlases can serve different poses. The current [Krita pack](../witch_hunter/krita-current/README.md) includes the repaired opening pose; Judgment remains a separate experimental family.

A rigid hammer's crosswise head may project at an angle in perspective. Hands can legitimately occlude part of a shaft. Distinguish artwork errors from crop/registration, camera scale, layer order, GIF palette effects and intentional dropped weapons. Preserve approved designs when proposing a correction.

The historical overview and animation-sampling packs are not included in the current branch. Current production sources remain in [the art library](../../assets/art_library/README.md); source atlases and selectable variants are retained.

Only files actually attached and inspected count as reviewed. The audit remains partial; do not certify unseen frames from an inventory or ZIP upload.
