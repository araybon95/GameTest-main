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
	set_meta("surface_material","devotional" if region_index == 1 else "parchment")
	var backdrop := picture("res://assets/generated/expedition_map_four_regions.png",Rect2(0,0,1920,1080),0.28)
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel(Rect2(0, 0, 1920, 1080), Color(0.035,0.025,0.035,0.65))
	panel(Rect2(30, 30, 490, 765))
	var heading := label_at("EXPEDITIONS", Vector2(595, 32), 1230, 36)
	heading.size.y = 52
	preload("res://scripts/visual_overlays.gd").banner(heading)
	panel(Rect2(542,92,1356,466),Color("#0E0B0D"))
	var map_rect := Rect2(550, 100, 1340, 450)
	var art := picture("res://assets/generated/expedition_map_four_regions.png", map_rect)
	art.stretch_mode = TextureRect.STRETCH_SCALE
	preload("res://scripts/visual_overlays.gd").stage_edges(self,map_rect)
	for r in range(REGIONS.size()):
		var region: Dictionary = REGIONS[r]
		# Select the village cluster or the descending pilgrimage pathway.
		var center: Vector2 = map_rect.position + Vector2(0.24 if r == 0 else 0.70, 0.34) * map_rect.size
		var footprint := Vector2(310, 180)
		var region_rect := Rect2(center - footprint * 0.5, footprint)
		var hotspot := button_at("", region_rect, choose_region.bind(r))
		hotspot.get_node("IronFittings").hide()
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
		for state in ["normal", "pressed"]:
			hotspot.add_theme_stylebox_override(state, StyleBoxEmpty.new())
		var hover := StyleBoxFlat.new()
		hover.bg_color = Color(0.7, 0.4, 0.25, 0.12)
		hotspot.add_theme_stylebox_override("hover", hover)
		var title := label_at(str(region["name"]).to_upper(), region_rect.position + Vector2((region_rect.size.x - 460) * 0.5, region_rect.size.y - 55), 460, 29)
		title.name = "ExpeditionTitle_%d" % r
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.add_theme_color_override("font_color", Color("#E0BB81") if r == region_index else Color("#EADDD0"))
		title.add_theme_color_override("font_outline_color", Color("#130D11"))
		title.add_theme_constant_override("outline_size", 7)
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
		sealed.name = "FutureExpedition_%d" % index
		sealed.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		sealed.tooltip_text = "Sealed location · Future expedition"
		for state in ["normal", "pressed"]:
			sealed.add_theme_stylebox_override(state, StyleBoxEmpty.new())
		var caption := label_at("SEALED · FUTURE EXPEDITION", center + Vector2(-170, 52), 340, 20)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.add_theme_color_override("font_color", Color("#B5A2A3"))
		caption.add_theme_color_override("font_outline_color", Color("#130D11"))
		caption.add_theme_constant_override("outline_size", 6)
	panel(Rect2(570, 555, 1300, 215), Color(0.07, 0.05, 0.07, 0.94))
	label_at("DUNGEONS · " + str(REGIONS[region_index]["name"]).to_upper(), Vector2(595, 570), 1250, 23)
	for t in range(3):
		var id: String = REGIONS[region_index]["tiers"][t]
		var dungeon := State.expedition_by_id(id)
		var option := button_at("", Rect2(595 + t * 420, 615, 400, 135), choose.bind(region_index, t))
		option.name = "Dungeon_" + id
		preload("res://scripts/visual_overlays.gd").frame(option,"warden" if region_index == 0 else "occultist")
		var seal := preload("res://scenes/ui/expedition_decoration.gd").new()
		seal.name = "DungeonSeal"
		seal.mode = "seal"
		seal.region = region_index
		seal.selected = t == tier_index
		seal.sealed = not dungeon.get("released",true)
		seal.completed = State.completed_expeditions.has(id)
		seal.position = Vector2(14,23)
		seal.size = Vector2(90,90)
		option.add_child(seal)
		option.tooltip_text = str(dungeon["name"]) + " · Three floors in one run · " + tier_status(id)
		var name_label := label_at("%s · %s" % [["I","II","III"][t], dungeon["name"]], option.position + Vector2(112, 16), 270, 22)
		name_label.size.y = 62
		name_label.clip_text = true
		label_at("3 floors · One continuous run\n" + tier_status(id), option.position + Vector2(112, 82), 270, 17)
		if t == tier_index:
			var selected := StyleBoxFlat.new()
			selected.bg_color = Color("#392329")
			selected.border_color = Color("#E0BB81")
			selected.set_border_width_all(3)
			option.add_theme_stylebox_override("normal", selected)
	var selected_region: Dictionary = REGIONS[region_index]
	var selected_id: String = selected_region["tiers"][tier_index]
	var chosen := State.expedition_by_id(selected_id)
	label_at(str(selected_region["name"]).to_upper(), Vector2(55, 55), 440, 30)
	var dossier := preload("res://scenes/ui/dungeon_dossier.gd").new()
	dossier.name = "DungeonDossier"
	dossier.position = Vector2(40,95)
	dossier.size = Vector2(465,635)
	dossier.expedition = chosen
	dossier.region = region_index
	dossier.tier = tier_index
	dossier.status = tier_status(selected_id)
	add_child(dossier)
	var embark_button := button_at("EMBARK" if State.can_embark(selected_id) else "UNRELEASED", Rect2(55, 733, 440, 50), embark)
	embark_button.name = "EmbarkButton"
	embark_button.disabled = not State.can_embark(selected_id)
	party_bar(return_to_hamlet, "RETURN TO HAMLET")

func show_future(_index: int) -> void:
	if has_node("FutureNotice"):
		var previous := get_node("FutureNotice")
		remove_child(previous)
		previous.queue_free()
	var notice := label_at("This expedition is sealed. More journeys will arrive in a future release.", Vector2(595, 70), 1250, 20)
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

