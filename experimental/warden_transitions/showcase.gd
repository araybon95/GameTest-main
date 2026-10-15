extends Node2D
## Visual comparison only. No combat state, damage or production timing changes.
const Builds = preload("res://scripts/party_builds.gd")
const Profiles = preload("res://scripts/attack_profiles.gd")
const SLOT = 2.6
var elapsed: float = 0.0
var paused: bool = false
var textures: Dictionary = {}
var backdrop: Texture2D
var font: Font
var frame_meshes: Array[ArrayMesh] = []
func _ready() -> void:
 var reference := AtlasTexture.new()
 reference.set_meta("pose_id","warden")
 var idle: Texture2D = Builds.idle(reference)
 for state in ["idle","windup","attack"]:
  textures[state] = ImageTexture.create_from_image(Builds.pose(idle,state).get_image())
 backdrop = load("res://assets/art_library/generated/bandit_battle_stage.png")
 font = ThemeDB.fallback_font
func _process(delta: float) -> void:
 if not paused: elapsed += delta
 queue_redraw()
func _unhandled_key_input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed and not event.echo:
  if event.keycode == KEY_SPACE: paused = not paused
  if event.keycode == KEY_R: elapsed = 0
func timing(heavy: bool, improved: bool) -> Dictionary:
 var result: Dictionary = Profiles.PROFILES["heavy" if heavy else "light"].duplicate()
 result["id"] = "heavy" if heavy else "light"
 if improved:
  result["release"] = 0.44 if heavy else 0.18
  result["impact"] = 0.60 if heavy else 0.31
  result["hold"] = 0.18 if heavy else 0.07
  result["duration"] = 1.16 if heavy else 0.80
 return result
func layers(age: float, schedule: Dictionary, improved: bool) -> Array:
 var release: float = schedule.release
 var impact: float = schedule.impact
 var finish: float = schedule.duration
 var recover: float = impact+schedule.hold
 if age < 0 or age >= finish: return [["idle",1.0]]
 var state: String = "windup" if age < release else "attack" if age < recover else "idle"
 if not improved: return [[state,1.0]]
 # Short blends avoid a lingering transparent second weapon/arm.
 for entry in [[0.0,"idle","windup",0.065],[release,"windup","attack",0.040],[recover,"attack","idle",0.075]]:
  if age >= entry[0] and age < entry[0]+entry[3]:
   var mix: float = smoothstep(0,1,(age-entry[0])/entry[3])
   return [[entry[1],1.0-mix],[entry[2],mix]]
 return [[state,1.0]]
func body_mesh(texture: Texture2D, anchor: Vector2, lean: float, breath: float) -> ArrayMesh:
 var vertices := PackedVector3Array()
 var uv := PackedVector2Array()
 var indices := PackedInt32Array()
 var scale_factor: float = 285.0/479.0
 var size_px: Vector2 = texture.get_size()*scale_factor
 const COLS = 18
 const ROWS = 24
 for row in range(ROWS+1):
  for col in range(COLS+1):
   var u: float = float(col)/COLS
   var v: float = float(row)/ROWS
   var upper: float = 1.0-smoothstep(0.20,0.72,v)
   var arm: float = exp(-pow((u-0.72)/0.24,2)-pow((v-0.43)/0.24,2))
   var point := anchor+Vector2((u-0.5)*size_px.x,(v-1)*size_px.y)
   point.x += lean*upper+lean*0.22*arm
   point.y -= breath*upper+lean*0.12*arm
   vertices.append(Vector3(point.x,point.y,0))
   uv.append(Vector2(u,v))
 for row in range(ROWS):
  for col in range(COLS):
   var i: int = row*(COLS+1)+col
   indices.append_array(PackedInt32Array([i,i+1,i+COLS+1,i+1,i+COLS+2,i+COLS+1]))
 var arrays: Array = []
 arrays.resize(Mesh.ARRAY_MAX)
 arrays[Mesh.ARRAY_VERTEX] = vertices
 arrays[Mesh.ARRAY_TEX_UV] = uv
 arrays[Mesh.ARRAY_INDEX] = indices
 var mesh := ArrayMesh.new()
 mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
 return mesh
func caption(at: Vector2, message: String, pixels: int, color: Color = Color("#e8d9b9")) -> void:
 draw_string(font,at,message,HORIZONTAL_ALIGNMENT_LEFT,-1,pixels,color)
func _draw() -> void:
 if textures.is_empty(): return
 frame_meshes.clear()
 draw_rect(Rect2(0,0,1440,640),Color("#111014"))
 var heavy: bool = int(elapsed/SLOT)%2 == 1
 var age: float = fmod(elapsed,SLOT)-0.45
 caption(Vector2(28,38),"WARDEN / "+("HEAVY STRIKE" if heavy else "SLASH"),26)
 caption(Vector2(28,620),"Space: pause   R: restart   |   Experimental motion study — shield retained, one-handed weapon",18)
 for panel in range(2):
  var improved: bool = panel == 1
  var origin := Vector2(panel*720,0)
  draw_texture_rect(backdrop,Rect2(origin+Vector2(12,96),Vector2(696,460)),false,Color(0.60,0.60,0.60))
  draw_line(origin+Vector2(24,500),origin+Vector2(696,500),Color("#9c8460"),2)
  caption(origin+Vector2(28,78),"PROPOSED / CONNECTED MOTION" if improved else "BASELINE / TIMING & POSE CUTS",21)
  var schedule: Dictionary = timing(heavy,improved)
  var frame: Dictionary = Profiles.sample(schedule,maxf(age,0))
  var lean: float = 0
  if improved and age >= 0 and age < schedule.duration:
   lean = -9*sin(frame.windup*PI/2) if frame.phase == "windup" else lerpf(-9,14,smoothstep(0,1,frame.flight)) if frame.phase == "release" else 14*(1-smoothstep(0,1,frame.recovery))
  var breath: float = sin(elapsed*2.2)*1.2 if improved else 0
  for layer in layers(age,schedule,improved):
   if layer[1] <= 0.001: continue
   var texture: Texture2D = textures[layer[0]]
   var mesh: ArrayMesh = body_mesh(texture,origin+Vector2(360,500),lean,breath)
   frame_meshes.append(mesh)
   draw_mesh(mesh,texture,Transform2D.IDENTITY,Color(1,1,1,layer[1]))
  var phase: String = "IDLE" if age < 0 or age >= schedule.duration else str(frame.phase).to_upper()
  caption(origin+Vector2(28,584),phase+"  |  "+("weighted recovery" if improved else "existing timing"),19)
  if age >= schedule.impact and age < schedule.impact+0.06:
   draw_circle(origin+Vector2(620,270),9,Color("#eac791"))
