extends SceneTree
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.select_expedition("old_road")
	State.start_run(42)
	var locations: Array = State.floors[0].keys()
	for index in range(5):
		State.room_position = locations[index]
		State.floors[0][locations[index]]["cleared"] = true
		State.reveal_neighbors()
	var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(dungeon)
	for frame in range(12):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://../../dungeon-layout-preview.png")
	dungeon.inspect_hero("warden")
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://../../hero-equipment-preview.png")
	dungeon.inspect_hero("ranger")
	await process_frame
	assert(dungeon.has_node("HeroInspection"))
	dungeon.close_inspection()
	await process_frame
	assert(not dungeon.has_node("HeroInspection"))
	quit()
