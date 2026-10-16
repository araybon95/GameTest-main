# Artwork review downloads

The 2026-10-16 repair pass addresses 13 confirmed findings from the partial artwork audit. [Repair report and current previews](repairs/README.md) · [Before/after details](repairs/local-art-dark.png).

1. [Current frames and comparisons](01-current-frames.zip) — refreshed 160 transparent frames, stable R0001–R0160 IDs, grouped sheets, source hashes and canvas-origin offsets. Exported from base `5990a1974b33d5ab9041299b7cfd9304fd951172` plus the local repair changes. The Raider’s full blade is retained.
2. [All source overviews](02-all-source-overviews.zip) — **historical snapshot `80d4012`**, 118 pages with paths, hashes and duplicate aliases. These pages predate the repairs.
3. [Animation review](03-animation-review.zip) — **historical snapshot `80d4012`**, 28 storyboards and 332 sampled motion frames. Use the [new previews](repairs/README.md) for corrected Warden and Witch Hunter motion.

The refreshed frame pack and previews describe the repair working tree, not a published Git revision. Packs 02 and 03 remain useful for original audit evidence; their older frames are not the corrected baseline. The inventory covers 505 source records, but neither that inventory nor this repair pass establishes a complete visual audit of every asset.

Paste the [review prompt](REVIEW-PROMPT.md) into ChatGPT, then attach extracted JPG/PNG images in small batches. Include native frames for fine details and motion samples when checking contact or grounding. Uploading a ZIP alone does not guarantee its images are visually inspected.

[Detailed instructions](START-HERE.md) · [Batch request](BATCH-REQUEST.md) · [Findings template](FINDINGS-TEMPLATE.csv) · [Coverage](COVERAGE.json) · [ZIP checksums](SHA256SUMS.txt)

[Download the historical full project artwork snapshot](https://github.com/araybon95/GameTest-main/archive/80d401207b24c3e2bae3d096e1f3fedda0e79a3f.zip). Its original-image URLs refer to that historical revision. Use the local source paths and hashes in the refreshed frame index for this repair pass.

To regenerate native frames through the current asset loaders:

```sh
godot --headless --path . --script experimental/art_review/export_current_frames.gd -- /tmp/art-review-current-frames
```
