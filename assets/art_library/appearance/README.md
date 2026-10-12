# Hero appearance artwork

These five original alternate costumes were generated with the built-in image-generation tool, using the project's existing character sheets as references. Original assets remain unchanged. Final prompt sets and cleanup prompts are recorded in `prompts.json`.

| Class | Outfit asset | Costume |
|---|---|---|
| Warden | `hero_warden_outfit.png` | Blacksteel Sentinel |
| Ranger | `hero_ranger_outfit.png` | Winter Tracker |
| Occultist | `hero_occultist_outfit.png` | Ashen Ritualist |
| Healer | `hero_healer_outfit.png` | Field Medic |
| Penitent Crusader | `hero_crusader_outfit.png` | Chainbound Penitent |

Each independently replaceable PNG contains twelve poses in four columns and three rows: idle, attack, hurt, defensive/windup pose; four walking strides; camp, portrait, windup, second attack. `regions.gd` contains measured alpha bounds rather than rigid cell crops, preserving extended weapons. Atlas resources select the idle, camp and portrait images. Original portrait resources crop the existing class art without modifying its pixels. Gameplay uses the most appropriate compact cast/guard frame for each class.

The Workshop now offers original/alternate attire, five accent colours and full-figure/character-portrait views with unsaved live previews. Saving persists the selected outfit and portrait through progression and save slots. These are cosmetic choices: they do not change class, equipment, abilities or stats. Combat, walking, camp, the hero sheet and other views consuming `State.hero()` use the same costume. Portrait view affects the character sheet and the selected hero information panel, while actors remain full figures.
