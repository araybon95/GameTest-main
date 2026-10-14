# Room selection and illustrated discoveries

[Full-screen discovery](fullscreen-event.png) · [Outcome](fullscreen-outcome.png) · [Room map](room-event-map.png) · [Resolved room](room-event-resolved.png) · [Preview sequence](story-events.gif) · [Entrance chamber](entrance.png) · [Standing lineup](standing-lineup.png)

New procedural expeditions begin in a grimdark entrance chamber. Click the iron
gate or Dungeon Map to choose a room. Opening the map does not move the party or
spend resources. Selecting a reachable room enters it immediately, including
routes through cleared rooms. There is no corridor travel screen or new passage
encounter roll in this mode.

Mysterious chambers are marked **?**. Entering one opens a full-screen illustrated
story with hero selection and choice cards showing costs, rewards and risks.
The illustration stays visible while the result replaces the choices, followed
by Continue back to the map. Decisions persist, including leaving an object
untouched; reopening a resolved room cannot repeat its rewards or consequences.
Hero, class skill and supply rules retain their existing mechanics.

The strongbox prototype has original full-screen artwork. Other existing events
use the same story layout with existing dungeon backgrounds and enlarged event
illustrations; bespoke artwork for each can follow after visual review. Combat,
treasure, camp and stairs keep their room interactions. Camp Watch protects
against the existing camp ambush risk. Fixed story encounters remain room content.

Unknown encounters stay mysterious until entry. Scouting reveals nearby rooms;
newly revealed rooms receive a brief NEW badge. Cleared rooms remain marked on
the map. Inventory, scouting and retreat remain available. Party members stand
in combat-ready poses using selected complete costume art and subtle breathing.
Warden and Crusader remain 8% taller and 5% broader in these exploration views.

Unresolved room discoveries from the earlier passage prototype are restored to
rooms. Resolved discoveries stay resolved. An older saved journey already in a
passage finishes through its existing flow before room selection takes over.
Settings → Dungeon travel retains Manual walking and its original event layout.

Preview fixtures reveal part of a floor and place a strongbox adjacent to the
entrance for review; real runs use generated floors and saved event seeds.
The links above show the current room-based flow. Superseded passage previews
and abandoned animation experiments have been removed.

Includes the Warden outfit integration and the current dungeon discovery flow.

Validation: all 90 smoke checks pass. Coverage includes instant arrival,
full-screen choices, missing-supply rejection, save/load of results, repeated
resolution prevention, invalid routes, resolved/unresolved discovery migration,
cancelled and invalid older passage saves, Watch, actual saved-passage combat,
and the legacy dungeon lifecycle. The graveyard smoke check verifies the current painted settlement hotspot
instead of the superseded CemeteryMarker. Some legacy headless scenes emit
non-blocking font/resource-cleanup diagnostics. Native Godot screenshots were
inspected, and the migration correction received an independent code review.
