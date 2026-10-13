extends SceneTree
func _initialize() -> void: call_deferred("run")
func shot(path_value: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(path_value) == OK)
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty(): quit(2); return
	DirAccess.make_dir_recursive_absolute(args[0])
	if args.size() > 1 and args[1] == "sprites":
		var actors: Array = []
		var views: Array[SubViewport] = []
		for improved in [false,true]:
			var view := SubViewport.new()
			view.size = Vector2i(590,470)
			view.transparent_bg = true
			view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
			root.add_child(view)
			var actor = preload("res://actor.gd").new()
			actor.improved = improved
			view.add_child(actor)
			actors.append(actor)
			views.append(view)
		for i in range(16):
			for actor in actors: actor.set_phase(i/4.0)
			await process_frame
			await RenderingServer.frame_post_draw
			assert(views[1].get_texture().get_image().save_png(args[0]+"/frame_%02d.png"%i) == OK)
			if i%4 == 0: assert(views[0].get_texture().get_image().save_png(args[0]+"/original_%d.png"%(i/4)) == OK)
		print("WARDEN_SPRITES_CAPTURE_OK")
		quit()
		return
	root.size = Vector2i(1280,720)
	change_scene_to_file("res://lab.tscn")
	for i in range(5): await process_frame
	current_scene.set_process(false)
	if args.size() > 1 and args[1] == "movie":
		for i in range(80):
			current_scene.clock = i/30.0
			current_scene._process(0)
			await shot(args[0]+"/frame_%04d.png"%i)
			if i%20 == 0: print("FRAME ",i)
	else:
		for i in range(16):
			current_scene.clock = i/24.0
			current_scene._process(0)
			await shot(args[0]+"/pose_%02d.png"%i)
	print("WARDEN_LEG_CAPTURE_OK")
	quit()
