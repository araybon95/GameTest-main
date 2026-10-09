# Ashen Expedition

A Godot 4.7.2 deckbuilding RPG project. The original project code is licensed under the MIT License; see [`LICENSE`](LICENSE). Third-party assets are not covered by that license and remain subject to their own terms. In particular, see `Sound FX Starter Pack Vol. 1/Royalty-Free License (Link).pdf` for the included audio pack's license.

## Running the game

1. Install **Godot 4.7.2** (or a compatible Godot 4.7 release).
2. In Godot Project Manager, choose **Import** and select this repository's `project.godot`.
3. Open the project, let Godot finish importing assets, then press **F5** (or click **Run Project**). The game starts at the title screen.

The project targets Godot 4.7 and uses the GL Compatibility renderer. Godot 4.6.3 has also passed the project's headless combat checks, but 4.7.2 is the recommended version.

## Ashen Expedition

A Slay-the-Spire-style deckbuilder with Darkest Dungeon flavour: a party of
three heroes, each with their own deck, HP, Block and Stress, facing a creature
that telegraphs its intent. Built around a Hamlet hub: choose expeditions, change
your party in the Barracks (recruit the Healer), and record foes in the Archive.

### Flow

Title → Hamlet → (Barracks / Archive / Forge) → Expedition → (battle) → Hamlet.

1. `scenes/ui/title_screen.tscn` is the **Main Scene** (Project Settings →
   Application → Run → Main Scene). **ENTER THE HAMLET** loads the settlement;
   **QUIT** closes the game.
2. `scenes/hub/settlement.tscn` — the **Hamlet**, a single painted town vista. Its
   buildings are baked into the scene art as invisible hotspots: hovering one
   lights it up and reveals its name and purpose (Darkest Dungeon style), and
   clicking it enters. The **gate** ("The Old Road") opens the expedition list.
   A `locked` building still highlights and shows a "sealed" note.
3. `scenes/hub/barracks.tscn` — the **Barracks**. Compose the three-hero party:
   select a slot, then click a hero from the roster (e.g. recruit the **Healer**).
4. `scenes/hub/bestiary.tscn` — the **Archive**. A bestiary that fills in as the
   party faces creatures.
5. `scenes/hub/forge.tscn` — the **Forge**. Spend **Embers** won in battle to
   upgrade the party's cards (each card up to ★3).
6. `scenes/combat/combatscene.tscn` reads the chosen expedition's creature and the
   current party. When the battle ends, **RETURN TO THE HAMLET**.

### The roster and the Healer

Heroes are defined in `GameState.HEROES` (id → name, max_hp, art, deck); the
active three live in `GameState.party`. The **Healer** heals itself (*Mend*) and
the team (*Blessing*), eases Stress (*Solace*), and deals bonus damage against
**Undead** (*Smite*, *Turn Undead*). Swap heroes in the Barracks — changes take
effect on the next expedition.

### Embers and the Forge

Winning an expedition awards **Embers** (The Old Road 5, Bone Warrens 7, the
sealed Weald 12 — see each expedition's `reward`). The Forge spends them to
upgrade any card the party can play, up to **★3**; the cost rises with each level
(`4 + level × 3`). Upgrades are stored per card in `GameState.card_levels` and
applied every time a card resolves through `GameState.card_stats()`, so the
upgraded numbers show in both the Forge and the combat hand. Current Embers
appear in the Forge header and on the combat HUD.

### Adding content (data-driven)

`scripts/game_data.gd` holds all game data. Add an entry and the hub builds the UI
automatically:

- **Hero** → `HEROES` (plus a portrait PNG at `art`).
- **Card** → `CARDS`; reference its id from a hero's `deck`.
- **Creature** → `CREATURES` (name, tags, undead, hp, attack, art, lore).
- **Expedition** → `EXPEDITIONS` (name, region, difficulty, blurb, `creature`, locked).
- **Building** → `BUILDINGS` in `scenes/hub/settlement.gd` (`name`, `subtitle`, `scene`,
  `pos` = its centre and `size` = its footprint in the 1920×1080 layout, sitting over
  the building painted into the vista; `locked`; `expeditions: true` opens the
  expedition list instead of a scene).

Every scene loads it by path — `const GameState := preload("res://scripts/game_data.gd")` —
and reads its static members. No autoload or global class registry is required.

### Editing screens in Godot

Open a screen's `.tscn` file (for example, `scenes/combat/combatscene.tscn`) and
use the **2D** workspace and Scene dock to select, move, resize, and restyle its
saved controls. The title, Hamlet, Barracks, Archive, and Forge have authored
scene-tree layouts; combat's background, header, enemy frame, meters, hand,
party region, battle log, and buttons are saved in the combat scene. Runtime
scripts fill changing values and spawn repeated/data-driven widgets (Archive
entries, Forge rows, expedition cards, and Hamlet hotspots). Combat's hero and
card templates are editable directly inside `combatscene.tscn` as the hidden
`HeroTemplate` and `CardTemplate` nodes. Select one in the Scene dock and edit
its children; the game duplicates that template for the current heroes/cards.
The Hamlet hotspot positions and sizes come from `BUILDINGS` in
`scenes/hub/settlement.gd`.

### Combat UI

The saved combat scene supplies the interactive nodes, background art, title,
combat regions, enemy art slot, meters, and signal connections. These fixed
layouts are editable directly in Godot's 2D editor; `combatscene.gd` fills in
expedition-specific text/art and creates data-driven hero and card widgets at
runtime. Each hero has a HealthBar and StressBar (red and purple); the enemy has
a HealthBar and an intent line. Values update after every action.

Heroes start with three cards. Each standing hero keeps unplayed cards and
draws one new card at the start of every subsequent party turn. Played cards go
to the discard pile; an empty draw pile reshuffles the discard pile. Action
points reset to two each round. The card hand scrolls horizontally when it grows.

### Darkest Dungeon mechanics

- **Death's Door** — a hero reduced to 0 HP is not dead yet; they stand at
  Death's Door and the next blow fells them. Healing above 0 clears it.
- **Stress & the resolve test** — Stress builds from enemy hits and from cards
  like the Occultist's *Dark Blast*. At 100 Stress a hero faces a resolve test:
  ~25% they become **Virtuous** (heal, steadied to 45 Stress, +2 damage) or they
  become **Afflicted** (-2 damage and +3 Stress each turn). The result is shown
  beside the hero's name.
- **Enemy intents** — the intent line shows the coming attack and its target;
  every fourth turn the enemy braces for Block instead.
- **The Healer** — heals itself (*Mend*) and the team (*Blessing*), eases Stress
  (*Solace*), and deals bonus damage against **Undead** (*Smite*, *Turn Undead*).

### Artwork

All art lives in `assets/generated/` (transparent PNGs, Darkest Dungeon style):

- `bg_crypt.png`, `settlement_hamlet.png`, `title_key_art.png` — backgrounds
- `hero_warden.png`, `hero_ranger.png`, `hero_occultist.png`, `hero_healer.png` — portraits
- `enemy_hollow_villager.png`, `enemy_bone_rabble.png` — creatures
- `hamlet_vista.png` — the whole Hamlet as one painted scene (the buildings are
  hotspots over it); `building_barracks.png`, `building_bestiary.png`,
  `building_forge.png`, `building_gate.png` remain for other uses
- `mote.png`, `glow_warm.png` — drifting dust motes and the warm building glow
- `<card_id>.png` for each card (e.g. `wd_slash.png`, `hl_mend.png`)

Any missing file falls back to a text placeholder, so the game always runs.

Scene: scenes/combat/combatscene.tscn
Script: scenes/combat/combatscene.gd
Theme: assets/new_theme.tres

The nested duplicate project and generated .godot cache are excluded. Empty folders use .gitkeep so Git preserves them.

