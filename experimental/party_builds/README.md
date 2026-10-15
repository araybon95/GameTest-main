# Party build and Ranger stance study

- [Before/after party comparison](party-comparison.png)
- [Ranger bow study GIF](ranger-bow.gif)
- [Ranger bow study video](ranger-bow.mp4)

The approved builds are now integrated into default-outfit combat presentation. Selected alternate and equipment outfits retain their own art. Gameplay, equipment and rewards are unchanged.

- [Integrated combat lineup](combat-lineup.png)
- [Integrated Ranger attack](combat-ranger.mp4)
- [Melee lineup](combat-melee-lineup.png)
- [Crusader charge](combat-charge.png)

The proposed Warden and Crusader have broader armored shoulders, heavier limbs and larger melee silhouettes. The Ranger and Occultist have leaner builds. The Ranger stands with his feet closer together and slightly staggered, with a more upright archery posture. Existing colors, clothing, masks and weapons are preserved.

The comparison's upper row uses existing repository artwork at approximate current combat proportions. Its lower row shows proposed artwork and relative sizes on a common baseline. Staff tips, helmet spikes and capes are allowed to extend beyond the body-height reference; the Occultist is not scaled by the staff's height.

The 3.2-second bow study compares the original idle on the left with ready, aim and release poses on the right. Draw and recovery use whole-pose crossfades. This is a three-pose study rather than finished skeletal animation. It keeps complete hands, bow and cloak intact. All poses use the same foot baseline, with subtle horizontal stance shifts. A normal arrow leaves the bow at release; the release pose has no nocked arrow or magic effect. Audio is not included.

## Run

This standalone project requires its original location inside the repository so it can read the existing reference PNGs. From the repository root:

```sh
godot --path experimental/party_builds
```

Tab switches between comparison and bow views, Space restarts the shot, and R disables the traveling arrow and changes soft blends to discrete poses.

For a native rendered export (requires a display):

```sh
godot --path experimental/party_builds --script export_preview.gd -- /tmp/party-build-preview
```

The exporter captures the comparison and 96 bow frames at 30 FPS. The final export completed on Godot 4.6.3 through Xorg/Mesa software rendering. Comparison, ready, aim and release frames were visually reviewed; review found no important code or presentation issues. Godot reports the display driver's unsupported V-Sync mode. That standalone study did not modify production files. The later combat integration has separate smoke checks and native captures below.

The proposed artwork in `assets/party-builds.png` and `assets/ranger-stance.png` was generated from the existing hero references for this study. Only the three top-row Ranger poses are used by the bow preview. The remaining original study poses are exploratory references. Production uses the separately generated, registered six-pose sheets described below.

## Combat integration

Production six-pose sheets live in `assets/art_library/party_builds/`. They were generated from the approved study references and extend the builds into idle, attack, windup/cast, guard, hurt and death poses. Warden attacks retain his shield and use one hand. The Ranger release pose has no nocked arrow. `scripts/party_builds.gd` defines measured atlas regions, body-height references and grounded pivots; it substitutes only default combat artwork. Hub, exploration and HUD portraits retain their existing assets.

Reproduce the native integration capture with `godot --path . --script tests/party_builds_preview.gd`. The original standalone study remains available above.

Validation: all 94 root smoke scripts passed on Godot 4.6.3 with isolated save data (93 in the full run, then the corrected attack-profile identity assertion passed on rerun). Native Xorg/Mesa captures cover both lineups, Ranger release and Crusader charge. Existing Godot shutdown resource warnings remain in some tests; editor import also reports the existing missing export-preset `runnable` key. No script parse errors were found.
