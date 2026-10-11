extends Control
## Short ink-and-ember bursts at application/tick time, independent of persistent badges.
const Visual = preload("res://scenes/combat/status_visual.gd")
var bursts: Array[Dictionary] = []
const LIFETIME: float = 0.65

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 44

func pulse(target: Control, effect: String) -> void:
	if not is_instance_valid(target) or not Visual.COLORS.has(effect): return
	if bursts.size() >= 12: bursts.pop_front()
	bursts.append({"rect":target.get_global_rect(),"effect":effect,"age":0.0})
	queue_redraw()

func _process(delta: float) -> void:
	var was_active: bool = not bursts.is_empty()
	for index in range(bursts.size()-1,-1,-1):
		bursts[index]["age"] += delta
		if float(bursts[index]["age"]) >= LIFETIME: bursts.remove_at(index)
	# Also clear the final rendered frame when the last burst expires.
	if was_active: queue_redraw()

func _draw() -> void:
	for burst in bursts:
		var rect: Rect2 = burst["rect"]
		rect.position -= global_position
		var age: float = burst["age"]
		var alpha: float = 1.0-smoothstep(0.2,LIFETIME,age)
		draw_set_transform(rect.position)
		for mark in Visual.effect_marks(str(burst["effect"]),rect.size,age*3.0):
			var tint: Color = mark["color"]
			tint.a *= alpha
			if mark["filled"]: draw_colored_polygon(mark["points"],tint)
			else: draw_polyline(mark["points"],tint,float(mark["width"])*1.7,true)
		draw_set_transform(Vector2.ZERO)
