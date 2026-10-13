extends SceneTree
## Render vertices decoded by the official Spine runtime, not native rig transforms.
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2: quit(2); return
	var directory: String = args[0]
	root.size = Vector2i(1000,900)
	var canvas := Node2D.new()
	root.add_child(canvas)
	var background := ColorRect.new()
	background.color = Color("#29282c")
	background.size = Vector2(1000,900)
	canvas.add_child(background)
	label(canvas,"WARDEN / SPINE SETUP HANDOFF",Vector2(28,28),28)
	label(canvas,"20 basic bones · 24 image attachments · replaceable blockout artwork",Vector2(29,76),18)
	var entries = JSON.parse_string(FileAccess.get_file_as_string(directory+"/decoded-setup.json"))
	for entry in entries:
		var image := Image.load_from_file(directory+"/images/"+entry.path+".png")
		if image == null: quit(1); return
		var polygon := Polygon2D.new()
		var points := PackedVector2Array()
		for i in range(4): points.append(Vector2(entry.vertices[i*2],-entry.vertices[i*2+1]))
		polygon.polygon = points
		polygon.uv = PackedVector2Array([Vector2(0,entry.height),Vector2.ZERO,Vector2(entry.width,0),Vector2(entry.width,entry.height)])
		polygon.texture = ImageTexture.create_from_image(image)
		polygon.position = Vector2(520,748)
		polygon.scale = Vector2.ONE*1.65
		canvas.add_child(polygon)
	label(canvas,"Decoded from Spine JSON by the official spine-core runtime.",Vector2(29,805),18)
	label(canvas,"Starting rig only. Match the supplied references in Spine before authoring final motion.",Vector2(29,843),17)
	for i in range(4): await process_frame
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(args[1])
	print("SPINE_SETUP_PREVIEW_OK" if error == OK else "SPINE_SETUP_PREVIEW_FAILED")
	quit(0 if error == OK else 1)
func label(parent: Node, text_value: String, position_value: Vector2, font_size: int) -> void:
	var item := Label.new()
	item.text = text_value
	item.position = position_value
	item.add_theme_font_size_override("font_size",font_size)
	item.add_theme_color_override("font_color",Color("#dfd1b8"))
	parent.add_child(item)
