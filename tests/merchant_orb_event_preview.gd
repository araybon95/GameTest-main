extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.size = Vector2i(1920, 1080)
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.party.assign(["warden", "ranger", "occultist"])
	for settings in [["old_road", 0, "bandit"], ["old_road", 1, "keep"], ["path_beast", 0, "beast"]]:
		State.select_expedition(settings[0])
		State.start_run(42)
		State.floor_index = int(settings[1])
		for location in State.floors[State.floor_index]:
			if State.floors[State.floor_index][location].get("merchant_orb", false): State.room_position = location
		State.finish_encounter()
		change_scene_to_file("res://scenes/expedition/merchant_orb_room.tscn")
		await create_timer(0.9).timeout
		var motion := InputEventMouseMotion.new()
		motion.position = Vector2(1510, 415)
		motion.global_position = motion.position
		Input.parse_input_event(motion)
		for frame in range(3): await process_frame
		await RenderingServer.frame_post_draw
		assert(root.get_texture().get_image().save_png("C:/GAME/Ashen/orb-event-%s.png" % settings[2]) == OK)
	current_scene.queue_free()
	await process_frame
	print("PASS: themed orb room and actual hover previews captured at 1920 × 1080")
	quit()
