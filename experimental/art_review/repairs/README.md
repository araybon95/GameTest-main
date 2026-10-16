# Art consistency repairs — 2026-10-16

This pass fixes the 13 confirmed audit findings in the working tree based on `5990a1974b33d5ab9041299b7cfd9304fd951172`. It preserves the approved designs and combat timing. The scope is the confirmed findings, not a complete review of all 505 source records.

## Inspect the results

- Local source details: [before/after on dark](local-art-dark.png) · [before/after on light](local-art-light.png). These are labeled, nearest-neighbor detail enlargements.
- Warden attacks: [Slash GIF](warden-slash.gif) / [MP4](warden-slash.mp4) · [Heavy Strike GIF](warden-heavy.gif) / [MP4](warden-heavy.mp4). Isolated production motion, with the source sampled at 60 FPS and GIFs at 30 FPS.
- Warden execution: [normal GIF](warden-execution-motion.gif) / [MP4](warden-execution-motion.mp4) · [reduced-motion GIF](warden-execution-reduced.gif) / [MP4](warden-execution-reduced.mp4). Isolated current presentation module including its effects; cropped for readability.
- Full combat: [Warden attacks](../../warden_transitions/integrated-combat.mp4) · [Warden execution](warden-execution-integrated.mp4). Native game-scene captures, including camera, effects and interface.
- Occultist: [neighboring poses GIF](occultist-poses.gif) / [MP4](occultist-poses.mp4). Static pose sequence without combat effects.
- Witch Hunter execution: [normal GIF](../../witch_hunter/execution/witch-hunter-execution.gif) / [MP4](../../witch_hunter/execution/witch-hunter-execution.mp4) · [reduced-motion GIF](witch-hunter-execution-reduced.gif) / [MP4](witch-hunter-execution-reduced.mp4). The existing experimental scene, with corrected opening artwork.
- Raider export: [before/after](raider-export.png) · [refreshed 160-frame pack](../01-current-frames.zip).

## Findings addressed

| ID | Correction | Verification |
| --- | --- | --- |
| W-001 | Removed whole-pose dissolves that doubled the Warden's limbs and equipment. Kept mesh motion and approved timing. | Single opaque pose across sampled transitions; isolated and full combat playback. |
| W-002 | Alternate and relic outfits cannot trigger execution artwork for the original Warden. | Real lethal-hit fixtures with selected alternate and equipped relic appearances, plus default and Ashen Wolf checks. |
| W-003 | Masked neighboring-cell fragments in Warden death, original travel 07 and Ashen Wolf travel 05. | Masks retain full atlas dimensions, source UVs, intended pixels and anchors. |
| W-004 | Completed the windup mace tip inside the existing canvas. | Native contour, adjacent poses, playback and exact outside-mask pixel comparison. |
| W-005 | Shared status breathing now respects Ambient Motion. | Healthy idle remains still when disabled; injury/death transforms are retained. |
| WE-01 | Extracted the complete dropped cleaver from existing artwork, kept it visible through contact and aligned it with the next painted prop. | Blade/handle endpoint checks and normal/reduced execution playback. |
| WE-02 | Registered contact, followthrough and recovery using measured sole anchors. | Contact-to-followthrough foot tolerance, frame bounds and normal/reduced playback. |
| WH-01 | Masked the neighboring hammer fragment in the Witch Hunter windup. | Intended hammer, atlas UVs and registration retained. |
| WH-02 | Restored a sealed bronze faceplate to the uppercut lead-in. | Local before/after, neighboring poses and normal/reduced experimental playback. |
| WH-03 | Restored the missing framed devotional plaque on the lead-in shoulder. | Local before/after and playback; armor, arm and hammer geometry preserved. |
| OCC-001 | Removed the extra raised empty arm from the hurt pose and repaired the small cloak edge. | Two equipment-holding arms retained; light/dark alpha views and neighboring pose playback. |
| OCC-002 | Widened the windup/cast crop to include the existing book flame. | Full alpha extent retained with the same absolute body anchor. |
| RG-E01 | Expanded review canvases to retain negative-margin overflow, using common +20px left padding for the Raider sequence. | R0107 retains all imported source pixels, including 623 previously clipped visible pixels. This was an export defect. |

## Preservation and checks

Only three source PNGs changed: the Warden sheet (160 pixels), Occultist sheet (4,577 pixels) and Witch Hunter uppercut lead-in (2,326 pixels). All retain their original dimensions and **zero pixels changed outside the explicit repair masks**. Small generated detail patches were composited through those masks; no full-character regeneration was used. Atlas cleanup and the cleaver extraction operate on runtime copies.

All 11 focused smoke scripts passed: art consistency, Warden execution registration, Warden transitions, Warden execution, status visual, party builds, Warden outfits, hero appearance, equipment costumes, battlefield ground and Witch Hunter execution. The Warden execution and status-visual fixtures still emit the pre-existing shutdown resource diagnostics; assertions pass and there are no script errors. Independent code review found no remaining blockers.

The 160-frame ZIP passed CRC validation and per-frame hash checks. Frame IDs are stable, and the index records source hashes and origin offsets. Godot's existing alpha-border import processing remains enabled; native exports therefore match imported textures, while the source repair pixel counts above refer to the actual PNG files. The [verification manifest](verification.json) records the checks, source hashes and preview metadata.

The original audit coverage remains partial. Uncertain flags are not relabeled as fixed, and historical source-overview/animation ZIPs were not regenerated. These changes and refreshed artifacts have not been pushed to GitHub as part of this pass.
