# Room-to-room Travel Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans to implement task-by-task.

**Goal:** Prototype the approved clickable dungeon map with automatic, stationary-party travel and occasional passage events.

**Architecture:** Reuse room topology, progression and encounter rules. A passage ledger in the existing saved journey stores deterministic undirected hallway outcomes and a resumable transit record. A map-first view previews reachable routes; a short transition pauses for decisions or travel combat before committing arrival.

**Tech Stack:** Godot 4.6 / GDScript, existing painted art and ConfigFile saves.

**Spec:** Approved conversation: click rooms, some quiet journeys, all random exploration events during travel; preserve room contents, complete outfit illustrations and no walking. Fixed story encounters remain rooms.

## Global Constraints
- Preserve existing topology, boss progression, equipment stats, saves and RNG stream.
- Never reroll passage rewards by reopening, reversing, retracing or reloading.
- Arrival commits only after events; invalid/stale routes cannot move the party.
- Respect settings/inventory pauses and ambient-motion preference.
- Prototype remains on a separate branch; retain the previous walking flow as a settings option.

## Review Focus
- Travel ambush victory resumes the remaining route instead of clearing the destination.
- Multi-room routes process each edge without bypassing encounters or charging twice.
- Migrated old random-event rooms resolve on travel; fixed Crusader rescue stays intact.
- Saving/loading or cancelling a pending event preserves outcomes and prevents reward duplication.
- Dead heroes cannot investigate, route preview reveals no unknown rooms, and reduced motion remains playable.

### Task 1: Passage state and event resolution
Files: `scripts/passage_events.gd`, `scripts/game_data.gd`, `scripts/dungeon_events.gd`, `tests/passage_events_smoke.gd`.
- [x] Write/run failing ledger tests: quiet/event seeds, undirected keys, unchanged loot RNG, once-only choices, old events, save roundtrip and resumed ambush.
- [x] Implement `key(floor,a,b)`, `prepare_floor(state)`, `encounter(state,a,b)`, `resolve(state,event,hero,action)` and transit validation with stable seeded outcomes stored in journey.
- [x] Add explicit room-event resolution and travel-combat room access; verify ordinary boss rewards unchanged.

### Task 2: Map-first interaction and stationary transition
Files: `scenes/expedition/route_map.gd`, `scenes/expedition/map_travel.gd`, `scenes/expedition/dungeon_view.gd`, `scenes/expedition/dungeon.gd`, `scripts/game_settings.gd`, `tests/map_travel_smoke.gd`.
- [x] Write/run failing scene tests for clickable previews, automatic quiet arrival, event pause, skip guard, live costumes, dead investigator, stale run and battle continuation.
- [x] Build illustrated room tiles, hidden silhouettes, route highlighting, known-risk panel and party markers, retaining inventory/scout/retreat actions.
- [x] Add 1.4-second-per-edge stationary transition with breathing and event decisions; reuse existing camp/treasure/combat arrivals. Settings toggle retains legacy walking; do not change generation.
- [x] Verify settings pause, save compatibility and existing route/lifecycle checks with walking fixtures explicitly selecting legacy mode.

### Task 3: Reviewable prototype
- [x] Run relevant/all smoke checks; compare known baseline failures.
- [x] Render map, quiet travel, event choice and combat continuation into GitHub review artifacts.
- [x] Independently review, address findings, commit and publish prototype PR without merging main.
