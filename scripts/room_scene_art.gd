extends Control
## Independent room backdrops. Moving corridor scenery stays in the travel view.
var scene_theme: String = "bandit"
var ground_y: float = 430.0
var background: TextureRect
var clock: float = 0.0
static func path_for(kind: String, mode: String) -> String:
 return "res://assets/presentation/rooms/%s_%s.png" % [kind,mode]
static func lighting(kind: String) -> Color:
 return {"bandit":Color("#E7CDB8"),"keep":Color("#CDD4E0"),"beast":Color("#DDC0BB"),"medical":Color("#CFDAC2")}.get(kind,Color.WHITE)
func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 background = TextureRect.new()
 background.name = "RoomBackground"
 background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 background.stretch_mode = TextureRect.STRETCH_SCALE
 background.texture = load(path_for(scene_theme,"combat"))
 background.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(background)
 background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
func _process(delta: float) -> void:
 var runtime := get_node_or_null("/root/GameSettings")
 if runtime == null or runtime.ambient_motion: clock += delta
 queue_redraw()
func _draw() -> void:
 # Low drifting ash never covers the combatant silhouettes or information strips.
 var tint := lighting(scene_theme)
 tint.a = 0.12
 for i in range(9):
  var x: float = fposmod(i*239.0+clock*7,1920)
  var y: float = 100+fposmod(i*57.0-clock*11,280)
  draw_circle(Vector2(x,y),1.2,tint)
