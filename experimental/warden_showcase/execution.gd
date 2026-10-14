extends "res://showcase.gd"
## Presentation experiment only: accepts a defeat event; never deals damage.
const FINAL_HIT = 0.95
const COLLAPSE = 1.18
const DURATION = 1.8
var started: bool = false
var execution_warden: Array[Image] = []
var execution_target: Array[Image] = []
var contact_pair: Image
var ready_execution_assets: bool = false
func begin_finish(attacker: String, target_hp: int, direct_hit: bool, final_enemy: bool) -> bool:
 if started or attacker != "warden" or target_hp > 0 or not direct_hit or not final_enemy: return false
 started = true
 elapsed = 0.0
 return true
static func execution_sample(time: float, animate: bool = true) -> Dictionary:
 var warden_pose: int = -1 if time < 0.12 else 0 if time < 0.42 else 1 if time < FINAL_HIT else 2 if time < 1.5 else 3
 var target_pose: int = -1 if time < 0.29 else 0 if time < 0.42 else 1 if time < FINAL_HIT else 2 if time < COLLAPSE else 3
 var zoom: float = 1.0+0.16*smoothstep(0.0,0.4,time) if time < 1.5 else lerpf(1.16,1.08,smoothstep(1.5,DURATION,time))
 # Drive the shield through the near edge of the target, hold, then recover.
 var shield_lunge: float = 65.0*smoothstep(0.12,0.22,time)*(1.0-smoothstep(0.34,0.58,time))
 var shift: float = 65.0*smoothstep(0.05,0.25,time)+shield_lunge
 var shake: float = sin((time-FINAL_HIT)*110.0)*4.0*(1.0-smoothstep(FINAL_HIT,1.1,time)) if time >= FINAL_HIT and time < 1.1 else 0.0
 return {"warden_pose":warden_pose,"target_pose":target_pose,"zoom":zoom if animate else 1.0,"source_shift":shift if animate else (130.0 if warden_pose == 0 else 0.0),"shake":shake if animate else 0.0,"done":time >= DURATION,"phase":"SHIELD KNOCKDOWN" if time < 0.42 else "THE FINISHING BLOW" if time < COLLAPSE else "ENEMY FINISHED"}
static func execution_particles(time: float, animate: bool = true) -> Array[Dictionary]:
 var age: float = time-FINAL_HIT
 var result: Array[Dictionary] = []
 if not animate or age < 0 or age > 0.72: return result
 for i in range(54):
  var angle: float = lerpf(-2.9,-0.1,float((i*17)%54)/53.0)
  var speed: float = 110+float((i*43)%155)
  var velocity := Vector2(cos(angle),sin(angle))*speed
  velocity.x = -absf(velocity.x)
  result.append({"offset":velocity*age+Vector2(0,500*age*age),"radius":2.0+float(i%5)*0.75,"bone":i%9 == 0,"alpha":1.0-smoothstep(0.26,0.72,age)})
 return result
func trim_region(sheet: Image, rect: Rect2i) -> Image:
 var part: Image = sheet.get_region(rect)
 return part.get_region(part.get_used_rect())
func load_execution_assets() -> void:
 if ready_execution_assets: return
 load_assets()
 var sheet: Image = Image.load_from_file("res://assets/warden_execution.png")
 assert(sheet != null and not sheet.is_empty(),"Execution artwork missing")
 # Use only the corrected windup from this atlas; preserve every other approved pose.
 var windup: Image = Image.load_from_file("res://assets/warden_execution_windup.png")
 # The raised figure's cape needs a second atlas slice; exclude the neighboring mace.
 var raised := Image.create(382,465,false,Image.FORMAT_RGBA8)
 raised.blend_rect(windup,Rect2i(560,0,320,465),Vector2i(62,0))
 raised.blend_rect(windup,Rect2i(498,270,62,195),Vector2i(0,270))
 execution_warden.append(raised.get_region(raised.get_used_rect()))
 execution_warden.append(trim_region(sheet,Rect2i(895,150,485,320)))
 execution_warden.append(trim_region(sheet,Rect2i(1380,85,345,385)))
 for rect in [Rect2i(0,505,452,360),Rect2i(460,525,420,345),Rect2i(890,490,430,375),Rect2i(1320,690,454,187)]:
  execution_target.append(trim_region(sheet,rect))
 contact_pair = Image.load_from_file("res://assets/warden_execution_contact.png")
 assert(contact_pair != null and not contact_pair.is_empty(),"Paired execution contact artwork missing")
 # Exclude the near-transparent export halo and register the actual boot line.
 contact_pair = contact_pair.get_region(Rect2i(23,2,1492,965))
 ready_execution_assets = true
func execution_gore(canvas: Image, time: float, animate: bool) -> void:
 if time < FINAL_HIT: return
 var origin := Vector2(518,220)
 for particle in execution_particles(time,animate):
  var color := Color("#a99a7b") if particle.bone else Color("#791322")
  color.a = particle.alpha*0.95
  blood_stamp(canvas,origin+particle.offset,Vector2(particle.radius,particle.radius*0.75),color)
 if time >= FINAL_HIT+0.12:
  for i in range(6):
   blood_stamp(canvas,Vector2(510+i*13,390+(i%2)*3),Vector2(23-i*2,4+i%3),Color("#4a0b14"))
func render_execution(time: float, animate: bool = true) -> Image:
 load_execution_assets()
 var state: Dictionary = execution_sample(time,animate)
 var canvas := Image.create(800,540,false,Image.FORMAT_RGBA8)
 canvas.fill(Color("#100e13"))
 var scenery: Image = backdrop.duplicate()
 var camera: float = 1.0+(state.zoom-1.0)*0.45
 scenery.resize(roundi(800*camera),roundi(420*camera),Image.INTERPOLATE_BILINEAR)
 canvas.blend_rect(scenery,Rect2i((scenery.get_width()-800)/2,(scenery.get_height()-420)/2,800,420),Vector2i.ZERO)
 place(canvas,idle,Vector2(85,390),0.37,-1,0.12)
 var ground: float = 390.0
 # A paired contact illustration ensures the mace actually meets the skull.
 if time >= FINAL_HIT and time < FINAL_HIT+0.13:
  var scale_pair: float = minf(600.0/contact_pair.get_width(),315.0/contact_pair.get_height())
  var pair_foot: float = ground+(contact_pair.get_height()-932)*scale_pair
  place(canvas,contact_pair,Vector2(420+state.shake,pair_foot),scale_pair)
 else:
  var body: Image
  var body_scale: float
  if state.warden_pose <= 0:
   body = poses[2 if state.warden_pose < 0 else 7]
   body_scale = 0.78*state.zoom
  else:
   body = execution_warden[state.warden_pose-1]
   body_scale = (0.65 if state.warden_pose == 1 else 0.72 if state.warden_pose == 2 else 0.64)*state.zoom
  body_scale = minf(body_scale,342.0/body.get_height())
  var warden_x: float = 400+(220+state.source_shift-400)*state.zoom
  var body_half: float = body.get_width()*body_scale*0.5
  warden_x = clampf(warden_x,24+body_half,776-body_half)
  place(canvas,body,Vector2(warden_x,ground),body_scale)
  var target: Image = enemy if state.target_pose < 0 else execution_target[state.target_pose]
  var target_scale: float = (0.77 if state.target_pose < 0 else 0.6 if state.target_pose < 2 else 0.62 if state.target_pose == 2 else 0.70)*state.zoom
  var target_x: float = 400+(540-400)*state.zoom
  var target_half: float = target.get_width()*target_scale*0.5
  target_x = clampf(target_x,24+target_half,776-target_half)
  place(canvas,target,Vector2(target_x+state.shake,ground),target_scale)
 execution_gore(canvas,time,animate)
 # These bars are a defeated-target indicator, never a second damage event.
 canvas.fill_rect(Rect2i(0,420,800,120),Color("#171318"))
 canvas.fill_rect(Rect2i(35,475,265,7),Color("#735347"))
 canvas.fill_rect(Rect2i(500,475,265,7),Color("#30232b"))
 return canvas
func _ready() -> void:
 load_execution_assets()
 begin_finish("warden",0,true,true)
func _process(delta: float) -> void:
 if not started: return
 elapsed = minf(3.4,elapsed+delta)
 var image: Image = render_execution(elapsed,not reduced_motion)
 if current_texture == null: current_texture = ImageTexture.create_from_image(image)
 else: current_texture.update(image)
 queue_redraw()
 if elapsed >= 3.4: set_process(false)
func _draw() -> void:
 if current_texture == null: return
 draw_texture(current_texture,Vector2.ZERO)
 var state: Dictionary = execution_sample(elapsed,not reduced_motion)
 draw_string(ThemeDB.fallback_font,Vector2(35,25),"WARDEN EXECUTION - "+state.phase,HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("#dec58d"))
 draw_string(ThemeDB.fallback_font,Vector2(35,454),"WARDEN",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("#dec58d"))
 draw_string(ThemeDB.fallback_font,Vector2(590,454),"RAIDER - 0 HP",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("#b35a5e"))
 draw_string(ThemeDB.fallback_font,Vector2(35,515),"EXPERIMENTAL - SPACE replay / ENTER skip / R reduced motion",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("#c5b9ab"))
func _unhandled_input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed and not event.echo:
  if event.keycode == KEY_SPACE:
   started = false
   begin_finish("warden",0,true,true)
  if event.keycode == KEY_ENTER: elapsed = DURATION
  if event.keycode == KEY_R: reduced_motion = not reduced_motion
  set_process(true)
