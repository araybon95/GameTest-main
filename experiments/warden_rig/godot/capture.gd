extends SceneTree
func _initialize() -> void: call_deferred("run")
func shot(directory: String, title: String) -> bool:
	await process_frame
	await RenderingServer.frame_post_draw
	return root.get_texture().get_image().save_png(directory+"/"+title+".png") == OK
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty(): quit(2); return
	var directory: String = args[0]
	DirAccess.make_dir_recursive_absolute(directory)
	root.size = Vector2i(1440,900)
	change_scene_to_file("res://lab.tscn")
	for i in range(6): await process_frame
	var lab = current_scene
	lab.set_process(false)
	if args.size() > 1 and args[1] == "movie":
		for actor in lab.actors: actor.set_time(0)
		for i in range(270):
			if i == 60: lab.set_slot("weapon","axe")
			if i == 120: lab.set_slot("weapon","mace")
			if i == 180: lab.get_node("Pause").button_pressed = true
			if i == 210:
				lab.get_node("Pause").button_pressed = false
				lab.get_node("Facing").button_pressed = true
			if i == 240: lab.set_slot("weapon","axe")
			lab._process(1.0/30.0)
			if not await shot(directory,"frame_%04d" % i): quit(1); return
			if i%30 == 0: print("FRAME ",i)
	else:
		lab.actors[0].set_time(0.34)
		lab.actors[1].set_time(1.3)
		lab.actors[2].set_time(0.34)
		if not await shot(directory,"sword"): quit(1); return
		lab.set_slot("weapon","axe")
		if not await shot(directory,"axe"): quit(1); return
		lab.set_slot("weapon","mace")
		if not await shot(directory,"mace"): quit(1); return
		lab.set_slot("helmet","original")
		lab.set_slot("cloak","original")
		lab.set_slot("weapon","sword")
		if not await shot(directory,"stock"): quit(1); return
		lab.set_slot("helmet","wolf")
		lab.set_slot("cloak","crown")
		lab.set_slot("weapon","axe")
		lab.get_node("ShowJoints").button_pressed = true
		if not await shot(directory,"joints"): quit(1); return
	print("WARDEN_RIG_CAPTURE_COMPLETE ",directory)
	quit()
