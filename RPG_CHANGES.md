# Party RPG conversion

Open project.godot in Godot 4.7 and run the project. Choose your party in the
Barracks, then embark from the Hamlet's road. Click adjacent connected rooms.
Find stairs on each floor and use Descend; defeat the final floor's guardian.

Heroes share a party turn and may act in any order. Each has their full fixed
ability set and two AP. Basic actions have no cooldown; powerful attacks skip
one subsequent party turn, and healing/support abilities skip two. End Party
Turn resolves the displayed enemy intent. Existing ability illustrations,
portraits, backgrounds, themes, stress tests and Death's Door remain in use.
Forge upgrades now improve abilities.

Each expedition generates two or three connected floors. Health, stress,
afflictions, virtues and slain heroes persist between encounters. AP, Block
and ability cooldowns reset for a new encounter. Camps offer a one-time recovery;
treasure and combat earn Embers. Retreat ends the run. State remains in memory
as in the original project; persistent saves are not implemented.

Navigation uses validated unanimous votes. Single player has one local voter;
the rule supports multiple participant IDs and rejects non-adjacent movement.
Network transport, lobbies and ownership of heroes are future work. Bosses use
existing enemy artwork and stronger stats. Equipment inventory and selectable
skill loadouts are also future extensions; this version supplies fixed sets.

Validation: tests/rpg_smoke.gd checks 100 seeds for connected floors, navigation
agreement, instantiated dungeon/combat interfaces, shared turns, cooldowns,
encounter persistence, enabled victory controls and traversal to the final boss.
Run with Godot --headless --path . --script res://tests/rpg_smoke.gd.
