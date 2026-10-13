extends Control
## A neutral, same-scale anatomy sheet; hide the cape to expose limb structure.
const Rig = preload("res://rig.gd")
const Motion = preload("res://motion.gd")
const Appearance = preload("res://appearance.gd")
var actors: Array = []
var appearance: Resource = Appearance.new()
var headings: Array[Label] = []
var title_label: Label
var subtitle_label: Label
func _ready() -> void:
	appearance.helmet = "original"
	var background := ColorRect.new()
	background.color = Color("#29282c")
	background.size = Vector2(1440,900)
	add_child(background)
	title_label = text("WARDEN / ANATOMY & POSE REFERENCE",Vector2(28,25),28,Color("#e8ddca"))
	subtitle_label = text("Compact torso · fitted shoulder/hip sockets · independent boots · shared sword grip",Vector2(29,70),18,Color("#b9aa97"))
	var modes = ["walk","guard","windup","strike"]
	var titles = ["WALK / LOW CARRY","RAISED COMBAT GUARD","WIND-UP","STRIKE / REACH"]
	for i in range(4):
		var origin := Vector2(25+i*356,139)
		var pane := Panel.new()
		pane.position = origin
		pane.size = Vector2(334,646)
		var frame := StyleBoxFlat.new()
		frame.bg_color = Color("#211f23")
		frame.border_color = Color("#615749")
		frame.set_border_width_all(1)
		pane.add_theme_stylebox_override("panel",frame)
		add_child(pane)
		headings.append(text(titles[i],origin+Vector2(16,20),17,Color("#c5ad84")))
		var actor := Rig.new()
		actor.appearance = appearance
		actor.mode = modes[i]
		actor.position = origin+Vector2(135,564)
		actor.scale = Vector2.ONE*0.90
		add_child(actor)
		actor.set_time(0.34)
		actor.cape.visible = false
		actors.append(actor)
		text("SAME SCALE / SAME PARTS",origin+Vector2(16,601),13,Color("#a69b8a"))
	text("Cape hidden on this sheet to inspect the anatomy. Clothing and equipment remain interchangeable in the lab.",Vector2(29,819),17,Color("#b9aa97"))
	text("Pose study only · no live-game integration",Vector2(29,856),15,Color("#c5ad84"))
func show_walk_cycle() -> void:
	title_label.text = "WARDEN / WALKING PHASE REFERENCE"
	subtitle_label.text = "Steady shoulders · low weapon carriage · restrained steps · planted boot orientation"
	var times = [0.0, Motion.STANCE*0.5*Motion.PERIOD, Motion.PERIOD*0.5, Motion.PERIOD]
	for i in range(actors.size()):
		headings[i].text = ["CONTACT A","PASSING","CONTACT B","REPEAT A"][i]
		actors[i].mode = "walk"
		actors[i].set_time(times[i])
func show_joints(value: bool) -> void:
	for actor in actors:
		actor.show_joints = value
		actor.refresh()
func text(value: String, position_value: Vector2, font_size: int, tint: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.position = position_value
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",tint)
	add_child(label)
	return label
