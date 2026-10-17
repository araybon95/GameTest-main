extends RefCounted
static var cache: Dictionary = {}
static func available(hero: String) -> bool:
	return preload("res://assets/art_library/equipment/regions.gd").REGIONS.has(hero) and ResourceLoader.exists("res://assets/art_library/equipment/hero_%s_relic.png" % hero)
static func frame(hero: String, index: int) -> Texture2D:
	var key: String = hero+":"+str(index)
	if cache.has(key): return cache[key]
	var texture := AtlasTexture.new()
	texture.atlas = load("res://assets/art_library/equipment/hero_%s_relic.png" % hero)
	texture.region = preload("res://assets/art_library/equipment/regions.gd").REGIONS[hero][index]
	if hero == "crusader" and index == 11:
		texture.atlas = load("res://assets/art_library/equipment/hero_crusader_attack_relic.png")
		texture.region = Rect2(1040,750,405,310)
	texture.filter_clip = true
	texture.set_meta("pose_id",hero)
	texture.set_meta("appearance_style","equipment")
	texture.set_meta("idle_pixel_height",preload("res://assets/art_library/equipment/regions.gd").REGIONS[hero][0].size.y)
	if index == 9: texture.set_meta("portrait_view",true)
	cache[key] = texture
	return texture
static func pose(texture: Texture2D, state: String) -> Texture2D:
	if texture != null and texture.has_meta("weapon_id"): return preload("res://scripts/weapon_visuals.gd").from_texture(texture,state)
	return frame(str(texture.get_meta("pose_id","")),{"idle":0,"attack":1,"hurt":2,"death":2,"guard":3,"cast":10,"windup":10}.get(state,0))
