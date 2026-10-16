# Makko AI — ten-image game reference pack

[Download reference ZIP](https://raw.githubusercontent.com/araybon95/GameTest-main/main/experimental/makko_reference/makko-reference-pack.zip) · [Browse the ten PNGs](images/)

Download `makko-reference-pack.zip`, extract it, then upload **the ten PNGs in `images/`** to Makko. The ZIP contains exactly ten image files. Paste `MAKKO-PROMPT.txt` with them and replace its character/action or UI request with the asset you want to generate.

These references use the current reviewed artwork, including the completed art repairs. They emphasize the project's painted, engraved grimdark style: heavy ink contours, angular shadow shapes, worn iron and bronze, weathered cloth and restrained crimson, violet and gold accents.

| Upload | Reference | Purpose |
| --- | --- | --- |
| 01 | Approved Witch Hunter character | Strongest full-body detail reference: sealed hooded faceplate, coherent bronze armor, devotional shoulder details, straight two-handed hammer and occult sigil. |
| 02 | Current Warden poses | Muscular armored silhouette, mace and shield, red cloth; idle, windup, attack, guard, hurt and death. |
| 03 | Current Witch Hunter poses | In-game proportions and two-handed hammer poses; same six states. Internal `crusader` source name is retained for save compatibility. |
| 04 | Current Ranger poses | Slim green archer, practical bow stance and complete bow/arrow geometry; same six states. |
| 05 | Current Occultist poses | Lean purple caster, beaked mask, staff and book; repaired two-arm hurt pose and complete casting flame. |
| 06 | Current hooded Ash Raider variant | Twelve enemy frames with the full cleaver and retained registration. The wider export includes the previously clipped blade. |
| 07 | Painted ability UI icons | Twenty native icon crops showing bold silhouettes, inky shading, physical attacks, magic and support effects. The old Penitent axe row is excluded. |
| 08 | Items, equipment and ritual UI icons | Forty-eight native icons from two intact source sheets: scrolls, potions, supplies, armor, weapons, book, lantern, ritual, map, campfire and equipment-slot symbols. |
| 09 | UI frames, banner and status | Current panel border, map backing, crimson attack banner, status sprites and exact UI palette tokens. Status sprites include native and 4× nearest-neighbor detail views. |
| 10 | Current gameplay and UI context | Recent full combat capture showing character-to-scene scale, a shared ground line, dark HUD panels, cards, map and readable accents. |

## How to guide Makko

For a specific hero, prioritize that hero's sheet. For the Witch Hunter, use 01 for the detailed approved identity and 03 for the combat poses. Sheets 07–09 define UI treatment; their item and ability symbols do not replace the weapons held by characters. Image 10 defines composition and scale rather than a new pose to copy.

The pose sheets use registered native exports at their original pixel scale. They are reference documents with labels and spacing, not ready-made engine atlas layouts. Headers, labels, neutral backgrounds and palette swatches are annotations. Ask Makko to output clean artwork with transparency and a separate consistent frame layout.

For new animation frames, specify the character, action, frame count and target canvas size. Keep a stable root and foot baseline, coherent armor and exactly two arms. Idle motion should emphasize aggressive upper-body breathing with subtle forearm/weapon movement and planted legs. During attacks, retain a complete rigid weapon, plausible grips and consistent equipment. For UI generation, specify the icon names and equal cell size, with generous transparent padding.

## What was preserved

The approved concept is displayed at its original size on parchment white; the gameplay capture is an exact file copy. Character and ability sheets display existing RGBA tiles at native scale on a neutral background, without repainting or resampling. The item reference keeps both original source sheets intact, stacked vertically, so painted details that cross nominal tile boundaries stay with their neighbors. Opaque reference pages prevent colors hidden in transparent source pixels from appearing when an image service drops alpha. The UI board displays existing components on the same neutral background; only the explicitly marked status detail views are enlarged. No new generative artwork was used for this export, and no game source artwork was changed.

`manifest.json` records source paths, hashes, frame IDs, source rectangles and output tile positions. `SHA256SUMS.txt` verifies the ten images. The pack represents reviewed repair commit `af4b83f63a5c9ee4c5092796eb5ee03e325b8dc6`. Upload the ten extracted images to Makko after downloading them.

To rebuild after refreshing the current-frame archive, run from the repository root:

```sh
python3 experimental/makko_reference/build_pack.py
```

The builder uses Pillow, validates source hashes against the repaired frame index, checks each native-scale tile against its expected background composite, and verifies the final ZIP. It uses the included current gameplay-context image, so it does not depend on ignored local audit files. Replace that capture when selecting a newer composition reference.
