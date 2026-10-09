extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")

func _initialize() -> void:
	call_deferred("capture")

func screenshot(path: String) -> void:
	for frame in range(10):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)

func capture() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.select_expedition("old_road")
	State.start_run(42)
	State.floors[0][Vector2i.ZERO]["enemies"] = ["ash_raider", "gallows_scout", "ash_raider"]
	State.add_item("fire_bolt_scroll", 2)
	State.add_item("lightning_bolt_scroll")
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	combat._select_enemy(1)
	Rules.apply_status(combat.enemies[1]["statuses"], "burn")
	Rules.apply_status(combat.hero_state["warden"]["statuses"], "bleed")
	combat._refresh_all()
	await screenshot("res://../../multi-enemy-preview.png")
	combat.queue_free()
	await process_frame
	State.start_run(42)
	State.floor_index = State.floor_count - 1
	State.room_position = Vector2i(4, 3)
	combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	await screenshot("res://../../boss-support-preview.png")
	quit()
