extends Control
## Map halo and illustrated seals share no state with expedition unlock rules.
var mode: String = "location"
var selected: bool = false
var sealed: bool = false
var completed: bool = false
var region: int = 0
var clock: float = 0.0
var seal: Texture2D
var emphatic: bool = false
func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 if mode == "seal": seal = load("res://assets/art_library/presentation/settlement/%s_seal.png" % ("path" if region == 1 else "village"))
func _process(delta: float) -> void:
 var settings := get_node_or_null("/root/GameSettings")
 if settings == null or settings.ambient_motion: clock += delta
 if selected or emphatic: queue_redraw()
func _draw() -> void:
 var tint := Color("#B595CC") if region == 1 else Color("#D5B276")
 if mode == "location":
  if selected:
   var outline := PackedVector2Array([Vector2(15,size.y*.62),Vector2(size.x*.13,size.y*.27),Vector2(size.x*.46,8),Vector2(size.x*.78,18),Vector2(size.x-10,size.y*.53)])
   for width in [12.0,7.0,2.0]:
    var glow := tint; glow.a = 0.10 if width > 2 else 0.75+sin(clock*1.6)*0.12
    draw_polyline(outline,glow,width,true)
  if completed:
   draw_circle(Vector2(size.x*.5,8),17,Color("#19120F"))
   draw_polyline(PackedVector2Array([Vector2(size.x*.5-8,8),Vector2(size.x*.5-1,15),Vector2(size.x*.5+10,-1)]),Color("#E5C37E"),3,true)
 else:
  if emphatic:
   var active: bool = selected or get_parent().is_hovered() or get_parent().has_focus()
   draw_circle(size*0.5,size.x*0.49,Color("#08070A"))
   if active:
    var glow := tint
    glow.a = 0.16
    draw_arc(size*0.5,size.x*0.47,0,TAU,48,glow,12,true)
   draw_arc(size*0.5,size.x*0.47,0,TAU,48,tint if active else Color("#7A6651"),4 if active else 2.5,true)
  var rect := Rect2(Vector2(9,9),size-Vector2(18,18))
  if seal != null and not (emphatic and sealed): draw_texture_rect(seal,rect,false,Color(0.45,0.43,0.46) if sealed else Color.WHITE)
  if selected: draw_arc(size*.5,size.x*.47,0,TAU,48,tint,2.5,true)
  if sealed:
   if emphatic or size.x <= 64:
    var center := size*0.5
    draw_arc(center-Vector2(0,4),9,PI,TAU,16,Color("#A49B8A"),2,true)
    draw_rect(Rect2(center-Vector2(11,1),Vector2(22,19)),Color("#191619"))
    draw_rect(Rect2(center-Vector2(11,1),Vector2(22,19)),Color("#A49B8A"),false,1.5)
    draw_circle(center+Vector2(0,7),2,Color("#A49B8A"))
    return
   for direction in [-1,1]:
    for i in range(6):
     var p := Vector2(18+i*10,18+i*10 if direction == 1 else size.y-18-i*10)
     draw_rect(Rect2(p-Vector2(5,3),Vector2(10,6)),Color("#0B0D10"),false,4)
     draw_rect(Rect2(p-Vector2(5,3),Vector2(10,6)),Color("#92948F"),false,1.5)
  elif completed: draw_polyline(PackedVector2Array([Vector2(27,65),Vector2(37,76),Vector2(66,46)]),Color("#E5C37E"),4,true)
