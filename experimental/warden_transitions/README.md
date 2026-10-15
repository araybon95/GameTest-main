# Warden transition study

[Comparison video](comparison.mp4) · [Comparison GIF](comparison.gif) · [Heavy windup still](heavy-windup.png)

An experimental comparison using the approved default Warden combat sheet. The left panel isolates the existing light/heavy timing and abrupt pose cuts. The right panel tries short pose blends, continuous upper-body/forearm deformation, and a longer heavy recovery. Both use the same scale, feet pivot and retained shield, with a one-handed mace strike. The lower part of each drawing is not deformed.

This isolates pose transitions: the production camera, lunge, enemy reaction, blood and gameplay are intentionally absent from the comparison. The two panels run at the same time; their impact moments differ because the proposed windup is longer. The small gold flash marks each impact. This is painted-pose animation with mesh motion and brief dissolves, not newly illustrated intermediate frames or a skeletal rig. Poses have different leg silhouettes even though they share a planted foot anchor.

The original comparison is isolated from gameplay. Its approved shorter-recovery revision is now integrated as described below, keeping cues and effects synchronized and preserving reduced-motion settings and selected outfits.

From the repository root:

```sh
godot --path . experimental/warden_transitions/showcase.tscn
```

Space pauses and R restarts. For a 156-frame native export at 30 FPS:

```sh
godot --path . --screen 0 --script experimental/warden_transitions/export_preview.gd -- /tmp/warden-transitions
```

Validation: native Godot 4.6.3 Xorg/Mesa export completed with all 156 frames. Idle, windup, release and recovery captures were visually inspected. The final render reported only the display driver's unsupported V-Sync warning. Production smoke tests were not rerun because this commit adds an isolated visual study and does not change game code.

Recovery revision: shortened heavy recovery from 0.62s to 0.38s and slash recovery from 0.53s to 0.42s. Return-to-idle blend is now 75ms instead of 120ms; windup and impact hold are unchanged. Re-exported all 156 frames successfully.

## Integration

The approved shorter-recovery motion is integrated for the default-build Warden's Slash and Heavy Strike. `scripts/warden_transitions.gd` owns the presentation timing, blends and upper-body mesh; `scenes/combat/warden_motion.gd` draws it inside the existing cinematic actor. Production keeps its horizontal lunge, camera, enemy reaction and impact effects. Whole-body tilt is disabled for these attacks to avoid tipping the legs. Mesh rasters retain the atlas margins so pose width changes cannot shift the body pivot.

The approved release/impact/duration values are 0.18/0.31/0.80 seconds for Slash and 0.44/0.60/1.16 seconds for Heavy Strike. Cues and effects follow the same timing record. Reduced motion uses discrete poses without the mesh or dissolves. Alternate/relic costumes, Shield Bash and executions keep their existing presentation. Damage, AP and rewards are unchanged.

[Integrated battle video](integrated-combat.mp4) · [Integrated heavy strike](integrated-heavy.png)

Reproduce this capture from the repository root with `godot --path . --screen 0 --script tests/warden_transitions_preview.gd`.

Integration validation: all 95 root smoke scripts passed with isolated save data. The final attack-profile and combat-performance checks also passed after removing whole-body tilt. Native Godot 4.6.3 Xorg/Mesa captured 96 real battle frames covering Slash, Heavy Strike, impact and recovery. Code review found no remaining blockers. Godot shutdown resource warnings remain in some smoke tests; editor import retains the existing missing export-preset `runnable` diagnostic, with no script parse errors.
