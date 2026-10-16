# ChatGPT artwork consistency review

This packet prepares images for a separate ChatGPT conversation. It does not upload them into another chat. A partial audit and a repair pass have now been completed; see the [repair report](repairs/README.md) for the 13 confirmed findings addressed.

Pack 01 is refreshed from the 2026-10-16 repair working tree. Packs 02 and 03 remain historical `80d4012` snapshots. For corrected Warden and Witch Hunter motion, use the new previews linked in the repair report instead of the historical storyboards.

## Start with these steps

1. Download and extract the numbered review ZIPs.
2. Open `REVIEW-PROMPT.md` and paste it into ChatGPT.
3. Start with the Witch Hunter Judgment and execution sheets in `01-current-frames`, then the default party and hooded raider. Attach the relevant JPG comparison sheets **and** the original transparent PNG frames in `native-frames/` (six to eight images at a time is a practical starting batch).
4. For motion, attach one `storyboard.jpg` from `03-animation-review` plus the individual time-stamped JPGs near the impact being reviewed. The Witch Hunter and Ranger finishers have extra impact-focused samples.
5. Review `02-all-source-overviews` in small groups (four to six overview sheets per request). These pages cover all source images, including selectable variants, icons and historical experiments. When ChatGPT flags a small detail, attach the full-resolution original before accepting the finding.
6. Save findings using `FINDINGS-TEMPLATE.csv`. Start a new chat for another character/family if the current chat loses track of the baseline; reuse the prompt and carry forward the approved baseline and findings.

Uploading a ZIP alone may not expose its images to visual review. Extract the archive and attach the JPG/PNG files directly. If a ChatGPT session explicitly supports examining image files inside archives, ask it to report exactly which files it actually inspected. Never assume all files were reviewed just because the archive was attached.

## What is included

- `01-current-frames`: registered individual frames exported through the game/preview asset loaders, grouped comparison sheets, source mapping and state labels. These are static frame exports, not proof of every runtime deformation.
- `02-all-source-overviews`: labeled views of every unique static source image, rendered SVGs, and OpenRaster layer extracts. Exact duplicate source files are recorded as aliases in the index rather than silently omitted. Historical sheets may contain unused superseded cells.
- `03-animation-review`: chronological filmstrips and native-resolution sampled JPG frames for every tracked GIF/MP4. Sampling is not exhaustive; very short transitions can still require frame-by-frame video inspection. JPGs/GIFs have compression/palette limits.

## Full-resolution source artwork

The historical source-overview and animation snapshot is commit `80d401207b24c3e2bae3d096e1f3fedda0e79a3f`. The current frame pack records local repaired-source hashes and is not represented by that older commit.

[Download all original project files from that snapshot](https://github.com/araybon95/GameTest-main/archive/80d401207b24c3e2bae3d096e1f3fedda0e79a3f.zip).

The overview index includes original repository paths, file hashes and direct original-image URLs. ChatGPT may not be able to open private or raw URLs; attach the actual file when needed. Originals are not duplicated inside the overview ZIP, keeping the review download manageable. Exported native character frames and sampled motion frames are included in their own review ZIPs.

## Avoid false findings

- `default-crusader` is the Witch Hunter default combat body; `crusader` remains the internal save-compatible identifier.
- Compare within one character and one selected outfit. Original, alternate, equipment/relic and Ashen Wolf art are intentional variants.
- The Witch Hunter replaces the Penitent Crusader in default combat. Old Crusader art may remain in historical/selectable sources or still be routed into camp/portrait views. Flag a current-view inconsistency when routing or a current screenshot proves it; do not automatically treat every old source as either current or safely historical.
- `experimental/witch_hunter/execution/assets/poses.png` still contains superseded cells; current opening preparation is loaded from `uppercut-lead-in.png`, and corrected jaw contact from the left panel of `uppercut-corrected.png`. The crushing contact uses the original right panel. The standalone cleaver now has a complete handle and lands flat.
- The Witch Hunter Krita pack is an editing snapshot from before the later Judgment prototype. The Judgment family in this review packet is the current prototype.
- Check anatomy and art continuity on native images. Check crop, scale, pivot, ground alignment, occlusion and contact timing on actual motion frames. Different asset resolutions alone are not proof of in-game size inconsistency.
- A hammer must be rigid and correctly socketed. Perspective can make a valid three-dimensional right angle project differently on the image plane; do not flag it solely because two measured 2D lines are not exactly 90 degrees.
- Checkerboards are review backgrounds, not painted pixels. Camera lighting, materials and intentional shader effects can change an actor’s appearance in footage; do not confuse them with a source-paint mismatch.
- Hands legitimately cover parts of handles. Flag an absent or broken handle only when the visible evidence rules out normal occlusion.
- Do not treat GIF palette shimmer, JPEG block noise, expected motion blur, wounds from impacts, intentional weapon drops or a death pose as an unexplained continuity error.

This packet contains fictional dark fantasy violence and execution artwork from the project. Review it as game asset consistency, not as real-world injury imagery.
