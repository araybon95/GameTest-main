extends "res://experimental/witch_hunter/execution/showcase.gd"
## Judgment visual study only; gameplay and execution integration remain untouched.
const Judgment = preload("res://experimental/witch_hunter/judgment/timeline.gd")
const POSES = [Rect2i(27,12,586,704),Rect2i(716,12,777,704),Rect2i(1500,12,587,704)]
const ANCHORS = [285,978,1758]
var recoil: Texture2D
func _ready() -> void:
 super._ready()
 sources.clear()
 contacts.clear()
 var sheet := Image.load_from_file(ProjectSettings.globalize_path("res://experimental/witch_hunter/judgment/assets/poses.png"))
 for i in range(3): sources.append(registered(sheet,POSES[i],ANCHORS[i]))
 var contact := Image.load_from_file(ProjectSettings.globalize_path("res://experimental/witch_hunter/judgment/assets/contact.png"))
 contacts.append(ImageTexture.create_from_image(contact.get_region(Rect2i(73,42,1448,925))))
 var bandit: Texture2D = load("res://assets/art_library/executions/warden/raider.png")
 recoil = registered(bandit.get_image(),Rect2i(25,783,355,284),220)
 age = -0.4
func _process(delta: float) -> void:
 if not paused: age += delta
 if age > 1.8: age = -0.4
 queue_redraw()
func _draw() -> void:
 if sources.size() != 3 or contacts.size() != 1: return
 draw_rect(Rect2(0,0,1280,720),Color("#100d12"))
 draw_texture_rect(backdrop,Rect2(0,0,1280,620),false,Color(0.50,0.46,0.46))
 draw_rect(Rect2(0,GROUND,1280,50),Color("#21191a"))
 draw_line(Vector2(0,GROUND),Vector2(1280,GROUND),Color("#6d5843"),2)
 var frame: Dictionary = Judgment.sample(age)
 var zoom: float = 1.0 if reduced else 1.0+0.045*smoothstep(0,Judgment.RELEASE,age)*(1-smoothstep(Judgment.IMPACT+Judgment.HOLD,Judgment.DURATION,age))
 var shake := Vector2.ZERO
 var hit_age: float = age-Judgment.IMPACT
 if not reduced and hit_age >= 0 and hit_age < 0.065:
  shake.x = sin(hit_age*130)*1.6*(1-hit_age/0.065)
 draw_set_transform(Vector2(720,GROUND)*(1-zoom)+shake,0,Vector2(zoom,zoom))
 if frame.phase == "CONTACT HOLD":
  place(contacts[0],Vector2(720,GROUND),330.0/925.0)
 else:
  var target_shift: float = 0.0 if reduced or not frame.contact else 10*(1-float(frame.recover))
  place(recoil if frame.contact else target_idle,Vector2(860+target_shift,GROUND),310.0/294.0)
  var shift: float = 0 if reduced else float(frame.source_x)
  if frame.source < 0:
   place(idle,Vector2(565,GROUND),330.0/461.0)
  elif frame.phase == "RECOVER":
   var progress: float = float(frame.recover)
   place(sources[2],Vector2(565+shift,GROUND),330.0/704.0,1-smoothstep(0.4,1.0,progress))
   place(idle,Vector2(565+shift,GROUND),330.0/461.0,smoothstep(0.4,1.0,progress))
  else:
   place(sources[frame.source],Vector2(565+shift,GROUND),330.0/704.0)
 blood(Vector2(828,355),Judgment.IMPACT,false)
 draw_set_transform(Vector2.ZERO)
 draw_rect(Rect2(0,0,1280,96),Color(0.025,0.018,0.025,0.94))
 draw_rect(Rect2(0,630,1280,90),Color("#100d12"))
 draw_string(font,Vector2(48,44),"WITCH HUNTER — JUDGMENT",HORIZONTAL_ALIGNMENT_LEFT,-1,27,Color("#ead7b2"))
 draw_string(font,Vector2(48,77),"COMPACT HAMMER STRIKE · 1 AP / 6 BASE DAMAGE",HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("#b8a78d"))
 draw_string(font,Vector2(48,663),frame.phase,HORIZONTAL_ALIGNMENT_LEFT,-1,22,Color("#ead7b2"))
 draw_string(font,Vector2(48,694),"EXPERIMENTAL · Space: pause · R: restart · M: reduced motion",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("#a79483"))
