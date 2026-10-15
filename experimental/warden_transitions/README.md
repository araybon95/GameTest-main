# Warden transition study

[Comparison video](comparison.mp4) · [Comparison GIF](comparison.gif) · [Heavy windup still](heavy-windup.png)

An experimental comparison using the approved default Warden combat sheet. The left panel isolates the existing light/heavy timing and abrupt pose cuts. The right panel tries short pose blends, continuous upper-body/forearm deformation, and a longer heavy recovery. Both use the same scale, feet pivot and retained shield, with a one-handed mace strike. The lower part of each drawing is not deformed.

This isolates pose transitions: the production camera, lunge, enemy reaction, blood and gameplay are intentionally absent from the comparison. The two panels run at the same time; their impact moments differ because the proposed windup is longer. The small gold flash marks each impact. This is painted-pose animation with mesh motion and brief dissolves, not newly illustrated intermediate frames or a skeletal rig. Poses have different leg silhouettes even though they share a planted foot anchor.

No production files or gameplay timings are changed. Review this study before integrating it into real attacks; real integration must keep damage, sound and effects synchronized to impact and preserve reduced-motion settings and selected outfits.

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
