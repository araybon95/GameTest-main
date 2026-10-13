extends Control
const Actor = preload("res://ashen_wolf_actor.gd")
const Reference = preload("res://complete_actor.gd")
var reference: Node2D
var polished: Node2D
var actors: Array[Node2D] = []
var paused: bool = false
var travel: float = 0.0
var travel_direction: int = 1
var facing: int = 1
var caption: Label

func _ready() -> void:
	var background := TextureRect.new()
	background.texture = preload("res://assets/room.png")
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.modulate = Color(0.34,0.31,0.31)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label_at("WARDEN · ASHEN WOLF ARMOR SET",Vector2(40,25),1360,32)
	label_at("Complete painted outfits · same stride · armed only during combat",Vector2(40,76),1360,22)
	label_at("ORIGINAL WARDEN",Vector2(40,150),640,23)
	label_at("ASHEN WOLF REWARD SET",Vector2(760,150),640,23)
	reference = Reference.new()
	polished = Actor.new()
	actors = [reference,polished]
	for index in range(actors.size()):
		var actor: Node2D = actors[index]
		actor.position = Vector2(320+index*720,690)
		actor.scale = Vector2.ONE*1.1
		add_child(actor)
		actor.set_motion("walk")
	caption = label_at("WEAPONS HOLSTERED · Walk left, right, or enter combat to draw the weapon",Vector2(40,743),1360,20)
	var actions := [["Walk right","right"],["Walk left","left"],["Combat stance","idle"],["Attack","attack"],["Pause / resume","pause"]]
	for i in range(actions.size()):
		var button := Button.new()
		button.text = actions[i][0]
		button.position = Vector2(110+i*250,803)
		button.size = Vector2(225,52)
		button.add_theme_font_size_override("font_size",20)
		button.pressed.connect(choose.bind(actions[i][1]))
		add_child(button)

func label_at(value: String, origin: Vector2, width: float, font_size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = origin
	label.size = Vector2(width,40)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("#ecdfcd"))
	add_child(label)
	return label

func choose(choice: String) -> void:
	if choice == "pause":
		paused = not paused
		return
	paused = false
	match choice:
		"right", "left":
			facing = -1 if choice == "left" else 1
			travel_direction = facing
			for actor in actors:
				actor.set_facing(facing)
				actor.set_motion("walk")
			caption.text = "WEAPONS HOLSTERED · Complete outfit · no visible shield or weapon on the right"
		"idle":
			for actor in actors:
				actor.set_motion("idle")
			caption.text = "COMBAT STANCE · The equipped weapon appears; quiet breathing resumes"
		"attack":
			for actor in actors:
				actor.attack()
			caption.text = "ATTACK · One held pose, then return to armed combat idle"

func _process(delta: float) -> void:
	if paused:
		return
	for actor in actors:
		actor.advance(delta)
	if polished.mode == "walk":
		travel += travel_direction*65.0*delta
		if absf(travel) > 95.0:
			travel = clampf(travel,-95.0,95.0)
			travel_direction *= -1
			facing = travel_direction
			for actor in actors:
				actor.set_facing(facing)
	for i in range(actors.size()):
		actors[i].position.x = 320+i*720+travel
