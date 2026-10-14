# Warden attack showcase

An isolated, standalone combat presentation experiment with three different
painted Warden attacks. Normal game combat and balancing are unchanged.

- [Watch the looping GIF](warden-showcase.gif)
- [Download the MP4](warden-showcase.mp4)

The nine-second clip shows Slash, Heavy Strike and Shield Bash in that order.
Each has dedicated windup, contact and recovery artwork. The foreground Warden
and Raider receive focused framing while the other silhouettes and room fade
back. Camera scale, approach distance, contact hold and target recoil differ
between attacks. Ground anchors stay at the same floor level, actors remain
inside the stage, and the HUD stays fixed.

This uses complete painted poses plus motion, rather than articulated limb
animation. Contact produces a dark-red directional spray: narrow for Slash,
larger with heavier flecks for Heavy Strike, and smaller for Shield Bash.
Droplets fall and fade; brief, low floor stains clear before the next attack.
Reduced motion replaces the moving spray with a short static hit mark. Effects
stay above the HUD. Audio is not included. The Warden carries his existing mace
and heater shield.

## Play locally

Open this folder's `project.godot` in Godot 4.6.3 and press F5, or:

```sh
godot --path experimental/warden_showcase
```

Keys **1 / 2 / 3** restart Slash / Heavy Strike / Shield Bash. **R** toggles
reduced motion. The attacks loop automatically.

## Verification and reproduction

From the repository root:

```sh
godot --headless --path experimental/warden_showcase --script tests/smoke.gd
godot --headless --path experimental/warden_showcase --script export_preview.gd -- /tmp/warden-showcase-frames
```

The smoke script checks nine distinct attack-phase selections, actual asset
loading and rendered scene differences, unchanged HUD pixels, ground anchors,
raised-mace vertical clearance, and reduced-motion camera/movement settings.
It also checks that blood waits for contact, heavy bursts exceed shield
spatter, droplets honor reduced motion, rendered blood stays above the HUD,
and stains clear between attacks.
The exporter produces 180 PNG frames at 20 FPS; the MP4 retains that cadence.
The lightweight GitHub GIF is 640×432 at 15 FPS (135 frames), while the MP4 is
800×540. Video captions are added during
FFmpeg encoding. Frame export is checked in the cloud. Interactive window
playback has not been verified here.

The renderer deliberately uses CPU image composition so the same experiment
can be previewed headlessly. It is a visual prototype, not the renderer proposed
for production integration. Main-game damage, turn sequencing, saves and camera
code are untouched.

## Artwork

`assets/warden_attacks.png` is original AI-assisted art generated on 14 October
2026 from the existing Warden costume reference, with a spacing correction for
the raised mace. Raider and room images are copied from the project's existing
art library. No artwork or other assets were extracted from Darkest Dungeon or
the linked video. The video itself could not be accessed in this environment.
