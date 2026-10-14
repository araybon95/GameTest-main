# Path of the Beast — reimagining concepts

Concepts generated from the supplied retheme diff. These are review images;
they have not replaced the live game's sprites, atlases or environments.

## Image gallery

Click an image to view the full-size concept.

| Supplicant | Half-Breed | Shackled Warbeast |
| --- | --- | --- |
| [![Supplicant](anguish_penitent.png)](anguish_penitent.png) | [![Half-Breed](anguish_vessel.png)](anguish_vessel.png) | [![Warbeast](harrowed_giant.png)](harrowed_giant.png) |

| Priest: Wolf | Priest: Serpent | Priest: Goat |
| --- | --- | --- |
| [![Wolf Aspect](coterie_seamkeeper.png)](coterie_seamkeeper.png) | [![Serpent Aspect](coterie_cantor.png)](coterie_cantor.png) | [![Goat Aspect](coterie_matron.png)](coterie_matron.png) |

### The Howl Made Flesh

[![The Howl Made Flesh](howling_head.png)](howling_head.png)

### Moonlit warren

[![Moonlit warren](beast_sanctuary.png)](beast_sanctuary.png)

### Barricaded camp

[![Barricaded camp](beast_camp.png)](beast_camp.png)

## Enemy designs

- [Supplicant of the Path](anguish_penitent.png): a recent voluntary convert, caught between grief and the first hunt.
- [Rune-Marked Half-Breed](anguish_vessel.png): a wolf-headed soldier stalled between human and beast.
- [Shackled Warbeast](harrowed_giant.png): the first guardian, a huge chained boar/bear-like pack killer.
- [Horned Priest — Wolf Aspect](coterie_seamkeeper.png): lean, fast and predatory.
- [Horned Priest — Serpent Aspect](coterie_cantor.png): venom, cold light and a coiled hymn-singer.
- [Horned Priest — Goat Aspect](coterie_matron.png): the composed, ancient pack leader revealed last.
- [The Howl Made Flesh](howling_head.png): a meteoric wolf idol becoming the primordial hunger it represents.

## Environments

- [Moonlit warren](beast_sanctuary.png): clawed earth, ruined chapel masonry, runes, bone and a low altar.
- [Barricaded camp](beast_camp.png): a vulnerable refuge held against the hunting pack.

The overall progression is **Moonlit Warrens → Revel of Runes → Altar of the Beast**.
The three Priest forms share ecclesiastical clothing, iron and bone motifs so
they read as one shapeshifter rather than three unrelated bosses.

## Review of the supplied patch

The direction replaces the surgical-cult theme with willing beast converts,
war relics, rune worship and a calculating pack leader. This gives the enemy
roster a readable escalation from human remnants to primordial predator.
Existing creature IDs, the `remade` faction identifier and item-stat keys are
retained, which helps preserve current equipment and saved-data compatibility.

Before integrating the artwork:

1. Correct the legacy `assets/generated/` prompt paths to the live art library.
2. Produce all required idle/action/hurt/cast or roar frames. The four legacy
   two-pose prompts are not a complete replacement for the seven measured live
   combat sheets. Re-measure atlas regions and foot anchors for new sheets.
3. Update the active layered room/stage artwork as well as the two base
   backgrounds. The current scenery redirects the Beast background to a stage
   asset and uses room layers, so replacing the base PNG alone is insufficient.
4. Keep a regression assertion for legacy `Remade` tags. The patch implements
   the alias but replaces its existing test with a new `Beast`-tag assertion;
   both cases should be covered.
5. Regenerate the Fallen Idol and Offering Post artwork for the renamed events;
   otherwise their text will describe the new theme over old object drawings.

This is a review of the pasted diff and generated art concepts. The gameplay
patch has not been applied or tested. Source prompt wording is recorded in
[source-prompts.json](source-prompts.json); generation adds left-facing combat
readability, clear margins, shared Priest costume cues and uncluttered ground.
