# Warden execution

The approved one-handed mace execution now plays in normal combat when a Warden ability directly kills the final living Ash Raider while wearing his original outfit. It replaces that attack's normal presentation: shield contact, overhead windup with the shield retained, crushing impact, collapse, then a held corpse. The sequence lasts 2.4 seconds at normal combat speed, including its aftermath hold.

Damage, AP, cooldowns, deeds, gold, loot and XP use the existing combat rules. Rewards settle once; Continue and relic reveals wait until presentation finishes. The animation never deals additional damage or consumes gameplay randomness. The corpse remains until leaving combat. Outfits without matching execution artwork (including Ashen Wolf), other enemies, nonfinal kills, other attackers, scrolls, damage over time, misses and blocked attacks retain their existing behavior. A full presentation queue falls back to the ordinary death rather than changing an unrelated attack.

The native renderer draws cached textures and foreground particles within the battlefield. It respects combat speed, ambient motion and the presentation's motion-strength setting. It uses production assets under `assets/art_library/executions/warden/`; exported games do not depend on the experimental folder.

## Verification

```sh
godot --headless --path . --script tests/warden_execution_smoke.gd
```

The integration smoke test drives an actual Heavy Strike card and checks AP, the lethal trigger, excluded kills, control locking, persistent corpse, once-only rewards, loot RNG, reduced motion, combat speed, queue saturation and long-frame completion. Existing combat/death, boss-phase, audio, controls and reward tests remain applicable.

For a rendered production preview, run with a display and an output directory:

```sh
godot --path . --script tests/warden_execution_preview.gd -- /tmp/warden-integrated-preview
```

[Current motion GIF](../../experimental/art_review/repairs/warden-execution-motion.gif) · [Current integrated video](../../experimental/art_review/repairs/warden-execution-integrated.mp4)

The painted assets were generated and revised from the existing Warden and Raider references on October 14, 2026, then visually approved in the experimental showcase. Only the corrected second top-row figure is sampled from the windup atlas; other poses use the original approved artwork.

Validation on Godot 4.6.3: all 92 functional smoke checks passed across the full suite and an isolated retry. `camp_merchant_smoke.gd` timed out on the first run and passed on retry. Several tests still emit shutdown resource/material diagnostics; no assertion or script failures remained. The production sequence was also captured and visually reviewed using Xorg and Mesa software rendering.
