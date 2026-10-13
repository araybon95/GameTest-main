extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var view := SubViewport.new()
	view.size = Vector2i(800,600)
	view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(view)
	var background := ColorRect.new()
	background.color = Color("#201920")
	background.size = Vector2(800,600)
	view.add_child(background)
	var actor = load("res://actor.gd").new()
	actor.position = Vector2(430,560)
	actor.scale = Vector2.ONE*1.2
	view.add_child(actor)
	await process_frame
	await RenderingServer.frame_post_draw
	var equipped: Image = view.get_texture().get_image()
	actor.cape.visible = false
	await process_frame
	await RenderingServer.frame_post_draw
	var hidden: Image = view.get_texture().get_image()
	var differences: int = 0
	for y in range(600):
		for x in range(800):
			var a := equipped.get_pixel(x,y)
			var b := hidden.get_pixel(x,y)
			if absf(a.r-b.r)+absf(a.g-b.g)+absf(a.b-b.b) > 0.03:
				differences += 1
	print("Visible cloak pixel differences: %d" % differences)
	if differences < 2000:
		push_error("Equipped cloak must render above the background")
		quit(1)
	else:
		quit(0)
