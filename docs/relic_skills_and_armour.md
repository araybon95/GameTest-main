# Relic skills and armour choices

Legendary class weapons grant an additional combat skill while equipped, including renamed heirloom copies. Each has a three-party-turn cooldown and cannot be tempered at the forge. Existing passive weapon bonuses still apply.

| Weapon | Skill | AP | Behaviour |
| --- | --- | --- | --- |
| Oathkeeper | The Last Oath | 1 | Guard the most wounded other living ally until the next party turn, gain 6 base Block, intercept their hits and retaliate once for 6 base damage. |
| Venomous Thornsong | Thornsong Volley | 2 | 3 base damage to each living enemy; damaging hits apply two-turn Poison unless resisted. Equipment bonuses apply per shot. |
| Vampiric Gravetide | Gravetide Offering | 2 | 6 base damage; heal the most wounded companion, capped by both actual damage and 5 base healing plus equipment/training bonuses. |
| Dawn's Mercy | Dawn's Absolution | 1 | Cleanse Burn, Bleed, Poison and Chill from the most afflicted living ally; grant 4 base Block. |
| Unending Sacrament | Unending Charge | 2 | Pay 2 HP, advance to P1, deal 8 base damage and gain 4 base Block; damaging hits apply two-turn Bleed unless resisted. Requires more than 2 HP. |

Heavy Warden faction/relic plate and Crusader rare/relic armour cost 2 AP for manual formation moves. Ranger armour grants one free manual move per party turn and reduces skill Block by 1. Occultist faction/relic vestments reduce skill Block by 1. Healer faction/relic armour reduces skill damage by 5%. Skill-driven movement retains its skill cost. Item descriptions, comparisons and formation buttons expose these trade-offs.

Visual inspection at 1280×720 verified six-skill hands, the healer's seven-skill hand, the character record and hover cards. Added scroll reveal for keyboard selection, a compact seven-skill character panel, shorter in-card descriptions, automatic ally targeting hints, cooldown duration and remaining turns. Signature skill icons reuse individually replaceable weapon artwork.

Validation: the 71-check suite initially found two icon assertions assuming all skills used the old glyph/painted atlas. Updated those assertions to validate relic weapon art separately; both passed on rerun. The affected combat controls, hover, comparison and static-screen checks also passed. The new relic smoke check covers equipment gates, renamed copies, cooldown/expiry, interception, once-only retaliation, killing retaliation preserving the attacker, volley, blocked drain, cleansing, health payment, formation costs/free-move reset and seventh-skill scrolling.

Balance remains provisional: this pass verifies skill behaviour and visual layout; it is not a new full campaign balance study.
