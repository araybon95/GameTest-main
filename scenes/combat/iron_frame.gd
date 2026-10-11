extends Control
## Small iron corner fittings, kept separate from the readable panel contents.
const Art = preload("res://scripts/local_dungeon_art.gd")
var painted_frame: Texture2D
var hero_id: String = ""
func _ready() -> void:
 name = "IronFittings"
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 if get_parent() is Container:
  # Container layout must not inset this overlay onto the readable contents.
  set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
  set_as_top_level(true)
  global_position = get_parent().global_position
  size = get_parent().size
 resized.connect(queue_redraw)
 set_process(get_parent() is Container)
 painted_frame = Art.texture("../panels/panel_inventory.png")
func _process(_delta: float) -> void:
 if get_parent() is Container:
  global_position = get_parent().global_position
  size = get_parent().size
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
 if not hero_id.is_empty(): draw_class_border()

static func class_color(id: String) -> Color:
 return {"crusader":Color("#B5A09D"),"occultist":Color("#A990C7"),"ranger":Color("#92AA7A"),"healer":Color("#D8C38D"),"warden":Color("#98ACB9")}.get(id,Color("#AC9776"))

func draw_class_border() -> void:
 # Ornaments stay inside a ten-pixel border, leaving labels and art unobstructed.
 var tint := class_color(hero_id)
 var owner := get_parent()
 if owner is BaseButton:
  if owner.disabled: tint = tint.darkened(0.48)
  elif owner.is_hovered() or owner.has_focus(): tint = tint.lightened(0.25)
 draw_rect(Rect2(5,5,size.x-10,size.y-10),Color("#08090B"),false,4)
 draw_rect(Rect2(5,5,size.x-10,size.y-10),tint.darkened(0.3),false,1)
 for side in [4.0,size.x-4.0]:
  var inward: float = 1.0 if side < size.x*0.5 else -1.0
  for y in range(25,int(size.y)-18,30):
   var point := Vector2(side,y)
   match hero_id:
    "crusader":
     draw_line(point-Vector2(0,11),point+Vector2(0,11),tint,2,true)
     draw_polyline(PackedVector2Array([point+Vector2(-inward*3,-5),point+Vector2(inward*4,0),point+Vector2(-inward*3,5)]),tint,1.6,true)
    "occultist":
     draw_polyline(PackedVector2Array([point+Vector2(0,-6),point+Vector2(inward*4,-2),point+Vector2(0,5),point+Vector2(0,-6),point+Vector2(-inward*3,1)]),tint,1.4,true)
    "ranger":
     draw_colored_polygon(PackedVector2Array([point-Vector2(0,6),point+Vector2(inward*4,0),point+Vector2(0,5)]),tint)
    "healer":
     draw_line(point-Vector2(0,5),point+Vector2(0,5),tint,1.6,true)
     draw_line(point-Vector2(3,0),point+Vector2(3,0),tint,1.6,true)
    _:
     draw_circle(point,2.2,tint)
 if hero_id == "occultist":
  draw_arc(Vector2(size.x*0.5,7),5,0,TAU,20,tint,1.3,true)
 elif hero_id == "crusader":
  draw_line(Vector2(size.x*.5-15,6),Vector2(size.x*.5+15,6),tint,2)
  for x in [-10,0,10]: draw_line(Vector2(size.x*.5+x-3,3),Vector2(size.x*.5+x+3,10),tint,1.5)

func draw_painted_frame() -> void:
 # Nine-slice only the border: inventory dividers and tabs never cover text.
 var source := Rect2(0,0,668,360)
 var margin: float = minf(6.0,minf(size.x,size.y)*0.15)
 var xs: Array[float] = [0.0,margin,size.x-margin,size.x]
 var ys: Array[float] = [0.0,margin,size.y-margin,size.y]
 var sx: Array[float] = [0.0,18.0,source.size.x-18.0,source.size.x]
 var sy: Array[float] = [0.0,18.0,source.size.y-18.0,source.size.y]
 for row in range(3):
  for column in range(3):
   if row == 1 and column == 1: continue
   draw_texture_rect_region(painted_frame,Rect2(xs[column],ys[row],xs[column+1]-xs[column],ys[row+1]-ys[row]),Rect2(sx[column],sy[row],sx[column+1]-sx[column],sy[row+1]-sy[row]),Color(1.7,1.6,1.5,0.9))
