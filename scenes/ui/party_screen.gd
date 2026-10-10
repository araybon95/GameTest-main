extends Control
const State = preload("res://scripts/game_data.gd")

func clear_screen() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	theme = load("res://assets/new_theme.tres")

func picture(path: String, rect: Rect2, alpha: float = 1.0) -> TextureRect:
	var image := TextureRect.new()
	image.texture = load(path)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.position = rect.position
	image.size = rect.size
	image.modulate.a = alpha
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(image)
	return image

func panel(rect: Rect2, fill: Color = Color("#171116")) -> Panel:
	var result := Panel.new()
	result.position = rect.position
	result.size = rect.size
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = Color("#755246")
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	result.add_theme_stylebox_override("panel", style)
	add_child(result)
	return result

func label_at(value: String, pos: Vector2, width: float, font_size: int = 24) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", Color("#EADDD0"))
	label.add_theme_font_size_override("font_size", font_size)
	label.size = Vector2(width, 0)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	return label

func button_at(value: String, rect: Rect2, action: Callable) -> Button:
	var button := Button.new()
	button.text = value
	button.position = rect.position
	button.size = rect.size
	button.add_theme_font_size_override("font_size", 24)
	for state in ["normal", "hover", "pressed", "disabled"]:
		var style := StyleBoxFlat.new()
		style.bg_color = Color("#392329") if state == "hover" else Color("#20151B")
		style.border_color = Color("#AA7B53")
		style.set_border_width_all(2)
		style.set_corner_radius_all(6)
		button.add_theme_stylebox_override(state, style)
	button.pressed.connect(action)
	add_child(button)
	return button

func party_bar(return_action: Callable, return_text: String) -> void:
	panel(Rect2(20, 815, 1880, 245), Color("#21171D"))
	label_at("PARTY GOLD", Vector2(55, 855), 290, 23)
	label_at("%d" % State.gold, Vector2(55, 900), 290, 35)
	for index in range(State.party.size()):
		var hero_id: String = State.party[index]
		var pos := Vector2(500 + index * 270, 835)
		panel(Rect2(pos, Vector2(245, 215)))
		picture(str(State.hero(hero_id)["art"]), Rect2(pos + Vector2(5, 5), Vector2(235, 115)))
		var state: Dictionary = State.run_heroes.get(hero_id, {})
		label_at(str(State.hero(hero_id)["name"]).to_upper(), pos + Vector2(15, 123), 220, 17 if hero_id == "crusader" else 22)
		label_at("%d / %d HP\n%d Stress%s" % [int(state.get("hp", State.hero_max_hp(hero_id))), State.hero_max_hp(hero_id), int(state.get("stress", 0)), " · Slain" if state.get("dead", false) else ""], pos + Vector2(15, 154), 220, 17)
	button_at(return_text, Rect2(1450, 930, 400, 85), return_action)
	label_at("PARTY ITEMS  %d" % State.inventory.size(), Vector2(1450, 855), 400, 23)
