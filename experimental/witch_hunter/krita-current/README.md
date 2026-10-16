# Current Witch Hunter artwork for Krita

[Download this pack](https://raw.githubusercontent.com/araybon95/GameTest-main/main/experimental/witch_hunter/krita-current.zip)

Open **witch-hunter-scene.ora** for the layered 1280×720 scene. The Witch Hunter, bandit, background and ground are separate visible layers; nine alternate poses/contact/prop layers start hidden. Open **witch-hunter-concept.ora** for the full-body 1024×1536 illustration with one raster layer. Armor pieces are not individually separated.

Use **File → Save As → Krita Document (.kra)** for your native editing copy. Source PNGs retain their export dimensions. The scene uses the current preview composition without UI. Krita itself was not available for an application-level open test; OpenRaster structure, layer dimensions, transparency and checksums are validated.

Refreshed on 2026-10-16 from reviewed artwork commit `af4b83f63a5c9ee4c5092796eb5ee03e325b8dc6`, including the repaired opening faceplate and shoulder plaque. `manifest.json` records the individual image hashes.

| Files | Contents |
| --- | --- |
| witch-hunter-concept.png / .ora | Approved full-body identity |
| witch-hunter-combat-poses.png | Current production combat sheet |
| witch-hunter-idle.png | Registered active idle |
| execution-01…05 PNGs | Preparation, jaw contact, overhead windup, crushing contact and followthrough |
| bandit-idle.png; bandit-01…03 PNGs | Idle, recoil, buckling and collapse |
| bandit-cleaver-complete.png | Whole loose cleaver, including handle |
| scene-preview.png / witch-hunter-scene.ora | Composed scene and editable layers |

These are editing exports, not new runtime source paths. Return edited PNGs using the same names and dimensions so they can be mapped back to their atlas regions. Use this curated pack rather than editing a superseded neighboring atlas cell. The [Judgment study](../judgment/README.md) is separate from this execution pack.
