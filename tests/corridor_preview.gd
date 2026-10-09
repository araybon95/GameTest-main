extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.select_expedition("old_road")
	State.start_run(22)
	State.floors[0][Vector2i.ZERO] = {"kind": "event", "cleared": false, "seen": true, "event_layout": "corridor", "corridor_encounter": "roamer", "creature": "ash_raider"}
	State.enter_corridor()
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://../../surprised-roamer-preview.png")
	combat.queue_free()
	await process_frame
	quit()
