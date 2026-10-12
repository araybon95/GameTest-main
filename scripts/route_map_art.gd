extends RefCounted
## Shared cartographic skin for stationary and moving exploration maps.
static func backing(canvas: Control) -> void:
 canvas.draw_rect(Rect2(Vector2.ZERO,canvas.size),Color("#141114"))
 for x in range(12,int(canvas.size.x),28):
  canvas.draw_line(Vector2(x,6),Vector2(x,canvas.size.y-6),Color(0.48,0.42,0.35,0.055),1)
 for y in range(8,int(canvas.size.y),28):
  canvas.draw_line(Vector2(8,y),Vector2(canvas.size.x-8,y),Color(0.48,0.42,0.35,0.055),1)
 var center := canvas.size-Vector2(35,32)
 canvas.draw_arc(center,19,0,TAU,32,Color("#39302C"),1,true)
 for axis in [Vector2(0,24),Vector2(24,0)]: canvas.draw_line(center-axis,center+axis,Color("#4F4135"),1,true)
 canvas.draw_colored_polygon(PackedVector2Array([center+Vector2(0,-18),center+Vector2(-4,5),center+Vector2(4,5)]),Color("#746044"))

static func corridor(canvas: Control, start: Vector2, end: Vector2, selected: bool = false) -> void:
 canvas.draw_line(start,end,Color("#07060A"),14,true)
 canvas.draw_line(start,end,Color("#5B4C3B") if selected else Color("#393337"),10,true)
 var length: float = start.distance_to(end)
 for i in range(6,int(length),12):
  var point: Vector2 = start.lerp(end,float(i)/maxf(1,length))
  canvas.draw_rect(Rect2(point-Vector2(4,4),Vector2(8,8)),Color("#A28B60") if selected else Color("#625953"))
  canvas.draw_line(point-Vector2(3,3),point+Vector2(3,-3),Color(0.84,0.77,0.62,0.18),1)
 if selected: canvas.draw_line(start,end,Color("#DFC28D"),1,true)

static func room(canvas: Control, rect: Rect2, data: Dictionary, current: bool = false) -> void:
 var kind: String = str(data.get("kind","entry"))
 var cleared: bool = bool(data.get("cleared",false))
 var tint: Color = {"battle":Color("#D3746C"),"boss":Color("#E59764"),"event":Color("#B99ED8"),"camp":Color("#A7BF83"),"stairs":Color("#91BDCF"),"treasure":Color("#E5C16E")}.get(kind,Color("#A99C87"))
 if cleared: tint = tint.lerp(Color("#8D8477"),0.75)
 canvas.draw_rect(rect.grow(3),Color("#070609"))
 canvas.draw_rect(rect,Color("#211A20"))
 canvas.draw_rect(rect,tint.darkened(0.43),false,2)
 canvas.draw_rect(rect.grow(-3),Color("#675345"),false,1)
 canvas.draw_line(rect.position+Vector2(2,2),rect.position+Vector2(rect.size.x-2,2),tint.lightened(0.13),1)
 var scale: float = minf(rect.size.x,rect.size.y)/32.0
 canvas.draw_set_transform(rect.get_center(),0,Vector2.ONE*scale)
 match kind:
  "battle","boss":
   for direction in [-1,1]:
    canvas.draw_line(Vector2(-8*direction,8),Vector2(8*direction,-8),tint,2,true)
    canvas.draw_line(Vector2(-7*direction,2),Vector2(-2*direction,7),tint,2,true)
   if kind == "boss":
    canvas.draw_colored_polygon(PackedVector2Array([Vector2(-10,-8),Vector2(-11,-14),Vector2(-5,-11),Vector2(0,-16),Vector2(5,-11),Vector2(11,-14),Vector2(10,-8)]),tint)
  "event": canvas.draw_string(ThemeDB.fallback_font,Vector2(-6,8),"?",HORIZONTAL_ALIGNMENT_LEFT,-1,23,tint)
  "camp":
   canvas.draw_colored_polygon(PackedVector2Array([Vector2(-8,5),Vector2(-5,-4),Vector2(-1,0),Vector2(3,-11),Vector2(8,-1),Vector2(6,6),Vector2(0,9)]),tint)
   canvas.draw_line(Vector2(-10,11),Vector2(10,11),Color("#AF8A58"),2,true)
  "treasure":
   canvas.draw_rect(Rect2(-10,-6,20,16),tint,false,2)
   canvas.draw_line(Vector2(-10,-1),Vector2(10,-1),tint,2)
   canvas.draw_rect(Rect2(-2,-3,4,7),tint)
  "stairs":
   for step in range(4): canvas.draw_line(Vector2(-10+step*4,-8+step*5),Vector2(10,-8+step*5),tint,2)
  _: canvas.draw_rect(Rect2(-6,-10,12,20),tint,false,2)
 canvas.draw_set_transform(Vector2.ZERO,0,Vector2.ONE)
 if data.get("merchant_orb",false):
  var point := rect.position+Vector2(rect.size.x,0)
  canvas.draw_circle(point,5,Color("#0B1520"))
  canvas.draw_arc(point,4,0,TAU,16,Color("#82CFE2"),1.5,true)
 if current: canvas.draw_rect(rect.grow(5),Color("#E9C786"),false,1.5)

static func party(canvas: Control, point: Vector2) -> void:
 canvas.draw_circle(point,10,Color(0.94,0.72,0.35,0.13))
 canvas.draw_circle(point,7,Color("#08070B"))
 canvas.draw_colored_polygon(PackedVector2Array([point+Vector2(0,-6),point+Vector2(5,0),point+Vector2(0,6),point+Vector2(-5,0)]),Color("#FFE0A4"))
 canvas.draw_arc(point,10,0,TAU,28,Color("#D2AC68"),1.5,true)
