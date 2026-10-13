# Articulated Warden Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Demonstrate continuous Warden articulation with synchronized equipment across walking, combat and hero-card views.

**Architecture:** A validated Resource appearance profile is shared by three independent Node2D joint hierarchies. Atlas metadata supplies attachment regions, anchors and display dimensions; a two-link solver drives articulated limbs. The standalone scene controls selection, motion, inspection and prototype export.

**Tech Stack:** Godot 4.6 GDScript, native canvas rendering, transparent OpenAI-generated cutouts.

**Spec:** `brief.md`

## Global Constraints

- All implementation stays in `experiments/warden_rig`; live game and previous experiments unchanged.
- No runtime dependencies, game autoloads, real equipment stats or campaign mutations.
- All active source image pixels preserved, with provenance hashes and alpha checks.
- Profile export is version 1 and explicitly prototype-only.

## Review Focus

- Invalid or future profiles leave every current selection intact.
- Equipment swaps during attacks reach all views without resetting motion or detaching from the grip.
- Pausing freezes both articulation and corridor travel.
- Reversing travel mirrors the actor, retaining socket registration and positive walking cadence.
- Loop seam and contact feet remain continuous at normal and low frame rates.

### Task 1: Art and appearance contract

**Files:** `godot/appearance.gd`, `godot/assets/{body_parts,arm_parts,gear_parts}.png`, `godot/assets/attachments.json`, `godot/smoke.gd`.
**Interfaces:** Appearance `set_slot(slot:String,id:String)->bool`, `apply_data(data:Dictionary)->bool`, `to_dict()->Dictionary`, `appearance_changed` signal. Weapon IDs `sword`, `axe`, `mace`; helmet `original`, `wolf`; cloak `original`, `crown`; offhand `none`, `shield`.

- [x] Write and run smoke guard: absence of the profile/lab fails cleanly.
- [x] Generate cutout atlases and retain original outputs; inspect tile contents and alpha.
- [x] Implement profile validation, atomic import and attachment metadata.
- [x] Verify valid changes, invalid slot/ID rejection and incompatible import rejection.

### Task 2: Articulation and shared views

**Files:** `godot/{rig.gd,motion.gd,lab.gd,lab.tscn,project.godot,cloth.gdshader}`.
**Interfaces:** Rig `appearance`, `mode`, `advance(delta)`, `set_time(seconds)`, `paused`, `reverse`, `show_joints`; Lab `appearance`, `actors`, `set_slot`, `save_profile`, `load_profile`.

- [x] Extend smoke for shared selection, independent motion, limb movement, reachable feet and attachment parenting.
- [x] Build joint hierarchy, two-link solver, continuous stance/swing trajectory and restrained torso/cloth motion.
- [x] Build walking, repeating combat and full-body card views with shared Resource.
- [x] Add selection, pause, facing, inspection and own-project profile export/import.
- [x] Run full standalone smoke plus existing cosmetic lab regression check.

### Task 3: Native evidence and delivery

**Files:** `godot/capture.gd`, `preview/*`, `README.md`, `godot/assets/sources.json`.

- [x] Inspect native assembled, alternate weapon, stock and joint-overlay screenshots; tune fitting where evidence shows gaps.
- [x] Record a deterministic native 30 fps clip showing movement, equipment swaps and attack motion.
- [x] Verify clip metadata, profile semantics, source hashes and absence of live-game changes.
- [x] Request a fresh final code review, address material findings and rerun affected checks.
- [x] Commit and update the user-authorized GitHub repository.

### Anatomical reference revision

- [x] Fit a compact torso to corrected shoulder and hip sockets; use actual atlas regions and local pixel anchors.
- [x] Separate thigh, shin and boot artwork; keep soles level with independent ankle pivots.
- [x] Add a shared offhand selector, a foreshortened two-hand sword grip, and held guard/wind-up/strike poses.
- [x] Verify both-hand grip reach through walking and attack recovery, profile compatibility, and native pose sheets.
- [x] Review code and native renders independently; correct phase-sheet sampling and replacement-art guidance.
