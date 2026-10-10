# Tactical bosses, creature matchups and grimdark effects

10 October 2026. This follows the ordinary expedition balance pass described in [ordinary_playthrough_balance.md](ordinary_playthrough_balance.md). Base enemy statistics, XP, prices and camp recovery remain unchanged; the following boss mechanics and equipment modifiers are deliberate additions.

## Boss actions

Any living selected hero can spend **1 AP** on an outlined battlefield prop or its action button. The visible instructions and enemy intent update immediately. Completed actions cannot be repeated, and each Coterie replacement receives fresh objective state without ending combat or awarding loot.

| Boss | Interaction | Result |
| --- | --- | --- |
| Harrowed Slave Giant | Sever two Sacred Chains, 1 AP each | Intact chains grant 10% direct damage reduction, falling to 5% and then zero. Each severed chain permanently lowers the Giant's attack by 10%, to 20% total. |
| Coterie, each form | Break its rite once, 1 AP | Cancels its next healing/stress ritual, or halves its next strike and removes the strike's debuff. Suppression is consumed by the next enemy action. The next form has a new rite. |
| Howling Head | Silence the Choir Idol once, 1 AP | Unending Prayer falls from 8 Stress plus Chill to 4 Stress with no Chill for the rest of the encounter. |

The Last Honorable Son and Moth Knight keep their guard/heavy-strike/exposed cycles. The Undying Lord keeps its support tribute; Exuvia keeps its destructible cocoon. Normal encounters stay limited to three enemies, and boss encounters have at most one additional support. Ordinary boss supports retain 30% of the corresponding normal creature's HP and base attack. Boss rewards remain once per encounter, with party-compatible legendary equipment.

## Creature matchups

Existing undead and faction traits remain separate from these categories. Hunt trinkets improve their wearer's **direct skill and offensive scroll hits**, capped at a combined 25%. Wards reduce **direct hits from the matching creature**, capped at 20%, before Block. Neither modifier changes damage-over-time, reflection, or healing. Skill descriptions share the same target/Mark/defense calculation as actual attacks and display damage before Block without consuming Mark.

| Category | Innate application resistance | New equipment |
| --- | --- | --- |
| Human | None | Outlaw's Tally, Roadward Seal |
| Corrupted | 20% Bleed | Warden's Gravewatch Medal, Graveward Locket |
| The Remade | 15% Chill | Occultist's Severed Litany, Crusader's Penitent Stitch |
| Insect | 20% Poison | Ranger's Chitin Hunter's Lens, Healer's Chrysalis Rosary |

These modest resistance chances prevent application; they do not make a category immune or alter an existing tick. Resisted effects show resistance feedback and do not log a successful application. All eight trinkets use the existing rare/epic loot and shop rules, class eligibility and independently replaceable original SVG icons. Merchants still exclude legendary items. Discovered bestiary pages explain category tactics and boss objectives; unknown pages conceal them. Longer field notes scroll.

## Combat presentation

Melee impacts use broken ink wedges, narrow bone edges and dark blood flecks. Fire uses coals, soot and smoke rather than a bright circular burst. Persistent Burn, Bleed, Poison and Chill use restrained embers, wound marks, miasma and frost fractures on heroes and enemies. Giant chains and the Howling Head's teeth retain their larger boss treatments.

Fully blocked hits, misses, guards, healing and self actions have no injury contact. Nonliving objective props break into dry fragments. Effects stay within the battlefield and respect the existing attacker/target spotlight, fixed HUD and reduced-motion controls.

## Verification

All **40 smoke suites** pass, including actual one-AP boss interactions, phase resets, cancellation, support limits, real skills/scrolls against all four classes, ward-before-Block order, unchanged ticks, resisted/applied/invalid status feedback, Insect cocoons, grounded staging, queued animations, saves and full expedition lifecycle.

Graphical inspection covered six boss-objective states, twelve deterministic effect states, bestiary pages and the new trinket gallery/shop. The merchant sidebar was bounded to keep its complete text inside its panel. The ordinary playthrough audit separately records 26 expeditions and 187 combat victories, with earned progression rather than forced damage. Human testing remains necessary to judge pacing and discovery with fog and full animations.

Preview scripts: `tests/boss_objectives_preview.gd`, `tests/grimdark_vfx_preview.gd` and `tests/creature_matchups_preview.gd`. All graphical assets added in this pass are original native SVGs; the effects are drawn geometry and shaders.
