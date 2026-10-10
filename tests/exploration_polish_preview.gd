extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func shot(path: String) -> void:
	await create_timer(0.28).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)
func select_run(id: String, floor: int = 0) -> void:
	for expedition in State.EXPEDITIONS:
		if expedition["id"] == id: State.selected_expedition = expedition
	State.start_run(27)
	State.floor_index = floor
	State.room_position = Vector2i.ZERO
func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://exploration_polish_preview.cfg"
	var stages_only: bool = OS.get_cmdline_user_args().has("--stages-only")
	for context in [["old_road",0,"bandit"],["old_road",1,"keep"],["path_beast",0,"beast"],["infested_apothecary",0,"medical"]]:
		select_run(context[0],context[1])
		State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"camp","cleared":false,"seen":true}
		var camp = load("res://scenes/expedition/camp.tscn").instantiate()
		root.add_child(camp)
		await shot("C:/GAME/Ashen/exploration-%s-camp.png" % context[2])
		camp.queue_free()
		await process_frame
		var event_id: String = "beast_reliquary" if context[2] == "beast" else "bandit_strongbox"
		State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"event","event_id":event_id,"event_layout":"room","cleared":false,"seen":true}
		var event = load("res://scenes/expedition/event_room.tscn").instantiate()
		root.add_child(event)
		await shot("C:/GAME/Ashen/exploration-%s-event.png" % context[2])
		event.queue_free()
		await process_frame
		if stages_only: continue
		State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"entry","cleared":true,"seen":true}
		var travel = preload("res://scenes/expedition/hallway_travel.gd").new()
		travel.duration = 20.0
		travel.arrival_duration = 20.0
		root.add_child(travel)
		await process_frame
		travel.skip_travel()
		await shot("C:/GAME/Ashen/exploration-%s-threshold.png" % context[2])
		travel.finish()
		await process_frame
	if not stages_only:
		select_run("path_beast",0)
		State.floors[0][Vector2i.ZERO] = {"kind":"stairs","cleared":true,"seen":true}
		var entrance = preload("res://scenes/expedition/floor_entrance.gd").new()
		root.add_child(entrance)
		await shot("C:/GAME/Ashen/exploration-floor-entrance.png")
		entrance.stay_here()
		await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	quit()
