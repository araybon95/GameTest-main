# Equipment memories

In the character record, **NAME EQUIPMENT** lets players inscribe an equipped item (32 characters). An empty inscription restores its original name. Original type, rarity, icon, restrictions and combat effects remain unchanged; the tooltip shows the original name alongside its history.

Equipment records its first guardian victory with its bearer, and shields or armour record fully blocking a blow at Death's Door. These hooks use resolved combat outcomes. Records retain up to five recent deeds and do not consume gameplay RNG.

On a hero's death, one equipped item returns immediately to the party inventory: the weapon if present, otherwise the first occupied slot. Its previous owner's name and deeds travel with it. Other equipped items keep their existing handling. The graveyard stores a separate snapshot, so later renaming or accomplishments cannot rewrite a dead hero's memorial. Existing class restrictions still apply to inherited gear.

Ordinary loose equipment and consumables retain existing stacks. Naming or recording a deed gives an equipped copy a unique `keepsake_…` identity. Returning it to inventory does not merge it with ordinary copies. `ItemData.base_id` resolves its catalog stats and art; Workshop upgrades and merchant selling accept these copies. Merchants cannot generate a duplicate keepsake.

Optional `item_histories` data is stored in progression and save slots. Older saves without records remain readable. The inscription action also writes the continuity checkpoint. Archived item records are retained after selling, preserving any memorial references.

Validation: `tests/item_stories_smoke.gd` exercises real combat block/reward/death hooks, independent duplicate equipment, name reset, heirloom snapshots, restrictions, selling/upgrades, save round trips and the inscription dialog. All previews use isolated save directories.
