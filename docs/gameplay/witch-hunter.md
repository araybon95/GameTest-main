# Witch Hunter

The default Witch Hunter replaces the Penitent Crusader's former default combat identity with hooded engraved armor, a sealed mask and a two-handed hammer. The [approved concept](../../experimental/witch_hunter/concept.png) is the visual baseline. Internal `crusader` and `pc_*` identifiers remain for saves, recruitment and equipment compatibility. Selectable legacy appearances remain available where supported.

The class is mostly physical, with ritual support and visible banishment effects.

| Skill | AP | Current base effect |
| --- | ---: | --- |
| Judgment | 1 | 6 physical damage |
| Abjuring Ward | 1 | Gain 6 Block with a protective seal |
| Binding Sigil | 1 | Weakness: -3 damage on the target's next two attack actions; nonattack actions preserve it |
| Sunder | 2 | On hit, destroy up to 6 Block before 10 physical damage |
| Banishment | 2 | 12 physical damage, +4 against Weakness from any ally |

Damage and Block retain Forge upgrade support. Binding Sigil has no HP payment. The former default Bleed passive is replaced by Banishment's explicit Weakness condition. Explicitly selected equipment/relic outfits retain their own behavior.

The [uppercut/crush execution](../../experimental/witch_hunter/execution/README.md) and [compact Judgment timing study](../../experimental/witch_hunter/judgment/README.md) are experimental, separate from normal gameplay integration.

Verification: `tests/witch_hunter_smoke.gd` covers identity, AP/low-HP binding, Weakness duration and nonattack preservation, allied Weakness bonus, Sunder and formation. Recruitment and saved unlocks remain covered by the existing Crusader fixtures.
