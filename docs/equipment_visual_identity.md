# Equipment legacy and visual identity audit

This audit records the pool before the equipment-costume expansion. The current implementation and updated counts are documented in [equipment artwork](../assets/equipment/README.md): 15 class armour pieces and five relic pose sets.

Implemented: the unlocked Workshop's **Equipment Legacies** view lists owned gear with live hero previews and scrollable item histories; **Keepsakes** filters to individually recorded or favourited gear. It supports one permanent transformation per copy, separate from the existing Keen/Fortified modification:

| Choice | Cost | Gameplay effect | Cosmetic detail |
| --- | ---: | --- | --- |
| Restore | 75 gold | +4 maximum HP | Pale steel glints |
| Consecrate | 75 gold | +10% debuff resistance | Warm gold sparks |
| Corrupt | 75 gold | +8% skill damage, +1 Stress per party turn | Crimson seams |

Transforming a stacked loose design separates one copy, preserving modifications and favourite protection. Equipped transformations increase health capacity without healing. Changes persist through saves and heirloom inheritance. Existing cursed gear adds its existing penalty to corruption's +1 Stress.

An item carried through three guardian victories gains **Guardian's etching**, a cosmetic trim. Repeated reward checks in the same run/guardian do not advance it. Heirlooms receive the same remembrance detail; equipping them adds a factual hero memory and a short reaction. Transforming equipped gear also enters the wearer's biography.

The accent layer clips glints to the original sprite alpha and highlights existing light metal details. Frost is cyan, venom green, life-drain crimson and healing gold. Boss trophy colours follow their faction. A worn boss relic or transformed piece takes visual priority over an ordinary weapon; effects do not accumulate into a whole-body aura. Ambient-motion settings freeze the pulse. Combat, hallway travel, camps and character records use the layer without replacing recolour or injury materials. Poses remain the existing art; these are subtle surface accents, not newly illustrated weapon or armour silhouettes.

## Current pool

| Class | Weapons | Armour | Off-hand |
| --- | ---: | ---: | ---: |
| Warden | 4 | 0 | 1 |
| Ranger | 4 | 1 | 0 |
| Occultist | 4 | 0 | 1 |
| Healer | 4 | 0 | 1 |
| Crusader | 4 | 1 | 0 |
| Total | 20 | 2 | 3 |

Each class has a common, epic, unique-effect and legendary weapon. Armour coverage is sparse; no headgear exists. All current weapons belong to a class. Most higher tiers increase the same core stats, although frost, venom, drain and regeneration already provide effect identities.

## Recommended next art/content expansion

1. Give each class three recognisable armour silhouettes: practical starting gear, faction armour and a named relic variant. Prioritise Warden, Occultist and Healer, which currently have no armour items.
2. Keep the weapon families recognisable across tiers: Warden oath-forged iron, Ranger thornwood/venom, Occultist bone-and-binding, Healer votive bronze, Crusader barbed penance. Add one prominent silhouette feature per named weapon rather than making rarity purely a recolour.
3. Add at most one small persistent signature to an equipped item: a cyan blade nick, venom reservoir, blood-red binding, candlelit clasp or crimson barb. Reserve brighter pulses for skill use or a milestone.
4. Preserve original idle/attack/hurt/walk/camp sets when adding silhouettes: every alternate weapon needs matching poses, and every armour set must retain the hero's face and posture. Full sprite replacements require pose-aligned artwork, not pasting a floating inventory icon over a hand.
5. Expand meaningful sidegrades rather than power tiers: protective/resistant armour versus offensive gear, with visible motifs reflecting those choices. Balance new entries before adding them to the loot pool.

Tests: `equipment_legacies_smoke.gd` validates gate, cost, copy separation, stats/curse, no free healing, persistence, milestones, reactions, RNG independence and the Workshop page. Native previews cover 1920×1080 and 1280×720.
