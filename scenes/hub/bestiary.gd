extends Control
## The Archive — a bestiary of every creature. Entries stay hidden until the
## party has faced them in an expedition (GameState.discovered).

const GameState := preload("res://scripts/game_data.gd")

const HUB_SCENE = "res://scenes/hub/settlement.tscn"

const IVORY = "#EADDD0"
const GOLD = "#8F4546"
const MUTED = "#B5A2A3"
const LOCKED = "#4B343D"


func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)
	_build_entries()
	modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()


func _build_entries() -> void:
	var container: HBoxContainer = $Entries
	for child in container.get_children():
		child.queue_free()
	var found: int = 0
	for creature_id in GameState.CREATURES.keys():
		var discovered: bool = GameState.is_discovered(str(creature_id))
		if discovered:
			found += 1
		container.add_child(_make_entry(str(creature_id), discovered))
	$CountLabel.text = "RECORDED:  %d / %d" % [found, GameState.CREATURES.size()]


func _make_entry(creature_id: String, discovered: bool) -> PanelContainer:
	var creature: Dictionary = GameState.creature(creature_id)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(340.0, 540.0)
	panel.add_theme_stylebox_override("panel", _style(Color("#1B1218"), Color(GOLD) if discovered else Color(LOCKED)))

	var contents := VBoxContainer.new()
	contents.add_theme_constant_override("separation", 10)
	panel.add_child(contents)

	# Portrait slot.
	var frame := PanelContainer.new()
	frame.custom_minimum_size = Vector2(0, 190)
	frame.add_theme_stylebox_override("panel", _style(Color("#25171D"), Color(GOLD) if discovered else Color(LOCKED)))
	contents.add_child(frame)
	var texture: Texture2D = _load_texture(str(creature.get("art", ""))) if discovered else null
	if texture != null:
		var picture := TextureRect.new()
		picture.texture = texture
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		picture.modulate = Color(0.8, 0.8, 0.84)
		frame.add_child(picture)
		picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	else:
		var unknown := _make_label("?", 72, Color(LOCKED), true)
		unknown.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		frame.add_child(unknown)
		unknown.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var name_text: String = str(creature.get("name", creature_id)) if discovered else "UNKNOWN"
	contents.add_child(_make_label(name_text, 26, Color(IVORY) if discovered else Color(LOCKED), true))

	var tags: Array = creature.get("tags", []) as Array
	var tag_text: String = ", ".join(tags) if discovered else "—"
	contents.add_child(_make_label(tag_text, 19, Color(GOLD) if discovered else Color(LOCKED), true))

	var stats_text: String = "HP %d     ATK %d" % [int(creature.get("hp", 0)), int(creature.get("attack", 0))] if discovered else "HP ???     ATK ???"
	contents.add_child(_make_label(stats_text, 18, Color(MUTED), true))

	var lore_text: String = str(creature.get("lore", "")) if discovered else "Not yet encountered. Face this creature on an expedition to record its entry."
	var lore: Label = _make_label(lore_text, 17, Color(MUTED) if discovered else Color(LOCKED), true)
	lore.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lore.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	lore.custom_minimum_size = Vector2(0, 220)
	lore.size_flags_vertical = Control.SIZE_EXPAND_FILL
	contents.add_child(lore)
	return panel


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(HUB_SCENE)


# -------------------- STYLE HELPERS --------------------

func _make_label(value: String, font_size: int, color: Color, centered: bool = false) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _style(fill: Color, outline: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = outline
	box.set_border_width_all(2)
	box.set_corner_radius_all(12)
	box.set_content_margin_all(12)
	return box


func _load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	return null