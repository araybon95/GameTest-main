extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func shot(directory: String, filename: String) -> void:
	for i in range(5): await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(directory+"/"+filename+".png") == OK)
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty(): quit(2); return
	var directory: String = args[0]
	DirAccess.make_dir_recursive_absolute(directory)
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	change_scene_to_file("res://scenes/hub/settlement.tscn")
	await shot(directory,"settlement")
	current_scene.get_node("GuildHallEntrance").pressed.emit()
	for i in range(8): await process_frame
	var hall = current_scene
	hall.profile_path = "user://guild_hall_preview.cfg"
	hall.profile = hall.Profile.DEFAULTS.duplicate(true)
	hall.apply_profile()
	for i in range(24): await process_frame
	await shot(directory,"hall")
	hall.open_customization()
	await shot(directory,"customize")
	hall.close_modal()
	hall.change_choice("name","The Lanternbound")
	hall.change_choice("banner","forest")
	hall.change_choice("emblem","star")
	hall.change_choice("lighting","moonlit")
	hall.change_choice("furnishing","archive")
	await shot(directory,"moonlit")
	hall.open_board()
	await shot(directory,"board")
	print("GUILD_HALL_PREVIEW_COMPLETE ",directory)
	preload("res://scripts/settlement_music.gd").stop()
	var music = preload("res://scripts/settlement_music.gd").player()
	if music != null: music.stream = null; music.queue_free()
	await create_timer(0.1).timeout
	quit()
