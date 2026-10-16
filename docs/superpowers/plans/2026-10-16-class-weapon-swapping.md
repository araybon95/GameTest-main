# Visible Class Weapon Swapping Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Equip class-compatible weapons with matching art throughout gameplay, starting with a reviewed Warden proof and extending to Ranger, Witch Hunter and Occultist.

**Architecture:** Retain the existing equipment inventory and exchange operations. Add one compatibility service and one manifest-driven texture compositor, supplying weapon-aware textures to existing pose consumers. Treat art coverage as a publication gate: an unsupported class/style remains experimental, with no unrelated-weapon fallback.

**Tech Stack:** Godot 4.6.3, GDScript, existing Python smoke runner, PNG layers, built-in image generation for reference-based image edits; no new runtime dependency.

**Spec:** [Approved design](../specs/2026-10-16-class-weapon-swapping-design.md).

## Global Constraints

- The Warden keeps his shield. Witch Hunter weapons remain visibly two-handed.
- Keep `crusader`, `pc_*` and existing item IDs stable.
- No new loot rates, damage numbers, skill sets, procedural affixes, dual wielding or unrelated inventory redesign are included.
- Keep the existing out-of-combat swapping policy. No new mid-turn weapon actions or AP rules.
- Loading or equipping must never heal a hero or duplicate an item.
- Preserve existing staff/grimoire loadouts by classifying current Occultist staves as one-handed for equipment compatibility.
- Production integration requires matching weapon packs for every selectable style covered by the feature.
- Use the existing isolated cloud checkout; do not create a worktree unless the user requests one. Preserve unrelated edits and retain engine diagnostics.
- Approval of this plan starts execution; Warden showcase art is reviewed before runtime art integration. Remaining classes are part of the feature, not optional follow-ups.

## Review Focus

1. Named/transformed weapon copies: resolve the base catalog identity without losing per-copy names, favourites, histories or effects. Tasks 2 and 8 test this.
2. Existing legendary weapon with no armor: preserve the old relic body on save migration, then stop weapon-only swaps from selecting a different body. Task 3 tests this.
3. Unequip or cosmetic override: empty weapon slots render the starter without awarding starter stats, and appearance-disabled players retain their explicit cosmetic choice. Tasks 3, 6 and 8 test this.
4. Off-hand conflicts in either direction and malformed saves: reject without consuming/deleting gear or partially applying a load. Tasks 2 and 8 test this.
5. Preview/equip/load during a cached session: update every affected surface without changing foot/body registration, attack emitters, armor or execution targets. Tasks 4, 6, 7 and 8 test this.

---

## File responsibilities and contracts

New files:
- `scripts/weapon_rules.gd`: pure class/family/handedness validation and base-item resolution.
- `scripts/weapon_visuals.gd`: manifest lookup, native-resolution composition, metadata propagation and cache keys.
- `assets/art_library/weapons/manifest.gd`: approved production layer/frame records and class publication gates.
- `assets/art_library/weapons/<hero>/<style>/`: body, weapon and foreground-hand PNG layers plus exceptional complete cinematic frames.
- `experimental/weapon_swapping/coverage.json`: catalog × appearance × context/pose inventory and missing combinations; machine-readable, not a runtime fallback table.
- `experimental/weapon_swapping/warden/`: initial visual proof, contact sheets, GIF, source/provenance manifest and README.
- `tests/weapon_rules_smoke.gd`, `tests/weapon_appearance_migration_smoke.gd`, `tests/weapon_visuals_smoke.gd`, `tests/weapon_swapping_smoke.gd`, `tests/weapon_execution_smoke.gd`: distinct rules, persistence, compositor, integration and cinematic contracts.

Existing files to modify only at the task that needs them:
- `scripts/item_data.gd`, `scripts/game_data.gd`, `scripts/equipment_comparison.gd`, `scripts/save_files.gd`: catalog, exchange, comparisons and persistence.
- `scripts/equipment_looks.gd`, `scripts/party_builds.gd`, `scripts/combat_poses.gd`, `scripts/hero_appearance.gd`, `scripts/equipment_art.gd`, `scripts/warden_outfits.gd`: body choice and pose routing.
- `scripts/standing_party.gd`, `scripts/camp_art.gd`, `scenes/ui/hero_sheet.gd`, `scenes/ui/equipment_compare.gd`, `scenes/combat/combat_presentation.gd`, `scenes/combat/warden_execution.gd`: visible consumers and Warden cinematics.
- Other execution consumers must be listed by Task 1 before their class is implemented; do not assume Warden's execution handles other classes.

Shared interfaces (define once, use unchanged):
- `WeaponRules.base_id(state, item_id: String) -> String`: reuse item-history/base-ID resolution already used by `state.Items.item()`; never strip suffixes speculatively.
- `WeaponRules.reason(state, hero_id: String, item_id: String, loadout: Dictionary) -> String`: empty means compatible; otherwise a player-readable reason. This validates slot conflicts too, so equipping an off-hand against an existing two-handed weapon is rejected.
- `WeaponRules.loadout_error(state, hero_id: String, loadout: Dictionary) -> String`: validate a complete candidate loadout without touching live state.
- `WeaponVisuals.weapon_id(state, hero_id: String, preview_item: String = "") -> String`: candidate weapon if previewing a weapon, otherwise equipped base weapon, otherwise class starter visual.
- `WeaponVisuals.frame(state, hero_id: String, style: String, pose: String, preview_item: String = "") -> Texture2D`: composed approved texture; return null plus a recorded validation error for missing enabled combinations. Disabled/unpublished classes are bypassed by the caller, not silently mapped to another weapon.
- `WeaponVisuals.coverage_errors(hero_id: String, style: String) -> Array[String]`: missing or invalid required records.
- `WeaponVisuals._frame_for_weapon(hero_id: String, style: String, pose: String, weapon_id: String) -> Texture2D`: internal composition entry point with explicit selection; both ordinary and frozen cinematic selection use it.
- `WeaponVisuals.clear_cache() -> void`: reset derived textures on fixture teardown or manifest reload; normal equip does not clear every asset globally.

Manifest record contract: `hero`, `style`, `weapon_profile`, `pose`, `canvas_size:Vector2i`, ordered `layers:Array[Dictionary]` (`path:String`, `offset:Vector2i`, `role:String`), `foot:Vector2`, `grips:Array[Vector2]`, `weapon_axis:PackedVector2Array`, `metadata:Dictionary`. Roles are `rear_weapon`, `body`, `front_weapon`, `hands`; complete exceptional frames use `full_frame` alone. Preserve source `pose_id`, appearance routing tags, idle/body-height fields, hit/emitter points and any shader-required UV registration. A record is complete only when both resources and metadata validate.

## Task 1: Freeze the catalog and pose coverage inventory

**Files:** create `experimental/weapon_swapping/coverage.json` and `experimental/weapon_swapping/README.md`; inspect the existing selectors and execution consumers listed above.

**Interfaces:** consumes current item/appearance data; produces a concrete catalog/style/pose matrix, canonical style IDs and the initial Warden source map used by every asset task.

- [ ] Enumerate every current weapon ID and stat dictionary, including generated/named/transformed variants through their base IDs. Record the four families and existing Healer entries without adding loot.
- [ ] Enumerate all selectable styles from actual customization/appearance code and all runtime consumers. Include default, alternate, relic and Warden-specific outfits, walking strides, camp poses, portraits showing weapons, and each existing execution source frame.
- [ ] Record native canvases, body/foot anchors, pose states, emitter/hit metadata and backing image paths. Include SHA-256 hashes of the approved source assets.
- [ ] Check that every current weapon and selectable style is represented; mark unprepared records as experimental and missing rather than inventing support. Verify the inventory against root art/resource and equipment-costume smoke scripts.
- [ ] Commit the coverage/provenance inventory. It is documentation only and does not enable unfinished equipment art.

## Task 2: Add shared class/handedness rules without changing balance

**Files:** create `scripts/weapon_rules.gd`, `tests/weapon_rules_smoke.gd`; modify `scripts/item_data.gd`, `scripts/game_data.gd`, `scripts/equipment_comparison.gd`, `scripts/save_files.gd`.

**Interfaces:** implements `WeaponRules.base_id`, `reason` and `loadout_error`. Catalog metadata: `weapon_family` values `one_handed_melee`, `bow`, `two_handed_hammer`, `staff`; `hands:int` is 1 for existing Warden/Occultist weapons and 2 for Ranger/Witch Hunter. Preserve Healer eligibility through its existing owner rule.

- [ ] Write rule tests asserting every current target-class weapon has the expected family/hands, cross-class exchange returns false with inventory/equipment unchanged, and both weapon→off-hand and off-hand→weapon conflicts are rejected. Use an isolated synthetic two-handed/off-hand fixture for conflicts absent from the real catalog; do not add test gear to live loot.
- [ ] Add assertions that named/transformed copies resolve to their original family and keep their instance ID after equip/unequip. Snapshot all pre-change numerical item effects and assert they are unchanged after adding metadata; stat keys must exclude new metadata.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_rules --output artifacts/weapon-rules-red`; confirm a rule assertion fails before implementation.
- [ ] Implement the shared rules and use them in equip operations, comparison compatibility and candidate save-loadout checks. Invalid saved loadouts fail validation before assigning any state. Keep existing IDs, class unlock rules and Healer behavior.
- [ ] Update Witch Hunter weapon display names to hammers, retaining keys and numerical effects. Do not replace globally shared names on individually named copies.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_rules crusader witch_hunter items_unique save_validation save_runtime_validation equipment_feedback --output artifacts/weapon-rules-green`; require every assertion pass and inspect diagnostics.
- [ ] Commit the coherent rule and persistence validation changes.

## Task 3: Preserve body appearance while separating weapon selection

**Files:** create `tests/weapon_appearance_migration_smoke.gd`; modify `scripts/equipment_looks.gd`, `scripts/game_data.gd`, `scripts/save_files.gd` and existing progression serialization used by the inspected code.

**Interfaces:** add `State.legacy_weapon_costumes:Dictionary`, default `{}`, storing only hero→`"relic"` entries needed to retain old weapon-driven body looks. This is appearance data, not equipment or a gameplay bonus. Add `EquipmentLooks.migrate_weapon_costumes(state, saved:Dictionary) -> Dictionary` as a pure helper, consumed before state assignment on load.

- [ ] Write tests for an old save with a legendary weapon and no armor, a legendary weapon under an explicit armor choice, appearance disabled, repeated load/save, and an invalid sidecar value. Assert manual `hero_outfits` is never rewritten.
- [ ] Assert a weapon-only swap preserves the resolved body style, armor changes still select their own body style, empty slots keep prior unequipped stat behavior, and a cosmetic override does not add weapon bonuses.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_appearance_migration --output artifacts/weapon-style-red` and observe the expected failed contract.
- [ ] Implement optional-sidecar validation/serialization in both actual save/progression paths. For old data only, capture the old enabled weapon-driven relic choice if no armor overrides it; never infer relic from a newly equipped weapon. Body selection priority: explicit equipped armor look, retained legacy costume, existing manual/default style. The existing appearance-disabled branch remains manual-only.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_appearance_migration equipment_costumes settings_saves save_validation save_runtime_validation --output artifacts/weapon-style-green` and commit after passing. This task preserves existing appearances before any modular art is enabled.

## Task 4: Build and review the experimental Warden compositor proof

**Files:** create `scripts/weapon_visuals.gd`, `assets/art_library/weapons/manifest.gd`, `tests/weapon_visuals_smoke.gd`, and the Warden experimental assets/source map from Task 1.

**Interfaces:** implements the manifest and `WeaponVisuals` contracts above; only the experimental showcase calls it initially. Production class gates remain false.

- [ ] Write compositor tests using small explicit image fixtures: enforce layer order with known pixel colors; reject a missing hand layer/resource; verify separate cache entries for weapon/style/pose; assert foot/body/emitter metadata stays identical when only weapon geometry changes. Exercise previewing armor without accidentally changing the selected weapon.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_visuals --output artifacts/weapon-visuals-red` and observe the expected failure.
- [ ] Implement native-resolution `Image` composition in manifest order and `ImageTexture` caching. Keep generated textures detached from inventory/save data. Reuse existing metadata and atlas registration; if a UV-dependent material requires the original atlas canvas, compose on that canvas rather than changing shader math globally.
- [ ] Use the built-in image-generation/editing tool for the asset preparation, inspecting the original local images before editing. Preserve approved body/shield pixels and produce weapon-clean body plus hand/occlusion layers and two distinct existing weapons: Iron Longsword and Oathkeeper. Use pose-specific layers for idle, windup, attack, guard, hurt and the exact Warden execution source phases from Task 1. Keep all generated edits experimental.
- [ ] Inspect each layer at native resolution. Confirm no residual original blade, double fingers, disconnected handles, altered shield or changed armor. Add manifest registration only for verified images; source assets remain unchanged.
- [ ] Render side-by-side contact sheets and a GIF with identical camera/time sampling for both weapons. Include grip/contact zooms and a ground reference. Record generation prompts, source paths/hashes and the final selected files.
- [ ] Run the compositor regression and render checks, then commit the experimental proof. Present the actual showcase for the user's visual review before proceeding to production routing. A rejected hand/weapon frame is repaired here, not hidden by runtime fallback.

## Task 5: Complete Warden coverage for the existing weapon/style catalog

**Files:** extend Warden assets/manifest and `experimental/weapon_swapping/coverage.json`; extend `tests/weapon_visuals_smoke.gd`.

**Interfaces:** consumes Task 1 matrix and Task 4 layer contract; produces complete Warden records for all existing weapons and selectable styles.

- [ ] Add a failing coverage assertion enumerating Warden weapons/styles against the exact matrix: idle, all selected attack/guard/hurt/cast/death states, walking strides, camp, weapon-visible portraits and execution phases. An unchanged weapon profile may share genuine geometry; different item effects retain existing accents.
- [ ] Run the coverage regression and confirm missing combinations fail.
- [ ] Prepare the remaining approved-style body/hand layers and weapon profiles with reference-based edits. Preserve approved outfits rather than replacing the whole costume. No new axe/mace loot entry is required; a category proof may remain experimental.
- [ ] Validate coverage, alpha edges, source hashes, contact sheets and floor/grip registrations; review any newly authored cinematic frames. Keep the gate false until complete.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_visuals project_art art_library_resources --output artifacts/warden-weapon-assets` and commit the complete Warden pack.

## Task 6: Integrate Warden swapping with the existing UI and ordinary poses

**Files:** create `tests/weapon_swapping_smoke.gd`; modify `scenes/ui/hero_sheet.gd`, `scenes/ui/equipment_compare.gd`, `scripts/party_builds.gd`, `scripts/combat_poses.gd`, `scripts/standing_party.gd`, `scripts/camp_art.gd`, `scripts/hero_appearance.gd`, `scripts/equipment_art.gd`, `scripts/warden_outfits.gd`, and the Warden manifest gate.

**Interfaces:** consumers call `WeaponVisuals.frame`; composed textures carry selected weapon/style/pose metadata so later pose changes retain the same appearance identity. Keep `State.hero(...).art` compatible as a path for existing callers; do not replace a serialized path with an ImageTexture.

- [ ] Write an actual-sheet test: preview a candidate, confirm equip, remove it, save/load and reopen; assert the current/proposed frames carry correct weapon metadata, inventory totals are conserved, and combat/dead-hero UI restrictions remain enforced. Assert incompatible gear shows the shared reason.
- [ ] Test idle→attack→hurt→guard→idle, travel and camp after a swap. Assert constant foot/body anchors and shader metadata. With equipment appearance disabled, assert manual cosmetic art and the explicit override label remain while stats follow equipped gear.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_swapping --output artifacts/weapon-ui-red` and observe the missing-routing failure.
- [ ] Wire only the Warden-approved class gate, then integrate the existing sheet/preview and pose consumers. Use cache keys containing weapon/style/pose, and refresh cached standing/camp views after selection/load changes. Replace comparison wording that assumes weapon/armor compatibility solely from class ownership. Empty-slot UI labels the starter/default visual without claiming it is an owned equipped item.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_swapping weapon_visuals equipment_feedback equipment_costumes standing_party battlefield_ground status_visual skill_hover --output artifacts/weapon-ui-green`; review native 1920×1080 and 1280×720 previews, then commit.

## Task 7: Preserve Warden weapon identity throughout executions

**Files:** create `tests/weapon_execution_smoke.gd`; modify `scenes/combat/combat_presentation.gd`, `scenes/combat/warden_execution.gd`, Warden manifest and cinematic assets as needed.

**Interfaces:** add `source_weapon_id:String` and `source_style:String` to execution presentation options, captured at queue time. Add `WeaponVisuals.execution_frame(state, hero_id:String, style:String, phase:String, weapon_id:String) -> Texture2D`; it calls `_frame_for_weapon` with the explicit immutable weapon selection rather than rereading the live equipped item.

- [ ] Write a regression sampling every existing Warden source phase and contact transition for each supported weapon/style. Assert no frame returns the original weapon unexpectedly, source identity is stable after queueing, and victim frame selection/camera timing/dropped weapon data are unchanged.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_execution --output artifacts/weapon-execution-red` and observe the missing weapon-aware frame failure.
- [ ] Replace hard-coded attacker weapon frames with approved manifest frames. Keep the existing target/camera/gore timeline and source body anchors. Retain full-frame exceptions where contact occlusion demands them.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_execution warden_execution warden_execution_registration warden_transitions combat_audio --output artifacts/weapon-execution-green`; render and review full-speed and contact-frame comparisons, then commit.

## Task 8: Extend completed coverage and integration to the other three classes

**Files:** extend class assets/manifest and coverage inventory; modify the actual class-specific execution consumers identified in Task 1, shared pose selectors as necessary, and all five new weapon smoke tests.

**Interfaces:** reuse the same rules/resolver. Ranger family `bow`, Witch Hunter `two_handed_hammer` under `crusader`, Occultist `staff`. Do not add a new parallel renderer per class.

- [ ] Add class-parametrized failing tests for each current weapon/style, empty-slot default, named/transformed instance, save round-trip and unchanged armor/body registration. Assert Witch Hunter legacy item IDs resolve to hammers without resetting item history. Include the shared off-hand rule in both directions and preservation of existing Occultist grimoire saves.
- [ ] Run the class coverage/routing tests and confirm missing packs or consumers fail before their class gate is enabled.
- [ ] Prepare each class's complete pose coverage using its approved references. Bows need matched string/arrow release states; hammers need a continuous shaft and two-hand grip; staves need consistent shaft/grip and spell emitter placement. Retain each class's existing skill/release timing.
- [ ] Wire each class's existing execution, if any, to weapon-aware source frames with fixed queued identity. Do not invent a new execution mechanic for classes that have none. New source frames cannot change target-collapse arrows, camera/gore or reward logic.
- [ ] Enable each class only after all selectable styles and runtime contexts in its matrix pass. Render contact sheets/GIFs and review class-specific grip, draw, shaft and impact details.
- [ ] Run `python3 tools/run_smoke_tests.py weapon_rules weapon_appearance_migration weapon_visuals weapon_swapping weapon_execution creature_matchup_combat witch_hunter witch_hunter_execution --output artifacts/all-class-weapons`; add the exact Ranger/Occultist execution checks found in Task 1. Commit one complete class at a time; preserve experimental status for an unfinished class.

## Task 9: Final regression, visual acceptance and publication

**Files:** update `docs/gameplay/weapon_swapping.md`, `docs/README.md`, `README.md`, weapon coverage/provenance and current artwork download/reference manifests only where new assets belong.

**Interfaces:** consumes complete class gates and coverage matrix; produces the integrated, reviewed feature and reproducible verification record.

- [ ] Add the remaining end-to-end assertions: repeated swaps conserve total item instances; legacy saves retain names/upgrades/favourites; invalid family/slot/sidecar saves leave live state unchanged; no equip/load healing; preview/cached-session/load changes produce the selected geometry everywhere.
- [ ] Run `python3 -m unittest discover -s tests/ci -v`, editor import, and `python3 tools/run_smoke_tests.py --output artifacts/class-weapons-full`. Require all tests to execute and pass; report diagnostic counts and intentional corruption errors separately.
- [ ] Review native-resolution/full-speed showcases for all published classes and selectable styles: body/armor preservation, grounded feet, hand occlusion, continuous handles, perpendicular hammer heads, bow arrow direction, shield continuity and execution contact. Do not replace this gate with a manifest-only assertion.
- [ ] Request a fresh code review of rules, migration, resolver, cache keys and consumers; resolve blocking findings. Confirm no unrelated balance/loot/skill changes and that source hashes still match the retained originals.
- [ ] Commit the final documentation and approved integration, push using the repository's established GitHub workflow, and verify the hosted full-suite result plus uploaded logs. If an art pack is incomplete or a review gate fails, report that specific blocker and keep its class experimental; do not claim all four classes shipped.

## Execution handoff

Recommended execution: **Native**, in this session, with one fresh whole-change reviewer and the explicit Warden art-review gate. Asset/registration decisions and shared rendering interfaces are tightly coupled, so maintaining one implementation context reduces duplicate exploration. The user may instead choose fresh implementer/reviewer agents per task. Read both this plan and the approved spec before execution.
