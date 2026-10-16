# Current artwork and downloads

[Download the current project ZIP](https://github.com/araybon95/GameTest-main/archive/refs/heads/main.zip)

This live branch download includes the working game, current artwork and retained design studies. Older revisions remain in Git history; they are not the current editing baseline.

| Use | Current source/download |
| --- | --- |
| Production art and selectable variants | [Live art library](assets/art_library/README.md) |
| Character frames and source mapping | [Current 160-frame review pack](https://raw.githubusercontent.com/araybon95/GameTest-main/main/experimental/art_review/01-current-frames.zip) |
| Ten-image Makko reference set | [Download and instructions](experimental/makko_reference/README.md) |
| Witch Hunter layered Krita scene and concept | [Download current pack](https://raw.githubusercontent.com/araybon95/GameTest-main/main/experimental/witch_hunter/krita-current.zip) · [Individual files](experimental/witch_hunter/krita-current/README.md) |
| Current motion and experimental designs | [Preview index](experimental/README.md) |
| File inventory and SHA-256 hashes | [ARTWORK-MANIFEST.json](ARTWORK-MANIFEST.json) |

For Krita, open PNGs directly or open `.ora` files to retain the supplied layers, then save a native `.kra` copy. The layered scene has character, enemy, ground and background layers plus hidden alternate poses. Armor pieces are not individually separated.

Use the curated frame/Krita packs when editing an active pose. Runtime atlases can retain neighboring or alternate cells required by other states; do not delete or repaint a whole atlas merely because one cell is superseded.

The artwork inventory describes the files in the current branch, with hashes as the source of truth. Review ZIPs have their own checksums. Neither an inventory nor a contact sheet certifies that every asset has been visually reviewed.

Regenerate the inventory after artwork changes with `python3 tools/index_current_artwork.py`.
