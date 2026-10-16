# Dedicated combat ground layer

Combat now has a stationary `GroundLayer` sibling of `RoomBackground` under `BattlefieldBackdrop/BattlefieldLayers`. The camera can move and zoom `RoomBackground` without moving the painted floor. Original artwork remains aligned when the camera rests.

`scenes/combat/battlefield_ground.gd` defines the shared surface at Y=430 in the 1920×600 battlefield. Normal actor placement, contact shadows, the stage footer and the Warden execution use this surface. Existing cinematic fighters pivot at their planted feet. This is visual grounding; turn-based combat does not require physical floor collision.

The layer samples the floor band from each existing room image, starting 24 pixels above the surface. A local-coordinate shader feathers that upper edge and becomes fully opaque at the foot line. It works with atlas textures and resizes with the stage. Bandit, keep, beast and medical environments preserve their respective artwork. Current background camera effects remain enabled; no new automatic background movement is introduced.

For larger future pans or parallax, separate floor-free background paintings can replace the scenery while retaining the same ground and actor anchors. The current room images still contain painted floor detail above the stationary floor band.

## Checks and preview

```sh
godot --headless --path . --script tests/battlefield_ground_smoke.gd
godot --headless --path . --script tests/warden_execution_smoke.gd
godot --headless --path . --script tests/room_presentation_smoke.gd
```

The ground smoke check covers all four themes, matching floor artwork, unchanged ground transforms during camera movement, planted cinematic feet, and background restoration. A GPU test validates transparent, half-blended and opaque pixels of the actual atlas floor shader:

```sh
godot --path . --script tests/battlefield_ground_render.gd
godot --path . --script tests/battlefield_ground_preview.gd -- /tmp/battlefield-ground-preview
```

[Captured gameplay](../../experimental/battlefield_ground/README.md) uses a normal Heavy Strike card. GPU verification and capture ran through Xorg/Mesa software rendering. A zero-area slash triangle at the exact impact instant is skipped to prevent a renderer warning; the visible sweep is preserved.

Validation on Godot 4.6.3: all 93 functional smoke checks passed with isolated per-test save data. The native GPU floor-blend check passed, and the final Heavy Strike capture completed without script or polygon errors. Existing shutdown resource/material diagnostics remain in several smoke checks; the native display also reports its unsupported V-Sync mode.
