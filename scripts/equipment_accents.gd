extends TextureRect
## Silhouette-clipped cosmetics preserve the parent palette and injury shader.
var hero_id: String = ""
var preview_item: String = ""
var elapsed: float = 0.0
static func attach(target: TextureRect, hero: String, item: String = "") -> void:
	if target.has_node("EquipmentAccents"): return
	var node = load("res://scripts/equipment_accents.gd").new()
	node.name = "EquipmentAccents"
	node.hero_id = hero
	node.preview_item = item
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	var shader_material := ShaderMaterial.new()
	shader_material.shader = preload("res://assets/shaders/equipment_accents.gdshader")
	node.material = shader_material
	target.add_child(node)
	node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	node.sync()
static func profile(id: String) -> Dictionary:
	var state: Script = load("res://scripts/game_data.gd")
	var entry: Dictionary = state.Items.item(id)
	var record: Dictionary = state.Items.histories.get(id,{})
	var colour := Color("#AFD6E1")
	var pattern: int = 0
	if entry.has("unique_chill"): colour = Color("#7DE4FF"); pattern = 1
	elif entry.has("unique_poison") or entry.has("poison_chance"): colour = Color("#A1EA72"); pattern = 2
	elif entry.has("life_drain"): colour = Color("#DB5377"); pattern = 3
	elif entry.has("heal") or entry.has("regeneration"): colour = Color("#F4D98B"); pattern = 4
	if entry.get("boss_only",false):
		var base: String = state.Items.base_id(id)
		colour = Color("#DA6E8D") if base in ["giant_trophy","coterie_trophy","head_trophy"] else Color("#A6E3CA") if base in ["oleander_trophy","exuvia_trophy"] else Color("#E6C184")
		pattern = 5
	var mode: String = record.get("transformation", "")
	if not mode.is_empty():
		colour = {"restored":Color("#B5E3EF"),"consecrated":Color("#FFE099"),"corrupted":Color("#E85B80")}[mode]
		pattern = {"restored":0,"consecrated":4,"corrupted":3}[mode]
	return {"colour":colour,"pattern":pattern,"strength":0.35 if entry.get("rarity", "common") == "common" else 0.7,"etched":record.has("milestone") or not record.get("owners",[]).is_empty(),"armor":entry.get("slot","") in ["armor","off_hand"]}
func _process(delta: float) -> void:
	var settings := get_node_or_null("/root/GameSettings")
	if settings == null or settings.ambient_motion: elapsed += delta
	sync()
func sync() -> void:
	var parent: TextureRect = get_parent()
	texture = parent.texture
	stretch_mode = parent.stretch_mode
	flip_h = parent.flip_h
	flip_v = parent.flip_v
	var state: Script = load("res://scripts/game_data.gd")
	var chosen: String = preview_item
	if chosen.is_empty():
		var gear: Dictionary = state.equipment.get(hero_id,{})
		chosen = str(gear.get("weapon",gear.get("armor",gear.get("charm",""))))
		for item in gear.values():
			if state.Items.item(item).get("boss_only",false) or state.Items.histories.get(item,{}).has("transformation"): chosen = item
	visible = not chosen.is_empty() and texture != null and not state.run_heroes.get(hero_id,{}).get("dead",false)
	if not visible: return
	var style: Dictionary = profile(chosen)
	for key in ["pattern","strength","etched","armor"]: material.set_shader_parameter(key,style[key])
	material.set_shader_parameter("accent",style.colour)
	material.set_shader_parameter("clock",elapsed)
	var area := Rect2(0,0,1,1)
	if texture is AtlasTexture: area = Rect2(texture.region.position / texture.atlas.get_size(),texture.region.size / texture.atlas.get_size())
	material.set_shader_parameter("atlas_area",Vector4(area.position.x,area.position.y,area.size.x,area.size.y))
