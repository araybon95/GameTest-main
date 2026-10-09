# Keep floors and themed entrances

The Old Road remains one three-floor dungeon. Floor one retains the bandit road. Floor two introduces Revenant Footmen and Grave Crossbowmen, with the Last Honorable Son guarding the descent. Floor three adds Wolfguard Reavers and ends with the Undying Lord. Deeper floors use a ruined, bloodied keep backdrop for combat, camps and events. The Penitent Crusader rescue remains on floor two.

Both keep bosses have a single support combatant at 30% of normal dungeon health and strength. Each new enemy has three attacks, including bleed, poison, chill or stress effects where appropriate. Rewards retain existing class legendary rules.

After defeating every combatant in a non-final floor boss encounter, a modal presents the next floor's themed entrance. Descend moves the saved party to the next floor; Stay on this floor returns to the map and leaves the cleared exit available. Final bosses use normal dungeon completion. The Coterie must finish all three phases before offering the passage. Stairs also use this modal.

Entrance names: The Broken Portcullis, The Lord's Stair, The Sutured Gate, The Throat of the Sanctuary.

## Art references

- https://bestiarumgames.com/collections/calden-keep
- https://bestiarumgames.com/cdn/shop/files/01_Aethelric_the_Undying_Lord_of_Calden_Front_Scale.jpg?v=1748466967&width=1080
- Knight of the Gravid Moon / The Last Honorable Son, Revenant Footmen, Revenant Crossbowmen and Calden Wolfsguard from the collection.

Generated bitmap assets use the built-in ImageGen tool; source reference photographs are not bundled. Individual enemies can be replaced via their data art paths. Footman, crossbowman and wolfguard use separate AtlasTexture resources over the three-character sheet.

## Saved assets

- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_undying_lord.png
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_keep_son.png
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_keep_troops.png
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_keep_footman.tres
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_keep_crossbow.tres
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/enemy_keep_wolfguard.tres
- C:/GAME/Ashen/latest/GameTest-main/assets/generated/keep_hall.png

## Generation prompts

### keep_lord_prompt

Use case: stylized-concept. Asset: one isolated full-body FINAL BOSS sprite for Ashen grimdark adult RPG. Use reference image 1 VERY closely for silhouette/anatomy: towering crouched monstrous undying feudal lord, gigantic skull-like wolf/lion head and yawning toothed jaw under a mound of ragged wolf pelts, crown-like cluster of broken sword hilts and metal ancestral reliquary rising behind skull, multiple long sinewy arms, one arm raised with an open hand, two long lower arms grip a heavy huge greatsword angled diagonally across lower front and long ornate spiked ceremonial mace pointing outward. Gaunt rotten muscular chest, ragged black cloth and dark silver ancient armor. NO tabletop base, NO scale mannequin, NO scenery. Match reference image 2 game style: heavy dark contours and detailed weathered painterly textures, readable silvery edge highlights, muted midnight blue cloth, pallid grey flesh, tiny cold blue spectral light in eyes, oppressive aristocratic horror. Whole figure visible crown to feet and weapons entirely in frame with generous margins, portrait or square framing, front three-quarter stance facing left. Transparent alpha background, no background shadows or glow backdrop, no text logos or watermarks. Original game illustration guided closely by supplied reference.

### keep_son_prompt

Use case: stylized-concept. Asset: isolated complete full-body boss sprite for Ashen grimdark adult RPG. Reference 1 strongly guides the Last Honorable Son: a hulking wolf-headed cursed knight throwing head upward in a tortured howl, very long shaggy dark wolf mane, huge broken greatsword resting horizontally across shoulders held in right hand, battered silver plate and chainmail on his powerful body, ragged midnight-blue cape, clawed armored feet, left arm lowered. His exposed side is torn and shows bloody sinew beneath fractured armor. Preserve reference silhouette and armor scale closely, but make original painterly game illustration matching reference 2's detailed metal and dark ink contours, bright cold highlights, muted blue and red. Front three-quarter facing left. One figure only. No ground, no miniature plinth, no scale mannequin, no environment, no text no logo. All sword tips and feet visible with margin, transparent alpha background. Readable heavy knight silhouette.

### keep_troops_prompt

Use case: stylized-concept. Asset: transparent horizontal sprite strip containing exactly THREE different full-body enemies evenly spaced, each wholly confined to its own third with transparent gaps, no overlap. Ashen grimdark adult RPG. Left: armored revenant footman guided by ref1, fleshless gaunt face inside kettle helmet, dark tarnished breastplate, exposed wounded sinewy arms, small round shield, cleaver axe. Center: revenant crossbowman guided by ref2, tall pointed helmet with wrapped face, ragged sleeves, chainmail skirt, stretched sinewy thin legs, loaded crossbow leveled slightly left and quiver on back. Right: powerful wolfguard knight guided by ref3, elongated perforated wolf-beak visor, shaggy grey mane and ripped blue cloth cloak, ornate battered silver plates, great two-handed poleaxe held diagonally. These are powerful terrifying elite raiders, decayed flesh, bloody rents in armor and exposed tendons permitted. Match ref4 grimdark illustrated painterly art with heavy dark outlines, readable detailed silver highlights, muted midnight blue cloth and rust, subtle cold spectral eyes. Facing slightly left ready for combat. Feet and weapons fully visible with generous margins. No miniature bases, no backdrop shadows or scenery, no lettering, no logos. Genuine transparent alpha background.

### keep_troops_clean_prompt

Edit this sprite strip only to separate its three figures into exactly three equal-width cells. Preserve their designs, detail and grimdark appearance exactly. Shift and slightly scale each entire figure INCLUDING all weapon tips, shields and cloaks so every pixel belonging to the footman is in the left third, every pixel of crossbowman and his whole crossbow is in center third, every pixel of wolfguard and entire poleaxe is in right third, each with at least 40px transparent margin from its cell boundaries. No overlap, no neighboring weapon fragments in another cell. Three complete isolated characters full body, transparent alpha, no text no base.

### keep_background_prompt

Use case: stylized-concept. Asset: widescreen 16:9 grimdark RPG combat environment, no characters. A ruined medieval noble keep's vaulted entrance hall opening into a vast subterranean throne room, cold slate stone arches, wolf insignia on torn midnight blue banners, shattered silver heraldic shields, pale candle clusters and one warm iron brazier in lower middle, iron portcullis far left, crumbled stone dais far right. Visible horror traces: dragged bloody trails on worn stone flags, mutilated remains and exposed viscera near outer edges, bones hung as trophies around damaged pillars. Dark ink contours with rich painterly stone textures matching Ashen RPG existing background reference. Keep the central floor wide and clear for hero cards; readable cold blue/silver atmospheric highlights, deep shadow recesses, crimson gore accents, bleak aristocratic decay, haunting abandoned keep. Full background edge-to-edge, landscape, no UI, no text, no logos, no figures.

## Validation

Keep generation and progression checked across 200 seeds. Floor entrance tests cover waiting for support, saving party state, avoiding duplicate rewards, staying, descending, all Coterie phases and excluding final bosses. Visual preview: C:/GAME/Ashen/keep-entrance-preview.png.
