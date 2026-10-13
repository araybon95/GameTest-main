extends Node2D
## Each pose is one finished illustration, including helmet and cloak.
const SHEET = preload("res://assets/complete_poses.png")
const GROUNDS := [379.0,381.0,381.0,383.0,344.0,344.0,346.0,348.0,339.0,343.0,339.0,342.0]
const HEAD_TOPS := [40.0,62.0,50.0,52.0,10.0,9.0,12.0,13.0,5.0,5.0,7.0,8.0]
const FRAME_SECONDS := 0.084
var sheet: Texture2D = SHEET
var ground_values: Array = GROUNDS
var head_values: Array = HEAD_TOPS
var art: Sprite2D
var material_instance: ShaderMaterial
var frames: Array[AtlasTexture] = []
var mode: String = "idle"
var clock: float = 0.0
var attack_elapsed: float = 0.0
var current_frame: int = 0
func region(index: int) -> Rect2:
	var row: int = index/4
	var tops := [0.0,389.0,741.0]
	var ends := [389.0,741.0,1086.0]
	var width: float = 366.0 if index % 4 != 3 else 362.0
	return Rect2((index%4)*362.0,tops[row],width,ends[row]-tops[row])
func _ready() -> void:
	art = Sprite2D.new()
	art.name = "CompletePaintedCharacter"
	art.centered = false
	art.z_index = 20
	add_child(art)
	material_instance = ShaderMaterial.new()
	material_instance.shader = preload("res://breath.gdshader")
	art.material = material_instance
	for i in range(12):
		var texture := AtlasTexture.new()
		texture.atlas = sheet
		texture.region = region(i)
		texture.filter_clip = true
		frames.append(texture)
	refresh()
func set_motion(value: String) -> void:
	if value in ["walk","idle"]:
		mode = value
		refresh()
func set_facing(direction: int) -> void:
	scale.x = absf(scale.x)*(-1 if direction < 0 else 1)
func set_time(value: float) -> void:
	clock = maxf(0,value)
	refresh()
func attack() -> void:
	mode = "attack"
	attack_elapsed = 0.0
	refresh()
func advance(delta: float) -> void:
	clock += maxf(0,delta)
	if mode == "attack":
		attack_elapsed += maxf(0,delta)
		if attack_elapsed >= 0.62:
			mode = "idle"
	refresh()
func refresh() -> void:
	if art == null:
		return
	current_frame = 2+int(clock/FRAME_SECONDS)%10 if mode == "walk" else 1 if mode == "attack" else 0
	var i: int = current_frame
	var factor: float = 355.0/(ground_values[i]-head_values[i]) if mode != "attack" else 355.0/(ground_values[0]-head_values[0])
	art.texture = frames[i]
	art.scale = Vector2.ONE*factor
	art.position = Vector2(-202.0*factor,-ground_values[i]*factor)
	var frame: Rect2 = region(i)
	material_instance.set_shader_parameter("frame_uv",Vector4(frame.position.x/sheet.get_width(),frame.position.y/sheet.get_height(),frame.size.x/sheet.get_width(),frame.size.y/sheet.get_height()))
	material_instance.set_shader_parameter("breath_pixels",(1.0-cos(clock*TAU/3.6))*0.85 if mode == "idle" else 0.0)
