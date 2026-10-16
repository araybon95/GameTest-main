# Current artwork review

[Download 160 current frames](01-current-frames.zip) · [Latest motion and repair notes](repairs/README.md) · [Checksums](SHA256SUMS.txt)

The frame pack contains transparent native frames, stable R0001–R0160 IDs, grouped comparison sheets, source hashes and canvas-origin offsets. It includes the reviewed Warden, Occultist and Witch Hunter repairs and the complete Raider blade export. Artwork sources match reviewed repair commit `af4b83f63a5c9ee4c5092796eb5ee03e325b8dc6`.

Use [START-HERE.md](START-HERE.md), the [review prompt](REVIEW-PROMPT.md) and [findings template](FINDINGS-TEMPLATE.csv). Extract the ZIP and attach actual images in small batches; uploading a ZIP alone does not prove visual inspection.

For movement, use the current GIFs/MP4s in the [repair previews](repairs/README.md) and [design index](../README.md). The two older source-overview/animation-sampling ZIPs were removed because they predated these corrections. Older source inventories are not a current visual certification.

The [coverage record](COVERAGE.json) describes this export and the partial audit. Neither 160 exported frames nor 13 addressed findings establishes complete visual inspection of every game asset.

Regenerate native frames through current loaders:

```sh
godot --headless --path . --script experimental/art_review/export_current_frames.gd -- /tmp/art-review-current-frames
```
