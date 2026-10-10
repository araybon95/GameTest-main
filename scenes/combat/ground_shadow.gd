extends Node2D
## Soft contact shadow on the common battlefield ground plane.
func _draw() -> void:
 draw_set_transform(Vector2.ZERO,0.0,Vector2(6.0,0.65))
 for index in range(5):
  draw_circle(Vector2.ZERO,13.0-index*1.7,Color(0.015,0.009,0.012,0.10))
 draw_set_transform(Vector2.ZERO,0.0,Vector2.ONE)
