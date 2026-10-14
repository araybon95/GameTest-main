extends Node2D
## GPU-drawn approved poses. Presentation only; never accesses combat state or RNG.
const ART = "res://assets/art_library/executions/warden/"
const DURATION = 2.4
const FINAL_HIT = 0.95
static var bodies: Array[Texture2D] = []
static var targets: Array[Texture2D] = []
static var contact: Texture2D
var age: float = 0.0
var animate: bool = true
var corpse_only: bool = false
func crop(sheet: Image, rect: Rect2i) -> Texture2D:
 var part: Image = sheet.get_region(rect)
 return ImageTexture.create_from_image(part.get_region(part.get_used_rect()))
func _ready() -> void:
 if not bodies.is_empty(): return
 var sheet: Image = load(ART+"poses.png").get_image()
 var windup: Image = load(ART+"windup.png").get_image()
 var raised := Image.create(382,465,false,Image.FORMAT_RGBA8)
 raised.blend_rect(windup,Rect2i(560,0,320,465),Vector2i(62,0))
 raised.blend_rect(windup,Rect2i(498,270,62,195),Vector2i(0,270))
 var attacks: Image = load(ART+"attacks.png").get_image()
 bodies.append(crop(attacks,Rect2i(1057,28,338,341)))
 bodies.append(crop(attacks,Rect2i(515,729,479,344)))
 bodies.append(ImageTexture.create_from_image(raised.get_region(raised.get_used_rect())))
 bodies.append(crop(sheet,Rect2i(895,150,485,320)))
 bodies.append(crop(sheet,Rect2i(1380,85,345,385)))
 targets.append(crop(load(ART+"raider.png").get_image(),Rect2i(0,0,380,380)))
 for rect in [Rect2i(0,505,452,360),Rect2i(460,525,420,345),Rect2i(890,490,430,375),Rect2i(1320,690,454,187)]:
  targets.append(crop(sheet,rect))
 contact = ImageTexture.create_from_image(load(ART+"contact.png").get_image().get_region(Rect2i(23,2,1492,965)))
func set_frame(time: float, motion: bool) -> void:
 age = time
 animate = motion
 queue_redraw()
func place(texture: Texture2D, foot: Vector2, scale_factor: float) -> void:
 var dimensions := texture.get_size()*scale_factor
 draw_texture_rect(texture,Rect2(foot-Vector2(dimensions.x*0.5,dimensions.y),dimensions),false)
func _draw() -> void:
 if bodies.is_empty(): return
 # Keep all execution artwork and gore inside the battlefield, above the HUD.
 draw_set_transform(Vector2(500,-18.5),0,Vector2(1.15,1.15))
 if corpse_only:
  var held_zoom: float = 1.08 if animate else 1.0
  place(targets[4],Vector2(400+140*held_zoom,390),0.7*held_zoom)
  pool()
  return
 draw_rect(Rect2(-435,16,1670,522),Color(0.025,0.015,0.02,0.80))
 var zoom: float = (1.0+0.16*smoothstep(0.0,0.4,age) if age < 1.5 else lerpf(1.16,1.08,smoothstep(1.5,1.8,age))) if animate else 1.0
 var source_index: int = 0 if age < 0.12 else 1 if age < 0.42 else 2 if age < FINAL_HIT else 3 if age < 1.5 else 4
 var target_index: int = 0 if age < 0.29 else 1 if age < 0.42 else 2 if age < FINAL_HIT else 3 if age < 1.18 else 4
 var shift: float = 65*smoothstep(0.05,0.25,age)+65*smoothstep(0.12,0.22,age)*(1-smoothstep(0.34,0.58,age)) if animate else 130.0 if source_index == 1 else 0.0
 var shake: float = sin((age-FINAL_HIT)*110)*4*(1-smoothstep(FINAL_HIT,1.1,age)) if animate and age >= FINAL_HIT and age < 1.1 else 0.0
 if age >= FINAL_HIT and age < FINAL_HIT+0.13:
  var pair_scale: float = minf(600.0/contact.get_width(),315.0/contact.get_height())
  place(contact,Vector2(420+shake,390+(contact.get_height()-932)*pair_scale),pair_scale)
 else:
  var body: Texture2D = bodies[source_index]
  var body_scale: float = minf([0.78,0.78,0.65,0.72,0.64][source_index]*zoom,342.0/body.get_height())
  var half: float = body.get_width()*body_scale*0.5
  place(body,Vector2(clampf(400+(220+shift-400)*zoom,24+half,776-half),390),body_scale)
  var target: Texture2D = targets[target_index]
  var target_scale: float = [0.77,0.6,0.6,0.62,0.7][target_index]*zoom
  var target_half: float = target.get_width()*target_scale*0.5
  place(target,Vector2(clampf(400+140*zoom,24+target_half,776-target_half)+shake,390),target_scale)
 gore()
func pool() -> void:
 for i in range(6):
  draw_set_transform(Vector2(500,-18.5)+Vector2(510+i*13,390+(i%2)*3)*1.15,0,Vector2(1.15,1.15)*Vector2(23-i*2,4+i%3))
  draw_circle(Vector2.ZERO,1,Color("#4a0b14"))
 draw_set_transform(Vector2(500,-18.5),0,Vector2(1.15,1.15))
func gore() -> void:
 var elapsed: float = age-FINAL_HIT
 if elapsed < 0: return
 if animate and elapsed <= 0.72:
  for i in range(54):
   var angle: float = lerpf(-2.9,-0.1,float((i*17)%54)/53.0)
   var velocity := Vector2(-absf(cos(angle)),sin(angle))*(110+float((i*43)%155))
   var color := Color("#a99a7b") if i%9 == 0 else Color("#791322")
   color.a = (1-smoothstep(0.26,0.72,elapsed))*0.95
   draw_circle(Vector2(518,220)+velocity*elapsed+Vector2(0,500*elapsed*elapsed),2+float(i%5)*0.75,color)
 if elapsed >= 0.12: pool()
