# Gothic presentation overhaul

Original scenery receives restrained ink-and-wash tonal bands, desaturation and an edge vignette. Interface frames use angular iron borders, warm parchment lettering, shadowed headings and serif titles. Item rarity borders and bright tooltips remain readable.

Combat stages the party on the left and up to three enemies on the right. The lower interface retains selected hero details, permanent ability descriptions, consumables and the log. Shared party turns, formations, encounter caps, loot and three-floor dungeon progression are unchanged.

Each attack receives a short cinematic cutout duel with anticipation, strike, impact and recovery. Melee uses a lunge and slash; arrows travel between combatants; spells use rings and rays; fully mitigated damage produces a shield. Healing and guard skills receive their own effects. Damage, misses, blocks and healing have floating feedback. Inputs beneath the duel are blocked until it finishes. Effects queue and never resolve gameplay damage themselves.

The current animation pass moves existing illustrated cutouts; these are not separately drawn articulated attack poses. Dedicated class and creature pose assets can replace the cutouts later. No Darkest Dungeon artwork or animations were imported.

Validation: `tests/presentation_smoke.gd`, the existing combat/system smoke suite, and graphical combat/strike previews.
