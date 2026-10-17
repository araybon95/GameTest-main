# Current documentation

[Game overview and controls](../README.md) · [Artwork downloads](../ARTWORK-DOWNLOADS.md) · [Design previews](../experimental/README.md)

## Current behavior

- [Gameplay systems](gameplay/gameplay-systems.md): turns, formation, services and expedition rules.
- [Witch Hunter](gameplay/witch-hunter.md): current identity and physical/ritual skills.
- [Settings and continuity](gameplay/settings-and-continuity.md): saved journeys, customization and memorials.
- [Room selection and discoveries](room_travel/README.md): map travel, encounters and manual walking.
- [Warden outfits](warden_outfits/README.md), [execution](gameplay/warden-execution.md) and [ground layer](gameplay/battlefield-ground.md).
- [Visible class weapons](gameplay/weapon_swapping.md): compatible swapping, matching art and save continuity.
- [Equipment and skills](economy_and_skills.md), [relic skills](relic_skills_and_armour.md), [equipment/route guidance](equipment_and_route_guidance.md).
- [Guild hall](guild_hall.md): persistent hall appearance and expedition board; online transport is not connected.

## Verification

[Visible weapon verification](gameplay/weapon_swapping.md) covers the latest feature checks and visual reviews.

[Automated checks](automated_checks.md) documents the GitHub Actions workflow, local runner and downloadable results.

The [shutdown cleanup](shutdown_cleanup.md) records the latest verification: 102 passing smoke scripts and eight runner tests. The [gameplay stability audit](gameplay_stability_audit.md) records the earlier 101-test baseline, 30 malformed-save cases and two bounded automated expeditions. Remaining shutdown diagnostics and verification limits are documented.

[Art consistency repairs](../experimental/art_review/repairs/README.md) records 13 confirmed corrections and their preservation checks. The art audit is partial.

[Repository cleanup record](repository_cleanup.md) documents the retained/deleted scope, current packs and validation.

## Implementation references

Feature details are grouped in [gameplay/](gameplay/). [Art prompts](art-prompts/) retain source-generation references for existing artwork; they are not a specification for replacing approved designs. Additional feature notes and provenance JSON remain beside their assets or under this directory. Counts in older feature-specific validation sections describe those integration runs; use the current audit above for overall verification.

Obsolete conversion notes, old balance-run dumps and superseded review archives are recoverable through Git history rather than duplicated in the current tree.
