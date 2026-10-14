extends RefCounted
## Complete painted costumes. Ownership lives in the existing completion record.
const STYLE = "warden_complete"
const GROUNDS = {
	"original": [379,381,381,383,344,344,346,348,339,343,339,342],
	"ashen_wolf": [380,380,384,384,349,345,348,350,336,337,338,338],
}
const HEAD_TOPS = {
	"original": [40,62,50,52,10,9,12,13,5,5,7,8],
	"ashen_wolf": [42,55,47,47,7,9,8,10,5,6,7,6],
}
## Helmet registration measured from the opaque upper-helm band in each pose.
## Keeps the complete illustration aligned without splitting equipment layers.
const WALK_ANCHORS = {
	"original": [217.0,227.53,219.63,224.98,218.75,232.38,218.83,213.36,222.01,228.16],
	"ashen_wolf": [214.95,238.44,218.58,227.88,217.86,240.48,218.08,212.85,213.51,235.53],
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
	if index >= 2: texture.set_meta("stride_anchor",(WALK_ANCHORS[outfit][index-2]+(380-width)/2)/380.0)
	texture.set_meta("stride_scale",float(GROUNDS[outfit][0]-HEAD_TOPS[outfit][0])/float(GROUNDS[outfit][index]-HEAD_TOPS[outfit][index]) if index >= 2 else 1.0)
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
