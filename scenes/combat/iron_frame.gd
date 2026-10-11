extends Control
## Small iron corner fittings, kept separate from the readable panel contents.
const Art = preload("res://scripts/local_dungeon_art.gd")
var painted_frame: Texture2D
func _ready() -> void:
 name = "IronFittings"
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 resized.connect(queue_redraw)
 painted_frame = Art.texture("../panels/panel_inventory.png")
func _draw() -> void:
 if painted_frame != null: draw_painted_frame()
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

func draw_painted_frame() -> void:
 # Nine-slice only the border: inventory dividers and tabs never cover text.
 var source := Rect2(0,0,668,360)
 var margin: float = minf(18.0,minf(size.x,size.y)*0.25)
 var xs: Array[float] = [0.0,margin,size.x-margin,size.x]
 var ys: Array[float] = [0.0,margin,size.y-margin,size.y]
 var sx: Array[float] = [0.0,18.0,source.size.x-18.0,source.size.x]
 var sy: Array[float] = [0.0,18.0,source.size.y-18.0,source.size.y]
 for row in range(3):
  for column in range(3):
   if row == 1 and column == 1: continue
   draw_texture_rect_region(painted_frame,Rect2(xs[column],ys[row],xs[column+1]-xs[column],ys[row+1]-ys[row]),Rect2(sx[column],sy[row],sx[column+1]-sx[column],sy[row+1]-sy[row]),Color(1.7,1.6,1.5,0.9))
