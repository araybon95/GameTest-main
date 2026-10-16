# Tactical expedition update

This update keeps the three-hero shared party turn, three-enemy limit, existing illustrations, floor bosses, and one-use full-heal camp. It adds no dungeon light system, quirks, or persistent injuries.

## Positions and combat

Position 1 is nearest the opposing side. Heroes can advance or fall back for 1 AP, exchanging places with an ally. Preparation allows free formation changes. Exact positions and journal data persist in saves; older saves receive valid formation and ration defaults.

Skill cards show usable positions and enemy reach. Out-of-position or out-of-range actions spend no AP or cooldown. Frontline weapon skills generally work from 1–2 and reach 1–2; bow skills require 2–3 and reach all three. Support skills and scrolls remain broadly usable. The Occultist's drain works from 1–2 and blast from 2–3. Healer's Smite is a frontline attack.

- Shield Bash pushes a surviving enemy back one position.
- Barbed Charge advances the Crusader to position 1 before striking.
- Ranger's Dodge falls back one position.
- Wolfguard pulls exchange the furthest hero into position 1.
- Defeated enemies leave the formation; enemy positions compress.
- Boss transformations preserve position.

Defenders periodically guard another enemy. Marksmen choose a victim, enabling a bounded +2 allied strike bonus; they seek distance when forced to the front. Rear melee enemies spend an action closing the gap. Zealots periodically stress the party. Boss phases and their weakened supports retain their existing mechanics.

## Reactions and animation

The existing dedicated attack/hurt illustrations now work with idle breathing, stronger charge movement, blocked-hit reactions and a collapsed death stance. Full blocks keep the defender braced rather than showing a wound. Attacker/target spotlights, hit pauses, recoil, ground shadows and attack sounds remain in place.

Stress has additional once-per-hero-per-turn reactions, each with a 20% chance. Fearful, Hopeless and Irrational heroes can lose one AP; Abusive heroes add 3 stress to companions; Paranoid and Masochistic heroes can refuse a healing attempt. Virtuous heroes can rally everyone for +2 block and −3 stress. Speech captions and original synthesized virtue/distress cues announce resolve tests. Camps clear afflictions using the existing recovery rules. These reactions add no lasting traits or injury records.

## Provisions and events

Every departure supplies three basic party rations. Each six newly visited map spaces consumes one ration, restoring 3 HP to surviving heroes. Extra Trail Rations cost 2 gold. When none remain, hunger adds 6 stress to survivors; entering combat at 100 stress triggers the existing resolve test. Revisited spaces do not consume food or reroll hunger.

The preparation shop and merchant offer provisions. Locksmith Tools (4 gold) make strongboxes safe with a guaranteed reward. Cleansing Herbs (3 gold) safely recover tainted supplies or votive reliquaries. Bandages safely open stitched offerings, or reduce the Crusader coffin's opening damage to 1 HP. The event screen exposes the matching supply action; one item is consumed only after valid interaction. These items stack by name and have independently editable SVG icons.

## Camp preparation

After the normal one-use rest restores full health, clears debuffs and reduces stress by 90%, three preparation points become available. Each option can be used once at that camp:

| Choice | Cost | Benefit |
| --- | --- | --- |
| Keep Watch | 2 | Prevent this camp's ambush |
| Protective Rite | 1 | +15% debuff application resistance next battle |
| Ready Weapons | 1 | +10% skill damage next battle |
| Study the Route | 1 | Free nearby scouting |

An unguarded spent camp has a deterministic 15% ambush chance when leaving. The encounter contains one weakened creature (55% health, 60% damage); heroes start with 1 AP. A camp can attempt an ambush only once. Rites and readied weapons refresh rather than stack and expire after the next battle.

## Returning home

Final victories open the aftermath screen directly. Retreats and defeats also show results before returning to the settlement. The report includes survivors, fallen names, levels and XP, battle/damage/healing deeds, explored spaces, defeated foes, gold change and acquired items. Gold is a net change including purchases. The last report persists; the settlement music resumes on return. No quirks or injuries are awarded.

## Validation

All 26 smoke checks pass. New tests cover position/AP validation, pushes and swaps, role behavior, bounded stress reactions, safe event supplies, food/hunger, camp budgets and next-battle bonuses, one-use deterministic ambushes, older save migration, and aftermath. The Apothecary flow test exercises all three fights, camp watch, the building unlock, automatic final results, and the restored shop. `tests/depth_preview.gd` captures preparation, combat, stress speech, camp and aftermath for visual inspection.

The new `stress.wav` and `virtue.wav` are original synthesized cues created for this update; they and the original supply SVGs can be replaced independently.
