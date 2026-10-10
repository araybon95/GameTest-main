# Hero leveling

Victories award XP to surviving active party heroes. Benched, slain, and zero-HP heroes receive none. Rewards are once per encounter, including multi-phase bosses; revisiting rooms does not grant XP.

- Normal combat: 12 XP + 4 per floor after the first.
- Boss combat: 35 XP + 4 per floor after the first.
- Surprised corridor creature: 6 XP + 2 per floor after the first.
- Next-level requirement: 40 + 25 × (current level − 1). Overflow carries forward.
- Maximum level: 10. Each level grants +2 maximum HP and two training points. Growth does not heal current damage.

In the Barracks, use **TRAIN** beneath a roster hero. Each point purchases one upgrade, with six upgrades maximum per stat:

| Upgrade | Per point |
| --- | --- |
| Vitality | +3 maximum HP |
| Might | +4% skill damage (rounded down during attacks) |
| Guard | +1 block from block skills |
| Restoration | +1 healing from skills with flat healing |
| Resolve | +3% chance to resist debuff application |

Training is available between expeditions. Equipment, forge upgrades and hero training stack. Health equipment multipliers apply to the enlarged health pool. Percentage healing already benefits from higher maximum HP. Levels appear beneath combat hero names alongside their class and on dungeon party cards; victory logs announce XP and level gains. Combat skill descriptions include current stat bonuses.

Progress is stored in expedition progression and every save slot/checkpoint. Loading an older slot starts its heroes at level 1 and prevents importing progression from a different saved journey. Existing unlocks and equipment remain compatible. Progress currently belongs to each class roster entry, consistent with existing hero naming and equipment persistence.

Validation: `tests/leveling_smoke.gd` covers thresholds, overflow, level/stat caps, spending rejection, combat resistance, survivor/bench rewards, duplicate prevention, persistence, older save migration, and training UI creation. `tests/leveling_preview.gd` captures the training screen.
