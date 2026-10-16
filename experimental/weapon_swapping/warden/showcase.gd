extends Node2D
## Isolated art review; does not equip items or enable any production class gate.
const Visuals = preload("res://scripts/weapon_visuals.gd")
const Manifest = preload("res://assets/art_library/weapons/manifest.gd")
const Frames = preload("res://experimental/weapon_swapping/warden/frames.gd")
const Motion = preload("res://scripts/warden_transitions.gd")
const STATES = ["idle","windup","attack","guard","hurt","death"]
const LABELS = ["READY","WINDUP","HEAVY STRIKE","GUARD","WOUNDED","FALLEN"]
const ExecutionStudy = preload("res://experimental/weapon_swapping/warden/execution.gd")
const WEAPONS = ["warden_sword","warden_legend"]
var elapsed: float = 0.0
var paused: bool = false
var mode: int = 0
var movies: Array[Node2D] = []
var poses: Dictionary = {}
var backdrop: Texture2D
var font: Font
var frame_meshes: Array[ArrayMesh] = []
var phase_label: Label
func _ready() -> void:
 Manifest.frames.merge(Frames.RECORDS,true)
 font = ThemeDB.fallback_font
 backdrop = load("res://assets/art_library/presentation/rooms/bandit_combat.png")
 for weapon in WEAPONS:
  for pose in STATES:
   var texture: Texture2D = Visuals._frame_for_weapon("warden","original",pose,weapon)
   assert(texture != null,"All showcased weapon poses must be composed")
   poses[weapon+"|"+pose] = texture
 for side in range(2):
  var movie = ExecutionStudy.new()
  movie.weapon_id = WEAPONS[side]
  movie.position = Vector2(40+640*side,357)
  movie.scale = Vector2.ONE*0.70
  add_child(movie)
  movies.append(movie)
 build_labels()
 update_movies()
func build_labels() -> void:
 var ui := CanvasLayer.new()
 ui.layer = 100
 add_child(ui)
 add_label(ui,"WARDEN · WEAPON SWAP STUDY",Vector2(0,17),1280,29,Color("EAD8B2"))
 add_label(ui,"ONE-HANDED MELEE · SHIELD RETAINED",Vector2(0,63),1280,17,Color("AF9F88"))
 phase_label = add_label(ui,"READY",Vector2(0,108),1280,21,Color("C9AD72"))
 for side in range(2):
  add_label(ui,"IRON LONGSWORD" if side == 0 else "OATHKEEPER",Vector2(side*640,160),640,24,Color("EAD8B2"))
 add_label(ui,"SPACE · pause     TAB · poses / execution     R · restart",Vector2(0,665),1280,16,Color("AF9F88"))
func add_label(parent: Node, value: String, point: Vector2, width: float, size: int, color: Color) -> Label:
 var label := Label.new()
 label.text = value
 label.position = point
 label.size = Vector2(width,size+12)
 label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 label.add_theme_font_size_override("font_size",size)
 label.add_theme_color_override("font_color",color)
 parent.add_child(label)
 return label
func _process(delta: float) -> void:
 if not paused: elapsed += delta
 update_movies()
 queue_redraw()
func update_movies() -> void:
 if is_instance_valid(phase_label): phase_label.text = LABELS[state_index()] if mode == 0 else "EXECUTION · MATCHING WEAPON THROUGH EVERY PHASE"
 for movie in movies:
  movie.visible = mode == 1
  movie.set_frame(fposmod(elapsed,3.2),true)
func _unhandled_key_input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed and not event.echo:
  if event.keycode == KEY_SPACE: paused = not paused
  if event.keycode == KEY_R: elapsed = 0
  if event.keycode == KEY_TAB:
   mode = 1-mode
   elapsed = 0
   update_movies()
func state_index() -> int: return int(floor(fposmod(elapsed,6.0)))
func _draw() -> void:
 if poses.is_empty(): return
 frame_meshes.clear()
 draw_texture_rect(backdrop,Rect2(0,0,1280,720),false,Color(0.36,0.32,0.34))
 draw_rect(Rect2(0,0,1280,210),Color(0.035,0.025,0.035,0.94))
 draw_rect(Rect2(0,620,1280,100),Color(0.035,0.025,0.03,0.95))
 draw_line(Vector2(70,630),Vector2(1210,630),Color("8D7551"),2)
 var index: int = state_index()
 var scale_factor: float = 0.70
 for side in range(2) if mode == 0 else range(0):
  var weapon: String = WEAPONS[side]
  var texture: Texture2D = poses[weapon+"|"+STATES[index]]
  var floor_point := Vector2(320+640*side,630)
  var position: Vector2 = floor_point-texture.get_meta("foot_anchor")*scale_factor
  var breath: float = sin(elapsed*TAU*0.65)*1.2 if index != 5 else 0.0
  # One composed surface carries the hand and weapon together through motion.
  var mesh: ArrayMesh = Motion.body_mesh(texture,position+Vector2(texture.get_width()*scale_factor*0.5,texture.get_height()*scale_factor),0,breath,scale_factor)
  frame_meshes.append(mesh)
  draw_mesh(mesh,texture)
func _exit_tree() -> void:
 poses.clear()
 Visuals.clear_cache()
