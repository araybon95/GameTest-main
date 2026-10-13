# Articulated Warden reference

The user wants smooth, restrained dungeon movement and a customizable hero they can recognize in travel, combat and their card. Prototype one Warden outside the live game. Preserve the existing cosmetic and paused animation labs.

Use one shared, validated appearance profile for weapon (sword, double-headed axe, mace), helmet (greathelm, wolf), cape (oxblood, ash-grey/gold), clasp, and offhand (free or shield). Separate upper/lower limbs, torso, waist, helmet, cloth, shield and weapon. Render three instances with the same appearance and independent motion. Walking uses continuous two-link limb articulation, foot contact and light secondary motion. Combat is a looping illustrative attack, without damage or gameplay. The full-body card presents the actual selected equipment.

Godot 4.6+, no external runtime or Spine dependency, no game autoloads. The `.gdignore` and independent user-data directory keep this prototype outside main imports/saves. Generated source images remain unmodified; atlas regions, anchors and fitting live in metadata/code. Export only prototype IDs. Unknown IDs and unsupported schemas must be rejected without changing the current profile.

This is an animation/customization reference, not a production wardrobe or online implementation. The anatomical revision supports a two-hand sword reference guard and held walking/guard/wind-up/strike poses. Other two-handed weapon families, dual-wielded axes, other heroes, campaign unlocks and final hand-drawn art are future work. Native preview evidence and a short clip are required before claiming completion.
