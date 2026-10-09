# Small corridor discoveries

Corridor events keep their narrow map shape and now choose one of three encounters when the floor is generated:

- 40% scattered coins: immediately recover 1–4 Gold, with a message on the map.
- 25% lone roamer: enter combat against exactly one dungeon-appropriate enemy caught by surprise.
- 35% themed object: use the existing clickable event scene.

Room events keep their larger object interactions. The existing 3–5 event placements per floor include these corridor discoveries. Outcomes are fixed during generation; cleared discoveries cannot grant coins or trigger combat again.

A surprised roamer has normal health but deals 30% less attack damage and attacks with 70% accuracy for the entire encounter. Damage reduction applies after escalation/Weak and before Chill. Each hit rolls independently; a missed attack inflicts no damage, on-hit debuff, or attack stress. Non-damaging hymns retain their existing effects. Combat shows the surprise penalty in the enemy's intent card and battle log, and uses the matching hallway background. Combat victory uses normal rewards and opens the passage.

Validated by `tests/corridor_smoke.gd`, plus existing event and multi-enemy tests.
