extends RefCounted
## Measured original sprite regions; no raster processing at runtime.
const WALK = {
 "warden":[Rect2(70,8,653,504),Rect2(874,9,503,502),Rect2(92,518,643,494),Rect2(847,516,550,493)],
 "ranger":[Rect2(230,10,501,492),Rect2(814,11,469,490),Rect2(227,511,503,486),Rect2(827,511,480,492)],
 "occultist":[Rect2(32,7,620,590),Rect2(763,7,524,590),Rect2(45,607,611,577),Rect2(761,608,543,576)],
 "healer":[Rect2(46,8,585,565),Rect2(762,3,500,569),Rect2(62,579,584,563),Rect2(777,580,463,565)],
 "crusader":[Rect2(165,3,565,498),Rect2(863,5,553,497),Rect2(131,509,643,493),Rect2(891,509,552,494)],
}

const COMBAT = {
 "ranger":[Rect2(61,65,401,419),Rect2(535,48,482,436),Rect2(1046,47,464,438),Rect2(51,570,439,385),Rect2(534,563,464,393),Rect2(1062,534,376,424)],
 "occultist":[Rect2(46,52,364,442),Rect2(496,87,626,401),Rect2(1149,78,356,412),Rect2(91,518,326,455),Rect2(560,524,440,451),Rect2(1100,537,353,438)],
 "healer":[Rect2(68,48,351,461),Rect2(500,99,597,409),Rect2(1091,17,402,491),Rect2(64,555,370,418),Rect2(531,547,497,426),Rect2(1143,546,294,427)],
 "scout":[Rect2(46,188,561,581),Rect2(606,73,682,700),Rect2(1293,216,548,558)],
 "captain":[Rect2(10,80,757,636),Rect2(786,8,659,705),Rect2(1467,131,701,585)],
}
const SHEETS = {
 "ranger": "res://assets/generated/hero_ranger_combat_sheet.png",
 "occultist": "res://assets/generated/hero_occultist_combat_sheet.png",
 "healer": "res://assets/generated/hero_healer_combat_sheet.png",
 "scout": "res://assets/generated/enemy_gallows_scout_combat_sheet.png",
 "captain": "res://assets/generated/enemy_ash_bandit_captain_combat_sheet.png"
}
