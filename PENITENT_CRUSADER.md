# Penitent Crusader

50 maximum HP. Cursed by a demon of pain during the Hell Crusades, his senses crave an unending escalation of suffering. Inward-facing armor barbs tug at his flesh; the cursed warrior interprets relief as another debt.

Recruitment: a guaranteed spiked coffin event replaces one ordinary event on Old Road floor 2 while the Crusader remains locked. The opening hero pays a deterministic 2–3 HP, ignoring protection; the interaction requires enough HP to survive (the UI allows heroes with at least 4 HP). Leaving preserves the unopened coffin. Rescue permanently unlocks him in the Barracks, including across restarts, without displacing a hero mid-expedition. It cannot charge health twice, and future expeditions omit the coffin after recruitment.

Abilities:
- Barbed Strike: 1 AP, 6 damage.
- Iron Penance: 1 AP, 6 Block.
- Rapture of Pain: 1 AP, pay 2 HP directly, then heal 15% equipped maximum HP rounded down; requires more than 2 HP. Two full party turn cooldown. Percentage and payment do not scale with Forge upgrades.
- Thornbound Charge: 2 AP, 8 damage, 6 Block, damaging hits inflict Bleed for two turns (2 damage per turn). Two full party turn cooldown. Misses, fully blocked attacks, lethal hits and boss form changes do not inflict Bleed.
- Crimson Verdict: 2 AP, 12 damage.

Class equipment exists at Common, Rare, Epic, Unique and Legendary rarity, preserving boss class-appropriate Legendary rewards. Standing and seated art share one generated sheet through separate AtlasTexture resources. Existing hurt/debuff shader effects also apply.

Validation: tests/crusader_smoke.gd checks 100 guaranteed rescue seeds, health safety, one-use payment, saved recruitment, ability AP/cooldowns/healing, charge Block/Bleed and boss loot. Existing gameplay checks pass. Visual previews cover recruitment, locked roster, combat and camp.

## Artwork

Built-in imagegen used. Reference: https://bestiarumgames.com/cdn/shop/files/PenitentCrusadeP3-04_ScarletCenturion_Front-NoLogo_c4c8bef3-17d2-4caf-a9ca-59d213f9fd09.jpg?v=1755897637&width=1080

Saved: assets/generated/hero_crusader_poses.png; hero_crusader.tres; hero_crusader_camp.tres; event_crusader_coffin.png. The source reference is not bundled as game artwork.

Hero prompt:
Use case: stylized-concept. Create a transparent game sprite sheet with exactly two separate full-body views of the SAME Penitent Crusader, left a standing combat pose, right a seated resting camp pose, evenly spaced with clear transparent separation. Reference image 1 strongly guides character design: towering forked cage crown helmet masking a scarred face, heavily barbed crimson shoulder armor, dark silver breastplate, sun-like scarlet chest emblem, layered metal tassets with a crimson cloth hanging strip, spiked axe and spiked mace, oppressive cursed crusader devotion. Match image 2's grimdark illustrated game art: ink-like dark outlines, weathered painterly metal textures, readable silver highlights and muted crimson, carefully detailed, no photographic tabletop base. Standing figure facing slightly right with weapons at sides, seated figure tired but calm resting with weapons on lap. Complete boots and crown visible, no scenery, no text, no logo, no watermark. Transparent background with alpha, portrait figures occupy left and right halves; maintain generous margin. Horror barbs pulling against flesh are suggested with modest wounds, not extreme gore. This is for Ashen adult grimdark RPG.

Coffin prompt:
Use case: stylized-concept. Asset type: clickable grimdark RPG event prop. A closed vertical iron coffin prison for a cursed Penitent Crusader, an iron maiden cage with a small barred viewing grille showing faint crimson glow inside, many outward barbs around the door and thick rusted padlock and chain. Heavy black ink contours, weathered silver metal highlights, desaturated crimson cloth caught on spikes, grimdark painterly illustration matching Ashen's hero reference image. One complete coffin, centered isolated, fully visible with readable lock, no environment, no ground or shadow background, no text no logos. Genuine transparent alpha background. Horror mood, no visible graphic gore.
