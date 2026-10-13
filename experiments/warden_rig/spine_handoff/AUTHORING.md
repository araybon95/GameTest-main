# Match the references before animating

The supplied images are the visual specification. The current generated pieces are raw material, and may need repainting or replacement. A correctly connected skeleton alone is not a successful visual match.

## Establish the setup pose

Use the supplied raised two-hand sword stance for the combat guard and the three-position walking sheet for low-carry travel. Their source files were supplied in chat and are **not archived in this bundle**. Add your originals as temporary image attachments in Spine, with a separate reference slot behind the Warden. Remove the reference attachments before the final export.

Compare at equal head-to-ground height. Match the silhouette first: helmet/body ratio, chest width and height, waist position, shoulder spacing, leg length/thickness, knee bends, and boot spacing. Then match the angles and overlap of upper arms, forearms and hands. Align both hands to the sword handle; position and tilt the blade from the reference rather than accepting the generated guard as exact.

When a piece's shape will not match by moving or rotating it, replace the artwork. Avoid stretching limbs to compensate for an incorrectly drawn silhouette. Keep the pose readable with the cape hidden, then enable the cape and check its neck registration and outline.

## Bone and layer contract

| Bone or slot | Job |
|---|---|
| `root` | Whole-character placement and facing |
| `pelvis` | Hip position; parent of torso and both leg chains |
| `torso` | Compact chest; parent of shoulders, neck and waist artwork |
| `near_thigh` / `far_thigh` | Hip-to-knee articulation |
| `near_shin` / `far_shin` | Knee-to-ankle articulation |
| `near_ankle` / `far_ankle` | Independent boot orientation |
| `*_upper_arm` / `*_forearm` / `*_hand` | Shoulder, elbow and gripping-hand articulation |
| `head` | Helmet attachment, neck pivot |
| `weapon` | Grip pivot on the near hand; alternate weapon images |
| `shield` | Offhand grip pivot; hidden or visible attachment |
| `cape` / `scarf` | Registered cloth image transforms about the neck |
| `clasp` slot | Clasp image attached to torso; follows cloak choice |

Spine coordinates use **Y upward**, with `root` at ground level. Bone lengths and setup proportions are editable, not locked reference measurements. Cape/scarf bones include source-registration scales/shear, so use their visual pivot and start with tiny rotations rather than resetting their transforms. Boots are level in setup; with basic bones, counter-key ankle rotation as thigh/shin rotations change.

Draw order puts the cape behind the body, far limbs behind near limbs, and the gripping forearms over the scarf and sword handle. Inspect crossings in raised guard, wind-up, thrust, and walking; animate slot order when a pose needs different occlusion.

## Hand-drawn replacements

Keep each PNG's dimensions and its `pivot_pixels` position from `attachments.json`. Pivots are measured from the PNG's top-left in pixels, before display scaling. Some pivots lie outside the painted outline or canvas; preserve them intentionally. Paint overlap at joints so neighboring pieces can rotate without showing holes. Images are individual source-region crops; they are not equal-size atlas cells.

If you change a canvas or pivot, reposition that attachment in Spine and record the new contract. Keep names stable so appearance IDs continue to resolve. Forearms currently include gauntlets and hands; separately replaceable gloves or shoulder plates would require another layer split and corresponding slots.

## Author the movement

1. Create `walk_sword` with the reference low weapon carriage and restrained steps. Begin with contact A, passing, contact B, and returning contact A. These are authored phase choices, not recovered timing from the static reference sheet.
2. Key hips/thighs/shins/ankles directly. Keep a contact sole planted as the body advances, lift the swing sole slightly, and counter-key the boot angle. Check both knees point consistently with the character's facing.
3. Keep head and chest motion small. Use a little breathing, shoulder movement and delayed cloth rotation; avoid full-body hopping. Repeat the first pose at the loop end and tune interpolation until feet and hands cross the seam smoothly.
4. For two-hand sword poses, manually key the far arm so its hand remains on the second grip throughout. This import has no IK or automatic grip constraint. Inspect the entire transition, not just the keyframes.
5. Author `guard_sword`, `attack_sword`, `walk_onehand`, `attack_axe`, `attack_mace`, and `guard_shield` only as needed. Swapping an image does not automatically change the arm pose, limb projection, attack reach or draw order.
6. Review a looping video at gameplay size against the original references before treating it as final. `idle_blockout` only proves the basic animation path; replace it if its movement conflicts with the reference.

Keep weapon animation separate from helmet/cloak selection. `equipment.json` maps all currently supported appearance IDs; changing a cloak updates cape, scarf and clasp together. Each gameplay view should ultimately use the same selections and exported skeleton, with its own animation state.
