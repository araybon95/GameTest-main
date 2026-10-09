extends Control
## The Barracks — swap heroes in and out of the three-hero party. Select a party
## slot, then click a hero from the roster to place them there.

const GameState := preload("res://scripts/game_data.gd")

const HUB_SCENE = "res://scenes/hub/settlement.tscn"
const SLOT_COUNT = 3

const IVORY = "#EADDD0"
const GOLD = "#8F4546"
const MUTED = "#B5A2A3"

var _selected_slot: int = 0


func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)
	GameState.load_progression()
	_refresh()
	modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()


func _refresh() -> void:
	_build_slots()
	_build_roster()
	$Hint.text = "Selected SLOT %d — pick a hero below to place them (or click another slot)." % (_selected_slot + 1)


func _build_slots() -> void:
	var container: HBoxContainer = $PartySlots
	for child in container.get_children():
		child.queue_free()
	for i in range(SLOT_COUNT):
		var hero_id: String = str(GameState.party[i]) if i < GameState.party.size() else ""
		var tag: String = "SLOT %d%s" % [i + 1, "   ◀ SELECTED" if i == _selected_slot else ""]
		var card: Button = _hero_card(hero_id, tag, i == _selected_slot)
		card.pressed.connect(_on_slot_pressed.bind(i))
		container.add_child(card)


func _build_roster() -> void:
	var container: HBoxContainer = $Roster
	for child in container.get_children():
		child.queue_free()
	for hero_id in GameState.HEROES.keys():
		var in_party: bool = GameState.party.has(str(hero_id))
		var locked: bool = hero_id == "crusader" and not GameState.crusader_unlocked
		var tag: String = "LOCKED · OLD ROAD FLOOR 2" if locked else ("IN PARTY" if in_party else "BENCHED")
		var card: Button = _hero_card(str(hero_id), tag, false)
		card.disabled = locked
		card.tooltip_text = str(GameState.hero(str(hero_id)).get("lore", "")) + ("\nFree him from the spiked coffin on Old Road floor 2." if locked else "")
		card.pressed.connect(_on_hero_pressed.bind(str(hero_id)))
		container.add_child(card)


func _on_slot_pressed(slot: int) -> void:
	_selected_slot = slot
	_refresh()


func _on_hero_pressed(hero_id: String) -> void:
	if hero_id == "crusader" and not GameState.crusader_unlocked:
		return
	var existing: int = GameState.party.find(hero_id)
	var displaced: String = str(GameState.party[_selected_slot])
	if displaced == hero_id:
		_refresh()
		return
	GameState.party[_selected_slot] = hero_id
	if existing != -1 and existing != _selected_slot:
		GameState.party[existing] = displaced
	_refresh()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(HUB_SCENE)


# -------------------- UI BUILDERS --------------------

func _hero_card(hero_id: String, tag_text: String, highlighted: bool) -> Button:
	var card := Button.new()
	card.text = ""
	card.custom_minimum_size = Vector2(245.0, 300.0)
	card.focus_mode = Control.FOCUS_NONE
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color", "font_focus_color"]:
		card.add_theme_color_override(state, Color(IVORY))
	card.add_theme_stylebox_override("normal", _style(Color("#1B1218"), Color("#E6A095") if highlighted else Color(GOLD)))
	card.add_theme_stylebox_override("hover", _style(Color("#3A1C24"), Color("#D68177")))
	card.add_theme_stylebox_override("pressed", _style(Color("#4E1E27"), Color("#D68177")))
	card.add_theme_stylebox_override("focus", _style(Color("#241419"), Color("#E6A095")))

	var contents := VBoxContainer.new()
	contents.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contents.add_theme_constant_override("separation", 8)
	card.add_child(contents)
	contents.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	contents.offset_left = 14
	contents.offset_top = 14
	contents.offset_right = -14
	contents.offset_bottom = -14

	var frame := PanelContainer.new()
	frame.custom_minimum_size = Vector2(0, 160)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_theme_stylebox_override("panel", _style(Color("#25171D"), Color(GOLD)))
	contents.add_child(frame)
	if hero_id != "":
		var texture: Texture2D = _load_texture(str(GameState.hero(hero_id).get("art", "")))
		if texture != null:
			var picture := TextureRect.new()
			picture.texture = texture
			picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
			frame.add_child(picture)
			picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	else:
		var empty := _make_label("EMPTY", 22, Color(MUTED), true)
		empty.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		frame.add_child(empty)
		empty.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var name_text: String = "—" if hero_id == "" else str(GameState.hero(hero_id).get("name", hero_id))
	contents.add_child(_make_label(name_text, 21, Color(IVORY), true))
	if hero_id != "":
		contents.add_child(_make_label("Max HP %d" % int(GameState.hero(hero_id).get("max_hp", 0)), 17, Color(MUTED), true))
	contents.add_child(_make_label(tag_text, 17, Color(GOLD), true))
	return card


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