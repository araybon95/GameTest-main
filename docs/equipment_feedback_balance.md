# Equipment feedback and comparisons

Weapon-equipped damaging skills now carry a presentation-only signature: frost blades leave cyan cuts and shards; venom weapons leave green projectile trails and motes; draining weapons use crimson marks; healing/holy weapons use candle-gold flecks. Consecrated and corrupted ordinary weapons receive matching signatures. Weapon effects remain separate from scroll elements and creature attacks.

The signature is captured with each queued attack. Misses and fully blocked blows suppress elemental impact marks; projectile trails remain a weapon identity, not a successful poison/chill notification. These visuals change no damage, accuracy, statuses, turn costs, drops or RNG calls. Existing status applications still decide whether a debuff lands.

Hovering inventory and merchant gear shows a concise comparison, accounting for Keen/Fortified and Workshop transformations. Selecting equipment in the shared character record opens **Equipment Comparison**, with current/proposed costume, signed gains/losses and scrollable effects/history. **Equip** commits the choice; **Keep Current** or Escape leaves it unchanged. Other-class items are disabled. Stat changes describe equipment bonuses; existing accuracy/proc caps still apply. Increasing maximum HP does not heal. Armour costume priority and the saved equipment-costume opt-out are respected.

## Verification

The [current gameplay audit](gameplay_stability_audit.md) covers equipment, rewards and bounded actual-action playthroughs. Historical balance-run dumps were removed; no price or combat-stat tuning was made during the current audit or cleanup.
