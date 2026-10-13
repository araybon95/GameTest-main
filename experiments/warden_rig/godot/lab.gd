extends Control
const Rig = preload("res://rig.gd")
const Appearance = preload("res://appearance.gd")
const Motion = preload("res://motion.gd")
const PAPER = Color("#e8ddca")
const MUTED = Color("#aa9f90")
const GOLD = Color("#b9a077")
var appearance: Resource = Appearance.new()
var actors: Array = []
var selectors: Dictionary = {}
var scenery: Array = []
var paused: bool = false
var travel: float = 0.0
var speed: float = 1.0
var status: Label
var card_summary: Label
var pose: OptionButton
var feedback: Label
func _ready() -> void:
	var skin := Theme.new()
	skin.default_font_size = 16
	skin.set_color("font_color","Label",PAPER)
	for kind in ["Button","OptionButton"]:
		for state in ["normal","hover","pressed","disabled","focus"]:
			var box := frame(Color("#211e20"),GOLD if state in ["hover","focus"] else Color("#605447"))
			box.set_content_margin_all(7)
			if state == "focus": box.draw_center = false
			skin.set_stylebox(state,kind,box)
	theme = skin
	label("WARDEN  /  LIVING ARMORY",Vector2(24,18),1050,29)
	label("Articulated character reference · one wardrobe across travel, combat and your hero card",Vector2(25,58),1300,17,MUTED)
	pose = OptionButton.new()
	pose.name = "TravelMode"
	pose.position = Vector2(24,94)
	pose.size = Vector2(160,32)
	pose.add_item("Walking")
	pose.add_item("Standing")
	pose.item_selected.connect(func(index): actors[0].mode = "walk" if index == 0 else "idle")
	add_child(pose)
	check("Pause","Pause",Vector2(212,94),func(value):
		paused = value
		for actor in actors: actor.paused = value)
	check("Face left","Facing",Vector2(345,94),func(value):
		actors[0].reverse = value
		actors[0].refresh())
	check("Show joints","ShowJoints",Vector2(494,94),func(value):
		for actor in actors: actor.show_joints = value; actor.refresh())
	label("Pace",Vector2(691,100),55,15,MUTED)
	var pace := HSlider.new()
	pace.name = "Pace"
	pace.position = Vector2(748,102)
	pace.size = Vector2(145,20)
	pace.min_value = 0.5
	pace.max_value = 1.5
	pace.step = 0.05
	pace.value = 1.0
	pace.value_changed.connect(func(value): speed = value)
	add_child(pace)
	label("ISOLATED PROTOTYPE · LIVE GAME UNCHANGED",Vector2(950,102),450,14,GOLD)
	panel(Rect2(24,140,842,447))
	panel(Rect2(885,140,531,447))
	label("01  /  HALLWAY MOVEMENT",Vector2(44,158),560,18,GOLD)
	label("02  /  COMBAT MOTION",Vector2(905,158),480,18,GOLD)
	var walking := stage(Rect2(25,194,840,354),true)
	var fighting := stage(Rect2(886,194,529,354),false)
	actors.append(make_actor(walking,"walk",Vector2(470,335),0.71))
	actors.append(make_actor(fighting,"combat",Vector2(275,335),0.67))
	label("Continuous joints · restrained gait · shared equipment",Vector2(44,560),800,14,MUTED)
	label("Illustrative attack loop · no damage or combat rules",Vector2(905,560),480,14,MUTED)
	panel(Rect2(24,607,842,267))
	panel(Rect2(885,607,531,267))
	label("03  /  YOUR WARDEN",Vector2(44,625),450,18,GOLD)
	var card_view := Control.new()
	card_view.position = Vector2(44,653)
	card_view.size = Vector2(218,203)
	card_view.clip_contents = true
	add_child(card_view)
	actors.append(make_actor(card_view,"card",Vector2(144,196),0.40))
	label("THE ASHEN WARDEN",Vector2(287,671),540,23)
	label("An oath carried in iron. A silhouette made your own.",Vector2(288,710),540,16,MUTED)
	card_summary = label("",Vector2(288,749),545,16,GOLD)
	label("Same attachments as the moving and fighting hero.\nAppearance only · no item stats or boss ownership here.",Vector2(288,808),545,14,MUTED)
	label("WARDROBE",Vector2(905,625),475,18,GOLD)
	selector("Weapon","weapon",Vector2(905,663),["Arming sword","Double-headed axe","Gem mace"])
	selector("Helmet","helmet",Vector2(905,708),["Original greathelm","Corrupted wolf warhelm"])
	selector("Cape","cloak",Vector2(905,753),["Original oxblood","Ash-grey mantle · gold trim"])
	button("Save look","SaveLook",Rect2(905,808,138,32),save_profile)
	button("Load look","LoadLook",Rect2(1052,808,138,32),load_profile)
	button("Reset","ResetLook",Rect2(1199,808,193,32),func(): appearance.apply_data(Appearance.new().to_dict()))
	feedback = label("Lab profile only · separate from campaign saves",Vector2(905,848),488,13,MUTED)
	appearance.appearance_changed.connect(sync_choices)
	sync_choices()
func stage(area: Rect2, scroll: bool) -> Control:
	var result := Control.new()
	result.position = area.position
	result.size = area.size
	result.clip_contents = true
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(result)
	var texture: Texture2D = preload("res://assets/corridor.png")
	var width: float = texture.get_width()*area.size.y/texture.get_height()
	var count: int = int(ceil(area.size.x/width))+2 if scroll else 1
	for i in range(count):
		var bg := TextureRect.new()
		bg.texture = texture
		bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bg.size = Vector2(width,area.size.y)
		bg.position.x = (i-1)*width if scroll else (area.size.x-width)*0.5
		bg.modulate = Color(0.42,0.40,0.41)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		result.add_child(bg)
		if scroll: scenery.append({"node":bg,"index":i,"width":width})
	var floor := ColorRect.new()
	floor.position = Vector2(0,326)
	floor.size = Vector2(area.size.x,28)
	floor.color = Color(0.025,0.022,0.028,0.5)
	floor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result.add_child(floor)
	return result
func make_actor(parent: Node, action: String, origin: Vector2, factor: float) -> Node2D:
	var shadow := Polygon2D.new()
	var points := PackedVector2Array()
	for i in range(32): points.append(Vector2(cos(i*TAU/32)*56*factor,sin(i*TAU/32)*6*factor))
	shadow.polygon = points
	shadow.color = Color(0,0,0,0.65)
	shadow.position = origin+Vector2(0,2)
	parent.add_child(shadow)
	var actor := Rig.new()
	actor.appearance = appearance
	actor.mode = action
	actor.position = origin
	actor.scale = Vector2.ONE*factor
	parent.add_child(actor)
	return actor
func _process(delta: float) -> void:
	if actors.is_empty(): return
	for actor in actors: actor.advance(delta*speed)
	if not paused and actors[0].walk_blend > 0.001: travel += delta*speed*Motion.SPEED*actors[0].scale.y*actors[0].walk_blend*(-1 if actors[0].reverse else 1)
	for entry in scenery: entry.node.position.x = (entry.index-1)*entry.width-fposmod(travel,entry.width)
func set_slot(slot: String, id: String) -> bool: return appearance.set_slot(slot,id)
func sync_choices() -> void:
	for slot in selectors: selectors[slot].select(Appearance.VALID[slot].find(appearance.get(slot)))
	if card_summary != null:
		card_summary.text = {"sword":"ARMING SWORD","axe":"DOUBLE-HEADED AXE","mace":"GEM MACE"}[appearance.weapon]+"\n"+("WOLF WARHELM" if appearance.helmet == "wolf" else "GREATHELM")+"  /  "+("ASH-GREY & GOLD" if appearance.cloak == "crown" else "OXBLOOD")
func save_profile() -> void:
	var file := FileAccess.open("user://warden_rig_profile.json",FileAccess.WRITE)
	if file == null: feedback.text = "Could not save this lab profile."; return
	file.store_string(JSON.stringify(appearance.to_dict(),"\t"))
	file.close()
	feedback.text = "Saved appearance · this prototype only"
func load_profile() -> void:
	var path := "user://warden_rig_profile.json"
	if not FileAccess.file_exists(path): feedback.text = "Save a lab look first."; return
	var file := FileAccess.open(path,FileAccess.READ)
	if file == null: feedback.text = "Could not read the lab profile."; return
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or not appearance.apply_data(parsed): feedback.text = "Unsupported profile · current look retained."; return
	feedback.text = "Loaded appearance across all three views"
func selector(title: String, slot: String, origin: Vector2, choices: Array) -> void:
	label(title,origin+Vector2(0,6),90,15,MUTED)
	var field := OptionButton.new()
	field.name = "Choice_"+slot
	field.position = origin+Vector2(95,0)
	field.size = Vector2(392,33)
	for choice in choices: field.add_item(choice)
	field.item_selected.connect(func(index): set_slot(slot,Appearance.VALID[slot][index]))
	selectors[slot] = field
	add_child(field)
func check(title: String, id: String, origin: Vector2, action: Callable) -> void:
	var field := CheckBox.new()
	field.name = id
	field.text = title
	field.position = origin
	field.toggled.connect(action)
	add_child(field)
func button(title: String, id: String, area: Rect2, action: Callable) -> void:
	var field := Button.new()
	field.name = id
	field.text = title
	field.position = area.position
	field.size = area.size
	field.pressed.connect(action)
	add_child(field)
func label(value: String, origin: Vector2, width: float, font_size: int, tint: Color = PAPER) -> Label:
	var field := Label.new()
	field.text = value
	field.position = origin
	field.size.x = width
	field.add_theme_font_size_override("font_size",font_size)
	field.add_theme_color_override("font_color",tint)
	field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(field)
	return field
func panel(area: Rect2) -> void:
	var field := Panel.new()
	field.position = area.position
	field.size = area.size
	field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	field.add_theme_stylebox_override("panel",frame(Color("#141216"),Color("#504536")))
	add_child(field)
func frame(fill: Color, border: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(1)
	box.set_corner_radius_all(3)
	return box
