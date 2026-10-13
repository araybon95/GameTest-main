extends SceneTree
const Motion = preload("res://motion.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	change_scene_to_file("res://lab.tscn")
	await process_frame
	await process_frame
	var lab = current_scene
	lab.set_process(false)
	assert(root.get_node_or_null("State") == null and root.get_node_or_null("GameSettings") == null)
	for frame_index in range(4):
		var frame: Dictionary = Motion.frame(frame_index)
		assert(frame.region_uv.x >= 0 and frame.region_uv.y >= 0)
		assert(frame.region_uv.x+frame.region_uv.z <= 1.0 and frame.region_uv.y+frame.region_uv.w <= 1.0)
		for key in ["near_mask","far_mask","gear_mask","shaft_mask"]:
			assert(frame[key].size() >= 3 and frame[key].size() <= 32)
			for point in frame[key]: assert(point.y > -145.0,"Leg edit enters upper-body protection region")
	for index in range(16):
		for actor in lab.actors: actor.set_phase(index/4.0)
		var material: ShaderMaterial = lab.actors[1].image.material
		assert(material.get_shader_parameter("improved") == (index%4 != 0))
		assert(material.get_shader_parameter("region") == lab.actors[0].image.material.get_shader_parameter("region"),"Upper-body source pose differs")
		assert(material.get_shader_parameter("path_count") <= 32)
	for index in range(12):
		var item: Dictionary = Motion.tween(index)
		assert(item.region_uv.x >= 0 and item.region_uv.y >= 0)
		assert(item.region_uv.x+item.region_uv.z <= 1.000001 and item.region_uv.y+item.region_uv.w <= 1.000001)
		assert(item.size.x > 0 and item.size.y > 0)
		assert(is_finite(item.origin.x) and is_finite(item.origin.y))
	lab.actors[1].set_phase(4)
	assert(lab.actors[1].phase == 0 and not lab.actors[1].image.material.get_shader_parameter("improved"))
	lab.paused = true
	var held: float = lab.clock
	lab._process(1)
	assert(lab.clock == held)
	lab.paused = false
	lab.speed = 0.5
	lab._process(0.2)
	assert(is_equal_approx(lab.clock,held+0.1))
	print("WARDEN_LEG_SMOKE_OK: original sequence, 16 pose routing, masks, source bounds, loop, pause and playback")
	quit()
