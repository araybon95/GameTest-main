extends Control
const Actor = preload("res://actor.gd")
const Appearance = preload("res://appearance.gd")
var appearance: Resource
var walker: Node2D
var fighter: Node2D
var paused: bool = false
var actors: Array[Node2D] = []
var selectors: Dictionary = {}
var status: Label
var reward_toggle: CheckBox

func _ready() -> void:
	var background := TextureRect.new()
	background.texture = preload("res://assets/room.png")
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.modulate = Color(0.42,0.38,0.38)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label_at("WARDEN · PAINTED MOVEMENT & EQUIPMENT",Vector2(40,22),1360,29)
	label_at("Swap weapons and cosmetics while the same painted stride keeps moving",Vector2(40,70),1360,21)
	label_at("WALKING",Vector2(40,132),640,22)
	label_at("COMBAT",Vector2(760,132),640,22)
	appearance = Appearance.new()
	walker = Actor.new()
	walker.appearance = appearance
	walker.position = Vector2(360,685)
	walker.scale = Vector2.ONE*1.15
	add_child(walker)
	walker.set_motion("walk")
	fighter = Actor.new()
	fighter.appearance = appearance
	fighter.position = Vector2(1080,685)
	fighter.scale = Vector2.ONE*1.15
	add_child(fighter)
	actors = [walker,fighter]
	var button := Button.new()
	button.text = "Preview attack"
	button.position = Vector2(935,704)
	button.size = Vector2(290,46)
	button.add_theme_font_size_override("font_size",20)
	button.pressed.connect(fighter.attack)
	add_child(button)
	var face := CheckBox.new()
	face.text = "Face left"
	face.position = Vector2(210,704)
	face.add_theme_font_size_override("font_size",20)
	face.toggled.connect(func(value): walker.set_facing(-1 if value else 1))
	add_child(face)
	var freeze := CheckBox.new()
	freeze.text = "Pause"
	freeze.position = Vector2(405,704)
	freeze.add_theme_font_size_override("font_size",20)
	freeze.toggled.connect(func(value): paused = value)
	add_child(freeze)
	selector("WEAPON","weapon",Vector2(40,765),["Gem mace","Double-headed axe"])
	selector("HELMET","helmet",Vector2(360,765),["Original greathelm","Wolf Warhelm"])
	selector("CLOAK","cloak",Vector2(680,765),["Oxblood cloak","Crowned Mantle"])
	reward_toggle = CheckBox.new()
	reward_toggle.text = "Preview boss cosmetics"
	reward_toggle.position = Vector2(1020,787)
	reward_toggle.add_theme_font_size_override("font_size",20)
	reward_toggle.toggled.connect(appearance.set_reward_available)
	add_child(reward_toggle)
	status = label_at("",Vector2(40,859),1360,18)
	appearance.appearance_changed.connect(refresh_controls)
	refresh_controls()

func label_at(text: String, position_value: Vector2, width: float, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.position = position_value
	label.size = Vector2(width,40)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("#ecdfcd"))
	add_child(label)
	return label

func selector(title: String, slot: String, origin: Vector2, choices: Array) -> void:
	label_at(title,origin,280,17)
	var field := OptionButton.new()
	field.position = origin+Vector2(0,31)
	field.size = Vector2(280,46)
	field.add_theme_font_size_override("font_size",20)
	for choice in choices:
		field.add_item(choice)
	field.item_selected.connect(func(index): appearance.set_slot(slot,Appearance.VALID[slot][index]))
	selectors[slot] = field
	add_child(field)

func refresh_controls() -> void:
	for slot in selectors:
		selectors[slot].select(Appearance.VALID[slot].find(appearance.get(slot)))
		if slot != "weapon":
			selectors[slot].set_item_disabled(1,not appearance.reward_available)
	reward_toggle.set_pressed_no_signal(appearance.reward_available)
	status.text = "Both views share the equipped look · " + ("Boss cosmetics available in this preview" if appearance.reward_available else "Stock cosmetics · Enable boss preview to try the reward set")

func _process(delta: float) -> void:
	if not paused:
		for actor in actors:
			actor.advance(delta)
