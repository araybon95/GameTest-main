# Ashen Expedition

A grimdark, side-view party RPG built in Godot. Assemble three heroes in the
Hamlet, explore multi-floor dungeons, resolve illustrated encounters and fight
with shared party turns.

## Current dungeon experience

Expeditions begin in a painted dungeon entrance with standing, combat-ready
heroes. Click the iron gate to open the map, then select a reachable room to
enter it immediately. Rooms marked **?** open full-screen story encounters with
clear choices, costs, rewards and risks. The artwork stays visible for the
outcome, followed by **Continue** back to the map. Decisions and rewards are
saved; resolved discoveries cannot be collected again.

[Full-screen discovery](docs/room_travel/fullscreen-event.png) ·
[Outcome](docs/room_travel/fullscreen-outcome.png) ·
[Dungeon map](docs/room_travel/room-event-map.png) ·
[Preview sequence](docs/room_travel/story-events.gif)

The strongbox has original full-screen artwork. Other events use the same story
layout with existing dungeon backgrounds and painted event objects. Combat,
treasure, camp, merchants and stairs keep their room interactions. Scouting
reveals nearby rooms; explored rooms remain marked on the map. Camp Watch
protects against the existing camp ambush risk.

See [Room selection and discoveries](docs/room_travel/README.md) for details and
save compatibility. **F10 → Dungeon travel → Manual walking** retains the
optional walking controls and original event presentation.

## Warden outfits and customization

The Warden uses complete painted costume art with subtle combat breathing and
an attack pose. Defeating the Undying Lord at the end of the Old Road unlocks
**Ashen Wolf**. Select it in the Workshop and save the appearance; previous saves
that completed the Old Road also qualify. The outfit is cosmetic and preserves
equipment stats. The painted combat poses contain a fixed mace and shield;
additional visible weapon families require additional artwork.

The standing exploration party uses selected costumes. Warden and Crusader are
slightly taller and broader than the other heroes. See
[Warden outfits](docs/warden_outfits/README.md) for Workshop and combat previews.

## Running the game

1. Import this repository's `project.godot` in Godot.
2. Allow the editor to finish importing artwork.
3. Press **F5** to start at the title screen.

The project targets Godot 4.7 with the GL Compatibility renderer. Verification
in this repository uses Godot **4.6.3**. Start with **Enter the Hamlet**, choose
three heroes in the Barracks, and embark from the expedition board or gate.

## Controls

| Context | Controls |
| --- | --- |
| Dungeon map | Click a reachable room to enter; use Scout, Inventory or Retreat |
| Story event | Select a living investigator, choose an option, then Continue |
| Combat | Select a hero; **1–5** selects a skill; **Enter** uses it; **Tab** opens inventory |
| Hero details | Right-click a hero or press **C**; **Q / E** cycles heroes |
| Help and settings | **I** opens contextual controls; **F10** opens settings |
| Optional manual walking | **D / Right** forward, **A / Left** backward, **W / Enter** enters, **Space** toggles automatic walking |

## Other available systems

- [Guild hall](docs/guild_hall.md): saved hall name, banner, lighting and furnishings, plus an expedition board. Online lobbies are not connected.
- [Gameplay systems](GAMEPLAY_SYSTEMS.md): party turns, progression, services and expedition rules.
- [Settings and continuity](SETTINGS_AND_CONTINUITY.md): settings, saved journeys, hero names/colors and memorials.
- [Item and camp artwork](docs/item_camp_art.md): painted item sprites and camp preparation cards.
- [Equipment economy and skills](docs/economy_and_skills.md): merchants, inventory sales, equipment and skill inspection.
- [Readiness and attack timing](docs/readiness_and_attack_timing.md): party preparation and combat presentation.
- [Live art library](assets/art_library/README.md): searchable artwork catalog and replacement instructions.

Abandoned Spine/layered animation experiments and superseded review previews
have been removed. Gameplay assets needed by current scenes, alternate outfits,
manual walking and saved journeys remain available.

## Verification

Smoke checks are Godot scripts in `tests/`. Run a check with:

```sh
godot --headless --path . --script res://tests/room_discoveries_smoke.gd
```

The room-discovery check covers direct arrival, choices, saved outcomes,
unavailable supplies, repeated resolution, invalid routes and migration from
older passage saves. All **90 smoke checks pass** on the cleaned project. The suite also covers combat, outfits,
progression, services, settings and the legacy exploration lifecycle.

## Licensing

Original project code is licensed under the [MIT License](LICENSE). Third-party
assets retain their own terms; source credits and provenance files are kept with
the assets. The included Sound FX Starter Pack license is in its own folder.
