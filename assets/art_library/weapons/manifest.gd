extends RefCounted
## Only enable a class after its complete art coverage and visual review.
const ENABLED = {"warden":true,"ranger":false,"crusader":false,"occultist":false}
const STARTERS = {"warden":"warden_sword","ranger":"ranger_bow","crusader":"crusader_axe","occultist":"occultist_staff"}
const POSES = ["idle","windup","attack","guard","cast","hurt","death","walk_0","walk_1","walk_2","walk_3","camp","portrait"]
static var frames: Dictionary = preload("res://experimental/weapon_swapping/warden/frames.gd").RECORDS.duplicate(true)
