# Warden Spine handoff plan

> **For agentic workers:** Use superpowers:executing-plans for inline execution. Checkboxes track delivery.

**Goal:** Give the user separate PNG attachments and an editable Spine skeleton, with a practical route back to Godot.

**Architecture:** A standalone Godot export script reads the existing cutout rig without changing it, saves original image regions, and converts its setup transforms to Spine coordinates. A single default skin contains individually selectable equipment attachments. An independent official Spine runtime reads and checks the resulting JSON.

**Tech stack:** Godot 4.6+, Spine JSON 4.3, official spine-core 4.3.13 for validation only.

**Spec:** `brief.md`, especially Reference fidelity requirement; user authorizes the shared Spine workflow and reports the latest standard edition.

## Constraints

- Keep all repository changes under `experiments/warden_rig`.
- Basic bones and region attachments only; no IK, meshes, physics constraints, or named wardrobe skins.
- Preserve original source pixels and record provenance; current artwork is a replaceable blockout, not an accepted reference match.
- Do not install a runtime into the live game or access the user's Spine account.
- Clearly distinguish runtime validation from testing in the unavailable Spine desktop editor.

## Review focus

- Godot's downward Y axis must convert to Spine's upward Y axis without mirrored art or detached equipment.
- Attachment paths must resolve after unzipping; setup pivots and source dimensions must survive replacement art.
- Cosmetic selectors must remain independently composable; axe/mace swaps still require authored grip/pose families.
- The latest standard edition must not require Professional-only features.
- Editor and Godot runtime minor versions must match when the user returns a final export.

## Task 1: Export and validate the handoff

**Files:** `godot/export_spine.gd`, `spine_handoff/warden-import.json`, `spine_handoff/images/*`, `spine_handoff/attachments.json`, `spine_handoff/equipment.json`, `spine_handoff/setup-geometry.json`, `spine_handoff/validate.mjs`.

**Interfaces:** Exporter accepts one destination directory; outputs 24 PNGs, setup bones/slots, and independent equipment entries. Validator accepts handoff directory and an installed official spine-core directory; outputs `SPINE_HANDOFF_OK` and decoded setup geometry for rendering.

- [x] Write and run validator before export; expect a clear failure that the skeleton handoff is missing.
- [x] Implement lossless region extraction, parent-first bone transforms, image attachment paths, and equipment contract.
- [x] Run official runtime validation; compare world joint positions and image corners against native setup geometry.
- [x] Check all PNG dimensions, RGBA and source-region pixel equality; run existing isolated rig smoke.

## Task 2: Document and deliver

**Files:** `spine_handoff/README.md`, `spine_handoff/AUTHORING.md`, `spine_handoff/EXPORT.md`, `godot/preview_spine.gd`, `preview/spine-setup.png`, `preview/warden-spine-handoff.zip`, `README.md`.

- [x] Render the decoded Spine setup, inspect orientation/layering/gear, and include the preview.
- [x] Document import/save as .spine, reference tracing, hand-drawn replacement, basic bone animation, and matching-version export.
- [x] Package a portable ZIP with image paths and handoff documents; exclude source tools and runtime dependencies.
- [x] Obtain a fresh independent review, fix material findings, and run affected checks.
- [x] Commit, fast-forward main, push GitHub, and verify remote revision.
