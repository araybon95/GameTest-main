# Camp poses and combat feedback

Four new transparent seated sprites preserve the original standing character designs:

- `assets/generated/hero_warden_camp.png`
- `assets/generated/hero_ranger_camp.png`
- `assets/generated/hero_occultist_camp.png`
- `assets/generated/hero_healer_camp.png`

The `camp_art` field in `scripts/game_data.gd` selects the resting pose. Camp scenes use these sprites around the fire; combat, inventory and other portraits keep the standing artwork. All four poses were created with the built-in imagegen tool using their existing sprite as an edit target. Full final prompts are in `ART_PROMPTS.md`. Individual poses can be replaced without changing the code.

`scenes/combat/status_visual.gd` attaches an independent visual layer and shader material to each hero, each enemy, and the selected hero portrait. `assets/shaders/combat_status.gdshader` applies effects inside the original sprite silhouette, retaining transparent backgrounds. Animated particles and labeled turn counters distinguish burn, bleed, poison and chill; weaken and affliction have violet aura markers. Multiple debuffs can be displayed at once. Actual HP damage triggers a short red impact flash and recoil. Below 35% health, characters have a slight hurt stance and a HURT marker; visible wound shading begins below 65% health. Slain models desaturate and stop showing active status particles.

These effects are cosmetic. They do not change damage, status duration, health, AP or camp rules. Healing and natural status expiry reset the relevant visuals. Materials are independent so one combatant's status cannot tint another's model.

Verification: `tests/status_visual_smoke.gd` covers independent models, selected portrait updates, multiple statuses, hurt response, natural expiry and healing cleanup. The RPG, multiple-enemy and camp/commerce smoke checks also pass. `tests/status_visual_preview.gd` captures both normal and Healer camp parties plus a three-enemy encounter with status effects for visual inspection.
