extends Node2D
## Isolated visual study. No gameplay controller, damage, RNG or rewards.
const Builds = preload("res://scripts/party_builds.gd")
const MeshMotion = preload("res://scripts/warden_transitions.gd")
const Timeline = preload("res://experimental/ranger_showcase/timeline.gd")
const GROUND = 580.0
const SOURCE = Vector2(330,GROUND)
const TARGET = Vector2(940,GROUND)
const RANGER_REGIONS = [Rect2i(63,10,471,482),Rect2i(580,10,419,482),Rect2i(1107,26,367,466),Rect2i(62,485,455,494),Rect2i(578,486,446,493),Rect2i(1107,527,405,452)]
const RANGER_ANCHORS = [254,770,1305,254,770,1305]
const TARGET_REGIONS = [Rect2i(132,59,354,463),Rect2i(635,65,316,461),Rect2i(1152,158,367,376),Rect2i(41,672,489,244),Rect2i(550,736,610,227)]
const TARGET_ANCHORS = [310,819,1332,300,850]
# Wounds follow the front abdomen and center of the face in each painted pose.
const GUT_POINTS = [Vector2(270,260),Vector2(750,277),Vector2(1278,341),Vector2(226,812),Vector2(804,870)]
const FACE_POINTS = [Vector2.ZERO,Vector2(729,130),Vector2(1230,216),Vector2(130,762),Vector2(641,841)]
var mode: int = 0
var age: float = -0.25
var paused: bool = false
var reduced: bool = false
var elapsed: float = 0.0
var source_frames: Array[Texture2D] = []
var target_frames: Array[Texture2D] = []
var target_regions: Array = TARGET_REGIONS.duplicate()
var target_anchors: Array = TARGET_ANCHORS.duplicate()
var target_scales: Array[float] = []
var gut_points: Array = GUT_POINTS.duplicate()
var face_points: Array = FACE_POINTS.duplicate()
const FACE_TAILS = [Vector2.ZERO,Vector2(-20,-73),Vector2(-25,-68),Vector2(-76,8),Vector2(-76,-5)]
var bow_frames: Dictionary = {}
var target_idle: Texture2D
var cleaver: Texture2D
var backdrop: Texture2D
var meshes: Array[ArrayMesh] = []
var font: Font
func registered(image: Image, region: Rect2i, absolute_anchor: float) -> Texture2D:
 var local_anchor: float = absolute_anchor-region.position.x
 var left: int = int(maxf(0,region.size.x-2*local_anchor))
 var right: int = int(maxf(0,2*local_anchor-region.size.x))
 var result := Image.create(region.size.x+left+right,region.size.y,false,Image.FORMAT_RGBA8)
 result.blit_rect(image,region,Vector2i(left,0))
 return ImageTexture.create_from_image(result)
func _ready() -> void:
 font = ThemeDB.fallback_font
 backdrop = load("res://assets/art_library/generated/bandit_battle_stage.png")
 var ranger: Image = Image.load_from_file(ProjectSettings.globalize_path("res://experimental/ranger_showcase/assets/ranger-execution.png"))
 var bandit: Image = Image.load_from_file(ProjectSettings.globalize_path("res://experimental/ranger_showcase/assets/bandit-execution.png"))
 for index in range(6): source_frames.append(registered(ranger,RANGER_REGIONS[index],RANGER_ANCHORS[index]))
 for index in range(5):
  target_frames.append(registered(bandit,TARGET_REGIONS[index],TARGET_ANCHORS[index]))
  target_scales.append(310.0/float(TARGET_REGIONS[0].size.y))
 var snap: Image = Image.load_from_file(ProjectSettings.globalize_path("res://experimental/ranger_showcase/assets/bandit-neck-snap.png"))
 var snap_regions = [Rect2i(99,44,504,910),Rect2i(936,253,539,701)]
 for index in [1,2]:
  target_regions[index] = snap_regions[index-1]
  target_anchors[index] = 389 if index == 1 else 1245
  target_scales[index] = 0.31
  target_frames[index] = registered(snap,target_regions[index],target_anchors[index])
 gut_points[1] = Vector2(300,370)
 gut_points[2] = Vector2(1150,550)
 face_points[1] = Vector2(412,107)
 face_points[2] = Vector2(1240,312)
 cleaver = ImageTexture.create_from_image(bandit.get_region(Rect2i(1218,762,252,195)))
 target_idle = registered(load("res://assets/art_library/executions/warden/raider.png").get_image(),Rect2i(34,70,308,294),220)
 var reference := AtlasTexture.new()
 reference.set_meta("pose_id","ranger")
 var idle: Texture2D = Builds.idle(reference)
 for state in ["idle","windup","attack"]:
  var pose: AtlasTexture = Builds.pose(idle,state)
  var pixels: Image = pose.get_image()
  var full := Image.create(pose.get_width(),pose.get_height(),false,Image.FORMAT_RGBA8)
  full.blit_rect(pixels,Rect2i(Vector2i.ZERO,pixels.get_size()),Vector2i(pose.margin.position))
  bow_frames[state] = ImageTexture.create_from_image(full)
func _process(delta: float) -> void:
 elapsed += delta
 if not paused: age += delta
 if age >= 2.55:
  age = -0.25
  mode = 1-mode
 queue_redraw()
func _unhandled_key_input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed and not event.echo:
  if event.keycode == KEY_SPACE: paused = not paused
  if event.keycode == KEY_TAB:
   mode = 1-mode
   age = -0.25
  if event.keycode == KEY_R: age = -0.25
  if event.keycode == KEY_M: reduced = not reduced
func label_at(at: Vector2, text: String, pixels: int, color: Color = Color("#eadcbb")) -> void:
 draw_string(font,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,pixels,color)
func place(texture: Texture2D, anchor: Vector2, scale_factor: float, tint: Color = Color.WHITE) -> void:
 var dimensions: Vector2 = texture.get_size()*scale_factor
 draw_texture_rect(texture,Rect2(anchor-Vector2(dimensions.x/2,dimensions.y),dimensions),false,tint)
func source(texture: Texture2D, scale_factor: float, lean: float, alpha: float = 1.0) -> void:
 var mesh: ArrayMesh = MeshMotion.body_mesh(texture,SOURCE,0.0 if reduced else lean,0.0 if reduced else sin(maxf(age,0)*2.2)*0.8,scale_factor)
 meshes.append(mesh)
 draw_mesh(mesh,texture,Transform2D.IDENTITY,Color(1,1,1,alpha))
func arrow(from: Vector2, to: Vector2, shot: float, hit: float) -> void:
 if age < shot or age >= hit: return
 var progress: float = clampf((age-shot)/(hit-shot),0,1)
 var point: Vector2 = from.lerp(to,progress)
 var direction: Vector2 = (to-from).normalized()
 draw_line(point-direction*70,point,Color("#ba9656"),3,true)
 draw_line(point-direction*70,point-direction*58+direction.orthogonal()*5,Color("#d7d0b7"),2,true)
 draw_line(point-direction*70,point-direction*58-direction.orthogonal()*5,Color("#d7d0b7"),2,true)
 draw_colored_polygon(PackedVector2Array([point+direction*6,point-direction*8+direction.orthogonal()*4,point-direction*8-direction.orthogonal()*4]),Color("#ddd6c3"))
func blood(point: Vector2, hit: float, head: bool) -> void:
 var time: float = age-hit
 if time < 0 or time > 0.4: return
 if reduced:
  if time < 0.07: draw_circle(point,5,Color("#8e2834"))
  return
 for index in range(18 if head else 11):
  var angle: float = -2.9+float((index*7)%18)/17.0*2.4
  var velocity := Vector2(cos(angle),sin(angle))*(80+float((index*29)%120))
  var tint := Color("#a73c42") if index%4 == 0 else Color("#781523")
  tint.a = 1-smoothstep(0.14,0.4,time)
  draw_circle(point+velocity*time+Vector2(0,350*time*time),2+index%3,tint)
func target_point(index: int, pixel: Vector2) -> Vector2:
 var factor: float = target_scales[index]
 var region: Rect2i = target_regions[index]
 return TARGET+Vector2(pixel.x-float(target_anchors[index]),pixel.y-float(region.end.y))*factor
func embedded_arrow(tip: Vector2, tail: Vector2) -> void:
 var direction: Vector2 = (tip-tail).normalized()
 draw_line(tail,tip,Color("#24190e"),5,true)
 draw_line(tail,tip,Color("#ba9656"),2.2,true)
 # Flat nock and paired feather vanes distinguish the rear from an arrowhead.
 draw_line(tail-direction*4,tail+direction*5,Color("#d5c8a4"),2.2,true)
 for side in [-1,1]:
  var rear: Vector2 = tail+direction*7
  var front: Vector2 = tail+direction*27
  var outward: Vector2 = direction.orthogonal()*float(side)
  draw_colored_polygon(PackedVector2Array([rear,rear+direction*3+outward*5,front+outward*3,front]),Color("#b3a88b"))
  draw_line(rear+direction*5+outward*3,front,Color("#514b3d"),1,true)
func embedded_arrows(index: int) -> void:
 var gut: Vector2 = target_point(index,gut_points[index])
 var length: float = 78.0 if index < 3 else 62.0
 var offset := Vector2(-length,15 if index < 3 else 35)
 embedded_arrow(gut,gut+offset)
 if index > 0:
  var face: Vector2 = target_point(index,face_points[index])
  embedded_arrow(face,face+FACE_TAILS[index])
func dropped_weapon() -> void:
 if age < Timeline.HIT_ONE: return
 var t: float = clampf((age-Timeline.HIT_ONE)/0.20,0,1)
 var origin := Vector2(869,477).lerp(Vector2(770,GROUND-37),t*t)
 draw_set_transform(origin,lerpf(-0.6,0.05,t))
 var dimensions: Vector2 = cleaver.get_size()*0.36
 draw_texture_rect(cleaver,Rect2(-dimensions/2,dimensions),false)
 draw_set_transform(Vector2.ZERO)
func draw_bow() -> String:
 var schedule = {"release":0.31,"impact":0.46,"hold":0.065,"duration":0.82}
 var state: String = "idle" if age < 0 or age >= 0.82 else "windup" if age < 0.31 else "attack" if age < 0.525 else "idle"
 var lean: float = -4*smoothstep(0,0.31,age) if age < 0.31 else -7*sin(clampf((age-0.31)/0.15,0,1)*PI) if age < 0.46 else -2*(1-smoothstep(0.46,0.82,age))
 var layers: Array = [[state,1.0]] if reduced else MeshMotion.layers(age,schedule,true)
 for layer in layers:
  if layer[1] > 0.001: source(bow_frames[layer[0]],330.0/440.0,lean,layer[1])
 place(target_idle,TARGET,310.0/294.0)
 arrow(Vector2(490,336),Vector2(920,420),0.31,0.46)
 blood(Vector2(910,420),0.46,false)
 return "READY" if state == "idle" else "DRAW" if state == "windup" else "RELEASE / RECOIL"
func draw_execution() -> String:
 var frame: Dictionary = Timeline.sample(maxf(age,0))
 var index: int = 5 if age < 0 else frame.source
 var lean: float = -3 if index in [0,3] else -6*(1-smoothstep(Timeline.SHOT_TWO,Timeline.SHOT_TWO+0.1,age)) if index == 4 else 0
 source(source_frames[index],330.0/438.0,lean)
 if frame.target < 0:
  place(target_idle,TARGET,310.0/294.0)
 else:
  place(target_frames[frame.target],TARGET,target_scales[frame.target])
  embedded_arrows(frame.target)
 dropped_weapon()
 arrow(Vector2(486,352),target_point(0,gut_points[0]),Timeline.SHOT_ONE,Timeline.HIT_ONE)
 arrow(Vector2(510,325),target_point(0,Vector2(174,165)),Timeline.SHOT_TWO,Timeline.HIT_TWO)
 blood(target_point(0,gut_points[0]),Timeline.HIT_ONE,false)
 blood(target_point(0,Vector2(174,165)),Timeline.HIT_TWO,true)
 return "READY" if age < 0 else frame.phase
func _draw() -> void:
 if source_frames.is_empty(): return
 meshes.clear()
 draw_rect(Rect2(0,0,1280,720),Color("#111014"))
 draw_texture_rect(backdrop,Rect2(0,80,1280,560),false,Color(0.65,0.65,0.65))
 draw_rect(Rect2(0,80,1280,560),Color(0.02,0.015,0.02,0.28 if mode == 0 else 0.48))
 draw_rect(Rect2(0,GROUND,1280,60),Color(0.08,0.055,0.045,0.8))
 draw_line(Vector2(40,GROUND),Vector2(1240,GROUND),Color("#776348"),2)
 var phase: String = draw_bow() if mode == 0 else draw_execution()
 label_at(Vector2(30,43),"RANGER / "+("QUICK SHOT" if mode == 0 else "TWO-SHOT EXECUTION"),30)
 label_at(Vector2(30,677),phase,22)
 label_at(Vector2(30,708),"Space: pause   Tab: switch   R: restart   M: reduced motion",17,Color("#b5a88e"))
