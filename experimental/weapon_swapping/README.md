# Class weapon swapping

Experimental work toward visible, class-compatible weapons. The current game is unchanged by this inventory.

[Coverage and source hashes](coverage.json) records 20 current weapons (including four retained Healer weapons), 13 target class/style combinations, registered pose bounds and source artwork. The target classes are Warden (one-handed melee), Ranger (bows), Witch Hunter under the stable `crusader` ID (two-handed hammers), and Occultist (staves). The Warden retains his shield; existing Occultist staff/grimoire loadouts remain compatible.

The first visual proof compares Iron Longsword and Oathkeeper on the approved default Warden body. All combinations remain unpublished until their art is complete and reviewed. Empty `prepared_poses` lists mean missing coverage, not support through a fallback image.

Warden has an integrated execution. Ranger and Witch Hunter executions are isolated experimental showcases; Occultist has no execution to migrate. This feature does not add new execution mechanics.

The approved design and execution plan are tracked under `docs/superpowers/`. Existing art remains at the recorded paths; the inventory does not edit any source pixels or change stats, loot or skills.
