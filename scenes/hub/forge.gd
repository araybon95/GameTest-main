extends Control
## The Forge — spend Gold earned on expeditions to upgrade the party's cards.
## Upgrades persist in GameState.card_levels and apply in combat via card_stats().

const GameState := preload("res://scripts/game_data.gd")

const HUB_SCENE = "res://scenes/hub/settlement.tscn"

const IVORY = "#EADDD0"
const GOLD = "#8F4546"
const MUTED = "#B5A2A3"

var _toast: Label
var _toast_tween: Tween


func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)
	_toast = $Toast
	_build()
	modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()


func _build() -> void:
	$GoldLabel.text = "GOLD  ·  %d" % GameState.gold
	var columns: HBoxContainer = $Scroll/Columns
	for child in columns.get_children():
		child.queue_free()
	for hero_id in GameState.party:
		columns.add_child(_make_hero_column(str(hero_id)))


func _make_hero_column(hero_id: String) -> Control:
	var hero: Dictionary = GameState.hero(hero_id)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(548.0, 0.0)
	panel.add_theme_stylebox_override("panel", _style(Color("#160F13"), Color(GOLD), 2))

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	panel.add_child(column)
	column.add_child(_make_label(str(hero.get("name", hero_id)).to_upper(), 26, Color(GOLD), true))

	var seen: Dictionary = {}
	for card_id in GameState.hero_abilities(hero_id):
		if seen.has(card_id):
			continue
		seen[card_id] = true
		column.add_child(_make_card_row(str(card_id)))
	return panel


func _make_card_row(card_id: String) -> Control:
	var stats: Dictionary = GameState.card_stats(card_id)
	var level: int = GameState.card_level(card_id)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0.0, 86.0)
	panel.add_theme_stylebox_override("panel", _style(Color("#1B1218"), Color("#4B343D"), 2))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	panel.add_child(row)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 2)
	row.add_child(info)

	var stars: String = "   ★%d" % level if level > 0 else ""
	var title: Label = _make_label("%s%s" % [str(stats.get("name", card_id)), stars], 20, Color(IVORY))
	info.add_child(title)
	var description: Label = _make_label(GameState.card_description(stats), 16, Color(MUTED))
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_child(description)

	var button := Button.new()
	button.custom_minimum_size = Vector2(176.0, 58.0)
	button.add_theme_font_size_override("font_size", 17)
	_style_button(button)
	if GameState.can_upgrade(card_id):
		var cost: int = GameState.upgrade_cost(card_id)
		button.text = "UPGRADE  %d" % cost
		button.disabled = GameState.gold < cost
		button.pressed.connect(_on_upgrade.bind(card_id))
	else:
		button.text = "MAXED"
		button.disabled = true
	row.add_child(button)
	return panel


func _on_upgrade(card_id: String) -> void:
	if GameState.upgrade_card(card_id):
		_build()
		_show_toast("%s tempered.  Gold: %d" % [str(GameState.CARDS[card_id]["name"]), GameState.gold])
	else:
		_show_toast("Not enough Gold for that upgrade.")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(HUB_SCENE)


func _show_toast(text: String) -> void:
	_toast.text = text
	_toast.modulate.a = 0.0
	if _toast_tween != null:
		_toast_tween.kill()
	_toast_tween = create_tween()
	_toast_tween.tween_property(_toast, "modulate:a", 1.0, 0.15)
	_toast_tween.tween_interval(1.8)
	_toast_tween.tween_property(_toast, "modulate:a", 0.0, 0.5)


# -------------------- STYLE HELPERS --------------------

func _make_label(value: String, font_size: int, color: Color, centered: bool = false) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _style_button(button: Button) -> void:
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color", "font_focus_color"]:
		button.add_theme_color_override(state, Color(IVORY))
	button.add_theme_stylebox_override("normal", _style(Color("#211519"), Color(GOLD), 2))
	button.add_theme_stylebox_override("hover", _style(Color("#452029"), Color("#D68177"), 2))
	button.add_theme_stylebox_override("pressed", _style(Color("#5D202D"), Color("#D68177"), 2))
	button.add_theme_stylebox_override("disabled", _style(Color("#171216"), Color("#4B343D"), 2))
	button.add_theme_stylebox_override("focus", _style(Color("#241419"), Color("#E6A095"), 3))


func _style(fill: Color, outline: Color, border_width: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = outline
	box.set_border_width_all(border_width)
	box.set_corner_radius_all(10)
	box.set_content_margin_all(10)
	return box
