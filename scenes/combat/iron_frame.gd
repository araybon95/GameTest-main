extends Control
## Small iron corner fittings, kept separate from the readable panel contents.
func _ready() -> void:
 name = "IronFittings"
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 resized.connect(queue_redraw)
func _draw() -> void:
 var dark := Color("#080A0D")
 var edge := Color("#59606A")
 var light := Color("#A49D8D")
 for point in [Vector2(6,6),Vector2(size.x-6,6),Vector2(6,size.y-6),Vector2(size.x-6,size.y-6)]:
  var direction := Vector2(1 if point.x < size.x*.5 else -1,1 if point.y < size.y*.5 else -1)
  draw_line(point,point+Vector2(direction.x*17,0),dark,5)
  draw_line(point,point+Vector2(0,direction.y*17),dark,5)
  draw_line(point,point+Vector2(direction.x*17,0),edge,2)
  draw_line(point,point+Vector2(0,direction.y*17),edge,2)
  draw_circle(point+direction*3,2.0,light)
 var center := Vector2(size.x*.5,2)
 draw_colored_polygon(PackedVector2Array([center+Vector2(-5,0),center+Vector2(0,5),center+Vector2(5,0)]),edge)
