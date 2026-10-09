extends Control
## The Hamlet — a single painted town vista. Each building is baked into the
## scene art; hovering lights it up and reveals its name and purpose, and
## clicking it enters. Add an entry to BUILDINGS to place another.

const GameState := preload("res://scripts/game_data.gd")

const TITLE_SCENE = "res://scenes/ui/title_screen.tscn"
const COMBAT_SCENE = "res://scenes/combat/combatscene.tscn"

const IVORY = "#E7DACB"
const GOLD = "#C9A24B"
const MUTED = "#9A8B86"

const ART_MOTE = "res://assets/generated/mote.png"
const ART_GLOW = "res://assets/generated/glow_warm.png"

## Hotspots over the painted vista. `pos` = centre and `size` = footprint, both in
## the 1920x1080 layout. `subtitle` is the line shown beneath the name on hover.
## `expeditions: true` opens the expedition list; `locked: true` shows a sealed
## note. Listed back-to-front: the road is last so it sits in front.
const BUILDINGS: Array[Dictionary] = [
	{
		"id": "barracks", "name": "The Barracks", "subtitle": "Compose your party of three",
		"pos": [220, 260], "size": [330, 400], "highlight": Color("#A9B9C8"), "glow_scale": 0.92,
		"scene": "res://scenes/hub/barracks.tscn", "locked": false,
	},
	{
		"id": "bestiary", "name": "The Chapel Archive", "subtitle": "A bestiary of the creatures you have faced",
		"pos": [830, 220], "size": [240, 380], "highlight": Color("#D89A61"), "glow_scale": 0.94,
		"scene": "res://scenes/hub/bestiary.tscn", "locked": false,
	},
	{
		"id": "forge", "name": "The Forge", "subtitle": "Spend Embers to temper your abilities",
		"pos": [1660, 700], "size": [340, 340], "highlight": Color("#F58B43"), "glow_scale": 0.96,
		"scene": "res://scenes/hub/forge.tscn", "locked": false,
	},
	{
		"id": "road", "name": "The Old Road", "subtitle": "Take the road on an expedition",
		"pos": [960, 805], "size": [390, 350], "highlight": Color("#D6B66A"), "glow_scale": 1.0,
		"highlight_art": "res://assets/generated/building_gate.png", "highlight_alpha": 0.24,
		"scene": "", "locked": false, "expeditions": true,
	},
	{
		"id": "chapel", "name": "The Chapel Archive", "subtitle": "A bestiary of the creatures you have faced",
		"pos": [855, 175], "size": [145, 340], "highlight": Color("#D89A61"), "glow_scale": 1.0,
		"highlight_art": "res://assets/generated/building_bestiary.png", "highlight_alpha": 0.55,
		"scene": "res://scenes/hub/bestiary.tscn", "locked": false,
	},
]

var _map_view: Control
var _expedition_view: Control
var _toast: Label
var _toast_tween: Tween
var _hover_tweens: Dictionary = {}


func _ready() -> void:
	_map_view = $MapView
	_expedition_view = $ExpeditionView
	_toast = $Toast
	$BackButton.pressed.connect(_on_back_pressed)
	$ExpeditionView/MapBackButton.pressed.connect(_show_map)
	_build_party_line()
	_build_map()
	_build_atmosphere()
	_build_expeditions()
	_show_map()
	modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.6)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _expedition_view.visible:
			_show_map()
		else:
			_on_back_pressed()


# -------------------- MAP --------------------

func _build_map() -> void:
	for building in BUILDINGS:
		var hotspot := _make_hotspot(building)
		_map_view.add_child(hotspot)


func _building_pos(id: String, fallback: Vector2) -> Vector2:
	for building in BUILDINGS:
		if str(building.get("id", "")) == id:
			var p: Array = building.get("pos", [0, 0]) as Array
			return Vector2(float(p[0]), float(p[1]))
	return fallback


func _building_size(building: Dictionary) -> Vector2:
	var s: Array = building.get("size", [300, 300]) as Array
	return Vector2(float(s[0]), float(s[1]))


func _building_texture(building: Dictionary) -> Texture2D:
	var explicit_path: String = str(building.get("highlight_art", ""))
	if explicit_path != "":
		return _load_texture(explicit_path)
	var id: String = str(building.get("id", ""))
	var art_path: String = "res://assets/generated/building_%s.png" % id
	if ResourceLoader.exists(art_path):
		return _load_texture(art_path)
	return _load_texture(ART_GLOW)


func _build_atmosphere() -> void:
	var atmosphere: Control = $Atmosphere
	# Drifting dust motes.
	var motes := CPUParticles2D.new()
	motes.texture = _load_texture(ART_MOTE)
	motes.amount = 54
	motes.lifetime = 9.0
	motes.preprocess = 9.0
	motes.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	motes.emission_rect_extents = Vector2(1000.0, 640.0)
	motes.position = Vector2(960.0, 540.0)
	motes.gravity = Vector2(6.0, -8.0)
	motes.initial_velocity_min = 3.0
	motes.initial_velocity_max = 9.0
	motes.scale_amount_min = 0.1
	motes.scale_amount_max = 0.3
	motes.color = Color(0.95, 0.9, 0.82, 0.22)
	atmosphere.add_child(motes)
	# The smithy's painted fire already supplies its own idle glow.


func _make_hotspot(building: Dictionary) -> Button:
	var locked: bool = bool(building.get("locked", false))
	var footprint := _building_size(building)
	var centre := _building_pos(str(building.get("id", "")), Vector2(960.0, 540.0))

	var button := Button.new()
	button.name = str(building.get("id", "building"))
	button.text = ""
	button.flat = true
	button.size = footprint
	button.position = centre - footprint * 0.5
	button.focus_mode = Control.FOCUS_ALL
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	# A building-shaped cutout is layered over the matching structure. The
	# transparent PNG silhouette preserves the painted background everywhere else.
	var highlight := TextureRect.new()
	highlight.name = "GlowHover"
	highlight.texture = _building_texture(building)
	highlight.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	highlight.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var highlight_scale: float = float(building.get("glow_scale", 0.86))
	var hsize := footprint * highlight_scale
	highlight.z_index = 1
	highlight.size = hsize
	highlight.position = (footprint - hsize) * 0.5
	if str(building.get("id", "")) == "road":
		highlight.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var building_tint: Color = building.get("highlight", Color("#D89A61"))
	var highlight_alpha: float = float(building.get("highlight_alpha", 0.28))
	button.set_meta("highlight_alpha", highlight_alpha)
	highlight.modulate = Color(building_tint.r, building_tint.g, building_tint.b, 0.0)
	button.add_child(highlight)

	# A very subdued idle silhouette keeps hotspots discoverable without
	# putting an unrelated circular glow across the neighboring buildings.
	var idle := TextureRect.new()
	idle.name = "GlowIdle"
	idle.texture = _load_texture(ART_GLOW)
	idle.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	idle.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	idle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	idle.size = Vector2(1.0, 1.0)
	idle.modulate = Color(1.0, 1.0, 1.0, 0.0)
	button.add_child(idle)

	# Name + purpose, revealed on hover (Darkest Dungeon style).
	var banner := VBoxContainer.new()
	banner.name = "Banner"
	banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	banner.add_theme_constant_override("separation", 0)
	banner.size = Vector2(footprint.x, 74.0)
	var top_y := centre.y - footprint.y * 0.5
	banner.position = Vector2(0.0, maxf(-70.0, 208.0 - top_y))
	banner.modulate.a = 0.0
	button.add_child(banner)

	var name_label: Label = _make_label(str(building.get("name", "")), 38, Color(IVORY), true)
	name_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	name_label.add_theme_constant_override("shadow_offset_x", 3)
	name_label.add_theme_constant_override("shadow_offset_y", 3)
	name_label.add_theme_color_override("font_outline_color", Color(0.1, 0.06, 0.07, 1.0))
	name_label.add_theme_constant_override("outline_size", 6)
	banner.add_child(name_label)

	var subtitle_text: String = "Sealed for now" if locked else str(building.get("subtitle", ""))
	var subtitle: Label = _make_label(subtitle_text, 19, Color(MUTED) if locked else Color(GOLD), true)
	subtitle.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	subtitle.add_theme_constant_override("shadow_offset_x", 2)
	subtitle.add_theme_constant_override("shadow_offset_y", 2)
	banner.add_child(subtitle)

	button.mouse_entered.connect(_on_hotspot_hover.bind(button, true))
	button.mouse_exited.connect(_on_hotspot_hover.bind(button, false))
	button.pressed.connect(_on_building_pressed.bind(building))
	return button


func _on_hotspot_hover(button: Button, entered: bool) -> void:
	var highlight: TextureRect = button.get_node_or_null("GlowHover") as TextureRect
	var banner: Control = button.get_node_or_null("Banner") as Control
	var key: int = button.get_instance_id()
	if _hover_tweens.has(key):
		var previous: Tween = _hover_tweens[key] as Tween
		if previous.is_running():
			previous.kill()
	var tween := create_tween()
	_hover_tweens[key] = tween
	tween.set_parallel(true)
	if highlight != null:
		var target_alpha: float = float(button.get_meta("highlight_alpha", 0.28)) if entered else 0.0
		tween.tween_property(highlight, "modulate:a", target_alpha, 0.22)
	if banner != null:
		tween.tween_property(banner, "modulate:a", 1.0 if entered else 0.0, 0.16)


func _on_building_pressed(building: Dictionary) -> void:
	if bool(building.get("expeditions", false)):
		_show_expeditions()
		return
	if bool(building.get("locked", false)):
		_show_toast("%s is sealed — it will be raised here later." % str(building.get("name", "")))
		return
	var scene_path: String = str(building.get("scene", ""))
	if scene_path != "":
		get_tree().change_scene_to_file(scene_path)


func _show_map() -> void:
	_map_view.visible = true
	_expedition_view.visible = false


func _show_expeditions() -> void:
	_map_view.visible = false
	_expedition_view.visible = true


# -------------------- EXPEDITIONS --------------------

func _build_expeditions() -> void:
	var container: HBoxContainer = $ExpeditionView/Expeditions
	for child in container.get_children():
		child.queue_free()
	for expedition in GameState.EXPEDITIONS:
		container.add_child(_make_expedition_card(expedition))


func _make_expedition_card(expedition: Dictionary) -> Button:
	var locked: bool = bool(expedition.get("locked", false))
	var creature: Dictionary = GameState.creature(str(expedition.get("creature", "")))
	var card := _make_card_button(Vector2(360.0, 452.0), locked)
	card.pressed.connect(_on_expedition_chosen.bind(str(expedition.get("id", ""))))

	var contents := _card_contents(card)
	contents.add_child(_art_slot(str(creature.get("art", "")), locked, 190.0))
	contents.add_child(_make_label(str(expedition.get("name", "")), 27, Color(IVORY), true))
	contents.add_child(_make_label("%s  ·  %s" % [str(expedition.get("region", "")), str(expedition.get("difficulty", ""))], 18, Color(GOLD), true))
	var blurb: Label = _make_label(str(expedition.get("blurb", "")), 17, Color(MUTED), true)
	blurb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	blurb.custom_minimum_size = Vector2(0, 90)
	blurb.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	contents.add_child(blurb)
	contents.add_child(_make_label("SEALED — more to come" if locked else "EMBARK", 19, Color(MUTED) if locked else Color(GOLD), true))
	return card


func _on_expedition_chosen(expedition_id: String) -> void:
	if GameState.select_expedition(expedition_id):
		GameState.start_run()
		get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn")


# -------------------- SHARED UI --------------------

func _build_party_line() -> void:
	var text := "PARTY:"
	for i in range(GameState.party.size()):
		text += "   " + str(GameState.hero(GameState.party[i]).get("name", GameState.party[i]))
		if i < GameState.party.size() - 1:
			text += "  ·"
	$PartyLabel.text = text


func _show_toast(text: String) -> void:
	_toast.text = text
	_toast.modulate.a = 0.0
	if _toast_tween != null:
		_toast_tween.kill()
	_toast_tween = create_tween()
	_toast_tween.tween_property(_toast, "modulate:a", 1.0, 0.15)
	_toast_tween.tween_interval(1.8)
	_toast_tween.tween_property(_toast, "modulate:a", 0.0, 0.5)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(TITLE_SCENE)


# -------------------- UI BUILDERS --------------------

func _make_card_button(min_size: Vector2, locked: bool) -> Button:
	var card := Button.new()
	card.text = ""
	card.custom_minimum_size = min_size
	card.disabled = locked
	card.focus_mode = Control.FOCUS_ALL
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color", "font_focus_color"]:
		card.add_theme_color_override(state, Color(IVORY))
	card.add_theme_stylebox_override("normal", _style(Color("#1B1218"), Color(GOLD), 2))
	card.add_theme_stylebox_override("hover", _style(Color("#3A1C24"), Color("#D68177"), 2))
	card.add_theme_stylebox_override("pressed", _style(Color("#4E1E27"), Color("#D68177"), 2))
	card.add_theme_stylebox_override("focus", _style(Color("#241419"), Color("#E6A095"), 3))
	card.add_theme_stylebox_override("disabled", _style(Color("#141013"), Color("#4B343D"), 2))
	return card


func _card_contents(card: Button) -> VBoxContainer:
	var contents := VBoxContainer.new()
	contents.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contents.add_theme_constant_override("separation", 10)
	card.add_child(contents)
	contents.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	contents.offset_left = 16
	contents.offset_top = 16
	contents.offset_right = -16
	contents.offset_bottom = -16
	return contents


func _art_slot(path: String, locked: bool, height: float) -> Control:
	var frame := PanelContainer.new()
	frame.custom_minimum_size = Vector2(0, height)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_theme_stylebox_override("panel", _style(Color("#25171D"), Color(GOLD), 2))
	var texture: Texture2D = _load_texture(path)
	if texture != null and not locked:
		var picture := TextureRect.new()
		picture.texture = texture
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		picture.modulate = Color(0.82, 0.82, 0.85)
		frame.add_child(picture)
	else:
		var placeholder := _make_label("?", 64, Color(MUTED), true)
		placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		frame.add_child(placeholder)
	return frame


func _make_label(value: String, font_size: int, color: Color, centered: bool = false) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _style(fill: Color, outline: Color, border_width: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = outline
	box.set_border_width_all(border_width)
	box.set_corner_radius_all(12)
	box.set_content_margin_all(12)
	return box


func _load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	return null
