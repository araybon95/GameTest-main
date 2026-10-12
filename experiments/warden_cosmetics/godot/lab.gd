extends Control
const Actor = preload("res://actor.gd")
const PAPER = Color("#EDE1CE")
const MUTED = Color("#B5A694")
const GOLD = Color("#B89C71")
const SCALE: float = 400.0/1261.0
var actor: Node2D
var model_origin := Vector2(472,166)
var status: Label
var unlocked: bool = true
var selectors: Dictionary = {}
var feedback: Label
func _ready() -> void:
	var skin := Theme.new()
	skin.default_font_size = 16
	skin.set_color("font_color","Label",PAPER)
	for state in ["normal","hover","pressed","disabled","focus"]:
		var box := frame(Color("#171518"),GOLD if state == "hover" else Color("#665B4E"))
		box.set_content_margin_all(7)
		if state == "focus": box.draw_center = false
		skin.set_stylebox(state,"Button",box)
	theme = skin
	label("WARDEN · COSMETIC WORKBENCH",Vector2(24,18),1100,26)
	label("Isolated component prototype · standing pose only · live game unchanged",Vector2(25,54),1110,16,MUTED)
	var room := TextureRect.new()
	room.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	room.texture = preload("res://assets/room.png")
	room.size = Vector2(1280,720)
	room.stretch_mode = TextureRect.STRETCH_SCALE
	room.modulate = Color(0.32,0.31,0.31)
	room.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(room)
	move_child(room,0)
	for area in [Rect2(20,98,380,534),Rect2(418,98,487,534)]:
		var pane := Panel.new()
		pane.position = area.position
		pane.size = area.size
		pane.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pane.add_theme_stylebox_override("panel",frame(Color(0.02,0.018,0.025,0.45),Color("#453D34")))
		add_child(pane)
	label("CURRENT WARDEN",Vector2(36,116),355,19,GOLD)
	label("LAYERED REWARD PREVIEW",Vector2(438,116),455,19,GOLD)
	var reference := Sprite2D.new()
	reference.texture = preload("res://assets/original.png")
	reference.centered = false
	reference.scale = Vector2.ONE*SCALE
	reference.position = Vector2(7,166)
	add_child(reference)
	actor = Actor.new()
	actor.position = model_origin
	actor.scale = Vector2.ONE*SCALE
	add_child(actor)
	label("One flattened illustration",Vector2(40,602),335,16,MUTED)
	status = label("",Vector2(438,602),460,16,MUTED)
	var panel := Panel.new()
	panel.position = Vector2(925,98)
	panel.size = Vector2(335,605)
	panel.add_theme_stylebox_override("panel",frame(Color("#151316"),Color("#665B4E")))
	add_child(panel)
	check("Preview boss reward","PreviewReward",Vector2(945,119),true,set_reward_preview)
	selector("Helmet","helmet",Vector2(945,160),["Original greathelm","Wolf warhelm · prototype"])
	selector("Rear cloak","cloak",Vector2(945,223),["Original oxblood","Crowned mantle · prototype"])
	selector("Insignia","insignia",Vector2(945,286),["Iron clasp","Crown brooch","Embroidered crown patch"])
	check("Breathing & cloth wind","AnimateModel",Vector2(945,353),false,func(value): actor.animate = value)
	check("Separate the components","ExplodeLayers",Vector2(945,384),false,func(value): actor.exploded = value)
	check("Overlay original for alignment","SourceOverlay",Vector2(945,415),false,func(value): actor.source_overlay = value)
	label("Inspect a layer",Vector2(948,450),285,14,MUTED)
	var inspect := OptionButton.new()
	inspect.name = "InspectLayer"
	inspect.position = Vector2(945,473)
	inspect.size = Vector2(290,35)
	for title in ["All components","Rear cloak","Cloth patch","Torso / legs","Arms / gear","Neck scarf","Helmet","Shoulder insignia"]: inspect.add_item(title)
	inspect.item_selected.connect(func(index): actor.inspection = (["all"]+Actor.ORDER)[index])
	add_child(inspect)
	label("Helmet socket fitting · source pixels",Vector2(948,521),290,14,MUTED)
	label("X",Vector2(948,552),20,16,GOLD)
	spin("HelmetX",Rect2(972,546,107,35),-80,80,0,1,func(value): actor.helmet_offset.x = value)
	label("Y",Vector2(1091,552),20,16,GOLD)
	spin("HelmetY",Rect2(1115,546,110,35),-80,80,0,1,func(value): actor.helmet_offset.y = value)
	label("Helmet scale",Vector2(948,602),125,15,MUTED)
	spin("HelmetScale",Rect2(1090,593,135,35),0.4,1.0,actor.helmet_scale,0.01,func(value): actor.helmet_scale = value)
	var save := Button.new()
	save.name = "SaveDraft"
	save.text = "SAVE LAB FITTING"
	save.position = Vector2(945,650)
	save.size = Vector2(290,35)
	save.pressed.connect(save_draft)
	add_child(save)
	label("PREVIEW UNLOCK · No boss kills, rewards or character stats are changed.",Vector2(25,650),875,15,GOLD)
	feedback = label("Walking, combat and camp need matching per-pose component exports before any port.",Vector2(25,683),875,14,MUTED)
	set_reward_preview(true)
func _process(delta: float) -> void:
	if actor == null: return
	actor.advance(delta)
	var breath: float = 1.0+sin(actor.clock*1.45)*0.0018 if actor.animate else 1.0
	actor.scale = Vector2(SCALE,SCALE*breath)
	actor.position = model_origin+Vector2(0,Actor.CANVAS.y*SCALE*(1.0-breath))
	status.text = "Modular layers · "+("exploded" if actor.exploded else "assembled")
func set_reward_preview(value: bool) -> void:
	unlocked = value
	for key in selectors:
		var choice: OptionButton = selectors[key]
		choice.set_item_disabled(1,not value)
		if choice.item_count > 2: choice.set_item_disabled(2,not value)
		choice.select(1 if value else 0)
		actor.set(key,"crown" if value else "original" if key != "insignia" else "iron")
	actor.refresh()
func save_draft() -> void:
	var data := {"schema":1,"prototype_only":true,"pose":"standing","helmet":actor.helmet,"cloak":actor.cloak,"insignia":actor.insignia,"helmet_socket":[Actor.HEAD_SOCKET.x+actor.helmet_offset.x,Actor.HEAD_SOCKET.y+actor.helmet_offset.y],"helmet_joint":[Actor.HEAD_JOINT.x,Actor.HEAD_JOINT.y],"helmet_scale":actor.helmet_scale,"canvas":[Actor.CANVAS.x,Actor.CANVAS.y]}
	var path := "user://warden_cosmetic_fitting.json"
	var file := FileAccess.open(path,FileAccess.WRITE)
	if file == null: feedback.text = "Could not write the lab fitting."; return
	file.store_string(JSON.stringify(data,"\t"))
	file.close()
	feedback.text = "Saved lab fitting · user://warden_cosmetic_fitting.json (full path in console)."
	feedback.tooltip_text = ProjectSettings.globalize_path(path)
	print("SAVED_LAB_FITTING ",ProjectSettings.globalize_path(path))
func selector(title: String, property: String, pos: Vector2, choices: Array) -> void:
	label(title,pos,285,14,MUTED)
	var field := OptionButton.new()
	field.name = "Choice_"+property
	field.position = pos+Vector2(0,23)
	field.size = Vector2(290,35)
	for entry in choices: field.add_item(entry)
	field.select(1)
	field.item_selected.connect(func(index):
		if index > 0 and not unlocked: field.select(0); return
		actor.set(property,"patch" if property == "insignia" and index == 2 else "crown" if index == 1 else "iron" if property == "insignia" else "original"))
	selectors[property] = field
	add_child(field)
func check(title: String, id: String, pos: Vector2, initial: bool, action: Callable) -> void:
	var field := CheckBox.new()
	field.name = id
	field.text = title
	field.position = pos
	field.button_pressed = initial
	field.toggled.connect(action)
	add_child(field)
func spin(id: String, area: Rect2, low: float, high: float, initial: float, step: float, action: Callable) -> void:
	var field := SpinBox.new()
	field.name = id
	field.position = area.position
	field.size = area.size
	field.min_value = low
	field.max_value = high
	field.step = step
	field.value = initial
	field.value_changed.connect(action)
	add_child(field)
func frame(fill: Color,border: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(1)
	box.set_corner_radius_all(2)
	return box
func label(value: String, pos: Vector2, width: float, font_size: int, tint: Color = PAPER) -> Label:
	var result := Label.new()
	result.text = value
	result.position = pos
	result.size = Vector2(width,0)
	result.add_theme_font_size_override("font_size",font_size)
	result.add_theme_color_override("font_color",tint)
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(result)
	return result
