# Warden weapon review

Experimental visual proof: Iron Longsword (left) and Oathkeeper (right), using the same original Warden armor and shield. Production weapon-art gates remain disabled. This does not replace the live game artwork.

- [Ordinary pose animation](weapon-comparison.gif) · [MP4 download](weapon-comparison.mp4)
- [Execution comparison](weapon-execution.gif) · [MP4 download](weapon-execution.mp4)
- Full-size stills: [idle](comparison.png), [windup](windup.png), [execution contact](execution-contact.png)

Please review grip placement, straight weapon axes, hand occlusion, shield continuity and foot registration. Both animations use the same underlying body poses; these are weapon-layer proofs, not newly animated body frames.

Run `godot --path . experimental/weapon_swapping/warden/showcase.tscn` for the native showcase. Tab switches ordinary poses/execution, Space pauses, and R restarts. `prepare_assets.gd` and `prepare_execution.gd` build the registered layers; `export_preview.gd` captures the two comparisons. Source artwork, repair masks, registration transforms and generation provenance are retained alongside the proof.

Shared class rules and legacy appearance migration are implemented. Remaining Warden weapons/styles and Ranger, Witch Hunter and Occultist visual coverage are pending. All 106 smoke tests and eight runner tests passed for this milestone. Review found no blocking code issues; future two-handed staff support and stricter compositor registration validation remain deferred until before production enablement.

The approved plan requires Warden showcase art review before runtime art integration.
