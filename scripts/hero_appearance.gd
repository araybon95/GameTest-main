extends RefCounted
## Alternate outfits share one atlas across combat, walking, camp and portraits.
const TITLES = {"warden":"Blacksteel Sentinel","ranger":"Winter Tracker","occultist":"Ashen Ritualist","healer":"Field Medic","crusader":"Chainbound Penitent"}
static var cache: Dictionary = {}
static func path(id: String, purpose: String = "idle") -> String:
 return "res://assets/appearance/hero_%s_%s.tres" % [id,purpose]
static func available(id: String) -> bool:
 return ResourceLoader.exists(path(id))
static func frame(id: String, index: int) -> Texture2D:
 var key: String = id+":"+str(index)
 if cache.has(key): return cache[key]
 var sheet: Texture2D = load("res://assets/appearance/hero_%s_outfit.png" % id)
 var region: Rect2 = preload("res://assets/appearance/regions.gd").REGIONS[id][index]
 var texture := AtlasTexture.new()
 texture.atlas = sheet
 texture.region = region
 texture.filter_clip = true
 texture.set_meta("pose_id",id)
 texture.set_meta("appearance_style","alternate")
 var idle: Texture2D = load(path(id))
 texture.set_meta("idle_pixel_height",idle.get_height())
 cache[key] = texture
 return texture
static func pose(original: Texture2D, state: String) -> Texture2D:
 var id: String = str(original.get_meta("pose_id",""))
 var index: int = {"idle":0,"attack":1,"hurt":2,"death":2,"guard":3,"cast":10,"windup":10}.get(state,0)
 if id == "warden" and state == "guard": index = 0
 if id == "ranger" and state in ["cast","windup"]: index = 1
 if id == "crusader" and state in ["cast","windup"]: index = 3
 return frame(id,index)
