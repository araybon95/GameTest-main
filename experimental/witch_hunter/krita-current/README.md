# Current Witch Hunter artwork for Krita

Open **witch-hunter-scene.ora** in Krita for the layered 1280×720 scene. The Witch Hunter, bandit, background and ground are separate visible layers. Nine alternate pose/contact/prop layers start hidden. Toggle visibility in the Layers panel to work on them.

Open **witch-hunter-concept.ora** for the approved full-body illustration at its original 1024×1536 resolution. It contains one raster illustration layer; armor pieces are not separately layered.

Use **File → Save As → Krita Document (.kra)** to create your native editable copy. These are standard OpenRaster files; Krita itself was not available here for an application-level open test. Archive structure, layer PNGs, transparency and checksums were validated.

The source PNG exports remain included at their original resolution; the layered scene uses the 1280×720 preview composition, without game UI.


This pack was exported from the current animation at source revision `cc2dbf3`. The source revision remains current for the artwork in this pack: later packaging commits only add these downloads and documentation.

These are the frames actually used by the animation, with no obsolete neighboring poses included. The source artwork files are PNGs; the `.ora` files package those raster layers for Krita. Transparent margins register the character to its foot anchor; preserve canvas dimensions and those margins while editing.

| File | Contents |
| --- | --- |
| witch-hunter-concept.png | Latest approved full-body concept, including sigil, armor cleanup and dried blood. |
| witch-hunter-combat-poses.png | Current production combat sheet. |
| witch-hunter-idle.png | Current registered idle frame. |
| execution-01-uppercut-preparation.png | Latest natural arm pose, squared hammer and low jaw approach. |
| execution-02-jaw-contact.png | Corrected uppercut contact. |
| execution-03-overhead-windup.png | Current raised hammer pose. |
| execution-04-crushing-contact.png | Current paired crushing impact. |
| execution-05-downswing-followthrough.png | Current downswing pose. |
| bandit-idle.png | Current unhit bandit. |
| bandit-01-uppercut-recoil.png | Recoil body with the loose weapon omitted; weapon animates separately. |
| bandit-02-buckling.png | Current wounded buckling body. |
| bandit-03-collapsed.png | Current collapsed body. |
| bandit-cleaver-complete.png | Complete standalone weapon with handle, bolster and pommel. |

Save editable work as `.kra`, then export a transparent PNG for return to the project. The individual frames here are editing exports, not new runtime source paths. Return the edited files with the same names and dimensions so they can be mapped back into the animation. The concept and combat sheet retain their original source dimensions.

Historical source atlases elsewhere in the repository intentionally retain unused older cells. They are still needed for other active poses and crop coordinates; use this pack to avoid editing an obsolete cell.
