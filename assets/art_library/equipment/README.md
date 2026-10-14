# Equipment costumes

Five original relic outfits were created with the **built-in imagegen tool** as reference-based edits of the existing class atlases. `final_prompts.json` records the complete prompt set and Crusader grip/spacing refinements. PNG pixels and their generated alpha are preserved; `regions.gd` measures pose bounds without editing images.

| Class | Replaceable PNG | Gear identity |
| --- | --- | --- |
| Warden | `hero_warden_relic.png` | Oathkeeper plate, straight oath-marked longsword and iron shield |
| Ranger | `hero_ranger_relic.png` | Thornsong mantle and thornwood venom bow |
| Occultist | `hero_occultist_relic.png` | Ribmantle and bone-ring Gravetide staff |
| Healer | `hero_healer_relic.png` | Dawnmantle half-plate and lantern mace |
| Crusader | `hero_crusader_relic.png` | Sacrament barbed plate and pierced battle axe |

The Crusader's corrected second attack uses frame 11 from `hero_crusader_attack_relic.png`; the other eleven frames use its main atlas. This retains the best separated walking frames while using the corrected single-weapon grip. Unused poses in that supplementary source are not used by the game.

Each set contains idle, attack, hurt, guard, four walking strides, seated camp, bust portrait, windup and second attack. Atlas resources provide idle/camp/portrait paths. Combat and travel choose matching frames via `equipment_art.gd` rather than falling back to original gear mid-action.

The armour catalog contains three class-bound entries for each of five classes: practical, faction and relic (15 total; 13 new entries). Practical armour uses original art, faction armour uses alternate art and relic armour uses these sets. Armour takes visual priority. Warden, Ranger, Occultist and Healer render equipped weapons independently in combat while preserving selected armour; see [Warden combat weapons](../../../docs/warden_combat_weapons/README.md) and [party combat weapons](../../../docs/party_combat_weapons/README.md). Travel and inspection artwork remains costume-based. A legendary Crusader weapon still selects its existing relic set when no armour is equipped; Crusader retains its existing accent layer pending design revisions.

**Equipment Costumes** in Workshop appearance customization can disable automatic gear looks while retaining equipment bonuses and the player's saved outfit choice. The option persists in progression and save slots; older saves default to enabled. Individual names, heirloom history and favourites resolve through the item's base catalog ID.

New armour SVG icons in `assets/art_library/items` are original native vector artwork and independently replaceable; a same-name PNG takes precedence. New gear participates in normal loot and existing class/rarity rules. Merchants continue to exclude legendary gear and boss trophies retain their dedicated drops.

Counts after this update: 87 catalog item types, including 20 weapons, 15 armour, three off-hands, 32 trinkets/charms, nine remedies, five scrolls and three provisions. This expands the armour pool; no new headgear or off-hand entries are added.
