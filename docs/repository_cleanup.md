# Current-content cleanup — 2026-10-16

The current branch now prioritizes the working game, approved artwork, current editing/reference downloads and useful tests. Git history is retained; no history rewrite is part of this cleanup.

## Changes

- Removed 321 superseded or unused files (375,483,199 bytes, approximately 358 MiB): historical art-review archives, pre-repair Warden captures, the initial Raider animation, obsolete conversion/Crusader notes, old balance-run dumps and the unreferenced source sound bundle.
- Retained production audio, all game assets and selectable variants, runtime sources, tests, credits and provenance. All 1,620 captured runtime files are byte-identical to the pre-cleanup working tree.
- Relocated 24 top-level implementation/prompt references under `docs/`, updated their links and added a concise documentation index. Replaced obsolete no-save/old-Crusader descriptions with current behavior.
- Updated the main README and artwork download page to point at current branch contents. Historical snapshots are available through Git history rather than presented as current downloads.
- Refreshed Witch Hunter Krita PNGs and the layered scene from reviewed artwork commit `af4b83f63a5c9ee4c5092796eb5ee03e325b8dc6`. The preparation PNG exactly matches current review frame R0137.
- Preserved all 160 PNG payloads in the current frame pack while refreshing its metadata. Rebuilt the ten-image Makko pack without relying on ignored local audit files. Regenerated the inventory of 516 artwork files.
- Kept raw local investigations and agent plans out of the published tree through `.gitignore`.

The reviewed art/save repairs are recorded in a separate parent commit, followed by this content-only cleanup. Runtime changes belong to that reviewed repair commit; this cleanup changes no game rules or balance.

## Verification

All eight affected smoke scripts passed: project art, art-library resources, combat audio, art consistency, Warden execution registration, Witch Hunter execution, malformed-save validation and enemy variants. These runs emitted no diagnostics. The earlier full 101-script run and its shutdown warnings are documented in the [gameplay audit](gameplay_stability_audit.md); that full suite was not needlessly repeated after documentation/media-only removals.

Static checks found no broken local Markdown links and no retained resource/code references to removed files. Current artwork hashes, ZIP CRCs and per-frame hashes were checked. The Krita pack contains 14 PNGs, a 13-layer scene OpenRaster file and a one-layer concept OpenRaster file. Krita application-level opening has not been tested here. Native scene export completed through Xorg/Mesa with display-driver warnings; no replacement artwork was generated.

Removing files from the current tree reduces current downloads; retained Git history still contains older objects. Production atlases retain any source cells needed by active states or selectable appearances.
