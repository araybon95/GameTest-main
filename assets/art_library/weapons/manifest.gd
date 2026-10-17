extends RefCounted
## Enabled only after complete catalog/outfit/context coverage and native review.
const ENABLED = {"warden":true,"ranger":true,"crusader":true,"occultist":true}
const STARTERS = {"warden":"warden_sword","ranger":"ranger_bow","crusader":"crusader_axe","occultist":"occultist_staff"}
const POSES = ["idle","windup","attack","guard","cast","hurt","death","walk_0","walk_1","walk_2","walk_3","camp","portrait"]
static var frames: Dictionary = preload("res://assets/art_library/weapons/warden/frames.gd").RECORDS.duplicate(true)
static func _static_init() -> void:
 frames.merge(preload("res://assets/art_library/weapons/ranger/frames.gd").RECORDS,true)
 frames.merge(preload("res://assets/art_library/weapons/crusader/frames.gd").RECORDS,true)
 frames.merge(preload("res://assets/art_library/weapons/occultist/frames.gd").RECORDS,true)
