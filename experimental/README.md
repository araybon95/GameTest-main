# Experimental designs

Use this folder to test and review artwork, animation, enemy variants and other
game designs before integrating them into the main game.

For larger experiments, create a descriptive subfolder containing the design
notes, assets, previews and instructions needed to review or run it. Keep
approved production changes in the game's normal asset and script directories.

The folder's `.gdignore` keeps review assets out of the main Godot import scan.
Standalone Godot prototypes should have their own `project.godot` and be opened
as separate projects.

## Current previews

- [Grounded Raider breathing](hooded-raider-breathing.gif): revised idle with
  fixed legs and feet, continuous chest/shoulder breathing, subtle forearm sway
  and a cleaver that follows the gripping hand. The 1.6-second loop contains
  32 frames; protected leg and boot pixels remain identical throughout.
- [Hooded Ash Raider animation](hooded-raider-animation.gif): a looping artwork
  preview of the initial twelve painted poses. Its original idle frame stepping
  is superseded by the grounded breathing preview above. Action timing is
  illustrative; in-game timing uses combat profiles.
