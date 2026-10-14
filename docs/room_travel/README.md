# Room-to-room dungeon prototype

[Entrance chamber](entrance.png) · [Standing lineup](standing-lineup.png) · [Watch the prototype](prototype.gif) · [Map](map.png) · [Travel event](event.png) · [Outcome](outcome.png)

New procedural expeditions begin in a grimdark entrance chamber. Click the iron
gate or Dungeon Map to choose a route; clicking the gate does not move the party
or spend resources. While at the entrance, the map can return to the chamber.

Hover or focus a reachable room to highlight its route and inspect known details.
Click it to travel automatically. Unexplored neighbouring rooms remain silhouettes;
cleared rooms are marked. Inventory, scouting, room actions and retreat remain
available. The party stands in combat-ready poses using selected complete costume art with
subtle breathing. Standing body heights match approximately across the five
classes; Warden and Crusader are 8% taller and 5% broader. These are visual
proportions for the map, entrance and travel; combat rules and stats are unchanged.

Each passage takes about 1.4 seconds. Most newly generated passages are quiet;
others contain a discovery, gold or a lone-enemy ambush. Existing unresolved
random events move into the approaching passage. Investigate with a living hero,
use an appropriate supply, choose an available class skill or leave the object.
Travel pauses for decisions and resumes after their outcome or combat victory.
Fixed story encounters, such as the Crusader rescue, remain room content.

Passage outcomes are saved, direction-independent and cannot be repeatedly
collected by reversing, cancelling or approaching a discovery from another room.
Room arrival and journey costs commit after the passage's event, once per room.
Settings and inventory pause the transition. Disabling ambient motion leaves
travel functional. In this mode camp Watch protects against the next passage
ambush instead of a camp departure ambush.

Settings → Dungeon travel switches between Room to room and Manual walking when
no journey is underway. The previous walking branch is also preserved separately.

The map prototype reuses existing dungeon illustrations for room tiles. Bespoke
room artwork and richer hallway event variety can follow after playtesting.
Preview data deliberately reveals part of a floor and supplies a strongbox event
so the interaction can be reviewed; actual runs use generated floors and seeded
passage outcomes.

Built on the Warden outfit integration branch. Neither branch is merged into main.

Validation: 87 of 88 smoke checks pass, including actual passage combat,
multi-edge routes, stale-transition isolation, saved outcomes, mode switching,
Watch protection, event choices and the complete legacy dungeon lifecycle.
The graveyard CemeteryMarker failure is reproduced on unchanged main. Some
headless scene tests emit existing resource-cleanup diagnostics at exit.
