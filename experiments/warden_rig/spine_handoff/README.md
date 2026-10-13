# Warden → Spine handoff

Start with **`warden-import.json`**. This is a generated Spine **4.3 JSON import**, not a native `.spine` project or a final animation. Its setup pose uses the current compact Warden blockout; this artwork has not been accepted as a close match to the supplied reference images.

The handoff uses basic bones and image-region attachments, with one default skin. It does not require IK, weighted meshes, physics constraints, or separate wardrobe skins. This keeps the starting rig suitable for the standard/basic workflow discussed in chat. Check the edition name in your editor; the commercial edition names are Essential and Professional.

## Open it in Spine

1. Download and unzip `warden-spine-handoff.zip` into its own folder. Keep `images/` beside `warden-import.json`; import the JSON from the extracted folder.
2. Check your editor version in **Help → About**. The starter targets **4.3**. If your installed release uses another major/minor version, send that version before changing the version field or troubleshooting import errors.
3. Choose **Import Data** from Spine's application menu and select `warden-import.json`. Import at scale **1** into a new skeleton.
4. If image paths need resolving, select the skeleton's **Images** node and set its path to the extracted `images/` folder. The included path is `./images/`.
5. Save as **`warden.spine`** beside the images folder. Saving this project requires your licensed desktop editor; it has not been done here.
6. Check the setup against `setup-preview.png`. Select the `helmet`, `weapon`, `cape`, `scarf`, `clasp`, and `shield` slots to inspect their alternative attachments. Shield is hidden initially. The only animation is `idle_blockout`, a small breathing demonstration.
7. Follow [AUTHORING.md](AUTHORING.md) to match the references and author walking/combat. Use [EXPORT.md](EXPORT.md) when sending the result back for Godot integration.

## Included files

| File | Purpose |
|---|---|
| `warden-import.json` | Parent-first bones, draw-order slots, attachment transforms, simple idle blockout |
| `images/body/` | Torso, waist, separate upper/lower arms, thighs, shins, boots |
| `images/cosmetics/` | Both helmets, capes, neck wraps, clasps |
| `images/gear/` | Sword, double axe, mace, shield |
| `attachments.json` | Source rectangles, image dimensions, local pivot pixels, provenance hashes |
| `equipment.json` | Independent appearance IDs mapped to slot/attachment changes |
| `setup-preview.png` | Setup rendered from official-runtime-decoded geometry |
| `setup-geometry.json` | Original native joint positions and attachment corners for conversion verification |
| `decoded-setup.json` | Matching setup geometry read by the official Spine runtime |

No account credentials or external Spine connection are needed. This folder stays under the isolated Warden experiment; the live game has no Spine runtime dependency yet.

## What has been checked

The official **spine-core 4.3.13** runtime reads the skeleton, resolves all 24 PNG attachments, and verifies every joint and image corner against the native setup within 0.05 rig units. Equipment mappings resolve, and `idle_blockout` applies without invalid coordinates. Exported PNG pixels match their original source regions. The runtime-decoded setup has been rendered and visually inspected.

The Spine desktop editor is unavailable here: **Import Data, Essential-edition behavior, and save/re-export must still be checked in your editor**. The runtime package's patch number is not a claim about your editor's patch version. There is no authored reference-matching walk yet, and the native Godot cloth shader was not exported.

## Rebuild or check the handoff

From the repository root, with Godot available:

```sh
godot --headless --path experiments/warden_rig/godot \
  --script res://export_spine.gd -- /absolute/path/to/new-handoff
```

Install the official runtime in a scratch directory outside the game:

```sh
npm install --prefix /absolute/path/to/scratch \
  --no-audit --no-fund --ignore-scripts @esotericsoftware/spine-core@4.3.13
node experiments/warden_rig/spine_handoff/validate.mjs \
  /absolute/path/to/new-handoff \
  /absolute/path/to/scratch/node_modules/@esotericsoftware/spine-core
```

Expected: `SPINE_HANDOFF_OK`. Rebuilding overwrites generated files in the destination; use a fresh directory so hand-edited work is preserved. This is a runtime data check, not a substitute for opening the project in Spine.

To verify original pixels and provenance against the repository source atlases:

```sh
godot --headless --path experiments/warden_rig/godot \
  --script res://verify_spine_images.gd -- /absolute/path/to/new-handoff
```

Expected: `SPINE_IMAGES_OK`. The standalone exporter is a source-workspace tool, not a script to ship in a Godot build.
