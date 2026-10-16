# Warden transition study

[Current integrated battle video](integrated-combat.mp4) · [Current heavy strike](integrated-heavy.png) · [Isolated Slash](../art_review/repairs/warden-slash.gif) · [Isolated Heavy Strike](../art_review/repairs/warden-heavy.gif)

The default Warden’s Slash and Heavy Strike use one opaque painted pose at a time, with grounded upper-body motion. Removing whole-pose dissolves prevents duplicate maces, shields and limbs. The approved one-handed attack, shield, foot anchor and shorter recovery remain in place. The windup mace has a locally repaired tip inside the existing canvas.

`scripts/warden_transitions.gd` owns production timing, pose selection and mesh motion; `scenes/combat/warden_motion.gd` draws it inside the cinematic actor. Production retains its lunge, camera, enemy reaction and impact effects. Atlas margins are preserved when building mesh textures. Whole-body tilt stays disabled for these attacks.

Release/impact/duration remain 0.18/0.31/0.80 seconds for Slash and 0.44/0.60/1.16 seconds for Heavy Strike. Reduced motion uses discrete poses without mesh motion. Alternate/relic costumes and Shield Bash retain their existing presentations. Gameplay damage, AP, RNG and rewards are unchanged.

Run the comparison scene from the repository root:

```sh
godot --path . experimental/warden_transitions/showcase.tscn
```

The left panel shows the older attack-profile timing; the right uses current timing and grounded motion. Both use the corrected single-pose selector. Space pauses and R restarts. Export this scene with:

```sh
godot --path . --screen 0 --script experimental/warden_transitions/export_preview.gd -- /tmp/warden-transitions
```

The superseded comparison clips and windup still have been removed. Use the current links above to assess repaired motion; the runnable comparison source remains available.

The integrated video was refreshed through `tests/warden_transitions_preview.gd`, capturing 96 frames in the actual combat scene. The isolated clips use the current motion module sampled at 60 FPS, without the production camera, lunge or effects; their GIF exports play at 30 FPS. See the [repair report](../art_review/repairs/README.md) for scope and validation.
