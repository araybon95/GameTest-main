extends Control
const Actor = preload("res://actor.gd")
const IVORY = Color("#EDE1CE")
const MUTED = Color("#B5A694")
const BRASS = Color("#B89C71")
var actor: Node2D
var stage: Control
var backdrops: Array[TextureRect] = []
var distance: float = 0.0
var status: Label
var movement_button: Button
var stage_hint: Label
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var skin := Theme.new()
	skin.default_font_size = 17
	skin.set_color("font_color","Label",IVORY)
	for state in ["normal","hover","pressed","disabled","focus"]:
		var box := frame(Color("#161518"),BRASS if state == "hover" else Color("#665B4E"))
		box.set_content_margin_all(8)
		if state == "focus": box.draw_center = false; box.border_color = BRASS
		skin.set_stylebox(state,"Button",box)
	theme = skin
	label("ASHEN · ANIMATION LAB",Vector2(24,18),900,26)
	label("Standalone stride experiment · isolated from the main game",Vector2(25,54),1100,16,MUTED)
	stage = Control.new()
	stage.name = "PreviewStage"
	stage.position = Vector2(20,90)
	stage.size = Vector2(920,525)
	stage.clip_contents = true
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)
	for i in range(2):
		var background := TextureRect.new()
		background.texture = preload("res://assets/background.png")
		background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		background.size = stage.size
		background.modulate = Color(0.45,0.43,0.43)
		background.position.x = i*stage.size.x
		stage.add_child(background)
		backdrops.append(background)
	var shade := ColorRect.new()
	shade.position = Vector2(0,439)
	shade.size = Vector2(920,86)
	shade.color = Color(0.025,0.02,0.025,0.82)
	stage.add_child(shade)
	var shadow := Shadow.new()
	shadow.position = Vector2(460,442)
	stage.add_child(shadow)
	actor = Actor.new()
	actor.position = Vector2(460,440)
	stage.add_child(actor)
	var panel := Panel.new()
	panel.position = Vector2(960,90)
	panel.size = Vector2(300,600)
	panel.add_theme_stylebox_override("panel",frame(Color("#151316"),Color("#665B4E")))
	add_child(panel)
	label("STRIDE CONTROLS",Vector2(980,104),260,20)
	var hero := option("Hero",Vector2(980,142),["Warden","Ranger","Occultist","Healer","Crusader"])
	hero.name = "HeroSelection"
	hero.item_selected.connect(func(index): actor.select_hero(Actor.Catalog.REGIONS.keys()[index]))
	var style := option("Mode",Vector2(980,214),["Animated prototype","Subtle reference","Original four frames"])
	style.name = "ModeSelection"
	style.item_selected.connect(func(index): actor.style = ["animated","subtle","classic"][index])
	movement_button = button("WALKING · SWITCH TO IDLE",Rect2(980,286,260,38),func():
		actor.requested_walking = not actor.requested_walking
		movement_button.text = "WALKING · SWITCH TO IDLE" if actor.requested_walking else "IDLE · START WALKING")
	movement_button.add_theme_font_size_override("font_size",15)
	var freeze := CheckBox.new()
	freeze.name = "FreezeAnimation"
	freeze.text = "Freeze pose"
	freeze.position = Vector2(980,328)
	freeze.toggled.connect(func(value): actor.frozen = value)
	add_child(freeze)
	var flip := CheckBox.new()
	flip.name = "FaceLeft"
	flip.text = "Face left"
	flip.position = Vector2(1110,328)
	flip.toggled.connect(func(value): actor.reverse = value)
	add_child(flip)
	slider("Cadence · steps/sec","cadence",Vector2(980,366),1.2,3.4,0.1)
	slider("Stride length","stride_length",Vector2(980,422),2,24,0.5)
	slider("Foot lift","foot_lift",Vector2(980,478),0,10,0.25)
	slider("Cloth sway","cloth_sway",Vector2(980,534),0,6,0.25)
	slider("Body rise / fall","body_bob",Vector2(980,590),0,2.5,0.1)
	var mesh := CheckBox.new()
	mesh.name = "ShowMesh"
	mesh.text = "Show deformation mesh"
	mesh.position = Vector2(980,645)
	mesh.toggled.connect(func(value): actor.show_grid = value)
	add_child(mesh)
	stage_hint = label("ALTERNATING STEP · SINGLE CONSISTENT SILHOUETTE",Vector2(35,584),860,16,BRASS)
	status = label("",Vector2(25,637),910,17,MUTED)
	button("SAVE STILL · F8",Rect2(25,672,230,30),save_still).add_theme_font_size_override("font_size",15)
	label("Experimental motion only. Compare modes and tune the controls before integration.",Vector2(275,675),670,14,MUTED)
func _process(delta: float) -> void:
	if actor == null: return
	actor.advance(delta)
	movement_button.text = "WALKING · SWITCH TO IDLE" if actor.requested_walking else "IDLE · START WALKING"
	if not actor.frozen and actor.requested_walking: distance += delta*actor.cadence*30*(-1 if actor.reverse else 1)
	for i in range(backdrops.size()): backdrops[i].position.x = i*stage.size.x-fposmod(distance,stage.size.x)
	status.text = "%s · %s · %.1f steps/sec · stride %.1f · lift %.1f" % [actor.hero.capitalize(),actor.style.capitalize(),actor.cadence,actor.stride_length,actor.foot_lift]
	stage_hint.text = {"animated":"ALTERNATING STEP · SINGLE CONSISTENT SILHOUETTE", "subtle":"SUBTLE REFERENCE · BREATHING AND SMALL SWAY", "classic":"ORIGINAL FOUR FRAMES · COMPARISON ONLY"}[actor.style]
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F8: save_still()
func save_still() -> void:
	await RenderingServer.frame_post_draw
	var path := "user://animation_lab_"+str(Time.get_unix_time_from_system()).replace(".","_")+".png"
	if get_viewport().get_texture().get_image().save_png(path) == OK: status.text = "Still saved: "+ProjectSettings.globalize_path(path)
func frame(fill: Color, border: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(1)
	box.set_corner_radius_all(2)
	return box
func label(value: String, pos: Vector2, width: float, font_size: int, tint: Color = IVORY) -> Label:
	var result := Label.new()
	result.text = value
	result.position = pos
	result.size = Vector2(width,0)
	result.add_theme_font_size_override("font_size",font_size)
	result.add_theme_color_override("font_color",tint)
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(result)
	return result
func option(title: String, pos: Vector2, values: Array) -> OptionButton:
	label(title,pos,260,14,MUTED)
	var result := OptionButton.new()
	result.position = pos+Vector2(0,23)
	result.size = Vector2(260,38)
	for value in values: result.add_item(value)
	add_child(result)
	return result
func button(title: String, rect: Rect2, action: Callable) -> Button:
	var result := Button.new()
	result.text = title
	result.position = rect.position
	result.size = rect.size
	result.pressed.connect(action)
	add_child(result)
	return result
func slider(title: String, property: String, pos: Vector2, low: float, high: float, step: float) -> void:
	var caption := label(title+" · "+str(actor.get(property)),pos,260,14,MUTED)
	var control := HSlider.new()
	control.name = "Adjust_"+property
	control.position = pos+Vector2(0,22)
	control.size = Vector2(260,26)
	control.min_value = low
	control.max_value = high
	control.step = step
	control.value = actor.get(property)
	control.value_changed.connect(func(value): actor.set(property,value); caption.text = title+" · "+str(snappedf(value,0.01)))
	add_child(control)
class Shadow extends Node2D:
	func _draw() -> void:
		draw_set_transform(Vector2.ZERO,0,Vector2(4.5,0.42))
		for i in range(5): draw_circle(Vector2.ZERO,18-i*2.0,Color(0.02,0.01,0.02,0.16))
