extends RefCounted
## Deterministic ink, metal and elemental marks. No combat state is modified.
const ELEMENTS = {"fire":Color("#C5703A"),"frost":Color("#A9C9D2"),"poison":Color("#798B4E"),"lightning":Color("#DDD6B2"),"arcane":Color("#9C86AF"),"heal":Color("#AFBE97")}
const INK = Color("#100C10")
const BONE = Color("#CFC3A8")
const BLOOD = Color("#751E2D")

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

static func harmful_contact(active: Dictionary) -> bool:
 if str(active.get("attack_kind","sword")) in ["heal","block","object"]: return false
 if str(active.get("reaction","hurt")) in ["miss","block"] or active.get("kind","") == "block": return false
 return not (active.has("source_node") and active.has("target_node") and active["source_node"] == active["target_node"])

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
 return {"clock":clock,"start":start,"target":target,"aim":aim,"progress":progress,"impact":impact,"reaction":reaction,"harmful":harmful_contact(active),"element":element(str(active["title"]),str(active["attack_kind"]))}

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
 var blocked: bool = data["reaction"] == "block" or active["kind"] == "block" or kind == "block"
 var harmful: bool = data["harmful"]
 # Blocked projectiles stop in front of the shield; misses pass overhead.
 var flight_aim: Vector2 = aim-((aim-start).normalized()*30 if blocked else Vector2.ZERO)
 if kind in ["bow","arrow"]:
  if clock >= 0.13 and clock < 0.38: arrow(canvas,start,flight_aim,progress)
 elif kind == "spell":
  spell(canvas,start,flight_aim,progress,clock,str(data["element"]),strength if harmful else 0.0)
 elif kind == "heal":
  heal(canvas,point,clock,strength)
 elif kind == "object":
  if strength > 0.0: debris(canvas,point,strength)
 elif kind != "block" and strength > 0.0:
  if str(active["title"]).to_lower().contains("chain") and active.get("source_boss",false):
   chain(canvas,start,flight_aim,progress,clock,strength)
   if harmful: slash(canvas,point,strength,direction,true)
  elif harmful:
   slash(canvas,point,strength,direction,active.get("source_boss",false))
  elif data["reaction"] == "miss":
   swing(canvas,aim,strength,direction)
 if blocked and strength > 0.0:
  shield(canvas,point,strength)
 elif harmful and strength > 0.0:
  sparks(canvas,point,strength,BONE,1.3 if active.get("source_boss",false) else 1.0)
  if kind in ["sword","bow","arrow"]: blood_flecks(canvas,point,strength,direction)
  if active.get("creature","") == "howling_head":
   for i in range(7):
    var fang: Vector2 = point+Vector2.from_angle(-0.8+i*0.27)*(30+strength*55)
    canvas.draw_colored_polygon(PackedVector2Array([fang+Vector2(-5,-8),fang+Vector2(5,-8),fang+Vector2(0,12)]),with_alpha(BONE,strength*0.85))

static func seed_value(index: int, salt: float = 0.0) -> float:
 return fposmod(sin(index*12.9898+salt*78.233)*43758.5453,1.0)

static func with_alpha(color: Color, opacity: float) -> Color:
 var result: Color = color
 result.a = opacity
 return result

static func ragged_outline(point: Vector2, radius: Vector2, seed: int) -> PackedVector2Array:
 var points := PackedVector2Array()
 for i in range(9):
  var angle: float = i*TAU/9.0
  var uneven: float = 0.66+seed_value(seed*9+i,2.0)*0.34
  points.append(point+Vector2(cos(angle)*radius.x,sin(angle)*radius.y)*uneven)
 return points

static func slash_points(point: Vector2, direction: float, heavy: bool) -> PackedVector2Array:
 var extent: float = 147.0 if heavy else 112.0
 var points := PackedVector2Array()
 for i in range(13):
  var phase: float = i/12.0
  var jag: float = (seed_value(i,4.0)-0.5)*12.0 if i > 0 and i < 12 else 0.0
  points.append(point+Vector2(direction*((phase-0.5)*extent*1.25+jag),(phase-0.5)*extent*1.48+sin(phase*PI)*13))
 return points

static func wound_outline(points: PackedVector2Array, heavy: bool) -> PackedVector2Array:
 var outline := PackedVector2Array()
 var width: float = 15.0 if heavy else 11.0
 for i in range(points.size()):
  var axis: Vector2 = points[mini(i+1,points.size()-1)]-points[maxi(0,i-1)]
  var normal := Vector2(-axis.y,axis.x).normalized()
  outline.append(points[i]+normal*width*sin(i*PI/float(points.size()-1))*(0.55+seed_value(i,7)*0.45))
 for i in range(points.size()-1,-1,-1):
  var axis: Vector2 = points[mini(i+1,points.size()-1)]-points[maxi(0,i-1)]
  var normal := Vector2(-axis.y,axis.x).normalized()
  outline.append(points[i]-normal*width*sin(i*PI/float(points.size()-1))*0.42)
 return outline

static func arrow(canvas: Node2D, start: Vector2, target: Vector2, progress: float) -> void:
 var axis: Vector2 = (target-start).normalized()
 var side := Vector2(-axis.y,axis.x)
 var tip: Vector2 = start.lerp(target,progress)
 for i in range(3):
  var trail: Vector2 = tip-axis*(45+i*26)
  canvas.draw_line(trail-side*2,trail-axis*19-side*2,with_alpha(BONE,0.23-i*0.055),1.2,true)
 canvas.draw_line(tip-axis*75,tip,INK,7,true)
 canvas.draw_line(tip-axis*75,tip,BONE.darkened(0.25),2,true)
 canvas.draw_colored_polygon(PackedVector2Array([tip,tip-axis*16+side*6,tip-axis*11,tip-axis*16-side*6]),BONE)
 for offset in [-1.0,1.0]:
  canvas.draw_line(tip-axis*60,tip-axis*76+side*7*offset,Color("#989B91"),2,true)

static func slash(canvas: Node2D, point: Vector2, strength: float, direction: float, heavy: bool) -> void:
 var points: PackedVector2Array = slash_points(point,direction,heavy)
 canvas.draw_colored_polygon(wound_outline(points,heavy),with_alpha(INK,strength*0.95))
 canvas.draw_polyline(points,with_alpha(BLOOD,strength*0.9),4 if heavy else 3,true)
 for i in [2,5,8]:
  var edge := PackedVector2Array([points[i]+Vector2(direction*5,-2),points[i+1]+Vector2(direction*4,-2),points[i+2]+Vector2(direction*2,-1)])
  canvas.draw_polyline(edge,with_alpha(BONE,strength*0.78),1.8,true)
 for i in range(3):
  var tear: Vector2 = points[4+i*2]
  canvas.draw_line(tear,tear+Vector2(-direction*(10+i*3),9+i*4),with_alpha(INK,strength),3,true)

static func swing(canvas: Node2D, point: Vector2, strength: float, direction: float) -> void:
 var points: PackedVector2Array = slash_points(point,direction,false)
 canvas.draw_polyline(points,with_alpha(INK,strength*0.7),5,true)
 canvas.draw_polyline(points,with_alpha(BONE,strength*0.22),1,true)

static func blood_flecks(canvas: Node2D, point: Vector2, strength: float, direction: float) -> void:
 for i in range(11):
  var angle: float = (seed_value(i,9)*1.8-0.9)+(0.0 if direction > 0 else PI)
  var axis := Vector2.from_angle(angle)
  var side := Vector2(-axis.y,axis.x)
  var fleck: Vector2 = point+axis*((16+seed_value(i,11)*52)*strength)+Vector2(0,strength*strength*8)
  var length: float = 3+seed_value(i,13)*7
  canvas.draw_colored_polygon(PackedVector2Array([fleck-axis*length,fleck+side*1.5,fleck+axis*2,fleck-side*1.1]),with_alpha(BLOOD,strength*(0.55+seed_value(i,14)*0.3)))

static func spell(canvas: Node2D, start: Vector2, target: Vector2, progress: float, clock: float, type: String, impact: float) -> void:
 var color: Color = ELEMENTS[type]
 var point: Vector2 = start.lerp(target,progress)
 var axis: Vector2 = (target-start).normalized()
 if type == "lightning":
  if clock >= 0.13 and clock < 0.42:
   var bolts := PackedVector2Array([start])
   var side := Vector2(-axis.y,axis.x)
   for i in range(1,13):
    var part: float = minf(progress,i/12.0)
    bolts.append(start.lerp(target,part)+side*sin(i*17.3+floor(clock*32)*0.8)*18*sin(part*PI))
   canvas.draw_polyline(bolts,with_alpha(INK,0.9),10,true)
   canvas.draw_polyline(bolts,with_alpha(color,0.85),3,true)
   canvas.draw_polyline(bolts,with_alpha(BONE,0.8),1,true)
 elif clock >= 0.12 and clock < 0.30:
  for i in range(6):
   var trail: Vector2 = point-axis*i*14+Vector2(0,sin(clock*26+i)*5)
   var soot: Color = Color("#241F24") if type == "fire" else color.darkened(0.58)
   canvas.draw_colored_polygon(ragged_outline(trail,Vector2(11-i,9-i*0.8),i),with_alpha(soot,0.7-i*0.08))
  if type == "frost":
   diamond(canvas,point,Vector2(9,17),INK)
   diamond(canvas,point+Vector2(-1,0),Vector2(5,13),with_alpha(color,0.9))
  else:
   canvas.draw_colored_polygon(ragged_outline(point,Vector2(12,10),17),INK)
   canvas.draw_colored_polygon(ragged_outline(point,Vector2(7,8),8),color)
   canvas.draw_line(point-Vector2(3,2),point+Vector2(1,-5),with_alpha(BONE,0.72),1.3,true)
 if impact <= 0.0: return
 match type:
  "fire":
   for i in range(7):
    var smoke: Vector2 = target+Vector2((seed_value(i,17)-0.5)*90,-18-impact*(24+seed_value(i,19)*52))
    canvas.draw_colored_polygon(ragged_outline(smoke,Vector2(17+impact*11,13+impact*18),i+20),Color(0.045,0.035,0.04,impact*0.7))
   for i in range(5):
    var ember: Vector2 = target+Vector2((i-2)*14,-impact*(13+seed_value(i,21)*49))
    canvas.draw_colored_polygon(PackedVector2Array([ember+Vector2(-4,8),ember+Vector2(-3,-1),ember+Vector2(-1,-13),ember+Vector2(2,-5),ember+Vector2(5,4),ember+Vector2(2,10)]),with_alpha(color,impact*0.82))
    canvas.draw_line(ember+Vector2(0,3),ember-Vector2(1,4),Color(0.8,0.48,0.23,impact*0.72),1.4,true)
   sparks(canvas,target,impact,Color("#A66538"),0.65)
  "frost":
   for i in range(7):
    var ray := Vector2.from_angle(i*TAU/7.0+seed_value(i,24)*0.25)
    var stem: Vector2 = target+ray*(18+impact*47)
    var fracture := PackedVector2Array([target+ray*13,stem+Vector2(-ray.y,ray.x)*5,stem+ray*12])
    canvas.draw_polyline(fracture,with_alpha(INK,impact*0.85),5,true)
    canvas.draw_polyline(fracture,with_alpha(color,impact*0.88),1.7,true)
    diamond(canvas,stem+ray*10,Vector2(3,7),with_alpha(color,impact*0.65))
  "poison":
   for i in range(6):
    var stain: Vector2 = target+Vector2((seed_value(i,25)-0.5)*100,-impact*35+(seed_value(i,27)-0.5)*38)
    canvas.draw_colored_polygon(ragged_outline(stain,Vector2(15,20),i+30),with_alpha(color.darkened(0.48),impact*0.46))
    var drip := PackedVector2Array([stain+Vector2(-3,-7),stain+Vector2(4,0),stain+Vector2(-2,8),stain+Vector2(1,17)])
    canvas.draw_polyline(drip,with_alpha(color,impact*0.6),2,true)
  _:
   for i in range(7):
    var ray := Vector2.from_angle(i*TAU/7.0+seed_value(i,29)*0.2)
    var fracture := PackedVector2Array([target+ray*15,target+ray*(30+impact*23)+Vector2(-ray.y,ray.x)*8,target+ray*(43+impact*34)])
    canvas.draw_polyline(fracture,with_alpha(INK,impact*0.9),6,true)
    canvas.draw_polyline(fracture,with_alpha(color,impact*0.7),1.8,true)

static func heal(canvas: Node2D, point: Vector2, clock: float, strength: float) -> void:
 var color: Color = with_alpha(ELEMENTS["heal"],strength*0.85)
 for i in range(3):
  canvas.draw_arc(point+Vector2(0,58),40+i*7,i*2.1,i*2.1+1.1,8,color,1.6,true)
 for i in range(5):
  var rising: Vector2 = point+Vector2((i-2)*22,38-fmod(clock*120+i*23,125))
  canvas.draw_line(rising-Vector2(4,0),rising+Vector2(4,0),with_alpha(INK,strength),5,true)
  canvas.draw_line(rising-Vector2(0,5),rising+Vector2(0,5),with_alpha(INK,strength),5,true)
  canvas.draw_line(rising-Vector2(4,0),rising+Vector2(4,0),color,1.8,true)
  canvas.draw_line(rising-Vector2(0,5),rising+Vector2(0,5),color,1.8,true)

static func shield(canvas: Node2D, point: Vector2, strength: float) -> void:
 if strength <= 0.0: return
 var vertices := PackedVector2Array([point+Vector2(-41,-48),point+Vector2(41,-48),point+Vector2(33,24),point+Vector2(0,53),point+Vector2(-33,24),point+Vector2(-41,-48)])
 canvas.draw_colored_polygon(vertices,with_alpha(INK,strength*0.72))
 canvas.draw_polyline(vertices,Color(0.57,0.63,0.65,strength*0.85),3,true)
 canvas.draw_line(point+Vector2(-27,-40),point+Vector2(27,-40),with_alpha(BONE,strength*0.8),1.5,true)
 canvas.draw_line(point+Vector2(0,-31),point+Vector2(0,27),with_alpha(BONE,strength*0.7),2,true)
 sparks(canvas,point,strength,Color("#A6B2B8"),0.9)

static func chain(canvas: Node2D, start: Vector2, target: Vector2, progress: float, clock: float, strength: float) -> void:
 for i in range(16):
  var part: float = i/15.0*progress
  var link: Vector2 = start.lerp(target,part)+Vector2(0,sin(part*PI+clock*8)*25)
  canvas.draw_arc(link,7,0,TAU,8,with_alpha(INK,strength),6,true)
  canvas.draw_arc(link,7,0,TAU,8,Color(0.45,0.46,0.45,strength),2,true)

static func debris(canvas: Node2D, point: Vector2, strength: float) -> void:
 for i in range(8):
  var angle: float = i*TAU/8+seed_value(i,37)*0.4
  var chip: Vector2 = point+Vector2.from_angle(angle)*(18+strength*(24+seed_value(i,38)*18))
  var shard := PackedVector2Array([chip+Vector2(-5,-3),chip+Vector2(3,-5),chip+Vector2(5,1),chip+Vector2(-2,4)])
  canvas.draw_colored_polygon(shard,with_alpha(INK,strength))
  canvas.draw_line(shard[0],shard[1],with_alpha(BONE,strength*0.7),1.5,true)
 sparks(canvas,point,strength,BONE)

static func diamond(canvas: Node2D, point: Vector2, half: Vector2, color: Color) -> void:
 canvas.draw_colored_polygon(PackedVector2Array([point-Vector2(0,half.y),point+Vector2(half.x,0),point+Vector2(0,half.y),point-Vector2(half.x,0)]),color)

static func sparks(canvas: Node2D, point: Vector2, strength: float, color: Color, scale: float = 1.0) -> void:
 for i in range(8):
  var ray := Vector2.from_angle(i*TAU/8.0+seed_value(i,31)*0.45)
  var distance: float = (19+strength*(20+seed_value(i,33)*18))*scale
  canvas.draw_line(point+ray*distance,point+ray*(distance+3+seed_value(i,35)*9),with_alpha(color,strength*(0.4+seed_value(i,36)*0.4)),1.2,true)
