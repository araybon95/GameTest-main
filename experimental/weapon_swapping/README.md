# Class weapon swapping

Registered weapon packs for Warden, Ranger, Witch Hunter and Occultist, integrated on the feature branch. [Gameplay and compatibility](../../docs/gameplay/weapon_swapping.md) explains swapping, saved appearances and empty-slot visuals.

[Coverage and retained source hashes](coverage.json) records all sixteen supported weapons across thirteen outfit combinations. The four Healer weapons remain unchanged outside this feature. Original source artwork is retained.

| Class | Native comparison | Animation review | Provenance |
| --- | --- | --- | --- |
| Warden | [Approved visual proof](warden/README.md) | [Execution](warden/weapon-execution.gif) | [Sources](warden/provenance.json) |
| Ranger | [Weapons and outfits](ranger/review/catalog.gif) | [Execution study](ranger/review/execution.gif) | [Sources](ranger/provenance.json) |
| Witch Hunter | [Weapons and outfits](crusader/review/catalog.gif) | [Execution study](crusader/review/execution.gif) | [Sources](crusader/provenance.json) |
| Occultist | [Weapons and outfits](occultist/review/catalog.gif) | [Combat](occultist/review/combat.gif) | [Sources](occultist/provenance.json) |

Warden has an integrated execution across supported outfits. Ranger and Witch Hunter execution studies retain their original fixed outfit, now with configurable class weapons. They remain experimental; Occultist has no execution. No new execution mechanic, skills, damage values or loot rates were added.

The Godot builders retain exact source pixels outside explicit weapon repair masks wherever safe. Clean seated/casting poses replace visibly misregistered patches; Witch Hunter poses align both fists on one shaft. Runtime files contain only referenced final layers under `assets/art_library/weapons/`; full source and cleanup sheets stay here for reproducibility. Run builders sequentially, then `promote_assets.py` after native review. Missing combinations fail development coverage tests.
