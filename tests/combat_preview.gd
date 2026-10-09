extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	for frame in range(12):
		await process_frame
	combat._select_hero("ranger")
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://../../combat-layout-preview.png")
	quit()
