extends SceneTree
func _initialize() -> void: call_deferred("run")
func label(parent: Node, value: String, at: Vector2, font_size: int) -> void:
	var text := Label.new()
	text.text = value
	text.position = at
	text.add_theme_font_size_override("font_size",font_size)
	parent.add_child(text)
func run() -> void:
	var args := OS.get_cmdline_user_args()
	assert(args.size() == 1)
	var directory: String = args[0]
	var manifest = JSON.parse_string(FileAccess.get_file_as_string(directory+"/parts.json"))
	root.size = Vector2i(1280,1000)
	var background := ColorRect.new()
	background.size = root.size
	background.color = Color("#242126")
	root.add_child(background)
	label(root,"WARDEN / SPINE CUTOUT PARTS",Vector2(25,20),27)
	label(root,"Setup draft · separate shoulders and limbs · original game unchanged",Vector2(25,62),17)
	var body := Node2D.new()
	body.position = Vector2(365,885)
	body.scale = Vector2(0.60,0.60)
	root.add_child(body)
	var ordered: Array = manifest.parts.duplicate()
	ordered.sort_custom(func(a,b): return a.draw_order < b.draw_order)
	for part in ordered:
		var sprite := Sprite2D.new()
		sprite.texture = ImageTexture.create_from_image(Image.load_from_file(directory+"/images/"+part.name+".png"))
		sprite.position = Vector2(part.center_world[0],-part.center_world[1])
		sprite.rotation = -deg_to_rad(part.rotation_world)
		sprite.scale = Vector2(-part.scale if part.flip_x else part.scale,part.scale)
		body.add_child(sprite)
	for i in range(manifest.parts.size()):
		var part: Dictionary = manifest.parts[i]
		var image := Image.load_from_file(directory+"/images/"+part.name+".png")
		var sprite := Sprite2D.new()
		sprite.texture = ImageTexture.create_from_image(image)
		sprite.position = Vector2(675+(i%4)*150,185+(i/4)*166)
		var fit := minf(130.0/image.get_width(),132.0/image.get_height())
		sprite.scale = Vector2(fit,fit)
		root.add_child(sprite)
		label(root,part.name,Vector2(610+(i%4)*150,255+(i/4)*166),12)
	label(root,"Near = visible mace side · Far = shield side. Setup requires artist adjustment in Spine.",Vector2(25,945),17)
	await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(directory+"/parts-preview.png") == OK)
	# A separate transparent setup export makes the composed artwork easy to inspect.
	background.visible = false
	for child in root.get_children():
		if child != body: child.visible = false
	root.transparent_bg = true
	await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(directory+"/setup-preview.png") == OK)
	print("WARDEN_PARTS_PREVIEW_OK")
	quit()
