# Combat performance pass

Combat uses grounded pose changes with anticipation, release, a held impact and recovery. Only the attacker and target are spotlighted. Bow and spell projectiles use their profiles' release/contact times; fully blocked blows show a braced stance with a small shield recoil, without blood or hurt shading. Armored floor bosses and the Harrowed Giant use the heavier attack profile.

The Warden and Ash Raider now have six-pose atlases with matching idle, attack, windup, guard, hurt and defeated artwork. The Warden's combat set carries a longsword to match his sword skills. Existing classes use their separate attack, casting, guard and hurt frames. Heroes with a sixth frame use it for defeat; creatures without a separate defeat illustration use their hurt frame with a collapse/fade. All poses retain their foot anchor and aspect ratio.

Burn, bleed, poison and chill applications pulse at impact. Status ticks pulse immediately. Brief ember, blood, vapor and frost marks are bounded to the affected model and fade out independently of persistent status icons. They never change damage, status duration or loot rolls.

Boss entrances retain the boss's larger battlefield silhouette and lore card. Phase transitions queue behind the defeating hit and show the new form and phase marks. Their sound plays once during the reveal; skipping a reveal cannot duplicate it.

## Individually replaceable files

- `assets/art_library/generated/hero_warden_combat_v2.png` and `enemy_ash_raider_combat_v2.png`: original generated transparent pose sheets. Their measured regions are in `scripts/ink_sprite_regions.gd`; idle regions are in the corresponding `*_combat_idle.tres` files. Original sheets are retained.
- `assets/audio/combat/impact.wav`, `death.wav`, `boss.wav` and `phase.wav`: original generated audio accents. Rebuild them with `tools/generate_combat_accents.py`, or replace each WAV individually. Existing weapon sounds play on release, impact/block on contact and defeat after the contact hold.
- `scenes/combat/status_bursts.gd`: short status bursts. Persistent effects remain in `status_visual.gd`; slash/projectile art remains in `strike_effects.gd` and the presentation PNGs.

Pose sheets were created with the built-in image generation tool using the existing Warden and Ash Raider as identity references. Prompt direction: six anatomically consistent full-body states, preserved crimson/steel/leather palette, heavy black ink and restrained bright edges, transparent gutters, Warden facing right with longsword/kite shield, Raider facing left with cleaver/chain. Warden layout was corrected in a second generation pass to keep every weapon and body inside its atlas cell.
