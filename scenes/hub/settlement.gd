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

const ART_MOTE = "res://assets/art_library/generated/mote.png"

## Hotspots over the painted vista. `pos` = centre and `size` = footprint, both in
## the 1920x1080 layout. `subtitle` is the line shown beneath the name on hover.
## `expeditions: true` opens the expedition list; `locked: true` shows a sealed
## note. Listed back-to-front: the road is last so it sits in front.
const BUILDINGS: Array[Dictionary] = [
	{"id": "graveyard", "name": "The Graveyard", "subtitle": "Names and deeds of those who fell", "pos": [350, 580], "size": [195, 170], "scene": "res://scenes/hub/graveyard.tscn", "locked": false},
	{
		"id": "apothecary", "name": "The Infested Apothecary", "subtitle": "Clear four rooms to restore the medical ward",
		"pos": [635, 305], "size": [175, 205],
		"scene": "res://scenes/hub/apothecary.tscn", "locked": false,
	},
	{
		"id": "barracks", "name": "The Barracks", "subtitle": "Compose your party of three",
		"pos": [220, 260], "size": [330, 400],
		"scene": "res://scenes/hub/barracks.tscn", "locked": false,
	},

	{
		"id": "forge", "name": "The Forge", "subtitle": "Spend Gold to temper your abilities",
		"pos": [1660, 700], "size": [340, 340],
		"scene": "res://scenes/hub/forge.tscn", "locked": false,
	},
	{
		"id": "road", "name": "The Old Road", "subtitle": "Take the road on an expedition",
		"pos": [960, 805], "size": [390, 350],
		"scene": "", "locked": false, "expeditions": true,
	},
	{
		"id": "chapel", "name": "The Chapel Archive", "subtitle": "Dungeon books, creature records and lore",
		"pos": [855, 175], "size": [145, 340],
		"scene": "res://scenes/hub/bestiary.tscn", "locked": false,
	},
	{"id": "watchtower", "name": "The Watchtower", "subtitle": "Reclaim the scouts' tower", "pos": [1250, 400], "size": [165, 220], "service": "watchtower", "locked": false},
	{"id": "infirmary", "name": "The Infirmary", "subtitle": "Restore the abandoned sickhouse", "pos": [535, 610], "size": [165, 185], "service": "infirmary", "locked": false},
	{"id": "workshop", "name": "The Workshop", "subtitle": "Reclaim the craftsmen's quarter", "pos": [1335, 630], "size": [170, 190], "service": "workshop", "locked": false},
]

# Traced contours in the painted settlement's 1920x1080 coordinate space.
const BUILDING_OUTLINES = {
 "apothecary": [Vector2(534,319),Vector2(572,266),Vector2(600,211),Vector2(624,230),Vector2(635,209),Vector2(650,216),Vector2(651,255),Vector2(675,270),Vector2(680,309),Vector2(697,326),Vector2(698,373),Vector2(655,384),Vector2(609,372),Vector2(570,374),Vector2(546,360)],
 "watchtower": [Vector2(1203,389),Vector2(1220,361),Vector2(1236,303),Vector2(1252,352),Vector2(1270,392),Vector2(1257,403),Vector2(1259,499),Vector2(1280,520),Vector2(1243,534),Vector2(1219,512),Vector2(1218,406)],
 "infirmary": [Vector2(490,455),Vector2(517,414),Vector2(542,400),Vector2(565,438),Vector2(589,415),Vector2(614,449),Vector2(642,487),Vector2(627,498),Vector2(636,555),Vector2(600,574),Vector2(553,569),Vector2(510,546),Vector2(512,480)],
 "forge": [Vector2(1457,682),Vector2(1502,605),Vector2(1548,525),Vector2(1569,508),Vector2(1595,536),Vector2(1682,562),Vector2(1718,601),Vector2(1790,663),Vector2(1916,717),Vector2(1919,1015),Vector2(1856,1036),Vector2(1731,1045),Vector2(1657,1028),Vector2(1599,1046),Vector2(1503,1000),Vector2(1487,841),Vector2(1446,815),Vector2(1462,782)],
 "graveyard": [Vector2(273,554),Vector2(312,551),Vector2(348,558),Vector2(372,545),Vector2(414,561),Vector2(441,608),Vector2(420,656),Vector2(367,667),Vector2(308,645),Vector2(270,616)],
 "road": [Vector2(838,956),Vector2(838,843),Vector2(852,782),Vector2(879,746),Vector2(921,715),Vector2(955,709),Vector2(986,726),Vector2(1023,752),Vector2(1050,796),Vector2(1068,861),Vector2(1068,967),Vector2(1022,975),Vector2(972,957),Vector2(916,964),Vector2(876,975)],
 "barracks": [Vector2(0,195),Vector2(106,141),Vector2(139,102),Vector2(174,107),Vector2(181,73),Vector2(221,79),Vector2(241,26),Vector2(249,0),Vector2(352,0),Vector2(353,59),Vector2(381,89),Vector2(417,116),Vector2(447,203),Vector2(483,256),Vector2(455,273),Vector2(460,400),Vector2(482,468),Vector2(447,505),Vector2(407,516),Vector2(396,543),Vector2(343,566),Vector2(286,568),Vector2(226,568),Vector2(171,552),Vector2(149,510),Vector2(92,482),Vector2(60,396),Vector2(28,383),Vector2(0,390)],
 "chapel": [Vector2(649,439),Vector2(683,352),Vector2(720,319),Vector2(758,252),Vector2(783,207),Vector2(779,145),Vector2(795,88),Vector2(809,36),Vector2(822,94),Vector2(843,151),Vector2(843,199),Vector2(868,248),Vector2(887,224),Vector2(893,149),Vector2(911,75),Vector2(923,45),Vector2(934,69),Vector2(938,0),Vector2(1030,0),Vector2(1050,60),Vector2(1074,134),Vector2(1065,158),Vector2(1089,210),Vector2(1085,468),Vector2(1081,493),Vector2(1040,480),Vector2(998,476),Vector2(956,482),Vector2(906,473),Vector2(847,496),Vector2(795,513),Vector2(752,540),Vector2(718,522),Vector2(683,498),Vector2(664,478)],
 "workshop": [Vector2(1208,637),Vector2(1232,590),Vector2(1257,540),Vector2(1282,518),Vector2(1298,472),Vector2(1312,527),Vector2(1342,545),Vector2(1377,552),Vector2(1407,588),Vector2(1434,639),Vector2(1405,645),Vector2(1404,724),Vector2(1360,741),Vector2(1307,731),Vector2(1280,749),Vector2(1239,727),Vector2(1241,652)]
}

var _map_view: Control
var _expedition_view: Control
var _toast: Label
var _toast_tween: Tween
var _hover_tweens: Dictionary = {}


func _ready() -> void:
	GameState.load_progression()
	preload("res://scripts/settlement_music.gd").play()
	_map_view = $MapView
	_expedition_view = $ExpeditionView
	_toast = $Toast
	$BackButton.pressed.connect(_on_back_pressed)
	$ExpeditionView/MapBackButton.pressed.connect(_show_map)
	_build_party_line()
	_build_map()
	_build_atmosphere()
	_show_map()
	var merchant := Button.new()
	merchant.text = "THE EMPORIUM"
	merchant.position = Vector2(1470, 40)
	merchant.size = Vector2(380, 70)
	merchant.add_theme_font_size_override("font_size", 24)
	merchant.pressed.connect(func():
		GameState.shop_return_scene = "res://scenes/hub/settlement.tscn"
		get_tree().change_scene_to_file("res://scenes/hub/item_shop.tscn"))
	add_child(merchant)
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
		var details: Dictionary = building.duplicate()
		if building.has("service") and GameState.service_unlocked(str(building["service"])):
			details["subtitle"] = "Restored · " + {"watchtower": "Scout the dungeon", "infirmary": "Discounted remedies", "workshop": "Modify equipment"}[building["service"]]
		if building["id"] == "apothecary" and GameState.apothecary_unlocked():
			details["name"] = "The Apothecary"
			details["subtitle"] = "Healing remedies, cleansing draughts and buff tonics"
		var hotspot := _make_hotspot(details)
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

	var button := preload("res://scenes/ui/building_hotspot.gd").new()
	var outline: PackedVector2Array = PackedVector2Array(BUILDING_OUTLINES.get(str(building.get("id", "")), []))
	if not outline.is_empty():
		var bounds := Rect2(outline[0], Vector2.ZERO)
		for point in outline: bounds = bounds.expand(point)
		footprint = bounds.size
		centre = bounds.get_center()
		for point in outline: button.silhouette.append(point - bounds.position)
	button.name = str(building.get("id", "building"))
	button.text = ""
	button.flat = true
	button.size = footprint
	button.position = centre - footprint * 0.5
	button.focus_mode = Control.FOCUS_ALL
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	# Sample the SAME painted vista, with UVs in its original pixel space.
	# No replacement building art can drift across roofs, walls or neighboring props.
	var highlight := TextureRect.new()
	highlight.name = "GlowHover"
	highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	highlight.size = footprint
	highlight.modulate.a = 0.0
	button.set_meta("highlight_alpha",1.0)
	button.add_child(highlight)
	var vista: TextureRect = $Background
	var painted := Polygon2D.new()
	painted.name = "PaintedHighlight"
	painted.polygon = button.silhouette
	painted.texture = vista.texture
	var texture_size := vista.texture.get_size()
	var cover_scale: float = maxf(vista.size.x / texture_size.x,vista.size.y / texture_size.y)
	var cover_offset := (vista.size-texture_size*cover_scale)*0.5
	var source_uvs := PackedVector2Array()
	for point in outline:
		source_uvs.append((point-vista.position-cover_offset)/cover_scale)
	painted.uv = source_uvs
	var paint_material := ShaderMaterial.new()
	paint_material.shader = preload("res://assets/shaders/settlement_highlight.gdshader")
	painted.material = paint_material
	highlight.add_child(painted)
	# A narrow warm roof edge, kept below the luminance of the painted firelight.
	var roof := Line2D.new()
	roof.points = button.silhouette.slice(0,maxi(3,button.silhouette.size()-4))
	roof.width = 1.5
	roof.default_color = Color(0.83,0.69,0.47,0.30)
	roof.antialiased = true
	highlight.add_child(roof)

	# Name + purpose, revealed on hover (Darkest Dungeon style).
	var banner := VBoxContainer.new()
	banner.name = "Banner"
	banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	banner.add_theme_constant_override("separation", 0)
	banner.size = Vector2(720.0, 84.0)
	banner.position = Vector2(600.0, 984.0)-button.position
	banner.modulate.a = 0.0
	button.add_child(banner)

	var name_label: Label = _make_label(str(building.get("name", "")), 32, Color(IVORY), true)
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
	button.focus_entered.connect(_on_hotspot_hover.bind(button, true))
	button.focus_exited.connect(_on_hotspot_hover.bind(button, false))
	button.pressed.connect(_on_building_pressed.bind(building))
	return button


func _on_hotspot_hover(button: Button, entered: bool) -> void:
	if entered:
		# Only one town caption occupies the shared footer at a time.
		for other in _map_view.get_children():
			if other == button or not other.has_node("GlowHover"): continue
			var other_key: int = other.get_instance_id()
			if _hover_tweens.has(other_key): _hover_tweens[other_key].kill()
			other.get_node("GlowHover").modulate.a = 0.0
			other.get_node("Banner").modulate.a = 0.0
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
	if building.has("service"):
		GameState.pending_service = str(building["service"])
		get_tree().change_scene_to_file("res://scenes/hub/restoration.tscn")
		return
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
	get_tree().change_scene_to_file("res://scenes/expedition/region_select.tscn")


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
