extends RefCounted
## Vector effects stay crisp at any resolution and never change combat state.
const ELEMENTS = {
 "fire":Color("#FF9850"),"frost":Color("#B4EDFF"),"poison":Color("#AADF72"),
 "lightning":Color("#FFF1A9"),"arcane":Color("#C4A0F3"),"heal":Color("#B7E5AC")
}

static func element(title: String, kind: String = "spell") -> String:
 if kind == "heal": return "heal"
 var text: String = title.to_lower()
 for word in ["fire","flame","ember","scorch","brand","candle","cauter"]:
  if text.contains(word): return "fire"
 for word in ["chill","frost","ice","cold","winter","moonlit"]:
  if text.contains(word): return "frost"
 for word in ["poison","venom","septic","plague"]:
  if text.contains(word): return "poison"
 for word in ["lightning","storm","thunder"]:
  if text.contains(word): return "lightning"
 return "arcane"

static func sample(presentation: Control) -> Dictionary:
 if presentation.active.is_empty() or presentation.fighters.size() < 2: return {}
 var active: Dictionary = presentation.active
 var factor: float = float(active.get("duration",presentation.duration))/presentation.duration
 var clock: float = presentation.age/maxf(0.01,factor)
 var start: Vector2 = presentation.fighters[0].position+presentation.fighters[0].size*Vector2(0.58 if active["hero"] else 0.42,0.4)
 var target: Vector2 = presentation.fighters[1].position+presentation.fighters[1].size*Vector2(0.5,0.43)
 var reaction: String = str(active.get("reaction","hurt"))
 var aim: Vector2 = target+Vector2(0,-95) if reaction == "miss" else target
 var progress: float = clampf((clock-0.13)/0.16,0.0,1.0)
 var impact: float = sin(clampf((clock-0.28)/0.27,0.0,1.0)*PI)
 return {"clock":clock,"start":start,"target":target,"aim":aim,"progress":progress,"impact":impact,"reaction":reaction,"element":element(str(active["title"]),str(active["attack_kind"]))}

static func draw(presentation: Control, canvas: Node2D) -> void:
 var data: Dictionary = sample(presentation)
 if data.is_empty(): return
 var active: Dictionary = presentation.active
 var start: Vector2 = data["start"]
 var point: Vector2 = data["target"]
 var aim: Vector2 = data["aim"]
 var clock: float = data["clock"]
 var progress: float = data["progress"]
 var strength: float = data["impact"]
 var direction: float = 1.0 if active["hero"] else -1.0
 var kind: String = active["attack_kind"]
 var blocked: bool = active.get("reaction", "") == "block" or active["kind"] == "block"
 var missed: bool = data["reaction"] == "miss"
 if kind in ["bow","arrow"]:
  if clock >= 0.13 and clock < 0.38:
   arrow(canvas,start,aim,progress,clock)
 elif kind == "spell":
  var tint: Color = ELEMENTS[data["element"]]
  spell(canvas,start,aim,progress,clock,str(data["element"]),tint,strength if not missed and not blocked else 0.0)
 elif kind == "heal":
  heal(canvas,point,clock,strength)
 elif kind == "block":
  shield(canvas,point,strength)
 elif strength > 0.0:
  if str(active["title"]).to_lower().contains("chain") and active.get("source_boss",false):
   chain(canvas,start,aim,progress,clock,strength)
  else:
   slash(canvas,aim,strength,direction,active.get("source_boss",false))
 if blocked and strength > 0.0:
  shield(canvas,point,strength)
 elif not missed and kind not in ["heal","block"] and strength > 0.0:
  sparks(canvas,point,strength,Color("#FFE1A5"),1.4 if active.get("source_boss",false) else 1.0)
  if active.get("creature","") == "howling_head":
   for i in range(7):
    var angle: float = -0.8+i*0.27
    var fang: Vector2 = point+Vector2.from_angle(angle)*(30+strength*65)
    canvas.draw_colored_polygon(PackedVector2Array([fang+Vector2(-7,-10),fang+Vector2(7,-10),fang+Vector2(0,15)]),Color(0.9,0.85,0.74,strength))

static func arrow(canvas: Node2D, start: Vector2, target: Vector2, progress: float, _clock: float) -> void:
 var axis: Vector2 = (target-start).normalized()
 var side := Vector2(-axis.y,axis.x)
 var tip: Vector2 = start.lerp(target,progress)
 for i in range(4):
  var trail: Vector2 = tip-axis*(45+i*28)
  canvas.draw_line(trail-side*2,trail-axis*25-side*2,Color(0.8,0.7,0.5,0.35-i*0.06),2,true)
 canvas.draw_line(tip-axis*75,tip,Color("#130F11"),7,true)
 canvas.draw_line(tip-axis*75,tip,Color("#E4CF9F"),3,true)
 canvas.draw_colored_polygon(PackedVector2Array([tip,tip-axis*17+side*7,tip-axis*12,tip-axis*17-side*7]),Color("#FAEDCF"))
 for offset in [-1.0,1.0]:
  canvas.draw_line(tip-axis*60,tip-axis*77+side*8*offset,Color("#C2CBCF"),3,true)

static func slash(canvas: Node2D, point: Vector2, strength: float, direction: float, heavy: bool) -> void:
 var extent: float = 155.0 if heavy else 120.0
 var points := PackedVector2Array()
 for i in range(18):
  var phase: float = i/17.0
  points.append(point+Vector2(direction*(phase-0.5)*extent*1.3,(phase-0.5)*extent*1.6+sin(phase*PI)*32))
 canvas.draw_polyline(points,Color(0.01,0.01,0.02,strength),23 if heavy else 17,true)
 canvas.draw_polyline(points,Color(0.96,0.85,0.65,strength),12 if heavy else 9,true)
 var edge := PackedVector2Array()
 for p in points: edge.append(p+Vector2(direction*9,0))
 canvas.draw_polyline(edge,Color(0.63,0.08,0.14,strength),4,true)

static func spell(canvas: Node2D, start: Vector2, target: Vector2, progress: float, clock: float, type: String, color: Color, impact: float) -> void:
 var tint: Color = color
 var flight: bool = clock >= 0.12 and clock < 0.30
 var point: Vector2 = start.lerp(target,progress)
 if type == "lightning":
  if clock >= 0.13 and clock < 0.42:
   var bolts := PackedVector2Array([start])
   var side := Vector2(-(target-start).y,(target-start).x).normalized()
   for i in range(1,13):
    var part: float = minf(progress,i/12.0)
    bolts.append(start.lerp(target,part)+side*sin(i*17.3+floor(clock*32)*0.8)*22)
   canvas.draw_polyline(bolts,Color(0.3,0.25,0.4,0.55),12,true)
   canvas.draw_polyline(bolts,tint,5,true)
   canvas.draw_polyline(bolts,Color("#FFFFED"),2,true)
 elif flight:
  var axis: Vector2 = (target-start).normalized()
  for i in range(7):
   var trail: Vector2 = point-axis*i*16+Vector2(0,sin(clock*26+i)*7)
   var trail_color: Color = tint
   trail_color.a = 0.7-i*0.085
   canvas.draw_circle(trail,maxf(2,12-i),trail_color)
  canvas.draw_circle(point,16,Color("#130F16"))
  if type == "frost":
   diamond(canvas,point,Vector2(16,23),Color("#E4FBFF"))
  else:
   canvas.draw_circle(point,12,tint)
   canvas.draw_circle(point,5,Color("#FFF4DC"))
 if impact <= 0.0: return
 tint.a = impact
 match type:
  "fire":
   for i in range(9):
    var spark: Vector2 = target+Vector2((i-4)*13,-impact*(65+sin(i*3.2)*25))
    canvas.draw_colored_polygon(PackedVector2Array([spark+Vector2(-9,24),spark+Vector2(5,-18),spark+Vector2(11,24)]),tint)
   canvas.draw_arc(target,35+impact*35,0,TAU,28,tint,4,true)
  "frost":
   for i in range(7):
    var ray: Vector2 = Vector2.from_angle(i*TAU/7.0)
    diamond(canvas,target+ray*(25+impact*60),Vector2(7,18),tint)
   canvas.draw_arc(target,40+impact*20,0,TAU,24,tint,3,true)
  "poison":
   for i in range(9):
    var bubble: Vector2 = target+Vector2(sin(i*6.4)*65,-impact*55+cos(i*2.3)*25)
    canvas.draw_circle(bubble,3+impact*7,tint,false,2,true)
  _:
   canvas.draw_arc(target,25+impact*55,clock*2,TAU+clock*2,36,tint,4,true)
   canvas.draw_arc(target,45+impact*40,-clock*3,PI-clock*3,24,tint,2,true)
   for i in range(8):
    var ray: Vector2 = Vector2.from_angle(i*TAU/8.0+clock)
    canvas.draw_line(target+ray*25,target+ray*(45+impact*40),tint,3,true)

static func heal(canvas: Node2D, point: Vector2, clock: float, strength: float) -> void:
 var color := Color(0.72,0.9,0.65,strength)
 canvas.draw_arc(point+Vector2(0,75),55,0,TAU,32,color,3,true)
 for i in range(5):
  var rising: Vector2 = point+Vector2((i-2)*25,40-fmod(clock*160+i*25,150))
  canvas.draw_line(rising-Vector2(5,0),rising+Vector2(5,0),color,3,true)
  canvas.draw_line(rising-Vector2(0,5),rising+Vector2(0,5),color,3,true)

static func shield(canvas: Node2D, point: Vector2, strength: float) -> void:
 if strength <= 0.0: return
 var vertices := PackedVector2Array([point+Vector2(-48,-60),point+Vector2(48,-60),point+Vector2(39,28),point+Vector2(0,65),point+Vector2(-39,28),point+Vector2(-48,-60)])
 canvas.draw_colored_polygon(vertices,Color(0.12,0.2,0.28,strength*0.5))
 canvas.draw_polyline(vertices,Color(0.77,0.89,1,strength),5,true)
 canvas.draw_line(point+Vector2(0,-38),point+Vector2(0,34),Color(0.87,0.93,1,strength),3,true)
 sparks(canvas,point,strength,Color("#C9E7FF"))

static func chain(canvas: Node2D, start: Vector2, target: Vector2, progress: float, clock: float, strength: float) -> void:
 for i in range(16):
  var part: float = i/15.0*progress
  var link: Vector2 = start.lerp(target,part)+Vector2(0,sin(part*PI+clock*8)*25)
  canvas.draw_arc(link,9,0,TAU,12,Color(0.65,0.7,0.72,strength),4,true)
 sparks(canvas,target,strength,Color("#EBCBC0"),1.3)

static func diamond(canvas: Node2D, point: Vector2, half: Vector2, color: Color) -> void:
 canvas.draw_colored_polygon(PackedVector2Array([point-Vector2(0,half.y),point+Vector2(half.x,0),point+Vector2(0,half.y),point-Vector2(half.x,0)]),color)

static func sparks(canvas: Node2D, point: Vector2, strength: float, color: Color, scale: float = 1.0) -> void:
 var tint: Color = color
 tint.a = strength
 for i in range(9):
  var ray := Vector2.from_angle(i*TAU/9.0+0.16)
  var distance: float = (30+strength*45)*scale
  canvas.draw_line(point+ray*distance,point+ray*(distance+12+strength*15),tint,2,true)
