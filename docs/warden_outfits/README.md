# Warden outfits

The original Warden and Ashen Wolf use the approved complete painted artwork:
standing exploration poses, armed combat idle with subtle breathing, and one
overhead attack pose. Optional Manual walking uses ten unarmed walking frames
in a 0.84-second loop. Helm, cloak and armor stay in the same
image. The ambient-motion setting freezes the new stride and breathing.

Defeat the Undying Lord at the end of the Old Road to unlock Ashen Wolf. The
results screen announces the armor set. Choose Warden → Ashen Wolf → Save
Appearance in the Workshop. Existing saves that already completed the Old Road
also unlock it. It is cosmetic: existing equipment stats remain active, and the
selected reward costume takes priority over automatic equipment appearances.

Other heroes and the Warden's existing alternate/relic costumes retain their
previous animations. The new combat drawings contain a fixed mace and shield;
weapon-family appearance swaps need additional art.

## Live game previews

[Standing party](../room_travel/standing-lineup.png) · [Workshop](workshop.png) · [Combat](combat.png)

The previews show the actual game scenes, using deterministic test save data.
The approved source atlases live in `assets/art_library/warden_outfits/`.
Older animation experiments and comparison previews have been removed.

Walking poses use measured horizontal helm anchors so the complete character
does not jump sideways between source frames. The anchors mirror when facing
left; feet stay on the existing ground line.

The foreground forearm swing is damped by 60% relative to the torso during
walking, using a local texture correction on the complete painted frame.
Equipment trim follows the same correction; combat poses remain unaffected.
