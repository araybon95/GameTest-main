extends SceneTree
# Actual shader render: cleaned legs replace old cloth and broad weapon halos,
# while the precise original equipment mask remains untouched.
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var view := SubViewport.new()
	view.size = Vector2i(590,470)
	view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(view)
	var rect := ColorRect.new()
	rect.size = view.size
	var material := ShaderMaterial.new()
	material.shader = preload("res://candidate.gdshader")
	rect.material = material
	view.add_child(rect)
	for entry in [["atlas",Color(1,0,0,1)],["tweens",Color(0,0,1,1)]]:
		var image := Image.create(8,8,false,Image.FORMAT_RGBA8)
		image.fill(entry[1])
		material.set_shader_parameter(entry[0],ImageTexture.create_from_image(image))
	for key in ["region","tween_region"]: material.set_shader_parameter(key,Vector4(0,0,1,1))
	for key in ["frame_size","tween_size"]: material.set_shader_parameter(key,Vector2(350,280))
	material.set_shader_parameter("tween_origin",Vector2(-175,-280))
	material.set_shader_parameter("canvas_size",Vector2(590,470))
	material.set_shader_parameter("root_point",Vector2(305,420))
	material.set_shader_parameter("improved",true)
	for key in ["near","far","path","gear","shaft"]:
		var points := PackedVector2Array()
		if key in ["near","path"]: points = PackedVector2Array([Vector2(-60,-80),Vector2(60,-80),Vector2(60,-40),Vector2(-60,-40)])
		if key == "gear": points = PackedVector2Array([Vector2(16,-64),Vector2(24,-64),Vector2(24,-56),Vector2(16,-56)])
		material.set_shader_parameter(key+"_count",points.size())
		points.resize(32)
		material.set_shader_parameter(key+"_mask",points)
	await process_frame
	await RenderingServer.frame_post_draw
	var result := view.get_texture().get_image()
	assert(result.get_pixel(305,360).b > 0.9,"Old cloth pixels block the cleaned leg drawing")
	assert(result.get_pixel(345,360).b > 0.9,"Broad generated-weapon exclusion retains old leg fragments")
	assert(result.get_pixel(325,360).r > 0.9,"Precise original weapon protection was lost")
	print("WARDEN_CLEANUP_OK: coherent lower replacement and precise equipment protection")
	quit()
