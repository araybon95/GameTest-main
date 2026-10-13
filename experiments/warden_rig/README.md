# Warden Living Armory — articulated reference

An isolated Godot prototype for a hero whose equipment stays recognizable while walking, attacking and appearing on their card. **The live game and both previous experiments are unchanged.** The parent `.gdignore` excludes this standalone project's resources from main-game imports/exports.

![Quick motion and equipment preview](preview/quick-preview.gif)

The quick preview is reduced to 15 fps; use the [native 30 fps clip](preview/articulated-warden.mp4) to judge the movement.

![Sword equipped across hallway, combat and card](preview/sword.png)

Choose an **arming sword**, **double-headed axe**, or **gem mace**. Every selection immediately updates all three views through one shared appearance profile, without restarting their motion. The original greathelm and corrupted wolf warhelm remain interchangeable, as do the original oxblood cape and ash-grey mantle with gold edging. The matching neck wrap and clasp follow the cape selection.

![Double-headed axe in all three views](preview/axe.png)

## What changed from the older animation experiments

This is a **hierarchy of articulated cutouts**, not a deformation of a single flattened picture and not a four-image flipbook. Upper and lower arms and legs have their own joint transforms. Weapons are separate artwork registered to a gripping-hand socket; the shield is attached to the other hand. Head, torso, waist, cloak, scarf and clasp have independent drawing layers.

Walking uses a two-link limb solver and a repeating stance/swing foot path. The stance foot moves backward at the corridor's scrolling speed; the swing foot lifts slightly and returns forward. Position and velocity meet at both ends of the loop. Small torso movement, head counter-rotation and deformable cape mesh add secondary motion. Walking eases into standing, while **Pause** freezes both actors and travel. **Face left** mirrors the walking rig. **Pace** controls movement and animation together.

The combat view plays an illustrative wind-up, swing and recovery. This does not implement combat damage, attack targeting, item stats or two-handed grip mechanics. The hero card uses another instance of the same rig at a smaller size; it reflects the selected visible equipment rather than a separate outdated portrait.

![Joint hierarchy overlay](preview/joints.png)

[Watch the nine-second native motion and equipment-swap clip](preview/articulated-warden.mp4) · [Original helmet/cape combination](preview/stock.png) · [Gem mace](preview/mace.png)

## Run

Import **`experiments/warden_rig/godot/project.godot`** as a separate Godot project, then press F5. Requires Godot 4.6 or newer, without plugins or additional runtime dependencies.

```sh
godot --path experiments/warden_rig/godot --editor --import --quit
godot --path experiments/warden_rig/godot
```

**Save look** and **Load look** use `user://warden_rig_profile.json` in the lab's own **Ashen Warden Articulation Lab** user-data directory. This stores schema-1 prototype-only hero/weapon/helmet/cape identifiers. Unsupported schemas, malformed content and unknown selections leave the current look intact. These are lab exports, not campaign saves, real inventory or unlocked rewards. Changes remain local; no multiplayer protocol is implemented.

## Artist replacement kit

All active source PNGs are under `godot/assets/`, with dimensions, source notes and SHA-256 hashes in `sources.json`. `original.png` is a reference image only. Source outputs are preserved unchanged; fitting is performed by Godot.

- `body_parts.png`: 2 × 3 cells, ordered torso, waist, near thigh, far thigh, near shin/boot, far shin/boot.
- `arm_parts.png`: 2 × 2 cells, ordered near upper arm, near forearm/hand, far upper arm, far forearm/hand.
- `gear_parts.png`: 2 × 2 cells, ordered shield, sword, double-headed axe, mace. No weapon is baked into an arm or hand.
- Helmet, cape, scarf and clasp images are unchanged copies of the current cosmetic study.
- `attachments.json` records atlas cells, anchors, segment endpoints and attachment sockets in a normalized 512 × 512 tile coordinate system. `alignment.json` supplies registration for the existing cape/scarf source canvases.

For a hand-drawn replacement, preserve the tile canvas and anchor/end positions. Paint hidden overlap around shoulders, elbows, hips and knees. Limb art is aligned from its anchor to its endpoint, so neighboring pieces can rotate without needing matching full-character drawings. Weapons should share a grip attachment contract; a two-handed or dual-wielded weapon needs additional pose/grip information, not just a larger icon.

The Node2D hierarchy is a Godot cutout rig with analytic limb articulation. It is **not a Spine skeleton/export**, and the new parts are AI reconstructions rather than a lossless separation of the original. Lower legs still include boots; forearms include gauntlets. These pieces and their sole contact, armor overlaps and changing occlusion need artist cleanup before production. Full attacks, back-facing views, other heroes and every possible equipment combination have not been authored.

## Future integration boundary

The reference proves the same appearance IDs can drive moving, fighting and card views. A later live implementation should separate equipment rules from their visual attachments, validate ownership, and load pose/grip profiles for weapon families. Online parties should synchronize validated appearance IDs, then reconstruct the same rig locally. Campaign unlocks and Steamworks remain separate work.

## Verification

`smoke.gd` covers shared selections, unknown-ID and future-schema rejection, atomic imports, hand-grip registration for all three weapons in every view, pose preservation during swaps, articulated knees, reachable foot targets, loop continuity, refresh-rate independence, walk-to-idle easing, pause, facing and isolated profile round trips. Native screenshots were inspected at 1440 × 900. The capture clip contains 270 frames at 30 fps, with sword/axe/mace changes, a pause, and reversed travel.

```sh
godot --headless --path experiments/warden_rig/godot --script res://smoke.gd
godot --path experiments/warden_rig/godot --script res://capture.gd -- /tmp/warden-rig-stills
godot --path experiments/warden_rig/godot --script res://capture.gd -- /tmp/warden-rig-movie movie
ffmpeg -framerate 30 -i /tmp/warden-rig-movie/frame_%04d.png -c:v libx264 -crf 20 -pix_fmt yuv420p -movflags +faststart /tmp/articulated-warden.mp4
```
