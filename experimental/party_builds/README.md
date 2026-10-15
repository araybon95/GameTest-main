# Party build and Ranger stance study

- [Before/after party comparison](party-comparison.png)
- [Ranger bow study GIF](ranger-bow.gif)
- [Ranger bow study video](ranger-bow.mp4)

Experimental visual review only. Production art, sizing, combat, equipment and rewards are unchanged.

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

The exporter captures the comparison and 96 bow frames at 30 FPS. The final export completed on Godot 4.6.3 through Xorg/Mesa software rendering. Comparison, ready, aim and release frames were visually reviewed; review found no important code or presentation issues. Godot reports the display driver's unsupported V-Sync mode. Production smoke checks were not rerun because no production files changed.

The proposed artwork in `assets/party-builds.png` and `assets/ranger-stance.png` was generated from the existing hero references for this study. Only the three top-row Ranger poses are used by the bow preview. The remaining sheet poses are exploratory references, not integrated combat assets. Further integration should carry the approved builds and stance through the applicable production outfits and action poses.
