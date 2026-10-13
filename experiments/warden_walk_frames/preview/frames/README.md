# Warden walking frame pack

Cleaned review prototype: sixteen transparent candidate PNGs, plus four original baseline PNGs. Twelve new leg drawings fill the transitions; the original upper-body sequence and protected weapon/hand pixels are retained. The cleanup repairs clipped toe tips and mixed leg/cloth overlaps. Minor plate/cloth joins still need visual review before a live-game port.

- Candidate sequence: `frame_00.png` through `frame_15.png`, played at 24 fps.
- Original key poses: indices 0, 4, 8 and 12. One cycle lasts 2/3 second.
- `original_0.png` through `original_3.png` are verification baselines, not additional animation frames.
- Canvas: 590 × 470 pixels. Ground/root: (305,420). Logical hero height: 280 pixels.
- Keep this canvas and root when hand-drawing replacements. `frame-index.json` records registration and timing.

These padded review canvases are not drop-in game textures. The current game sizes characters using the full texture height; a future integration must crop every frame to common registered bounds or respect the recorded hero height/root to avoid shrinking the character.

The live game is unchanged. Source artwork, the standalone Godot preview, verification scripts and comparison video are available at:

https://github.com/araybon95/GameTest-main/tree/main/experiments/warden_walk_frames
