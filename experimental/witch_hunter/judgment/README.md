# Witch Hunter — Judgment study

[Animated preview](judgment.gif) · [MP4](judgment.mp4) · [Contact](contact.png) · [Recovery](recovery.png)

A compact, nonlethal two-handed hammer drive into the Ash Raider's sternum. Three dedicated Witch Hunter poses cover the short draw-back, forward strike and recovery. A paired contact illustration makes the actual hit explicit. The bandit remains standing and keeps his complete cleaver in the same hand throughout the strike and recoil.

The mallet stays square to its straight shaft. Actor rotations and vertical travel are omitted so the feet remain grounded. Contact freezes briefly before the attacker returns to guard; a small foreground blood spray, camera emphasis and a restrained impact shake support the hit. Reduced motion suppresses camera movement, travel, recoil and moving spray while preserving the action poses.

| Beat | Time |
| --- | --- |
| Short draw-back | 0.00–0.16 s |
| Strike | 0.16–0.26 s |
| Contact hold | 0.26–0.325 s |
| Return to guard | 0.325–0.56 s |

This is a silent experimental visual study. Production Judgment still uses its existing presentation, 1 AP cost and 6 base damage. No combat controller, production art, balance, save IDs, execution rules or rewards are changed. Sunder and Banishment are subsequent tuning passes after this baseline is reviewed.

Run from the repository root:

```sh
godot --path . --screen 0 experimental/witch_hunter/judgment/showcase.tscn
```

Space pauses, R restarts and M toggles reduced motion. Capture 72 frames at 30 FPS:

```sh
godot --path . --screen 0 --script experimental/witch_hunter/judgment/export_preview.gd -- /tmp/witch-judgment
```

The showcase reuses the experimental execution's registration/drawing helpers and stage assets, then replaces its active artwork and draw loop; it does not run the execution timeline or draw its death poses. PNG source sheets are in `assets/` for Krita editing. Preserve sheet dimensions and sprite placement.

Validation: the Judgment timing smoke test checks preparation, release, exact contact boundary, 65 ms held contact without sliding, recovery under 250 ms and a finite return to guard. Existing Witch Hunter skill and execution smoke tests also passed. The native renderer captured the preview for contact, foot alignment, complete held weapon and recovery review; code/visual review found no remaining blocker. The skill smoke test retains existing Godot resource-shutdown diagnostics.
