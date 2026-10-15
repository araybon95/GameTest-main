extends Node2D
## Isolated animation study. Never loads the gameplay controller or changes combat state.
const Timeline = preload("res://experimental/witch_hunter/execution/timeline.gd")
const GROUND = 580.0
const SOURCE_RECTS = [Rect2i(46,6,441,549),Rect2i(552,9,386,546),Rect2i(999,172,519,385)]
const SOURCE_ANCHORS = [240,744,1190]
const TARGET_RECTS = [Rect2i(66,587,423,380),Rect2i(551,671,331,292),Rect2i(955,807,553,172)]
const TARGET_ANCHORS = [277,713,1225]
var age: float = -0.35
var paused: bool = false
var reduced: bool = false
var sources: Array[Texture2D] = []
var targets: Array[Texture2D] = []
var contacts: Array[Texture2D] = []
var idle: Texture2D
var target_idle: Texture2D
var cleaver: Texture2D
var backdrop: Texture2D
var font: Font
func registered(sheet: Image, rect: Rect2i, anchor: float) -> Texture2D:
 var local: float = anchor-rect.position.x
 var left: int = int(maxf(0,rect.size.x-2*local))
 var right: int = int(maxf(0,2*local-rect.size.x))
 var full := Image.create(rect.size.x+left+right,rect.size.y,false,Image.FORMAT_RGBA8)
 full.blit_rect(sheet,rect,Vector2i(left,0))
 return ImageTexture.create_from_image(full)
func _ready() -> void:
 var pairs := Image.load_from_file(ProjectSettings.globalize_path("res://experimental/witch_hunter/execution/assets/contacts.png"))
 var corrected := Image.load_from_file(ProjectSettings.globalize_path("res://experimental/witch_hunter/execution/assets/uppercut-corrected.png"))
 contacts.append(ImageTexture.create_from_image(corrected.get_region(Rect2i(27,11,1054,680))))
 contacts.append(ImageTexture.create_from_image(pairs.get_region(Rect2i(1121,13,1025,678))))
 font = ThemeDB.fallback_font
 backdrop = load("res://assets/art_library/generated/bandit_battle_stage.png")
 var sheet := Image.load_from_file(ProjectSettings.globalize_path("res://experimental/witch_hunter/execution/assets/poses.png"))
 var lead_in := Image.load_from_file(ProjectSettings.globalize_path("res://experimental/witch_hunter/execution/assets/uppercut-lead-in.png"))
 sources.append(registered(lead_in,Rect2i(42,128,508,430),SOURCE_ANCHORS[0]))
 for i in [1,2]: sources.append(registered(sheet,SOURCE_RECTS[i],SOURCE_ANCHORS[i]))
 # The loose cleaver is a separate moving layer; body strips omit its painted location.
 var victim := Image.create(sheet.get_width(),sheet.get_height(),false,Image.FORMAT_RGBA8)
 victim.blit_rect(sheet,Rect2i(66,587,423,152),Vector2i(66,587))
 victim.blit_rect(sheet,Rect2i(128,739,361,140),Vector2i(128,739))
 victim.blit_rect(sheet,Rect2i(66,879,423,88),Vector2i(66,879))
 targets.append(registered(victim,TARGET_RECTS[0],TARGET_ANCHORS[0]))
 for i in [1,2]: targets.append(registered(sheet,TARGET_RECTS[i],TARGET_ANCHORS[i]))
 cleaver = ImageTexture.create_from_image(sheet.get_region(Rect2i(12,739,114,129)))
 var hero: Texture2D = load("res://assets/art_library/party_builds/crusader.png")
 idle = registered(hero.get_image(),Rect2i(62,68,398,461),227)
 var bandit: Texture2D = load("res://assets/art_library/executions/warden/raider.png")
 target_idle = registered(bandit.get_image(),Rect2i(34,70,308,294),220)
func _process(delta: float) -> void:
 if not paused: age += delta
 if age > Timeline.DURATION+0.4: age = -0.35
 queue_redraw()
func _unhandled_key_input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed and not event.echo:
  if event.keycode == KEY_SPACE: paused = not paused
  if event.keycode == KEY_R: age = -0.35
  if event.keycode == KEY_M: reduced = not reduced
func place(texture: Texture2D, foot: Vector2, factor: float, alpha: float = 1.0) -> void:
 var dimensions := texture.get_size()*factor
 draw_texture_rect(texture,Rect2(foot-Vector2(dimensions.x/2,dimensions.y),dimensions),false,Color(1,1,1,alpha))
func blood(point: Vector2, start: float, final: bool) -> void:
 var t: float = age-start
 if t < 0 or t > 0.65: return
 if reduced:
  if t < 0.08: draw_circle(point,8,Color("#8b1c29"))
  return
 for i in range(58 if final else 16):
  var angle: float = -3.0+float((i*23)%59)/58.0*3.1
  var speed: float = 110+float((i*37)%210)
  var tint := Color("#a2383e") if i%5 == 0 else Color("#691322")
  if final and i%11 == 0: tint = Color("#c5ad8d")
  tint.a = 1-smoothstep(0.30,0.65,t)
  var pos: Vector2 = point+Vector2.from_angle(angle)*speed*t+Vector2(0,440*t*t)
  draw_circle(pos,2+float(i%5),tint)
func _draw() -> void:
 if sources.size() != 3 or targets.size() != 3: return
 draw_rect(Rect2(0,0,1280,720),Color("#100d12"))
 draw_texture_rect(backdrop,Rect2(0,0,1280,620),false,Color(0.52,0.48,0.48))
 draw_rect(Rect2(0,GROUND,1280,50),Color("#21191a"))
 draw_line(Vector2(0,GROUND),Vector2(1280,GROUND),Color("#6d5843"),2)
 var frame: Dictionary = Timeline.sample(maxf(0,age))
 var zoom: float = 1.0 if reduced else 1.0+0.075*smoothstep(0,0.30,age)
 var shake := Vector2.ZERO
 if not reduced and age >= Timeline.CRUSH and age < Timeline.CRUSH+0.13:
  shake = Vector2(sin(age*180)*5,cos(age*137)*2)*(1-smoothstep(Timeline.CRUSH,Timeline.CRUSH+0.13,age))
 draw_set_transform(Vector2(680,GROUND)*(1-zoom)+shake,0,Vector2(zoom,zoom))
 var source_x: float = 600.0 if reduced else 500+100*smoothstep(0.04,0.20,age)
 var target_foot := Vector2(840,GROUND)
 var pair: int = 0 if age >= Timeline.UPPERCUT and age < 0.52 else 1 if age >= Timeline.CRUSH and age < Timeline.CRUSH+0.13 else -1
 if pair >= 0 and contacts.size() == 2:
  place(contacts[pair],Vector2(730,GROUND),0.49)
 else:
  # Keep the rising mallet in front of the unhit target so its jaw alignment is visible.
  if frame.target < 0: place(target_idle,target_foot,310.0/294.0)
  if frame.source < 0: place(idle,Vector2(source_x,GROUND),330.0/461.0)
  else: place(sources[frame.source],Vector2(source_x,GROUND),[0.70,0.70,0.76][frame.source])
  if frame.target >= 0:
   var recoil: float = 10*(1-smoothstep(Timeline.UPPERCUT,0.8,age)) if frame.target == 0 and not reduced else 0.0
   place(targets[frame.target],target_foot+Vector2(recoil,0),0.82)
 if age >= 0.52:
  var drop: float = 1.0 if reduced else smoothstep(0.52,0.72,age)
  # Match the 0.82 scale of the recoil body instead of shrinking the loose prop.
  var dimensions: Vector2 = cleaver.get_size()*0.82
  var rotation: float = lerpf(-0.5,0.1,drop)
  var floor_center: float = GROUND-(absf(sin(rotation))*dimensions.x+absf(cos(rotation))*dimensions.y)*0.5
  draw_set_transform(Vector2(680,GROUND)*(1-zoom)+shake+Vector2(745,lerpf(451,floor_center,drop))*zoom,rotation,Vector2(zoom,zoom))
  draw_texture_rect(cleaver,Rect2(-dimensions*0.5,dimensions),false)
  draw_set_transform(Vector2(680,GROUND)*(1-zoom)+shake,0,Vector2(zoom,zoom))
 # Gore is drawn last, in front of BOTH combatants and the contact artwork.
 blood(Vector2(837,310),Timeline.UPPERCUT,false)
 blood(Vector2(833,352),Timeline.CRUSH,true)
 if age >= Timeline.CRUSH+0.15:
  for i in range(6):
   draw_set_transform(Vector2(680,GROUND)*(1-zoom)+Vector2(810+i*13,GROUND+4)*zoom,0,Vector2(zoom*(24-i*2),zoom*(3+i%2)))
   draw_circle(Vector2.ZERO,1,Color("#470c16"))
 draw_set_transform(Vector2.ZERO)
 draw_rect(Rect2(0,0,1280,96),Color(0.025,0.018,0.025,0.94))
 draw_rect(Rect2(0,630,1280,90),Color("#100d12"))
 draw_string(font,Vector2(48,45),"WITCH HUNTER — EXECUTION STUDY",HORIZONTAL_ALIGNMENT_LEFT,-1,27,Color("#ead7b2"))
 draw_string(font,Vector2(48,77),"TWO-HANDED HAMMER / UPPERCUT → CRUSH",HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("#b8a78d"))
 draw_string(font,Vector2(48,666),frame.phase if age >= 0 else "READY",HORIZONTAL_ALIGNMENT_LEFT,-1,22,Color("#ead7b2"))
 draw_string(font,Vector2(48,697),"EXPERIMENTAL · Space: pause · R: restart · M: reduced motion",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("#a79483"))
