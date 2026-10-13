extends Control
const Actor = preload("res://actor.gd")
var actors: Array = []
var clock := 0.0
var paused := false
var speed := 1.0
func _ready() -> void:
	text("WARDEN / LEG IN-BETWEEN STUDY",Vector2(26,24),27)
	text("Existing upper-body sequence preserved · prototype only",Vector2(27,65),17)
	for i in range(2):
		var panel := ColorRect.new()
		panel.color = Color("#28262a")
		panel.position = Vector2(20+i*630,127)
		panel.size = Vector2(610,500)
		add_child(panel)
		text("ORIGINAL / 4 POSES" if i == 0 else "CANDIDATE / 16 LEG POSES",Vector2(35+i*630,142),20)
		var actor := Actor.new()
		actor.improved = i == 1
		actor.position = Vector2(20+i*630,156)
		add_child(actor)
		actors.append(actor)
	var pause := Button.new()
	pause.text = "Pause"
	pause.toggle_mode = true
	pause.position = Vector2(27,94)
	pause.size = Vector2(105,28)
	pause.toggled.connect(func(value): paused = value)
	add_child(pause)
	var slider := HSlider.new()
	slider.position = Vector2(272,99)
	slider.size = Vector2(180,22)
	slider.min_value = 0.4
	slider.max_value = 1.2
	slider.step = 0.05
	slider.value = 1.0
	slider.value_changed.connect(func(value): speed = value)
	add_child(slider)
	text("Playback speed",Vector2(147,96),16)
	text("Arms · shield · weapon retain their original poses and timing.",Vector2(27,646),18)
	text("Three new leg drawings per transition · original upper-body sequence · isolated review candidate",Vector2(27,680),16)
func _process(delta: float) -> void:
	if not paused: clock += delta*speed
	for actor in actors: actor.set_phase(clock*6.0)
func text(value: String, position_value: Vector2, font_size: int) -> void:
	var label := Label.new()
	label.text = value
	label.position = position_value
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("#e0d1ba"))
	add_child(label)
