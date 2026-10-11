extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
const CASES = [["old_road", 0, "bandit-battle", "battle", "ash_raider"], ["old_road", 0, "bandit-gold", "gold", "ash_raider"], ["old_road", 1, "keep-threshold", "threshold", "keep_footman"], ["path_beast", 0, "beast-curio", "curio", "anguish_penitent"], ["infested_apothecary", 0, "medical-camp", "camp", "moth_metamorph"]]

func _initialize() -> void: call_deferred("run")

func capture(path: String) -> void:
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(path) == OK)

func run() -> void:
	root.size = Vector2i(1920, 1080)
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://dynamic_hallway_preview.cfg"
	State.party.assign(["warden", "ranger", "occultist"])
	State.hero_names["warden"] = "Alden"
	for context in CASES:
		assert(State.select_expedition(context[0]))
		State.start_run(42)
		State.floor_index = int(context[1])
		State.room_position = Vector2i(1, 0)
		var room: Dictionary = {"kind": context[3], "cleared": false, "seen": true}
		match str(context[3]):
			"battle": room["enemies"] = [context[4]]
			"gold": room.merge({"kind": "event", "event_layout": "corridor", "corridor_encounter": "gold"}, true)
			"curio": room.merge({"kind": "event", "event_layout": "corridor", "event_id": "beast_reliquary"}, true)
			"threshold": room.merge({"kind": "entry", "cleared": true}, true)
		State.floors[State.floor_index][State.room_position] = room
		var travel = Travel.new()
		travel.duration = 12.0
		travel.route_origin = Vector2i.ZERO
		travel.route_steps = [Vector2i(1, 0)]
		root.add_child(travel)
		await process_frame
		travel.set_process(false)
		travel.set_walking(true)
		assert(is_equal_approx(travel.progress.size.y, 4.0))
		assert(travel.progress.get_global_rect().end.y <= travel.passage_map.get_parent().get_global_rect().position.y)
		travel._process(5.5)
		await capture("C:/GAME/Ashen/dynamic-hallway-%s-walking.png" % context[2])
		travel.skip_travel()
		travel._process(0.01)
		await process_frame
		assert(travel.arrived and not travel.complete)
		await capture("C:/GAME/Ashen/dynamic-hallway-%s-arrival.png" % context[2])
		travel.finish()
		await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: 10 dynamic hallway previews; four themes and battle, gold, curio, camp and threshold destinations at 1920 x 1080")
	quit()
