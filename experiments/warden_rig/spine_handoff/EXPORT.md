# Return the Spine project for Godot integration

## Export from your editor

Save `warden.spine` and keep the editable PNG layers. Export skeleton **JSON** plus a packed texture atlas: `warden.json`, `warden.atlas`, and every generated atlas-page PNG. Use export scale **1** initially and keep the animation and attachment names described in the handoff. Use the editor's atlas packing option; the individual PNG folder alone is not a runtime atlas.

Use lossless PNG, modest padding/extrusion (start with 2 pixels), and avoid lossy image conversion. Note the atlas's premultiplied-alpha setting so the renderer is configured to match. Start with straight alpha if no runtime configuration has been chosen. Include all body and cosmetic attachments, including those hidden in setup, and verify the editor export has not omitted alternate gear.

The starter JSON's placeholder skeleton bounds are not final export bounds. Let the editor compute the real export bounds after pose/art changes. Remove temporary copyrighted reference/background attachments from your authored runtime export; retain your own editable source artwork separately.

## Send back this folder

```text
warden-spine-export/
  warden.spine
  images/                   editable attachment PNGs
  runtime/
    warden.json
    warden.atlas
    warden.png              plus warden2.png, etc., if multiple pages
  preview.mp4               reference-matching walk and combat loops
  export-notes.txt
```

In `export-notes.txt`, record the exact Spine editor version, edition, export scale, premultiplied-alpha setting, and final animation names. Include changed attachment pivots/names and any new slots. Zip the folder and attach it to the chat when ready. Do not send account credentials.

## Godot integration boundary

The official **spine-godot** runtime must match the exported Spine **major/minor** version. The starter targets 4.3; confirm your editor and the `skeleton.spine` version in the actual exported JSON before choosing the runtime. Do not relabel JSON from another version to make it load.

The current game uses a regular Godot project and has no Spine runtime installed. Integration requires an official spine-godot module build or a compatible GDExtension, including matching Godot binaries/exports for each target platform. Check compatibility with the game's actual Godot version before installing it. Keep the first imported skeleton in an isolated test scene until visuals, attachment swaps and exports are verified.

The first integration should load the JSON/atlas/pages, play the reviewed walk and combat clips, and apply `equipment.json` selections consistently to travel, battle and the hero card. Check seams, contact feet, pause/facing, alpha edges, all cosmetic combinations, and Steam target builds before replacing live sprites. Combat events and multiplayer replication are separate work and are not implemented by this handoff.

## Official references

- [Spine data import](https://esotericsoftware.com/spine-import)
- [Spine export](https://esotericsoftware.com/spine-export)
- [JSON format](https://esotericsoftware.com/spine-json-format)
- [Official spine-godot runtime](https://github.com/EsotericSoftware/spine-runtimes/tree/4.3/spine-godot)
- [Official spine-godot guide](https://esotericsoftware.com/spine-godot)

The 4.3 runtime branch was checked during preparation; it documents support for Spine 4.3 exports. The desktop editor workflow and final runtime export remain to be verified with your files.
