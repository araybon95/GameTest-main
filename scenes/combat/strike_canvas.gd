extends Node2D
var presentation: Control
func _process(_delta: float) -> void: queue_redraw()
func _draw() -> void:
 if is_instance_valid(presentation): presentation._draw_effects(self)
