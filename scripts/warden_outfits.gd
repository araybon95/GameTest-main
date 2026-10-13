extends RefCounted
## Complete painted costumes. Ownership lives in the existing completion record.
const STYLE = "warden_complete"
const GROUNDS = {
	"original": [379,381,381,383,344,344,346,348,339,343,339,342],
	"ashen_wolf": [380,380,384,384,349,345,348,350,336,337,338,338],
}
static var cache: Dictionary = {}
static func supported(outfit: String) -> bool: return GROUNDS.has(outfit)
static func unlocked(completed: Array) -> bool: return completed.has("old_road")
static func path(outfit: String, purpose: String = "idle") -> String:
	return "res://assets/art_library/warden_outfits/%s_%s.tres" % [outfit,purpose]
static func frame(outfit: String, index: int) -> Texture2D:
	if not supported(outfit): outfit = "original"
	index = clampi(index,0,11)
	var key: String = outfit+":"+str(index)
	if cache.has(key): return cache[key]
	var texture := AtlasTexture.new()
	texture.atlas = load("res://assets/art_library/warden_outfits/%s.png" % outfit)
	var top: float = [0,389,741][index/4]
	var height: float = GROUNDS[outfit][index]+1
	var width: float = 366 if index%4 != 3 else 362
	texture.region = Rect2((index%4)*362,top,width,height)
	texture.margin = Rect2((380-width)/2,400-height,380-width,400-height)
	texture.filter_clip = true
	texture.set_meta("pose_id","warden")
	texture.set_meta("appearance_style",STYLE)
	texture.set_meta("warden_outfit",outfit)
	texture.set_meta("idle_pixel_height",400)
	texture.set_meta("travel_unarmed",index >= 2)
	cache[key] = texture
	return texture
static func walks(outfit: String) -> Array[Texture2D]:
	var result: Array[Texture2D] = []
	for i in range(2,12): result.append(frame(outfit,i))
	return result
static func pose(original: Texture2D, state: String) -> Texture2D:
	var outfit: String = str(original.get_meta("warden_outfit","original"))
	var key: String = outfit+":pose:"+state
	if cache.has(key): return cache[key]
	var texture: Texture2D = frame(outfit,1 if state in ["attack","cast","windup"] else 0).duplicate()
	texture.set_meta("combat_state",state)
	cache[key] = texture
	return texture
