extends Node2D
## Standalone visual experiment; no gameplay state or combat controller dependency.
const ORDER = ["slash","heavy","bash"]
const TITLES = {"slash":"SLASH","heavy":"HEAVY STRIKE","bash":"SHIELD BASH"}
const TIMINGS = {
 "slash":{"release":0.18,"impact":0.34,"hold":0.12,"duration":0.85,"travel":95.0,"recoil":22.0},
 "heavy":{"release":0.48,"impact":0.68,"hold":0.22,"duration":1.4,"travel":115.0,"recoil":40.0},
 "bash":{"release":0.27,"impact":0.43,"hold":0.18,"duration":1.1,"travel":120.0,"recoil":52.0},
}
const POSE_SCALES = [1.0,1.0,1.0,1.33,1.13,1.16,1.0,1.13,1.0]
const REGIONS = [
 Rect2i(45,27,364,339),Rect2i(511,27,468,342),Rect2i(1057,28,338,341),
 Rect2i(60,397,310,314),Rect2i(512,431,462,304),Rect2i(1051,439,391,296),
 Rect2i(24,729,385,343),Rect2i(515,729,479,344),Rect2i(1052,730,381,343),
]
const SLOT = 3.0
var elapsed: float = 0.0
var reduced_motion: bool = false
var poses: Array[Image] = []
var anchors: Array[float] = []
var enemy: Image
var enemy_hurt: Image
var backdrop: Image
var idle: Image
var current_texture: ImageTexture
static func sample(skill: String, time: float, animate: bool = true) -> Dictionary:
 var timing: Dictionary = TIMINGS[skill]
 var phase: String = "windup" if time < timing.release else "release" if time < timing.impact else "hold" if time < timing.impact+timing.hold else "recover"
 var windup: float = clampf(time/timing.release,0,1)
 var flight: float = clampf((time-timing.release)/(timing.impact-timing.release),0,1)
 var recovery: float = clampf((time-timing.impact-timing.hold)/(timing.duration-timing.impact-timing.hold),0,1)
 var approach: float = smoothstep(0,1,flight)
 var zoom: float = (0.16 if skill == "heavy" else 0.12)*smoothstep(0,0.12,time)*(1.0-smoothstep(0.0,1.0,recovery))
 var shift: float = -14.0*windup if phase == "windup" else lerpf(-14,timing.travel,approach) if phase == "release" else timing.travel*(1.0-recovery)
 var recoil: float = timing.recoil*(1.0-recovery) if time >= timing.impact else 0.0
 var index: int = ORDER.find(skill)*3+(0 if phase == "windup" else 1 if phase in ["release","hold"] else 2)
 return {"pose":index,"phase":phase,"zoom":1.0+zoom if animate else 1.0,"source_shift":shift if animate else 0.0,"target_shift":recoil if animate else 0.0,"ground":390.0,"contact":phase == "hold","active":time < timing.duration}
static func blood_particles(skill: String, time: float, animate: bool = true) -> Array[Dictionary]:
 var age: float = time-float(TIMINGS[skill].impact)
 var particles: Array[Dictionary] = []
 if not animate or age < 0.0 or age > 0.8: return particles
 var count: int = 26 if skill == "heavy" else 16 if skill == "slash" else 8
 for i in range(count):
  var fraction: float = float((i*7)%count)/count
  var angle: float = lerpf(-2.1,0.4,fraction) if skill == "heavy" else lerpf(-0.95,0.15,fraction) if skill == "slash" else lerpf(-1.6,-0.25,fraction)
  var speed: float = 95.0+float((i*37)%110)
  if skill == "bash": speed *= 0.58
  var velocity: Vector2 = Vector2(cos(angle),sin(angle))*speed
  var offset: Vector2 = velocity*age+Vector2(0,400.0*age*age)
  var radius: float = (2.5+float(i%4)*0.8 if skill == "heavy" else 1.5+float(i%3)*0.65 if skill == "slash" else 1.2+float(i%2)*0.6)
  particles.append({"offset":offset,"tail":(velocity+Vector2(0,800*age)).normalized()*(8.0 if skill == "heavy" else 5.0),"radius":radius,"alpha":1.0-smoothstep(0.34,0.8,age),"chunk":skill == "heavy" and i%6 == 0})
 return particles
func blood_stamp(canvas: Image, centre: Vector2, radius: Vector2, color: Color) -> void:
 for y in range(floori(centre.y-radius.y),ceili(centre.y+radius.y)+1):
  for x in range(floori(centre.x-radius.x),ceili(centre.x+radius.x)+1):
   if x < 24 or x >= 776 or y < 48 or y >= 412: continue
   var distance: float = ((Vector2(x,y)-centre)/radius).length()
   if distance > 1.0: continue
   var ink: Color = color
   ink.a *= 1.0-smoothstep(0.65,1.0,distance)
   canvas.set_pixel(x,y,canvas.get_pixel(x,y).blend(ink))
func draw_blood(canvas: Image, skill: String, time: float, animate: bool) -> void:
 var age: float = time-float(TIMINGS[skill].impact)
 if age < 0 or age > 1.35: return
 var hit: Dictionary = sample(skill,TIMINGS[skill].impact,animate)
 var half_width: float = enemy_hurt.get_width()*0.77*hit.zoom*0.5
 var target_x: float = clampf(400+(550+hit.target_shift-400)*hit.zoom,24+half_width,776-half_width)
 var origin := Vector2(target_x-65,280 if skill == "heavy" else 218 if skill == "slash" else 245)
 if not animate:
  if age < 0.16: blood_stamp(canvas,origin,Vector2(8,5),Color("#721b2a"))
  return
 for particle in blood_particles(skill,time):
  var point: Vector2 = origin+particle.offset
  if point.y >= 390: continue
  var radius: float = particle.radius
  var color := Color("#681323") if particle.chunk else Color("#922b3a")
  color.a = particle.alpha*0.92
  for step in range(4):
   var tail_point: Vector2 = point-particle.tail*float(step)/3.0
   blood_stamp(canvas,tail_point,Vector2(radius,radius*0.7)*(1.0-step*0.15),color)
 # Low, irregular stains linger briefly after the airborne spray.
 if age > (0.42 if skill == "heavy" else 0.64 if skill == "slash" else 0.72):
  var fade: float = 1.0-smoothstep(0.75,1.35,age)
  var size: float = 13.0 if skill == "heavy" else 8.0 if skill == "slash" else 4.0
  for i in range(4):
   var color := Color("#5c1420")
   color.a = fade*0.8
   blood_stamp(canvas,Vector2(origin.x+12+i*11,393+(i%2)*2),Vector2(size*(1.0-i*0.14),2.5+(i%2)),color)
func load_assets() -> void:
 if not poses.is_empty(): return
 var sheet: Image = Image.load_from_file("res://assets/warden_attacks.png")
 assert(sheet != null and not sheet.is_empty(),"Warden art missing")
 for cell in REGIONS:
  var region: Image = sheet.get_region(cell)
  var bounds: Rect2i = region.get_used_rect()
  var pose: Image = region.get_region(bounds)
  assert(not pose.is_empty())
  poses.append(pose)
  var boots: Rect2i = pose.get_region(Rect2i(0,pose.get_height()-8,pose.get_width(),8)).get_used_rect()
  anchors.append(boots.position.x+boots.size.x*0.5)
 var raider: Image = Image.load_from_file("res://assets/raider.png")
 enemy = raider.get_region(Rect2i(0,0,380,380))
 enemy = enemy.get_region(enemy.get_used_rect())
 enemy_hurt = raider.get_region(Rect2i(0,750,405,336))
 enemy_hurt = enemy_hurt.get_region(enemy_hurt.get_used_rect())
 backdrop = Image.load_from_file("res://assets/backdrop.png")
 backdrop.convert(Image.FORMAT_RGBA8)
 backdrop.resize(800,420,Image.INTERPOLATE_LANCZOS)
 backdrop.adjust_bcs(0.34,1.0,0.6)
 idle = poses[2]
func place(canvas: Image, source: Image, foot: Vector2, scale_factor: float, anchor: float = -1.0, brightness: float = 1.0) -> void:
 var image: Image = source.duplicate()
 image.resize(maxi(1,roundi(source.get_width()*scale_factor)),maxi(1,roundi(source.get_height()*scale_factor)),Image.INTERPOLATE_LANCZOS)
 if brightness != 1.0: image.adjust_bcs(brightness,1.0,0.8)
 var centre: float = anchor*scale_factor if anchor >= 0 else image.get_width()*0.5
 canvas.blend_rect(image,Rect2i(Vector2i.ZERO,image.get_size()),Vector2i(roundi(foot.x-centre),roundi(foot.y-image.get_height())))
func fitted_scale(pose: int, zoom: float) -> float:
 return minf(0.78*zoom*POSE_SCALES[pose],342.0/poses[pose].get_height())
func render(skill: String, time: float, animate: bool = true) -> Image:
 load_assets()
 var state: Dictionary = sample(skill,time,animate)
 var canvas := Image.create(800,540,false,Image.FORMAT_RGBA8)
 canvas.fill(Color("#100e13"))
 var scenery: Image = backdrop.duplicate()
 var camera: float = 1.0+(state.zoom-1.0)*0.45
 scenery.resize(roundi(800*camera),roundi(420*camera),Image.INTERPOLATE_BILINEAR)
 canvas.blend_rect(scenery,Rect2i((scenery.get_width()-800)/2,(scenery.get_height()-420)/2,800,420),Vector2i.ZERO)
 # Quiet silhouettes remain behind the isolated spotlight.
 place(canvas,idle,Vector2(90,390),0.37,-1,0.18)
 place(canvas,enemy,Vector2(740,390),0.38,-1,0.18)
 var warden_x: float = 400+(225+state.source_shift-400)*state.zoom
 var enemy_x: float = 400+(550+state.target_shift-400)*state.zoom
 var pose: int = state.pose if state.active else 2
 var warden_scale: float = fitted_scale(pose,state.zoom)
 warden_x = clampf(warden_x,24+anchors[pose]*warden_scale,776-(poses[pose].get_width()-anchors[pose])*warden_scale)
 var target: Image = enemy_hurt if time >= TIMINGS[skill].impact and state.active else enemy
 var target_half: float = target.get_width()*0.77*state.zoom*0.5
 enemy_x = clampf(enemy_x,24+target_half,776-target_half)
 place(canvas,poses[pose],Vector2(warden_x,state.ground),warden_scale,anchors[pose])
 place(canvas,enemy_hurt if time >= TIMINGS[skill].impact and state.active else enemy,Vector2(enemy_x,state.ground),0.77*state.zoom)
 draw_blood(canvas,skill,time,animate)
 # HUD is drawn after the camera composition, at fixed screen coordinates.
 canvas.fill_rect(Rect2i(0,420,800,120),Color("#171318"))
 canvas.fill_rect(Rect2i(35,475,265,7),Color("#735347"))
 canvas.fill_rect(Rect2i(500,475,265,7),Color("#735347"))
 return canvas
func _ready() -> void:
 load_assets()
func _process(delta: float) -> void:
 elapsed += delta
 var slot: int = int(elapsed/SLOT)%3
 var image: Image = render(ORDER[slot],fmod(elapsed,SLOT),not reduced_motion)
 if current_texture == null: current_texture = ImageTexture.create_from_image(image)
 else: current_texture.update(image)
 queue_redraw()
func _draw() -> void:
 if current_texture == null: return
 draw_texture(current_texture,Vector2.ZERO)
 var skill: String = ORDER[int(elapsed/SLOT)%3]
 draw_string(ThemeDB.fallback_font,Vector2(35,25),"WARDEN · "+TITLES[skill],HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("#dec58d"))
 draw_string(ThemeDB.fallback_font,Vector2(35,454),"WARDEN",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("#dec58d"))
 draw_string(ThemeDB.fallback_font,Vector2(590,454),"ASH RAIDER",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("#dec58d"))
 draw_string(ThemeDB.fallback_font,Vector2(35,515),"EXPERIMENTAL · 1 Slash / 2 Heavy / 3 Bash · R reduced motion",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("#c5b9ab"))
func _unhandled_input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed:
  if event.keycode in [KEY_1,KEY_2,KEY_3]: elapsed = float(event.keycode-KEY_1)*SLOT
  if event.keycode == KEY_R: reduced_motion = not reduced_motion
