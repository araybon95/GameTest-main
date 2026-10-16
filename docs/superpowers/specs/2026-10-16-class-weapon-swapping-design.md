# Class weapon swapping with matching character art

Status: proposed design for review; implementation has not started.

## Goal and accepted scope

Let players equip different weapons within each hero's class and see that weapon on the hero, rather than receiving only stat changes. The user selected visible weapons plus stats and a Warden-first development sequence. The complete feature covers four classes:

| Class | Accepted weapon family | Existing internal ID |
| --- | --- | --- |
| Warden | One-handed melee: swords, axes and maces | `warden` |
| Ranger | Bows | `ranger` |
| Witch Hunter | Two-handed hammers | `crusader` |
| Occultist | Staves | `occultist` |

The Warden keeps his shield. Witch Hunter weapons remain visibly two-handed. Preserve the approved painted/engraved style, character proportions, grounded feet, attack timing, and established skill identities. Keep the current Healer working without expanding its weapon catalog in this feature.

## Existing behavior and gaps

`game_data.gd:equip_item()` already exchanges owned equipment and applies class restrictions. `hero_sheet.gd` already offers inventory, comparisons, equip and remove actions, and blocks equipment changes during combat. The new feature extends that flow rather than adding a second inventory or a second weapon slot.

Weapons currently have class ownership but no explicit weapon-family/handedness contract. Crusader weapon IDs and names still include the former axe identity. Keep stable IDs for saves and item histories while changing Witch Hunter presentation to hammers.

The current art is not modular. Default party builds, alternate/relic outfits, walking/camp art and execution images often contain their own painted weapon. `party_builds.gd`, `combat_poses.gd`, `equipment_art.gd`, `standing_party.gd` and execution renderers all select textures independently. Existing appearance caches also assume that a hero/style or art path uniquely identifies a visual. Those caches must include weapon identity where applicable.

## Approaches considered

1. **Recommended: pose-specific layers composed into cached textures.** Prepare a clean body, weapon layer and foreground hands/straps for each supported pose. Compose them once per weapon/pose/style and continue supplying Texture2D frames to existing renderers. This preserves status shaders and grounded deformation while keeping future weapon additions independent of repainting an entire character.
2. Complete painted pose packs per weapon. Integrates naturally with the current atlas system, but repeatedly repainting bodies increases consistency risks and asset volume. Useful for exceptional cinematic contact frames that cannot be safely separated into layers.
3. A single floating weapon sprite rotated onto every pose. Cheap to prototype, but insufficient for grip, occlusion, bow draw states and two-handed poses; do not use it as the production solution.

## Player flow

Use the existing character sheet and party inventory. Show the equipped weapon, family, class eligibility and comparison against the candidate. Equip swaps exactly one owned copy and returns the previous copy to inventory. Existing individual item names, modifications, favourites and histories remain attached to their item instance.

Keep the existing out-of-combat swapping policy. No new mid-turn weapon actions or AP rules. Preview the selected weapon before confirmation, then refresh visible heroes after equip, unequip, load or appearance changes. Loading or equipping must never heal a hero or duplicate an item.

An empty equipment slot retains the class's starter weapon visually and its existing unequipped stat behavior. Explain it as the basic/default weapon; do not accidentally add the starter item's bonus to an empty slot.

## Equipment rules and saves

Add explicit weapon-family and handedness metadata to catalog weapons. Resolve named/transformed copies through their base catalog item. Use one compatibility function for equip validation, comparisons and inventory filtering, and reuse it in saved-loadout validation where relevant.

Assign families to all existing weapons without altering their current numerical effects. Warden items are one-handed melee, Ranger items bows, Witch Hunter items two-handed hammers, and Occultist items staves. Preserve Healer compatibility. A two-handed weapon cannot coexist with an equipped off-hand; reject an incompatible swap clearly rather than silently discarding gear. Preserve existing staff/grimoire loadouts by classifying current Occultist staves as one-handed for equipment compatibility. Future explicitly two-handed staves would follow the same off-hand rejection rule.

Keep `crusader`, `pc_*` and existing item IDs stable. Old axe-named Witch Hunter IDs resolve to the same owned items with new hammer display names and matching hammer art. Existing saves retain equipped/loose counts, upgrades and histories. Invalid imported loadouts follow the project's existing validation/rejection rules; do not silently delete them.

## Visual contract

Use a small weapon-visual resolver with a manifest indexed by hero, base weapon ID, appearance style, pose and cinematic phase. The first integration points are the existing pose/appearance selectors; rendering components should not each invent weapon selection rules. Catalogs and manifests record a visual weapon profile, allowing ordinary/transformed copies of the same base weapon to reuse geometry while their existing accents supply special effects.

For ordinary frames, layer order is rear weapon components, body, visible weapon components, then foreground hands/straps. Store explicit canvas size, body registration, foot anchor, grip anchors, hand occlusion and weapon alignment. Compose at native resolution and cache the resulting texture with the metadata existing renderers require, including hero/pose identity, body height, hit and emitter points. Include weapon/style/pose in the cache key. Do not derive body scale or floor position from the new weapon's bounding box.

Bow assets include pose-specific string, arrow and draw states. Two-handed hammer/staff poses must place both hands on one continuous shaft. Preserve straight shafts, consistent hammer-head angles and weapon proportions. Weapon layers follow the same mesh transformation as the body; independent screen-space overlays would slip during breathing or attacks.

Executions need their own weapon-aware source frames and contact checks. Keep the victim sequence, blood effects and camera timing intact. An exceptional painted contact frame can be a complete weapon-specific image with matching anchors instead of a brittle cutout. Do not let the original weapon reappear halfway through an execution.

Coverage includes character/equipment previews, idle and combat states, travel/walking, camp and executions. Portraits that show a weapon must match; cropped head-only portraits can remain unchanged.

## Appearance compatibility and publication

The first art proof uses the approved default Warden body. Extend the same manifest contract to the remaining three default class bodies after that proof passes review. Existing alternate/relic costumes need explicitly authored matching packs as well; a weapon does not inherit support merely because an old costume atlas exists.

Do not silently substitute a different weapon, regenerate approved outfits wholesale, or change the player's saved cosmetic preference. The Warden proof stays experimental until the supported style/weapon/pose combinations are identified and complete. Missing combinations must be visible in development validation and the preview, not concealed by unrelated weapon art. Production integration requires matching weapon packs for every selectable style covered by the feature. Keep a class experimental until that coverage is complete; do not publish partial support as a finished class.

Honor the existing equipment-appearance setting deliberately. Proposed policy: when equipment appearance is enabled, show the selected supported weapon; when disabled, retain the player's explicitly chosen cosmetic weapon/appearance while retaining equipment stats. The sheet should label that override. This policy is part of design review, not an implementation assumption hidden from the player.

## Delivery sequence

1. **Catalog and visual coverage inventory.** Enumerate existing weapon IDs, ownership rules, styles and every pose consumer; document coverage before changing runtime art.
2. **Experimental Warden proof.** Show the existing Iron Longsword and Oathkeeper with different visible geometry across idle, windup, attack, guard, hurt and execution. Keep shield and body registration fixed. Demonstrate a one-handed axe/mace asset as an experimental compatibility proof if needed; adding it to loot or balancing new items is a separate explicit content decision.
3. **Warden integration.** Add common compatibility rules and the shared resolver, update the existing sheet/preview, connect all Warden pose consumers, and validate saves/copies. Complete the required selectable-style coverage before enabling it in the working game.
4. **Remaining classes.** Apply the approved pipeline to bows, two-handed hammers and staves, including class-specific releases, two-hand grips and execution art. These classes remain in the feature scope; Warden-first is the development order, not a substitute for them.
5. **Regression and publication.** Verify the full implemented scope and review visual comparisons before pushing gameplay integration.

No new loot rates, damage numbers, skill sets, procedural affixes, dual wielding or unrelated inventory redesign are included.

## Acceptance and verification

- Equipping/unequipping each supported class weapon changes the correct visible weapon in every supported context, without changing armor/body shape as a side effect.
- Wrong-class and invalid off-hand combinations fail without consuming inventory. Repeated swaps preserve total copies and individual histories.
- Old saves with legacy Witch Hunter item IDs load with preserved counts, upgrades and hammer identity. New saves retain the selected weapon and appearance override setting.
- Maximum HP changes clamp health without healing; no unrelated AP, damage formula or skill timing changes.
- Manifest/resource tests cover required frames and registrations; missing weapon poses cannot quietly fall back to a different weapon.
- Generated/composed textures preserve shader/material metadata, body height, floor anchor and emitter/hit points. Tests check cache separation between weapon/style combinations.
- Native-resolution contact sheets and animated showcases verify hands, continuous handles, hammer perpendicularity, bow strings/arrows, shield continuity, weapon direction, floor alignment and consistent proportions. Code assertions do not replace visual review.
- Run affected equipment/save/pose/grounding/execution tests and the full hosted Godot suite before claiming integration complete. Treat expected corruption-test errors separately from regressions, and retain all diagnostics.

## Review boundary

This is the written feature design. Approval permits writing the implementation plan; it does not claim that weapon art or runtime integration is already complete. The plan will identify the exact initial Warden asset set, test-first code changes, coverage gates and the route through the remaining classes.
