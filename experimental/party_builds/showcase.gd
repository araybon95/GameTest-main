extends Node2D
## Review-only artwork and timing; does not depend on production game state.
const HEROES = ["WARDEN","CRUSADER","OCCULTIST","RANGER"]
const PERIOD: float = 3.2
const FOOT: int = 512
const ANCHORS = [278.0,242.0,242.0]
var current: Array[Texture2D] = []
var proposed: Array[Texture2D] = []
var bow_poses: Array[Texture2D] = []
var elapsed: float = 0.0
var bow_view: bool = false
var animate: bool = true
func region(image: Image, rect: Rect2i, trim: bool = true) -> Texture2D:
 var part: Image = image.get_region(rect)
 if trim: part = part.get_region(part.get_used_rect())
 return ImageTexture.create_from_image(part)
func load_art() -> void:
 if not current.is_empty(): return
 var repo: String = ProjectSettings.globalize_path("res://").trim_suffix("/").get_base_dir().get_base_dir()
 var paths = ["assets/art_library/warden_outfits/original.png","assets/art_library/generated/hero_crusader_poses.png","assets/art_library/generated/hero_occultist_combat_sheet.png","assets/art_library/generated/hero_ranger_combat_sheet.png"]
 var rects = [Rect2i(0,0,366,380),Rect2i(0,0,900,1024),Rect2i(46,52,364,442),Rect2i(61,65,401,419)]
 for i in range(4):
  var image: Image = Image.load_from_file(repo+"/"+paths[i])
  assert(image != null and not image.is_empty(),"Open this study inside the GameTest-main repository")
  current.append(region(image,rects[i]))
 var party: Image = Image.load_from_file("res://assets/party-builds.png")
 for rect in [Rect2i(12,188,509,752),Rect2i(524,71,581,873),Rect2i(1120,203,404,736)]:
  proposed.append(region(party,rect,false))
 var ranger: Image = Image.load_from_file("res://assets/ranger-stance.png")
 proposed.append(region(ranger,Rect2i(90,72,345,440),false))
 for i in range(3): bow_poses.append(region(ranger,Rect2i(i*512,0,512,FOOT),false))
static func sample(time: float) -> Dictionary:
 var t: float = fposmod(time,PERIOD)
 if t < 0.65: return {"from":0,"to":0,"blend":0.0,"phase":"READY"}
 if t < 1.05: return {"from":0,"to":1,"blend":smoothstep(0.65,1.05,t),"phase":"DRAW"}
 if t < 1.65: return {"from":1,"to":1,"blend":0.0,"phase":"AIM"}
 if t < 1.95: return {"from":2,"to":2,"blend":0.0,"phase":"RELEASE"}
 if t < 2.4: return {"from":2,"to":0,"blend":smoothstep(1.95,2.4,t),"phase":"RECOVER"}
 return {"from":0,"to":0,"blend":0.0,"phase":"READY"}
func text_at(at: Vector2, words: String, size: int = 24, color: Color = Color("#dec99f")) -> void:
 draw_string(ThemeDB.fallback_font,at,words,HORIZONTAL_ALIGNMENT_LEFT,-1,size,color)
func place(texture: Texture2D, foot: Vector2, height: float, body_pixels: float = 0.0) -> void:
 var factor: float = height/(texture.get_height() if body_pixels <= 0 else body_pixels)
 var dimensions: Vector2 = texture.get_size()*factor
 draw_texture_rect(texture,Rect2(foot-Vector2(dimensions.x/2,dimensions.y),dimensions),false)
func lineup() -> void:
 text_at(Vector2(45,48),"PARTY BUILD & STANCE STUDY",32)
 text_at(Vector2(45,92),"CURRENT COMBAT PROPORTIONS",22,Color("#a99579"))
 text_at(Vector2(45,562),"PROPOSED - HEAVIER MELEE / LEANER RANGED",22)
 for row in range(2):
  var floor_y: float = 420 if row == 0 else 895
  draw_rect(Rect2(40,floor_y,1520,12),Color("#2a211d"))
  draw_line(Vector2(40,floor_y),Vector2(1560,floor_y),Color("#75634e"),1)
  for i in range(4):
   var x: float = 220+i*390
   var texture: Texture2D = current[i] if row == 0 else proposed[i]
   var height: float = [245,270,280,280][i] if row == 0 else [285,290,255,260][i]
   place(texture,Vector2(x,floor_y),height,638 if row == 1 and i == 2 else 0)
   text_at(Vector2(x-90,floor_y+42),HEROES[i],23)
   if row == 1: text_at(Vector2(x-120,floor_y+70),["Broad armored build","Heavy melee build","Slender caster","Lean archer / closer feet"][i],17,Color("#a99579"))
 text_at(Vector2(45,990),"EXPERIMENTAL - TAB bow preview / SPACE replay / R reduce motion - gameplay unchanged",18,Color("#a99579"))
func bow_pose(index: int, opacity: float, foot: Vector2, factor: float) -> void:
 var origin := foot-Vector2(ANCHORS[index],FOOT)*factor
 draw_texture_rect(bow_poses[index],Rect2(origin,Vector2(512,FOOT)*factor),false,Color(1,1,1,opacity))
func bow() -> void:
 var state: Dictionary = sample(elapsed)
 if not animate: state.blend = roundf(state.blend)
 text_at(Vector2(45,48),"RANGER - NARROWER STANCE & LEANER BUILD",32)
 text_at(Vector2(170,145),"CURRENT - WIDE STANCE",25,Color("#a99579"))
 text_at(Vector2(950,145),"PROPOSED - "+str(state.phase),25)
 draw_line(Vector2(800,180),Vector2(800,910),Color("#3b3028"),1)
 draw_rect(Rect2(50,840,1500,14),Color("#2a211d"))
 draw_line(Vector2(50,840),Vector2(1550,840),Color("#75634e"),1)
 place(current[3],Vector2(405,840),520)
 var factor: float = 520.0/(FOOT-78.0)
 var foot := Vector2(1170,840)
 if state.from == state.to: bow_pose(state.from,1.0,foot,factor)
 else:
  bow_pose(state.from,1.0-state.blend,foot,factor)
  bow_pose(state.to,state.blend,foot,factor)
 var age: float = fposmod(elapsed,PERIOD)-1.65
 if age >= 0 and age < 0.24 and animate:
  var point := Vector2(1430+age*800,440)
  draw_line(point-Vector2(65,0),point,Color("#d6c6a6"),2)
  draw_line(point-Vector2(12,5),point,Color("#d6c6a6"),2)
  draw_line(point-Vector2(12,-5),point,Color("#d6c6a6"),2)
 text_at(Vector2(135,910),"Original silhouette",22,Color("#a99579"))
 text_at(Vector2(950,910),"Hip-to-shoulder width / planted boots",22)
 text_at(Vector2(45,970),"Complete painted poses with a common foot baseline; subtle stance shifts during the shot.",21,Color("#a99579"))
 text_at(Vector2(45,995),"EXPERIMENTAL - TAB lineup / SPACE replay / R reduce motion",17,Color("#a99579"))
func _ready() -> void: load_art()
func _process(delta: float) -> void:
 elapsed += delta
 queue_redraw()
func _draw() -> void:
 draw_rect(Rect2(0,0,1600,1000),Color("#121014"))
 if current.is_empty(): return
 if bow_view: bow()
 else: lineup()
func _unhandled_input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed and not event.echo:
  if event.keycode == KEY_TAB: bow_view = not bow_view
  if event.keycode == KEY_SPACE: elapsed = 0.0
  if event.keycode == KEY_R: animate = not animate
  queue_redraw()
