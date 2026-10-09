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

func choose(region: int, tier: int) -> void:
	region_index = region
	tier_index = tier
	refresh()

func choose_region(region: int) -> void:
	choose(region, 0)

func refresh() -> void:
	clear_screen()
	panel(Rect2(0, 0, 1920, 1080), Color("#0F0B10"))
	panel(Rect2(30, 30, 490, 765))
	label_at("EXPEDITIONS", Vector2(560, 30), 1200, 36)
	var map_rect := Rect2(550, 100, 1340, 450)
	var art := picture("res://assets/generated/expedition_map_four_regions.png", map_rect)
	art.stretch_mode = TextureRect.STRETCH_SCALE
	for r in range(REGIONS.size()):
		var region: Dictionary = REGIONS[r]
		# Select the village cluster or the descending pilgrimage pathway.
		var center: Vector2 = map_rect.position + Vector2(0.24 if r == 0 else 0.70, 0.34) * map_rect.size
		var footprint := Vector2(310, 180)
		var region_rect := Rect2(center - footprint * 0.5, footprint)
		var hotspot := button_at("", region_rect, choose_region.bind(r))
		hotspot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		hotspot.name = "Expedition_" + ("village" if r == 0 else "path")
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
		option.tooltip_text = str(dungeon["name"]) + " · Three floors in one run · " + tier_status(id)
		var name_label := label_at("Tier %d · %s" % [t + 1, dungeon["name"]], option.position + Vector2(15, 12), 370, 22)
		name_label.size.y = 62
		name_label.clip_text = true
		label_at("3 floors · One continuous run\n" + tier_status(id), option.position + Vector2(15, 76), 370, 18)
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
	label_at(str(chosen["name"]), Vector2(55, 120), 435, 33)
	label_at("TIER %s · %s" % [["I", "II", "III"][tier_index], tier_status(selected_id)], Vector2(55, 210), 435, 20)
	var blurb := label_at(str(chosen["blurb"]), Vector2(55, 260), 435, 23)
	blurb.size = Vector2(435, 110)
	blurb.clip_text = true
	var details: String = "3 floors · Bandit raiders and scouts\nFinal guardian: Gallows Chieftain\nBosses award legendary party gear."
	if selected_id == "path_beast":
		details = "3 floors · Creations of Anguish\nFloor 1 — Harrowed Slave Giant\nFloor 2 — The Coterie: three consecutive forms\nFloor 3 — The Howling Head\nEach guardian awards legendary party gear."
	elif not chosen.get("released", true):
		details = "Future expedition. Defeat the previous tier to unlock eligibility; this dungeon remains unavailable until released."
	label_at(details, Vector2(55, 375), 435, 20)
	label_at("ONE DUNGEON · THREE FLOORS", Vector2(55, 580), 435, 23)
	label_at("Descend through every floor in one run. Dungeon tiers unlock the next dungeon in this expedition.", Vector2(55, 625), 435, 20).size = Vector2(435, 80)
	var embark_button := button_at("EMBARK" if State.can_embark(selected_id) else "UNRELEASED", Rect2(55, 720, 440, 55), embark)
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
		State.start_run()
		get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn")

func return_to_hamlet() -> void:
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		return_to_hamlet()

