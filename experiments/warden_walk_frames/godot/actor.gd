extends Control
const DATA = preload("res://motion.gd")
var improved := false
var image: ColorRect
var phase := 0.0
var last_tick := -1
var last_mode := false
func _ready() -> void:
	size = Vector2(590,470)
	image = ColorRect.new()
	image.size = size
	image.material = ShaderMaterial.new()
	image.material.shader = preload("res://candidate.gdshader")
	add_child(image)
	set_phase(0)
func set_phase(value: float) -> void:
	phase = fposmod(value,4.0)
	var tick := int(floorf(phase*4.0+0.00001))%16
	if tick == last_tick and improved == last_mode: return
	last_tick = tick
	last_mode = improved
	var first := tick/4
	var substep := tick%4
	var a: Dictionary = DATA.frame(first)
	var b: Dictionary = DATA.frame((first+1)%4)
	var tween: Dictionary = DATA.tween(first*3+maxi(0,substep-1))
	var material: ShaderMaterial = image.material
	material.set_shader_parameter("atlas",preload("res://assets/hero_warden_walk.png"))
	material.set_shader_parameter("tweens",preload("res://assets/warden_leg_inbetweens.png"))
	material.set_shader_parameter("canvas_size",size)
	material.set_shader_parameter("root_point",Vector2(305,420))
	material.set_shader_parameter("region",a.region_uv)
	material.set_shader_parameter("frame_size",a.size)
	material.set_shader_parameter("tween_region",tween.region_uv)
	material.set_shader_parameter("tween_size",tween.size)
	material.set_shader_parameter("tween_origin",tween.origin)
	material.set_shader_parameter("tween_gear",tween.gear)
	material.set_shader_parameter("original_hand",a.hand)
	material.set_shader_parameter("improved",improved and substep > 0)
	for key in ["near","far","gear","shaft"]:
		material.set_shader_parameter(key+"_mask",DATA.padded(a[key+"_mask"]))
		material.set_shader_parameter(key+"_count",a[key+"_mask"].size())
	var path := Geometry2D.convex_hull(a.near_mask+a.far_mask+b.near_mask+b.far_mask)
	assert(path.size() <= 32)
	material.set_shader_parameter("path_mask",DATA.padded(path))
	material.set_shader_parameter("path_count",path.size())
