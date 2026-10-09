# Group encounters and timed effects

Ordinary dungeon battles spawn 1–3 enemies. Boss rooms spawn one boss plus one
support; the runtime also caps boss encounters at two enemies. Support health
and attack power are 30% of a normal combatant of that support's creature type
at the current dungeon depth, rounded to the nearest integer (minimum 1).
The support does not inherit boss health multipliers. Its attack escalation and
damage-over-time potency are scaled too. It can cover a living ally with Block.

Click an enemy panel to choose the target of attacks, marks, weakening and
scrolls. Each enemy has independent HP, Block, Mark, Weak and status timers.
Slain enemies cannot act or be targeted. Killing a target selects a surviving
enemy. Victory and loot require defeating the complete group, including a boss's
support. Rewards still occur once per room, with the existing boss legendary rule.

Enemies rotate through telegraphed attacks. Some moves hit twice; others apply
Burn, Bleed, Poison or Chill. Every living enemy acts during the enemy phase.
On-hit effects require damage to get through Block. Fire Bolt and Sunfire scrolls
apply Burn to their chosen enemy when they deal damage.

- Burn: 3 damage on each of the next two affected-side turns.
- Bleed: 2 damage on each of the next two affected-side turns.
- Poison: 2 damage on each of the next two affected-side turns.
- Chill: 25% less outgoing attack/spell damage for two affected-side turns.

Damage-over-time ticks ignore Block, but use the existing Death's Door rules.
Enemy ticks resolve before that enemy acts; hero ticks resolve as the next party
turn begins. Chill expires after the affected side acts. Reapplication refreshes
the timer, preserves the strongest potency, and never creates unlimited stacks.
These short-lived effects reset between encounters; health, stress and permanent
resolve conditions continue to persist as before.

The enemy panels are smaller and arranged in one row. Every panel shows its
upcoming move, hit count, target and active effects. Hero cards show effect timers,
and the selected hero's upper-left information panel repeats them.

Validation: tests/multi_enemy_smoke.gd covers encounter caps across 100 seeds,
30% support scaling, target selection, separate marks, victory after the whole
group, timed damage/chill, blocked effects and multiple hits. Existing loot and
party-RPG smoke suites remain applicable. Preview scripts are test-only and do
not add starting items to normal gameplay.
