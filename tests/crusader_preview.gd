extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void:
	call_deferred("run")
func shot(path: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)
func run() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.crusader_unlocked = false
	State.select_expedition("old_road")
	State.start_run(20)
	State.floor_index = 1
	for location in State.floors[1]:
		if State.floors[1][location].get("event_id", "") == "crusader_coffin":
			State.room_position = location
	var event = load("res://scenes/expedition/event_room.tscn").instantiate()
	root.add_child(event)
	await shot("C:/GAME/Ashen/crusader-coffin-preview.png")
	event.queue_free()
	await process_frame
	var barracks = load("res://scenes/hub/barracks.tscn").instantiate()
	root.add_child(barracks)
	await create_timer(0.6).timeout
	await shot("C:/GAME/Ashen/crusader-barracks-preview.png")
	barracks.queue_free()
	await process_frame
	State.crusader_unlocked = true
	State.party = ["crusader", "ranger", "healer"]
	State.start_run(20)
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	battle._select_hero("crusader")
	await shot("C:/GAME/Ashen/crusader-combat-preview.png")
	battle.queue_free()
	await process_frame
	for location in State.floors[0]:
		if State.floors[0][location]["kind"] == "camp":
			State.room_position = location
			break
	var camp = load("res://scenes/expedition/camp.tscn").instantiate()
	root.add_child(camp)
	await shot("C:/GAME/Ashen/crusader-camp-preview.png")
	camp.queue_free()
	await process_frame
	quit()
