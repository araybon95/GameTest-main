# Experimental designs

[Download all project artwork](../ARTWORK-DOWNLOADS.md) · [Latest Witch Hunter Krita files](witch_hunter/krita-current/README.md)

Use this folder to test and review artwork, animation, enemy variants and other
game designs before integrating them into the main game.

For larger experiments, create a descriptive subfolder containing the design
notes, assets, previews and instructions needed to review or run it. Keep
approved production changes in the game's normal asset and script directories.

The folder's `.gdignore` keeps review assets out of the main Godot import scan.
Standalone Godot prototypes should have their own `project.godot` and be opened
as separate projects.

## Current previews

- [Witch Hunter](witch_hunter/README.md): hooded two-handed hammer
  fighter, sealed faceplate, matched armor, shoulder devotional reliefs and
  upper chains, with a banishment seal engraved on the hammer. The default combat
  design and five skills are integrated; the [uppercut/crush execution](witch_hunter/execution/README.md) is experimental.

- [Ranger bow and two-shot execution](ranger_showcase/README.md): narrow-stance
  draw/release transitions, a rapid stomach shot and headshot, dropped cleaver,
  and an abrupt limp collapse. Runs from the repository root; reads its review
  PNGs directly because this folder is excluded from the main import scan.

- [Party builds and Ranger stance](party_builds/README.md): heavier melee heroes,
  leaner ranged heroes, a before/after lineup and a narrower-stance bow study.

- [Dedicated battlefield ground](battlefield_ground/README.md): integrated themed
  floor with shared foot anchors and independent background camera movement.

- [Warden execution](warden_showcase/EXECUTION.md): shield knockdown, crushing
  mace finish, foreground gore, and a motionless corpse aftermath. Now integrated
  into normal combat; includes a captured in-game preview.

- [Warden attack showcase](warden_showcase/README.md): Slash, Heavy Strike and
  Shield Bash with dedicated painted poses, isolated framing, contact blood
  sprays and a fixed HUD.
- [Grounded Raider breathing](hooded-raider-breathing.gif): revised idle with
  fixed legs and feet, continuous chest/shoulder breathing, subtle forearm sway
  and a cleaver that follows the gripping hand. The 1.6-second loop contains
  32 frames; protected leg and boot pixels remain identical throughout.
- [Hooded Ash Raider animation](hooded-raider-animation.gif): a looping artwork
  preview of the initial twelve painted poses. Its original idle frame stepping
  is superseded by the grounded breathing preview above. Action timing is
  illustrative; in-game timing uses combat profiles.
