extends SceneTree
func _initialize() -> void: call_deferred("run")
func shot(directory: String, title: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(directory+"/"+title+".png") == OK)
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty(): quit(2); return
	var directory: String = args[0]
	DirAccess.make_dir_recursive_absolute(directory)
	root.size = Vector2i(1280,720)
	change_scene_to_file("res://lab.tscn")
	for i in range(6): await process_frame
	var lab = current_scene
	lab.set_process(false)
	var actor = lab.actor
	if args.size() > 1 and args[1] == "movie":
		actor.animate = true
		lab.get_node("AnimateModel").set_pressed_no_signal(true)
		actor.cloak = "original"
		lab.selectors.cloak.select(0)
		actor.insignia = "patch"
		lab.selectors.insignia.select(2)
		for i in range(150):
			lab._process(1.0/30.0)
			await shot(directory,"frame_%04d" % i)
			if i%30 == 0: print("FRAME ",i)
	else:
		lab._process(0)
		await shot(directory,"reward")
		lab.get_node("PreviewReward").button_pressed = false
		lab._process(0)
		await shot(directory,"stock")
		lab.get_node("PreviewReward").button_pressed = true
		lab.get_node("ExplodeLayers").button_pressed = true
		lab._process(0)
		await shot(directory,"exploded")
		lab.get_node("ExplodeLayers").button_pressed = false
		actor.cloak = "original"
		lab.selectors.cloak.select(0)
		actor.insignia = "patch"
		lab.selectors.insignia.select(2)
		lab._process(0)
		await shot(directory,"patch")
		lab.get_node("InspectLayer").select(2)
		lab.get_node("InspectLayer").item_selected.emit(2)
		lab._process(0)
		await shot(directory,"patch-only")
	print("WARDEN_COSMETIC_CAPTURE_COMPLETE ",directory)
	quit()
