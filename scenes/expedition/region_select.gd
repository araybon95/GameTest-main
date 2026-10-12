extends "res://scenes/ui/party_screen.gd"

const REGIONS = [
	{"name": "The Abandoned Village", "tiers": ["old_road", "village_chapel", "village_keep"]},
	{"name": "The Path", "tiers": ["path_beast", "path_lament", "path_ascension"]},
]
var region_index: int = 0
var tier_index: int = 0

func _ready() -> void:
	State.load_progression()
	refresh()
	preload("res://scripts/static_screen_art.gd").transition(self)

func choose(region: int, tier: int) -> void:
	region_index = region
	tier_index = tier
	refresh()

func choose_region(region: int) -> void:
	choose(region, 0)

func refresh() -> void:
	clear_screen()
	var quiet := ColorRect.new()
	quiet.color = Color("#100D11")
	quiet.mouse_filter = Control.MOUSE_FILTER_IGNORE
	quiet.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(quiet)
	var heading := label_at("EXPEDITIONS", Vector2(50, 28), 480, 34)
	heading.size.y = 52
	var map_rect := Rect2(500,0,1420,945)
	var art := picture("res://assets/art_library/presentation/expedition/estate_map.png", map_rect)
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.name = "RegionMap"
	art.modulate = Color(0.87,0.82,0.79)
	move_child(art,1)
	var mission_shade := ColorRect.new()
	mission_shade.name = "MissionShade"
	mission_shade.position = Vector2.ZERO
	mission_shade.size = Vector2(645,945)
	mission_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var gradient := Shader.new()
	gradient.code = "shader_type canvas_item; void fragment(){COLOR=vec4(0.025,0.018,0.025,1.0-smoothstep(0.73,1.0,UV.x));}"
	var wash := ShaderMaterial.new()
	wash.shader = gradient
	mission_shade.material = wash
	add_child(mission_shade)
	move_child(mission_shade,2)
	for r in range(REGIONS.size()):
		var region: Dictionary = REGIONS[r]
		# Select the village cluster or the descending pilgrimage pathway.
		var center: Vector2 = map_rect.position + Vector2(0.24 if r == 0 else 0.70, 0.34) * map_rect.size
		var footprint := Vector2(310, 180)
		var region_rect := Rect2(center - footprint * 0.5, footprint)
		var hotspot := button_at("", region_rect, choose_region.bind(r))
		hotspot.get_node("IronFittings").hide()
		hotspot.get_node("InkSurface").hide()
		hotspot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		hotspot.name = "Expedition_" + ("village" if r == 0 else "path")
		var marker := preload("res://scenes/ui/expedition_decoration.gd").new()
		marker.name = "LocationHalo"
		marker.size = footprint
		marker.region = r
		marker.selected = r == region_index
		marker.completed = State.completed_expeditions.has(str(region["tiers"][0]))
		hotspot.add_child(marker)
		hotspot.tooltip_text = "Choose " + str(region["name"]) + " to reveal its dungeons"
		for state in ["normal", "pressed", "focus"]:
			hotspot.add_theme_stylebox_override(state, StyleBoxEmpty.new())
		var hover := StyleBoxFlat.new()
		hover.bg_color = Color(0.7, 0.4, 0.25, 0.12)
		hotspot.add_theme_stylebox_override("hover", hover)
		var title := label_at(str(region["name"]), region_rect.position + Vector2((region_rect.size.x - 460) * 0.5, region_rect.size.y - 43), 460, 24)
		title.name = "ExpeditionTitle_%d" % r
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.add_theme_color_override("font_color", Color("#E0BB81") if r == region_index else Color("#EADDD0"))
		title.add_theme_color_override("font_outline_color", Color("#130D11"))
		title.add_theme_constant_override("outline_size", 4)
		title.add_theme_color_override("font_shadow_color", Color.BLACK)
		title.add_theme_constant_override("shadow_offset_x", 2)
		title.add_theme_constant_override("shadow_offset_y", 2)
		# Keep the full caption clickable as part of the same building hotspot.
		remove_child(title)
		hotspot.add_child(title)
		title.position -= region_rect.position
	for index in range(2):
		var center: Vector2 = map_rect.position + Vector2(0.25 if index == 0 else 0.76, 0.70) * map_rect.size
		var sealed := button_at("", Rect2(center - Vector2(100, 55), Vector2(200, 110)), show_future.bind(index))
		sealed.get_node("IronFittings").hide()
		sealed.get_node("InkSurface").hide()
		sealed.name = "FutureExpedition_%d" % index
		sealed.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		sealed.tooltip_text = "Sealed location · Future expedition"
		for state in ["normal", "pressed", "hover", "focus"]:
			sealed.add_theme_stylebox_override(state, StyleBoxEmpty.new())
		var caption := label_at("SEALED", center + Vector2(-100, 33), 200, 16)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.add_theme_color_override("font_color", Color("#B5A2A3"))
		caption.add_theme_color_override("font_outline_color", Color("#130D11"))
		caption.add_theme_constant_override("outline_size", 3)
	var selected_center: Vector2 = map_rect.position+Vector2(0.24 if region_index == 0 else 0.70,0.34)*map_rect.size
	for t in range(3):
		var id: String = REGIONS[region_index]["tiers"][t]
		var dungeon := State.expedition_by_id(id)
		var option := button_at("", Rect2(selected_center+Vector2(-146+t*104,110),Vector2(84,84)), choose.bind(region_index, t))
		option.name = "Dungeon_" + id
		preload("res://scripts/visual_overlays.gd").frame(option,"warden" if region_index == 0 else "occultist")
		option.get_node("IronFittings").painted_frame = null
		option.get_node("IronFittings").hide()
		option.get_node("InkSurface").hide()
		var seal := preload("res://scenes/ui/expedition_decoration.gd").new()
		seal.name = "DungeonSeal"
		seal.mode = "seal"
		seal.region = region_index
		seal.selected = t == tier_index
		seal.sealed = not dungeon.get("released",true)
		seal.completed = State.completed_expeditions.has(id)
		seal.position = Vector2.ZERO
		seal.size = Vector2(84,84)
		seal.emphatic = true
		option.add_child(seal)
		option.tooltip_text = str(dungeon["name"]) + " · Three floors in one run · " + tier_status(id)
		for state in ["normal","hover","pressed","focus"]: option.add_theme_stylebox_override(state,StyleBoxEmpty.new())
		option.set_deferred("size",Vector2(84,84))
	var selected_region: Dictionary = REGIONS[region_index]
	var selected_id: String = selected_region["tiers"][tier_index]
	var chosen := State.expedition_by_id(selected_id)
	var map_caption := label_at(str(chosen["name"]),selected_center+Vector2(-250,216),500,24)
	map_caption.name = "MapDungeonCaption"
	map_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	map_caption.add_theme_color_override("font_outline_color",Color.BLACK)
	map_caption.add_theme_constant_override("outline_size",4)
	label_at(str(selected_region["name"]).to_upper(), Vector2(55, 112), 440, 16).add_theme_color_override("font_color",Color("#A89A83"))
	var dossier := preload("res://scenes/ui/dungeon_dossier.gd").new()
	dossier.name = "DungeonDossier"
	dossier.position = Vector2(40,135)
	dossier.size = Vector2(465,640)
	dossier.estate_mode = true
	dossier.expedition = chosen
	dossier.region = region_index
	dossier.tier = tier_index
	dossier.status = tier_status(selected_id)
	add_child(dossier)
	var embark_button := button_at("EMBARK" if State.can_embark(selected_id) else "UNRELEASED", Rect2(60, 805, 440, 64), embark)
	embark_button.name = "EmbarkButton"
	embark_button.disabled = not State.can_embark(selected_id)
	build_manifest()

func build_manifest() -> void:
	var footer := panel(Rect2(0,945,1920,135),Color(0.045,0.035,0.045,0.95))
	footer.name = "PartyManifest"
	footer.get_node("IronFittings").hide()
	footer.get_node("InkSurface").hide()
	label_at("PARTY",Vector2(520,953),75,16).add_theme_color_override("font_color",Color("#BCAF98"))
	label_at("%d GOLD" % State.gold,Vector2(55,967),335,27)
	label_at("%d inventory stacks" % State.inventory.size(),Vector2(55,1014),335,17).add_theme_color_override("font_color",Color("#A99C8B"))
	for i in range(State.party.size()):
		var id: String = State.party[i]
		var hero := State.hero(id)
		var pos := Vector2(600+i*270,953)
		var card := button_at("",Rect2(pos,Vector2(250,110)),inspect_hero.bind(id))
		card.name = "PartyHero_"+id
		card.get_node("IronFittings").hide()
		card.get_node("InkSurface").hide()
		var backing := StyleBoxFlat.new()
		backing.bg_color = Color("#191518")
		backing.border_color = Color("#4C4140")
		backing.set_border_width_all(1)
		card.add_theme_stylebox_override("normal",backing)
		var portrait := picture(str(hero["art"]),Rect2(pos+Vector2(8,9),Vector2(60,90)))
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		preload("res://scripts/dungeon_scenery.gd").apply_hero_palette(portrait,id,str(State.hero_colors.get(id,"original")))
		var hero_name := label_at(str(hero["name"]),pos+Vector2(80,12),155,18)
		hero_name.size.y = 44
		hero_name.clip_text = true
		var class_caption := label_at("Lv %d · %s" % [State.leveling(id)["level"],State.HEROES[id]["name"]],pos+Vector2(80,64),155,14)
		class_caption.size.y = 38
		class_caption.add_theme_color_override("font_color",Color("#ADA08B"))
		card.tooltip_text = "Inspect "+str(hero["name"])
	button_at("RETURN TO HAMLET",Rect2(1510,975,355,60),return_to_hamlet)

func inspect_hero(id: String) -> void:
	var controls := get_node_or_null("/root/GameControls")
	if controls != null: controls.open_hero_sheet(id)

func show_future(_index: int) -> void:
	if has_node("FutureNotice"):
		var previous := get_node("FutureNotice")
		remove_child(previous)
		previous.queue_free()
	var notice := label_at("Sealed location · More journeys await a future release.", Vector2(610, 880), 1240, 17)
	notice.name = "FutureNotice"

func tier_status(id: String) -> String:
	var expedition := State.expedition_by_id(id)
	if State.completed_expeditions.has(id):
		return "Completed · Replay"
	if expedition.has("requires") and not State.completed_expeditions.has(str(expedition["requires"])):
		return "Locked · Unreleased"
	return "Available" if expedition.get("released", true) else "Unlocked · Unreleased"

func embark() -> void:
	var id: String = REGIONS[region_index]["tiers"][tier_index]
	if State.select_expedition(id):
		get_tree().change_scene_to_file("res://scenes/expedition/preparation.tscn")

func return_to_hamlet() -> void:
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		return_to_hamlet()

