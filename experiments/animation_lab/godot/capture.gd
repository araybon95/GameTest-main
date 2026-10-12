extends SceneTree
const FPS: int = 30
func _initialize() -> void: call_deferred("run")
func shot(directory: String, title: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(directory+"/"+title+".png") == OK)
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		push_error("Usage: --script res://capture.gd -- OUTPUT_DIRECTORY [movie|montage]")
		quit(2)
		return
	var directory: String = args[0]
	DirAccess.make_dir_recursive_absolute(directory)
	root.size = Vector2i(1280,720)
	change_scene_to_file("res://lab.tscn")
	for i in range(6): await process_frame
	var lab = current_scene
	lab.set_process(false)
	var actor = lab.actor
	if args.size() > 1 and args[1] == "movie":
		for i in range(13*FPS):
			if i == 4*FPS: actor.requested_walking = false
			if i == 6*FPS: actor.requested_walking = true; actor.reverse = true
			if i == 9*FPS: actor.reverse = false
			lab.get_node("FaceLeft").set_pressed_no_signal(actor.reverse)
			lab._process(1.0/FPS)
			await shot(directory,"frame_%04d" % i)
			if i%FPS == 0: print("FRAME ",i)
	elif args.size() > 1 and args[1] == "montage":
		for hero in actor.Catalog.REGIONS:
			actor.select_hero(hero)
			var hero_index: int = actor.Catalog.REGIONS.keys().find(hero)
			lab.get_node("HeroSelection").select(hero_index)
			for i in range(3*FPS):
				lab._process(1.0/FPS)
				await shot(directory,"frame_%04d" % (hero_index*3*FPS+i))
			print("HERO ",hero)
	else:
		for hero in actor.Catalog.REGIONS:
			actor.select_hero(hero)
			lab.get_node("HeroSelection").select(actor.Catalog.REGIONS.keys().find(hero))
			actor.walking = 1
			actor.clock = 1
			actor.style = "subtle"
			lab.get_node("ModeSelection").select(1)
			actor.gait = -actor.Catalog.PHASES[hero]
			lab._process(0)
			await shot(directory,hero+"-neutral")
			actor.style = "animated"
			lab.get_node("ModeSelection").select(0)
			for i in range(4):
				actor.gait = PI*0.5*i-actor.Catalog.PHASES[hero]
				lab._process(0)
				await shot(directory,hero+"-phase-"+str(i))
			actor.show_grid = true
			lab._process(0)
			await shot(directory,hero+"-mesh")
			actor.show_grid = false
	print("CAPTURE_COMPLETE ",directory)
	quit()
