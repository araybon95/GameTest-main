# Regional expeditions and themed scenes

Open Expeditions from the settlement. Click the Abandoned Village or The Path on the illustrated map to populate that expedition's dungeon options beneath the map. Select a dungeon card, then Embark. Each dungeon contains three floors in one continuous run; dungeon tiers and floor numbers are separate.

The Abandoned Village contains The Old Road (bandits), The Hollow Chapel, and The Forsaken Keep. The Path contains Path of the Beast, Path of Lament, and Path of Ascension. Both first tiers are playable immediately. Completing a tier unlocks eligibility for the next; tiers II and III remain explicitly unreleased. Completion persists in `user://expedition_progress.cfg`; this does not introduce a full save system for party inventory or an active expedition.

Path of the Beast has three procedural floors:

1. The Moonlit Warrens — Supplicants of the Path and Rune-Marked Half-Breeds, guarded by the Shackled Warbeast.
2. The Revel of Runes — the Horned Priest, shifting from Wolf Aspect to Choir Aspect to Goat Aspect in a single continuous encounter.
3. The Altar of the Beast — the Howl Made Flesh.

## Faction theme

The dungeon follows the Beast as a primordial corrupting force rather than a surgical body-horror cult. Its converts are not taken; they come willingly. Grief, fear and war drive mortals to kneel at the idol and renounce the claim to be made in anyone's image, and what they are given back is the end of fear and nothing else they asked for. Converts are marked with bestial runes cut into bare skin with obsidian knives; the runes burn and bleed when a pack gathers, and a pack leader who arranges its followers well can call terrible things out of them.

Most converts stall partway and become half-breeds — beast heads and claws pushing out of human flesh, shed and regrown like a coat, fed by parasites carrying the Beast's blood. A few go further and take an essence of a great predator. Packs are led by Horned Priests: ancient things that have walked the Path for centuries, still able to pass for human at a distance, and a match for any mortal general at planning a battle.

The creature class displayed in the bestiary and on matchup trinkets is **The Beast** (previously *The Remade*). Creature tags are now `Beast`, `Supplicant`, `Half-Breed`, `Priest`.

Floor guardians must be defeated before descending. Only the final guardian completes the expedition. The Horned Priest's aspect transitions preserve party health, AP, cooldowns, and round number; new aspects start with fresh enemy status, block, mark and weaken state. Damage beyond a slain aspect's health does not carry into the next. DOT and reflected damage can also advance an aspect. Rewards are awarded once per defeated encounter, with a guaranteed legendary compatible with a party class from each guardian. The Warbeast and final boss have at most one support at 30% normal enemy health and attack; the Horned Priest fights alone.

Pack attacks include bleed, burn, poison, chill, howls and siren hymns that inflict party stress, and the Goat Aspect's rune blessing that heals. Normal groups remain capped at three. Each floor retains one merchant orb and at least one camp. Existing camp recovery and merchant rarity rules continue to apply.

## Replaceable artwork

All new artwork is original generated art; referenced miniature ranges and the supplied estate image guided the theme without being imported as game assets.

- `assets/art_library/generated/expedition_map_four_regions.png`: four-location expedition map: dilapidated village, descending pilgrimage path, and two sealed future expedition landmarks. Building labels and click areas match those locations. Dungeon options appear beneath the map after selecting a released expedition.
- `assets/art_library/generated/region_map.png`: retained earlier regional map artwork.
- `assets/art_library/generated/bandit_combat.png` and `bandit_camp.png`: ruined village, barricades, outlaw banners and a courtyard fire.
- `assets/art_library/generated/beast_sanctuary.png` and `beast_camp.png`: a clawed-out predator warren beneath a ruined chapel, rune-scored beams, hides, bone middens and a barricaded refuge hollow.
- `assets/art_library/generated/enemy_anguish_penitent.png`, `enemy_anguish_vessel.png`, `enemy_harrowed_giant.png`, `enemy_coterie_seamkeeper.png`, `enemy_coterie_cantor.png`, `enemy_coterie_matron.png`, `enemy_howling_head.png`: individual transparent enemy assets.

Expedition background paths live in `scripts/game_data.gd`. Replace these PNGs individually or change the paths there. Prompts and generation mode are recorded in `EXPEDITION_ART_PROMPTS.md`.

The seven approved designs now have regenerated live combat atlases with measured
idle, attack, hurt and boss cast/roar regions. The Choir Aspect replaces the Serpent.
Active Beast room/camp backgrounds and both discovery objects are updated.
Creature IDs and the internal `remade` equipment keys remain stable for compatibility.
