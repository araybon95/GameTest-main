# Witch Hunter

[Layered scene for Krita (.ora)](krita-current/witch-hunter-scene.ora) · [Full-body concept for Krita (.ora)](krita-current/witch-hunter-concept.ora)

[Download complete current artwork pack (.zip)](krita-current.zip) · [Browse current individual PNGs and instructions](krita-current/README.md)

The pack contains the actual current animation frames, including the latest opening arm/hammer corrections and complete dropped cleaver. Use it instead of older atlases that retain unused historical cells.

[Painted Witch Hunter concept](concept.png) · [Approved clean baseline](clean-concept.png)

The approved visual direction is named **Witch Hunter**, a hooded two-handed hammer fighter intended to replace the Penitent Crusader. The approved five-skill rework and default two-handed hammer combat poses are now integrated; this folder retains the design and review captures.

The user supplied a front-view image of [Bestiarum's Witch Hunter Bastion](https://bestiarumgames.com/products/witch-hunter-bastion-stl-penitent-hero) as the reference. The design carries over the hood, sealed devotional faceplate, broad armor, armored boots and long-shaft two-handed hammer. The cape is removed. Devotional relief figures and plaques remain only on the shoulder armor, with the upper shoulder/chest chains preserved. All lower hanging figures and their chains, medallions, seals and attachments have been removed, exposing clean reconstructed armor and cloth. The hood remains cloth.

The concept uses the game's painted, ink-outlined dark fantasy style, a heavy melee build, a right-facing three-quarter stance and feet planted on a level baseline. The two-handed grip remains readable and clear. No miniature base or raised stepping rock is used.

The concept remains the visual baseline. Production combat poses are in `assets/art_library/party_builds/crusader.png`; internal `crusader` and `pc_*` identifiers remain stable for saves.

The concept was generated from the supplied reference image. Visual review checked the two-handed grip, complete hammer and boots, retained hood/mask, absent cape and shoulder devotional reliefs. The PNG is 1024×1536 RGBA with transparency. No production tests were needed for this isolated concept image.

The hammer face bears an original engraved banishment seal: concentric ward rings, an interlocking angular central glyph, smaller binding marks and an outer ring of abstract runes. Bones and the earlier borrowed sigil have been removed. The engraving follows the metal face perspective. The hammer shaft and collars follow one straight centerline into its centered head socket. The shoulder devotional details, sealed mask, hood and two-handed grip retain the approved design.

Armor cleanup: the gauntlets and paired knees/shins/boots share matching construction with perspective; boot fastenings use matching leather straps and buckles. The lower ornaments and associated hanging hardware are removed. The approved pose, proportions, straight hammer, both sigils and transparent background are retained. This remains one full-body experimental illustration.

Gauntlet refinement: decorative circular forearm bosses are removed from both arms. The paired gloves use a smooth forearm plate, one plain wrist cuff and a back-of-hand plate with articulated fingers; the extra stacked piece on the lower screen-left wrist is removed. Other armor fastenings remain unchanged.

Battle wear: restrained matte dark oxblood/brown-red traces mark the hammer striking edges, glove contact surfaces, knee edges and lower boots. Both sigils remain legible. The approved unstained illustration is preserved separately as `clean-concept.png`.


## Approved skill rework

| Skill | AP | Effect |
| --- | --- | --- |
| Judgment | 1 | 6 physical damage. |
| Abjuring Ward | 1 | Gain 6 Block; visible protective seal. |
| Binding Sigil | 1 | Apply Weakness: -3 damage on the target's next two attack actions. Nonattack actions preserve it. |
| Sunder | 2 | On hit, destroy up to 6 Block before dealing 10 physical damage. No movement, Bleed or health cost. |
| Banishment | 2 | 12 physical damage, +4 against Weakness from any ally; contact seal and fading embers. |

Damage and Block retain existing Forge upgrade support. Existing relic skills and explicitly selected alternate/equipment outfits retain their own behavior and art. The old default Bleed damage passive is replaced by Banishment's explicit Weakness condition.

Review captures: [idle](skills-idle.png), [Binding Sigil](skills-pc_pain.png), [Abjuring Ward](skills-pc_guard.png), [Banishment](skills-pc_verdict.png).

The approved experimental execution uses an uppercut, overhead crushing strike and limp collapse. It remains separate from lethal-hit gameplay integration.

[Experimental execution showcase](execution/README.md): the approved uppercut → overhead crushing blow → limp collapse sequence, with GIF, MP4 and key impact frames. This is a presentation study awaiting visual review before any gameplay integration.


[Judgment normal-attack study](judgment/README.md): compact two-handed chest strike, brief contact hold and quick recovery. Experimental preview; production timing awaits visual approval.
