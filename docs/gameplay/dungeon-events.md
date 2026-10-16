# Dungeon discoveries

The default room-selection mode presents unknown encounters as **? chambers**.
Select a reachable room to enter immediately and open its full-screen illustrated
story. Choose a living investigator, inspect the available costs/rewards/risks,
then investigate, use a class skill, spend an appropriate supply or leave.
The result remains on the same artwork until Continue returns to the map.

The strongbox uses bespoke art. Other existing discoveries use dungeon scenery
and their painted objects in the same layout. Outcomes are fixed by event seeds,
stored in the room and included in saved journeys. Cleared events cannot pay out
or apply consequences twice. Hero-specific effects only affect the investigator.
The Crusader's coffin remains a fixed recruitment encounter.

See [the current discovery screens and rules](../room_travel/README.md).
`scripts/dungeon_events.gd` owns resolution; `story_event.gd` builds the default
presentation. Optional Manual walking retains the original clickable-object UI.
