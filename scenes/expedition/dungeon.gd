extends Control

const GameState = preload("res://scripts/game_data.gd")
var message: String = "Choose an adjacent room. Find the stairs and descend to the final boss."

func _ready() -> void:
	if not GameState.run_active:
		get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
		return
	refresh()

func label_at(text: String, pos: Vector2, font_size: int = 24) -> void:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("#EADDD0"))
	add_child(label)

func button_at(text: String, pos: Vector2, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.position = pos
	button.size = Vector2(230, 100)
	button.add_theme_font_size_override("font_size", 22)
	var box := StyleBoxFlat.new()
	box.bg_color = Color("#1B1218")
	box.border_color = Color("#8F4546")
	box.set_border_width_all(2)
	box.set_corner_radius_all(8)
	button.add_theme_stylebox_override("normal", box)
	button.pressed.connect(action)
	add_child(button)
	return button

func refresh() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var background := TextureRect.new()
	background.texture = load("res://assets/generated/bg_crypt.png")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.modulate = Color(0.3, 0.3, 0.3)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	label_at("%s  ·  FLOOR %d / %d" % [GameState.selected_expedition.get("name", "Expedition"), GameState.floor_index + 1, GameState.floor_count], Vector2(80, 55), 36)
	label_at("EMBERS %d    ·    Expedition seed %d" % [GameState.embers, GameState.run_seed], Vector2(80, 110), 20)
	label_at(message if not GameState.run_complete else "VICTORY — the dungeon's guardian has fallen. Return to the Hamlet.", Vector2(80, 180))
	var rooms: Dictionary = GameState.floors[GameState.floor_index]
	# Connections are drawn below room controls.
	for location in rooms:
		if not rooms[location]["seen"]:
			continue
		for direction in [Vector2i.RIGHT, Vector2i.DOWN]:
			var other: Vector2i = location + direction
			if rooms.has(other) and rooms[other]["seen"]:
				var line := Line2D.new()
				line.default_color = Color("#8F4546")
				line.width = 4
				line.add_point(Vector2(245 + location.x * 285, 320 + location.y * 145))
				line.add_point(Vector2(245 + other.x * 285, 320 + other.y * 145))
				add_child(line)
	for location in rooms:
		var room: Dictionary = rooms[location]
		if not room["seen"]:
			continue
		var current: bool = location == GameState.room_position
		var text: String = "PARTY\n" + str(room["kind"]).to_upper() if current else ("CLEARED" if room["cleared"] else str(room["kind"]).to_upper())
		var button := button_at(text, Vector2(130 + location.x * 285, 270 + location.y * 145), move_to.bind(location))
		button.disabled = current or GameState.run_complete or abs(location.x - GameState.room_position.x) + abs(location.y - GameState.room_position.y) != 1
	if GameState.current_room_kind() == "stairs":
		button_at("DESCEND", Vector2(130, 880), descend)
	button_at("RETURN TO HAMLET" if GameState.run_complete else "RETREAT TO HAMLET", Vector2(1400, 880), retreat)
	var summary: String = "PARTY: "
	for hero_id in GameState.party:
		var state: Dictionary = GameState.run_heroes.get(hero_id, {})
		summary += "%s %d HP / %d Stress%s    " % [GameState.hero(hero_id)["name"], int(state.get("hp", GameState.hero(hero_id)["max_hp"])), int(state.get("stress", 0)), " (slain)" if state.get("dead", false) else ""]
	label_at(summary, Vector2(80, 1010), 20)

func move_to(destination: Vector2i) -> void:
	if not GameState.vote_move("local", destination):
		return
	var room: Dictionary = GameState.floors[GameState.floor_index][destination]
	if not room["cleared"]:
		match str(room["kind"]):
			"battle", "boss":
				get_tree().change_scene_to_file("res://scenes/combat/combatscene.tscn")
				return
			"treasure":
				GameState.embers += 3
				message = "Recovered 3 Embers from the ruins."
			"camp":
				for hero_id in GameState.run_heroes:
					var state: Dictionary = GameState.run_heroes[hero_id]
					if not state["dead"]:
						state["hp"] = mini(int(state["max_hp"]), int(state["hp"]) + 8)
						state["stress"] = maxi(0, int(state["stress"]) - 12)
						state["deaths_door"] = false
				message = "A sheltered camp: standing heroes recover 8 HP and ease 12 Stress."
			"stairs":
				message = "Stairs lead deeper. Explore further or descend."
		room["cleared"] = true
	refresh()

func descend() -> void:
	if GameState.descend():
		message = "The darkness deepens. Find the next passage."
		refresh()

func retreat() -> void:
	GameState.end_run()
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
