# Ranger bow and execution study

- [Quick Shot video](ranger-bow.mp4) · [GIF](ranger-bow.gif)
- [Two-shot execution video](ranger-execution.mp4) · [GIF](ranger-execution.gif)
- [Stomach hit](stomach-hit.png) · [Headshot](headshot.png) · [Final collapse](finished.png)

Experimental visual review. These files add no production skills, damage, resource costs, execution triggers or rewards.

Quick Shot uses the approved narrow-stance Ranger artwork with short draw/release/recovery blends, subtle upper-body and forearm movement, bow recoil, and an ordinary traveling arrow. The feet remain on the shared baseline. This isolates the Ranger motion; the bandit's normal hit reaction and gameplay camera are outside this bow study.

The execution uses a new six-pose Ranger sheet, five bandit reaction poses and a detached cleaver prop. The Ranger aims low, releases, immediately renocks, aims at the head and releases again. The bandit clutches the stomach wound, releases the cleaver, then loses muscular tension on the second hit. A short succession of limp collapse drawings ends with a still corpse, both arrows embedded, and the cleaver on the ground. Foreground blood bursts mark both impacts. The head remains intact.

## Timing

| Event | Seconds |
| --- | ---: |
| First release | 0.34 |
| Stomach impact and cleaver release | 0.46 |
| Renock | 0.50 |
| Second release | 0.70 |
| Head impact; tension lost | 0.82 |
| Collapse finished | 1.16 |

The two impacts are 0.36 seconds apart. Full collapse takes 0.34 seconds after the headshot. Both clips include a short ready lead-in and an end hold for review. They are silent. The execution uses rapid painted pose cuts rather than a physics ragdoll; its final pose stays still.

## Run

From the repository root:

```sh
godot --path . experimental/ranger_showcase/showcase.tscn
```

Space pauses, Tab switches between bow and execution, R restarts and M toggles reduced movement/effects. The showcase also alternates automatically.

For native export:

```sh
godot --path . --screen 0 --script experimental/ranger_showcase/export_preview.gd -- /tmp/ranger-showcase
```

The exporter captures 84 frames per clip at 30 FPS, 1280×720. The source art was generated from the approved Ranger and hooded Ash Raider references. Source sheets remain in `assets/` with measured crop regions and registration anchors in `showcase.gd`.

The intended future gameplay hook is the same kind of automatic lethal-hit finishing presentation used by the Warden. Review the sequence before implementing that trigger and its reduced-motion/gameplay timing behavior.

Validation: native Godot 4.6.3 Xorg/Mesa export completed with all 168 frames and no script/resource-loading errors. Ready, low release, stomach wound/drop, head impact and final collapse frames were visually reviewed; code and visual review found no important blockers. The renderer reports the display driver's unsupported V-Sync setting. Production smoke tests were not rerun because only experimental files and the experimental index changed.
