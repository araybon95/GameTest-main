extends RefCounted
## Measured source regions copied from the live library; sources stay unchanged.
const REGIONS = {
	"warden":[Rect2(70,8,653,504),Rect2(874,9,503,502),Rect2(92,518,643,494),Rect2(847,516,550,493)],
	"ranger":[Rect2(230,10,501,492),Rect2(814,11,469,490),Rect2(227,511,503,486),Rect2(827,511,480,492)],
	"occultist":[Rect2(32,7,620,590),Rect2(763,7,524,590),Rect2(45,607,611,577),Rect2(761,608,543,576)],
	"healer":[Rect2(46,8,585,565),Rect2(762,3,500,569),Rect2(62,579,584,563),Rect2(777,580,463,565)],
	"crusader":[Rect2(165,3,565,498),Rect2(863,5,553,497),Rect2(131,509,643,493),Rect2(891,509,552,494)]
}
# Center of leg region, half-width, deformation start, leg-motion strength.
const LEGS = {
	"warden":Vector4(0.61,0.25,0.70,0.85), "ranger":Vector4(0.58,0.25,0.65,1.0),
	"occultist":Vector4(0.49,0.18,0.77,0.70), "healer":Vector4(0.51,0.23,0.79,0.65),
	"crusader":Vector4(0.52,0.25,0.68,0.85)
}
const PHASES = {"warden":0.0,"ranger":1.3,"occultist":2.6,"healer":3.9,"crusader":5.2}
