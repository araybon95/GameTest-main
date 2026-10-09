# Regional expeditions and themed scenes

Open Expeditions from the settlement. Click the Abandoned Village or The Path on the illustrated map to populate that expedition's dungeon options beneath the map. Select a dungeon card, then Embark. Each dungeon contains three floors in one continuous run; dungeon tiers and floor numbers are separate.

The Abandoned Village contains The Old Road (bandits), The Hollow Chapel, and The Forsaken Keep. The Path contains Path of the Beast, Path of Lament, and Path of Ascension. Both first tiers are playable immediately. Completing a tier unlocks eligibility for the next; tiers II and III remain explicitly unreleased. Completion persists in `user://expedition_progress.cfg`; this does not introduce a full save system for party inventory or an active expedition.

Path of the Beast has three procedural floors:

1. The Halls of Anguish — Creations of Anguish and the Harrowed Slave Giant.
2. The Choir of Remaking — the Coterie, changing from Seamkeeper to Bone Cantor to Matron of Remaking in a single continuous encounter.
3. The Altar of the Beast — the Howling Head.

Floor guardians must be defeated before descending. Only the final guardian completes the expedition. The Coterie's transitions preserve party health, AP, cooldowns, and round number; new forms start with fresh enemy status, block, mark and weaken state. Damage beyond a slain form's health does not carry into the next. DOT and reflected damage can also advance a form. Rewards are awarded once per defeated encounter, with a guaranteed legendary compatible with a party class from each guardian. The giant and final boss have at most one support at 30% normal enemy health and attack; the Coterie fights alone.

Cult attacks include bleed, burn, poison, chill, hymns that inflict party stress, and the Matron's healing blessing. Normal groups remain capped at three. Each floor retains one merchant orb and at least one camp. Existing camp recovery and merchant rarity rules continue to apply.

## Replaceable artwork

All new artwork is original generated art; referenced miniature ranges and the supplied estate image guided the theme without being imported as game assets.

- `assets/generated/expedition_map_four_regions.png`: four-location expedition map: dilapidated village, descending pilgrimage path, and two sealed future expedition landmarks. Building labels and click areas match those locations. Dungeon options appear beneath the map after selecting a released expedition.
- `assets/generated/region_map.png`: retained earlier regional map artwork.
- `assets/generated/bandit_combat.png` and `bandit_camp.png`: ruined village, barricades, outlaw banners and a courtyard fire.
- `assets/generated/beast_sanctuary.png` and `beast_camp.png`: devotional anatomy, bone arches, votive candles and sheltered ritual recesses.
- `assets/generated/enemy_anguish_penitent.png`, `enemy_anguish_vessel.png`, `enemy_harrowed_giant.png`, `enemy_coterie_seamkeeper.png`, `enemy_coterie_cantor.png`, `enemy_coterie_matron.png`, `enemy_howling_head.png`: individual transparent enemy assets.

Expedition background paths live in `scripts/game_data.gd`. Replace these PNGs individually or change the paths there. Prompts and generation mode are recorded in `EXPEDITION_ART_PROMPTS.md`.

Validated with `tests/beast_smoke.gd` and existing RPG, loot, multi-enemy, camp/merchant and visual-effect checks. Rendered previews cover the region chooser and both dungeon themes' combat and camp scenes. Encounter balance still needs human playtesting, particularly the longer three-form Coterie battle.
