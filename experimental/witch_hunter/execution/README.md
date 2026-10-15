# Witch Hunter execution study

[Animated preview](witch-hunter-execution.gif) · [MP4](witch-hunter-execution.mp4) · [Uppercut](uppercut.png) · [Crushing blow](crush.png) · [Finished](finished.png)

Approved sequence: a two-handed hammer uppercut snaps the Ash Raider's head back; an overhead windup leads into a crushing head strike, followed by buckling knees and a limp, headless collapse. Both hands remain on one straight hammer. Dedicated paired contact illustrations make both connections explicit, and procedural blood/debris draw in front of the characters.

The first impact is at 0.40 seconds, the crushing blow at 1.03, and the collapsed body is held from 1.50. The loop includes a ready beat and a finished hold. The loose cleaver falls after the uppercut. Feet register to the same ground plane, with a small camera push and brief impact shake. Reduced motion removes camera motion, shake, approach/recoil, weapon-drop travel and animated blood spray while retaining the pose sequence.

This is an isolated experimental showcase. It does not alter lethal-hit gameplay, damage, RNG, rewards, or the existing Warden execution. The approved Witch Hunter concept and the game's Ash Raider supplied the visual references for the generated pose and contact sheets.

Run from the repository root:

```sh
godot --path . --screen 0 experimental/witch_hunter/execution/showcase.tscn
```

Space pauses, R restarts, M toggles reduced motion. Export 96 frames at 30 FPS:

```sh
godot --path . --screen 0 --script experimental/witch_hunter/execution/export_preview.gd -- /tmp/witch-execution
```

The exporter checks artwork initialization, directory creation and each PNG write, returning a failure status if capture fails. The folder remains under `experimental/.gdignore` and is not packaged into the game.

Validation: all 97 repository smoke tests passed, including timing/death-state checks for this execution. The native renderer captured 96 PNG frames; the MP4 is 1280×720 at 30 FPS and the GIF is 960×540 at 20 FPS, both 3.2 seconds. A forced PNG write failure returned exit status 1. Code review found no remaining blockers. Existing Godot font and resource-shutdown diagnostics remain in some unrelated smoke runs.
