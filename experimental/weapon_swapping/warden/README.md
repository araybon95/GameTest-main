# Warden weapon review

Experimental visual proof: Iron Longsword (left) and Oathkeeper (right), using the same original Warden armor and shield. Warden gameplay routing is enabled on the feature branch after approval of the original visual proof. The other three class packs are now integrated on the same feature branch.

- [Ordinary pose animation](weapon-comparison.gif) · [MP4 download](weapon-comparison.mp4)
- [Execution comparison](weapon-execution.gif) · [MP4 download](weapon-execution.mp4)
- Full-size stills: [idle](comparison.png), [windup](windup.png), [execution contact](execution-contact.png)

Oathkeeper now has an enhanced ice-blue fuller, luminous oath sigil and guard gem for a stronger relic identity.

Please review grip placement, straight weapon axes, hand occlusion, shield continuity and foot registration. Both animations use the same underlying body poses; these are weapon-layer proofs, not newly animated body frames.

Run `godot --path . experimental/weapon_swapping/warden/showcase.tscn` for the native showcase. Tab switches ordinary poses/execution, Space pauses, and R restarts. `prepare_assets.gd` and `prepare_execution.gd` build the registered layers; `export_preview.gd` captures the two comparisons. Source artwork, repair masks, registration transforms and generation provenance are retained alongside the proof.

The Warden catalog now covers all four weapons and four armor styles, including travel, camp and execution. [Native equipment comparison, 1280](equipment-preview-1280.png) · [1920](equipment-preview-1920.png). [Ranger, Witch Hunter and Occultist reviews](../README.md) include their completed weapon packs. Shared compatibility, save migration and registration validation remain covered by smoke tests.

The original showcase was approved before runtime integration. Full feature verification continues on the isolated feature branch.
