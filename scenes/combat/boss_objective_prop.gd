extends Button
## A nonliving clickable battlefield prop. The controller owns costs and effects.
var portrait: TextureRect
var caption: Label
var outline: ShaderMaterial

func _ready() -> void:
	name = "BossObjectiveProp"
	size = Vector2(140,180)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for mode in ["normal","hover","pressed","disabled","focus"]:
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.055,0.025,0.035,0.08)
		style.border_color = Color("#AD8563") if mode in ["hover","focus"] else Color.TRANSPARENT
		style.set_border_width_all(1)
		add_theme_stylebox_override(mode,style)
	portrait = TextureRect.new()
	portrait.name = "ObjectiveArt"
	portrait.position = Vector2(5,2)
	portrait.size = Vector2(130,146)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	outline = ShaderMaterial.new()
	outline.shader = preload("res://assets/shaders/curio_highlight.gdshader")
	outline.set_shader_parameter("glow_color",Color("#A26D53"))
	outline.set_shader_parameter("strength",0.25)
	portrait.material = outline
	add_child(portrait)
	var shadow = preload("res://scenes/combat/ground_shadow.gd").new()
	shadow.position = Vector2(70,147)
	shadow.scale = Vector2(0.65,0.7)
	shadow.z_index = -1
	add_child(shadow)
	caption = Label.new()
	caption.position = Vector2(0,150)
	caption.size = Vector2(140,30)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_font_size_override("font_size",14)
	caption.add_theme_color_override("font_color",Color("#DDC9B1"))
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(caption)
	mouse_entered.connect(func(): outline.set_shader_parameter("strength",0.9 if not disabled else 0.1))
	mouse_exited.connect(func(): outline.set_shader_parameter("strength",0.25 if not disabled else 0.1))
	focus_entered.connect(func(): outline.set_shader_parameter("strength",0.9 if not disabled else 0.1))
	focus_exited.connect(func(): outline.set_shader_parameter("strength",0.25 if not disabled else 0.1))

func sync(state: Dictionary, usable: bool) -> void:
	if state.is_empty():
		visible = false
		return
	visible = true
	portrait.texture = load(str(state["icon"]))
	var remaining: int = int(state["uses"])-int(state["spent"])
	caption.text = "%s %d/%d" % ["CHAINS" if state["kind"] == "chains" else "RITE" if state["kind"] == "rite" else "IDOL",remaining,state["uses"]]
	disabled = not usable
	portrait.modulate = Color(0.45,0.40,0.40) if remaining == 0 else Color.WHITE
	outline.set_shader_parameter("strength",0.25 if usable else 0.1)
