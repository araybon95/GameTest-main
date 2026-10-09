# Random dungeon events

Each floor contains 3–5 one-use events marked `?`. Their layout is chosen between a room and a narrow corridor. The map draws corridor event cells as long, narrow passages; entering one opens a themed hallway background. Event placement preserves entry chambers, stairs, bosses, camps and the floor's merchant orb.

Entering an unresolved event opens its scene. Choose a living hero with positive health, then click the illustrated object to investigate. Leave Untouched passes safely and consumes the event without granting rewards or inflicting a debuff. The selected hero alone receives any harmful effect. The scene reveals possible rewards and risks before interaction.

Objects are original, independently replaceable assets:

- Abandoned Strongbox: gold or party-compatible equipment; possible Bleed.
- Tainted Supply Cache: gold or a universal scroll; possible Poison.
- Votive Reliquary: gold or a universal scroll; possible Burn.
- Stitched Offering: gold or party-compatible equipment; possible Chill.

Outcomes are 50% reward alone, 25% reward plus debuff, and 25% debuff alone. Rewards choose gold (5–12) 55% of the time, otherwise the object's item pool. Items use the existing rarity weights and equipment class restrictions. Scroll event rewards use the scroll pool, independently of the combat loot's 15% scroll chance. Harmful effects use the existing two-round combat rules; they persist into the next battle and camps cleanse them. Combat now restores saved statuses instead of discarding them on entry.

Each event has a seed assigned during floor generation. Reopening the scene does not reroll it. Resolution is recorded on the room before the UI refreshes, and subsequent clicks cannot duplicate rewards. Event state follows the current in-memory expedition, like existing dungeon state; this is not an active-run disk save feature.

Implementation: `scripts/dungeon_events.gd`, generation in `scripts/game_data.gd`, `scenes/expedition/event_room.gd`. Art: `assets/generated/event_*.png`. Prompts and built-in image-generation mode are recorded in `EVENT_ART_PROMPTS.md`.

Validation: event placement across both dungeon themes and 200 seeds, gold and item outcomes, debuff isolation, duplicate-click protection, safe leave, hero eligibility, status persistence into combat, and scene interaction in `tests/events_smoke.gd`. Existing RPG, multi-enemy, camp/merchant, loot, and Beast progression checks cover integration.
