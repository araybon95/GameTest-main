# Warden execution experiment

- [Watch the GIF](warden-execution.gif)
- [Download the MP4](warden-execution.mp4)

The Warden knocks the Raider down with his shield, raises his mace, and crushes the Raider’s head. Foreground blood and bone fragments emphasize contact. The enemy collapses and stays motionless in a blood pool. The action lasts 1.8 seconds; the four-second preview holds the aftermath. The GIF loops for review; the native scene never revives the enemy automatically.

This standalone prototype simulates a direct Warden killing blow against the final enemy at zero HP. It rejects living targets, indirect damage, other attackers, and duplicate triggers. It does not yet connect to production combat, damage, rewards, or death handling.

## Run

```sh
godot --path experimental/warden_showcase execution.tscn
```

Space replays the simulated defeat, Enter skips to the aftermath, and R toggles reduced motion. Reduced motion removes camera movement and flying particles. The HUD stays fixed. Audio is not included.

## Verification

```sh
godot --headless --path experimental/warden_showcase --script tests/execution_smoke.gd
godot --headless --path experimental/warden_showcase --script tests/smoke.gd
godot --headless --path experimental/warden_showcase --script export_execution.gd -- /tmp/warden-execution-frames
```

Headless checks cover trigger gates, duplicate prevention, pose order, synchronized gore, reduced motion, unchanged HUD pixels, and an identical final tableau across later timestamps. The exported frames were visually reviewed; interactive window playback was not verified in the cloud environment.

Painted execution poses and the dedicated contact image were generated on October 14, 2026 using the existing Warden and Raider artwork as references. They are stored in assets/warden_execution.png and assets/warden_execution_contact.png. The sequence combines these poses with the existing shield attack, camera framing, and deterministic foreground effects.
