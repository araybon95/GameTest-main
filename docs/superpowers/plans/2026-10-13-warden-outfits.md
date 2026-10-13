# Approved Warden Outfit Integration Plan

Goal: Put the approved original and Ashen Wolf complete painted outfits into the
game, unlocking Ashen Wolf after completing the Old Road's Undying Lord fight.

Architecture: Use the existing outfit choice, completed-expedition record and
save files. A Warden-only art catalog supplies armed combat and ten unarmed travel
frames to the current TextureRect presentation. Other heroes and legacy outfits
continue through their existing catalogs. Work is isolated on a feature branch.

Approved reference: the original complete-painted stride and Ashen Wolf animation
were approved in this conversation; their source atlases are copied byte-for-byte
from the reviewed experiment, not regenerated.

- [x] Add the two approved atlases, tagged idle/camp/portrait resources and a
  shared frame catalog; test armed versus travel frame routing.
- [x] Gate Ashen Wolf on completed `old_road`, permit validated Workshop selection,
  retain selection and entitlement through existing saves, and protect manual
  reward selection from equipment-costume overrides; test locks and persistence.
- [x] Route Warden hallway frames and combat poses through the catalog. Respect
  travel pause, facing, arrival and reduced-motion settings; use unarmed travel
  frames in settled rooms. Test live scene changes and old outfit compatibility.
- [x] Add Workshop reward choice and unlock feedback. Verify drafts do not equip
  outfits and reject selection on other heroes or before completing the boss.
- [x] Run relevant and repository smoke checks, render live scenes, independently
  review the diff and publish a review branch/PR. Do not merge main automatically.

Limits: The approved combat drawings contain a fixed painted mace and shield;
weapon-family art swaps are separate future artwork. Unlocks are cosmetic and do
not grant stat equipment, alter RNG or auto-equip the reward. Completed older
campaigns gain entitlement from their existing completion record.
