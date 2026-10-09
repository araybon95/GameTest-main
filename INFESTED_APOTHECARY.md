# The Infested Apothecary

A clickable medical dispensary sits in a separate rear terrace between the hamlet barracks and chapel. Before cleansing it opens a mission briefing. Completing its three encounters permanently renames it The Apothecary and opens its remedy shop. The shop uses a clean reclaimed interior; the dungeon keeps the infested version.

## Four-room run

1. The Infested Dispensary: three Moth Acolyte Metamorphs at 65% normal health and 70% normal attack, rounded to 27 HP and 4 attack each.
2. The Sealed Sickroom: one-use camp, full living-party health, all debuffs removed and 90% current stress reduction. Slain heroes remain slain.
3. Oleander's Ward: Moth Knight Oleander, 108 HP / 9 attack, alone.
4. The Queen's Theatre: Moth Queen Exuvia, 150 HP / 10 attack, alone.

Initiate difficulty targets the transition between Apprentice and Adept. This is initial tuning; player feedback should guide later adjustments. Every enemy has three attacks with themed bleed, poison, chill or stress effects. Existing class legendary boss drops remain. There are exactly four rooms, one floor, no random extra rooms or stairs. The first fight begins on entry; cleared rooms gate navigation. All three combat rooms must be cleared to save the unlock to expedition_progress.cfg, reusing existing campaign progression.

## Remedy shop

Healing Potion: 20 HP, 8 gold. Cleansing Potion: removes Burn/Bleed/Poison/Chill, 12 gold. Solace Potion: reduces stress by 15, 8 gold. Healing Scroll: restores 30 HP, 14 gold. Might Tonic: +20% skill damage, 14 gold. Focus Tonic: +15% accuracy capped at 100%, 12 gold. Warding Tonic: 4 Block now and at the next party turn, 12 gold.

Consumables stack by item ID/name and target the selected living hero. Combat use costs 1 AP. Healing Scroll also works through hero inventory outside combat. Buffs last two party turns, refresh rather than stack, survive encounter transitions until they expire, and are displayed separately from harmful statuses. New scroll and tonic purchases require the building unlock and are offered at the Apothecary; they can also occur in existing consumable loot rolls. No legendary shop stock.

## Artwork and references

Built-in ImageGen generated all raster art from the primary collection reference: https://bestiarumgames.com/collections/cult-of-the-moth

Strong visual guidance used for the Metamorphs' elongated proboscis and distorted bodies, Oleander's stooped sword-bearing form and wing crest, and Exuvia's many arms, eye-marked wings and swollen abdomen. Reference photos are not bundled in the game. Backgrounds and enemy sprites are individual replaceable files; the original hamlet vista remains intact.

Saved project assets:
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/hamlet_vista_apothecary.png
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/apothecary_interior.png
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/apothecary_reclaimed.png
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_moth_metamorph.png
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_moth_oleander.png
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_moth_exuvia.png

Item SVGs: C:/GAME/Ashen/latest/GameTest-main/assets/items/{healing_scroll,might_tonic,focus_tonic,ward_tonic}.svg. Icon attribution in assets/items/CREDITS.md.

## Final prompts

### moth_metamorph_prompt

Use case: stylized-concept. Transparent full-body 2D enemy sprite for grimdark medieval RPG, heavily guided by supplied Moth Acolyte Metamorphs anatomy reference. One humanoid moth acolyte: hunched emaciated skeletal limbs, tattered crimson-black pilgrim robes; bulging round insect eyes on a bald elongated bone skull, long thick pale proboscis dangling then curling, raw flayed flesh visible at rib seams. Two high ragged pale membrane wings erupt from its shoulders, hornlike chitin crown, multiple thin insect arms clutching a cracked wood staff. Strong resemblance to the front-right figure in the reference. Distressing body horror of human becoming moth, exposed muscle, split skin and damaged wings. Painted inked game illustration with thick black contours, pale bone highlights, desaturated red fabric, cold blue-white wings, teal dust. Whole figure fits in frame with generous empty margins. Front three-quarter view; clean isolated silhouette readable small. No base, no pedestal, no scenery, no text. Actual transparent background.

### moth_knight_prompt

Use case: stylized-concept. Asset: transparent full-body grimdark RPG enemy sprite. Strongly match the reference Moth Knight Oleander's distinctive anatomy and silhouette. Hunched emaciated knight transformed into a moth: huge swept-back ragged membrane wing crest rising above his shoulders, bug-eyed skull face with two curled cheek feelers and a very long dangling looped proboscis, withered many-jointed arms gripping a tall straight medieval broadsword planted diagonally in front, rotting ankle-length pilgrim cloth, bony insect carapace, raw sinew and distressed flesh bursting through cloth. Preserve reference's leaning stoop, sword, long loop proboscis and massive high wing crest. Painted game illustration, thick black ink contours and sharp readable pale bone highlights, dull blue chitin, desaturated crimson cloth, bloody torn membranes. Body horror anatomy, no text or background, no miniature stand or base. Whole figure fits with generous clear margin. Front three-quarter view, actual transparency. Readable at 300 pixels.

### moth_queen_prompt

Use case: stylized-concept. Asset: transparent full-body enemy sprite for grimdark medieval RPG. Use the supplied reference photograph as strong anatomy and silhouette guidance: Moth Queen Exuvia. Reinterpret as readable painted 2D game art with thick black ink outlines and chiaroscuro, muted bone ivory, blue slate chitin, sanguine raw flesh and pale teal luminous dust. A towering body horror moth queen: a slender sinewy humanoid upper torso, long streaming tendril hair around a screaming crownlike face, four thin ritual arms; immense torn ragged moth wings spreading symmetrically with large embossed eye nodes, pointed scalloped tips; torso fused into an enormous swollen armored insect abdomen, extruded muscle seams and branching fleshy tendrils under it. Intensely reference the photograph's distinctive wing contours, multiple arms and bloated abdomen. Horrific remade human anatomy, exposed sinew and viscera, no sexual framing. Full figure fully in view, wings and tendrils fit comfortably, centered, no miniature base, no floor, no background, no labels or text. Front three-quarter view. Silhouette legible at 300 pixels. Actual transparent background.

### apothecary_vista_prompt

Use case: precise-object-edit. Edit target is the supplied hamlet vista. Preserve exact existing grimdark ink illustration, framing, canvas aspect, cathedral chapel in upper middle, left barracks building, foreground gate, roads and right forge. Add one clearly distinct small medieval apothecary building at approximately x=350 to 480 and y=145 to 345 on this 1280x720 composition: BETWEEN the left barracks and the central chapel, set deeper in the town on an elevated rear lane. Replace the indistinct existing rooftops in that small gap with a readable narrow stone-and-timber medical dispensary with steep slate roof, crooked chimney, projecting stained-glass green lantern, herbs drying beneath an awning, a small medieval mortar-and-pestle hanging sign without writing, barred sickroom window and faint moth cocoons tangled round the gutter. Weathered decaying medieval medical atmosphere, subtle teal green window illumination readable against the amber town. Apothecary visually smaller than foreground buildings, deep perspective, its facade centered around x400,y235 and entire building within the gap without covering either the barracks or chapel. No new text, no UI, no changed buildings outside gap. Match heavy black linework and muted red dusk exactly. Output full revised vista.

### apothecary_rear_prompt

Use case: precise-object-edit. Edit target: supplied full hamlet vista. Preserve exact canvas aspect and all existing buildings, cathedral chapel, left barracks, right forge, gate and roads. The green-lit apothecary currently looks too close and large. Make ONLY that building smaller and distinctly farther away, in an isolated elevated rear quarter between the left barracks and cathedral. Reduce its width and height to roughly 55% of current size, roof and facade centered about normalized x=.31,y=.245, so it fits inside normalized x=.27 to .36,y=.15 to .34. Show a separate stone-walled terrace and narrow rear lane isolating it from the main hamlet; some intervening uninfected foreground roofs conceal its lower facade. Retain readable green medieval glass lantern, mortar-and-pestle sign and steep roof. Keep subtle moth silk ONLY on that distant building; other town buildings are uninfected. Match existing exact black ink linework and red dusk. No text or UI. Save full vista.

### apothecary_interior_prompt

Use case: stylized-concept. Asset: wide 16:9 environment backdrop for medieval grimdark medical apothecary combat, camp and shop in a horror RPG. An abandoned vaulted stone dispensary and surgical theatre: central empty stone floor with ample unobstructed space for game combat cards; raised medieval physician workbench toward far wall, wooden cabinets of glass herbal remedies, mortar and pestles, bandage rolls, leech jars, iron surgical instruments, stained linen, brazier and wax candles. Infested body horror setting: huge ragged moth cocoons woven into roof arches, shed human-like husks and bloody gauze along peripheral wall, sinewy growths behind iron grates, pale moth dust catching teal lamplight. Left side sealed sickroom nook with a small warm camp brazier sheltered behind hanging cloth. Right far wall a ruined stone altar lit by an unnatural moth lamp. No creatures or people; no modern medical technology, no writing, no interface. Thick dark ink outlines, hand-painted game concept illustration, readable ivory rimlights on implements, cold blue-green lamp light against warm amber refuge, muted sanguine details. Horrific but readable composition, architecture and medical nature unmistakable. Match existing grimdark game art.

### apothecary_reclaimed_prompt

Use case: precise-object-edit. Supplied image is the infested medieval apothecary dungeon. Create its CLEAN RECLAIMED SHOP version after the heroes cleanse it. Preserve same camera, wide aspect, stone vaulted architecture, alcove positioning, floor and central dispensary workbench. Remove EVERY infestation feature: all moths, cocoons, webs and silk, human husks, skeletal remains, flayed bodies, viscera, flesh growths, blood, dirty hanging rags, hanging chains used as traps, ominous moth altar figure. Replace with a working grimdark medieval medical apothecary: organized wooden medicine cabinets, plentiful clean glowing glass potion bottles, hanging dried herbs, rolled fresh pale linen bandages, wooden drawers, mortar and pestle, metal medical tools neatly laid out on clean linen, orderly sickroom bed left. Replace right moth altar with a normal remedy counter with herbs and glass medicine display. Clean swept dry stone floor, no gore. Warm amber candles and green glass lanterns, still moody and weathered medieval stone atmosphere matching thick ink outlines and painted RPG style. Visually reclaimed, safe, humane medieval medical shop, no creatures or people, no text or UI. No infestations anywhere.

## Validation

Test script: tests/apothecary_smoke.gd covers 100 four-room seeds, weakened acolytes, navigation ordering, camp, persistent unlock, restricted purchases, healing scroll/AP, buff refresh/expiry and clean shop routing. tests/apothecary_preview.gd renders settlement, briefing, encounters, camp, map and unlocked shop into C:/GAME/Ashen/apothecary-*-preview.png.
