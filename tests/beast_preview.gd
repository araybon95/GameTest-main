extends SceneTree
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("run")

func capture(path: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)

func run() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	var region = load("res://scenes/expedition/region_select.tscn").instantiate()
	root.add_child(region)
	await capture("res://../../village-selection-preview.png")
	region.choose(1, 0)
	await capture("res://../../regions-preview.png")
	region.queue_free()
	await process_frame
	for id in ["old_road", "path_beast"]:
		State.select_expedition(id)
		State.start_run(42)
		State.room_position = Vector2i(4, 3) if id == "path_beast" else Vector2i.ZERO
		var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
		root.add_child(combat)
		await capture("res://../../%s-combat-preview.png" % id)
		combat.queue_free()
		await process_frame
		for location in State.floors[0]:
			if State.floors[0][location]["kind"] == "camp":
				State.room_position = location
		var camp = load("res://scenes/expedition/camp.tscn").instantiate()
		root.add_child(camp)
		await capture("res://../../%s-camp-preview.png" % id)
		camp.queue_free()
		await process_frame
	quit()
