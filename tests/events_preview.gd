extends SceneTree
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	for id in ["old_road", "path_beast"]:
		State.select_expedition(id)
		State.start_run(19)
		for location in State.floors[0]:
			if State.floors[0][location]["kind"] == "event":
				State.room_position = location
		for layout in ["room", "corridor"]:
			State.floors[0][State.room_position]["event_layout"] = layout
			var event = load("res://scenes/expedition/event_room.tscn").instantiate()
			root.add_child(event)
			await process_frame
			await process_frame
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("res://../../%s-%s-event-preview.png" % [id, layout])
			event.queue_free()
			await process_frame
	quit()
