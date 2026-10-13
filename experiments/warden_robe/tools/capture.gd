extends SceneTree
func _initialize() -> void: call_deferred("run")
func text(value: String, at: Vector2, font_size: int) -> void:
	var label := Label.new()
	label.text = value
	label.position = at
	label.add_theme_font_size_override("font_size",font_size)
	root.add_child(label)
func run() -> void:
	var args := OS.get_cmdline_user_args()
	assert(args.size() == 2,"Pass handoff directory and capture directory")
	var directory: String = args[0]
	var output: String = args[1]
	DirAccess.make_dir_recursive_absolute(output)
	var manifest = JSON.parse_string(FileAccess.get_file_as_string(directory+"/parts.json"))
	var motion = JSON.parse_string(FileAccess.get_file_as_string(directory+"/motion-frames.json"))
	root.size = Vector2i(1280,1000)
	var bg := ColorRect.new()
	bg.color = Color("#242126")
	bg.size = root.size
	root.add_child(bg)
	text("WARDEN / BATTLE ROBE STUDY",Vector2(25,20),27)
	text("ARMOR SETUP",Vector2(140,75),22)
	text("ROBE / BREATHING / BOOT STEPS",Vector2(760,75),22)
	text("Separate front/rear cloth · hidden leg layers retained · Spine basic-bone prototype",Vector2(25,945),17)
	var original := Node2D.new()
	original.position = Vector2(365,885)
	original.scale = Vector2(.60,.60)
	root.add_child(original)
	var base_parts: Array = manifest.parts.filter(func(p): return not p.name.begins_with("robe_"))
	base_parts.sort_custom(func(a,b): return a.draw_order < b.draw_order)
	for part in base_parts:
		var sprite := Sprite2D.new()
		sprite.texture = ImageTexture.create_from_image(Image.load_from_file(directory+"/images/"+part.name+".png"))
		sprite.position = Vector2(part.center_world[0],-part.center_world[1])
		sprite.rotation = -deg_to_rad(part.rotation_world)
		sprite.scale = Vector2(-part.scale if part.flip_x else part.scale,part.scale)
		original.add_child(sprite)
	var actor := Node2D.new()
	actor.position = Vector2(995,885)
	actor.scale = Vector2(.60,.60)
	root.add_child(actor)
	var layers := {}
	for layer in motion.setup:
		var image := Image.load_from_file(directory+"/images/"+layer.name+".png")
		var polygon := Polygon2D.new()
		polygon.texture = ImageTexture.create_from_image(image)
		polygon.uv = PackedVector2Array([Vector2(0,image.get_height()),Vector2.ZERO,Vector2(image.get_width(),0),Vector2(image.get_width(),image.get_height())])
		actor.add_child(polygon)
		layers[layer.name] = polygon
	for i in range(motion.frames.size()):
		for layer in motion.frames[i]:
			var points := PackedVector2Array()
			for j in range(4): points.append(Vector2(layer.vertices[j*2],-layer.vertices[j*2+1]))
			layers[layer.name].polygon = points
		await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		assert(image.save_png(output+"/frame_%04d.png"%i)==OK)
		if i==0: assert(image.save_png(directory+"/preview.png")==OK)
	print("WARDEN_ROBE_CAPTURE_OK: 72 official-runtime-decoded frames")
	quit()
