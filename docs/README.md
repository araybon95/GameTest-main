# Current documentation

[Game overview and controls](../README.md) · [Artwork downloads](../ARTWORK-DOWNLOADS.md) · [Design previews](../experimental/README.md)

## Current behavior

- [Gameplay systems](gameplay/gameplay-systems.md): turns, formation, services and expedition rules.
- [Witch Hunter](gameplay/witch-hunter.md): current identity and physical/ritual skills.
- [Settings and continuity](gameplay/settings-and-continuity.md): saved journeys, customization and memorials.
- [Room selection and discoveries](room_travel/README.md): map travel, encounters and manual walking.
- [Warden outfits](warden_outfits/README.md), [execution](gameplay/warden-execution.md) and [ground layer](gameplay/battlefield-ground.md).
- [Equipment and skills](economy_and_skills.md), [relic skills](relic_skills_and_armour.md), [equipment/route guidance](equipment_and_route_guidance.md).
- [Guild hall](guild_hall.md): persistent hall appearance and expedition board; online transport is not connected.

## Verification

The [2026-10-16 gameplay stability audit](gameplay_stability_audit.md) is the current full-suite report: 101 passing smoke scripts, 30 malformed-save cases and two bounded automated expeditions. Known shutdown diagnostics and the limits of those runs are documented there.

[Art consistency repairs](../experimental/art_review/repairs/README.md) records 13 confirmed corrections and their preservation checks. The art audit is partial.

[Repository cleanup record](repository_cleanup.md) documents the retained/deleted scope, current packs and validation.

## Implementation references

Feature details are grouped in [gameplay/](gameplay/). [Art prompts](art-prompts/) retain source-generation references for existing artwork; they are not a specification for replacing approved designs. Additional feature notes and provenance JSON remain beside their assets or under this directory. Counts in older feature-specific validation sections describe those integration runs; use the current audit above for overall verification.

Obsolete conversion notes, old balance-run dumps and superseded review archives are recoverable through Git history rather than duplicated in the current tree.
