extends ColorRect
## A short presentation fade never owns or changes navigation state.
func _ready() -> void:
	name = "SceneArrival"
	color = Color.BLACK
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 120
	var fade := create_tween()
	fade.tween_property(self,"modulate:a",0.0,0.24)
	fade.tween_callback(queue_free)
