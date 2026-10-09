extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func shot(path: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)
func run() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://mechanics_preview.cfg"
	State.completed_expeditions.clear()
	State.formation.clear()
	State.modifications.clear()
	State.party = ["warden", "ranger", "occultist"]
	State.gold = 100
	State.select_expedition("old_road")
	var prep = load("res://scenes/expedition/preparation.tscn").instantiate()
	root.add_child(prep)
	await shot("C:/GAME/Ashen/mechanics-preparation.png")
	prep.queue_free()
	await process_frame
	State.select_expedition("infested_apothecary")
	State.start_run(20)
	State.room_position = Vector2i(3, 0)
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await shot("C:/GAME/Ashen/mechanics-cocoon-combat.png")
	battle.queue_free()
	await process_frame
	State.end_run()
	for service in ["watchtower", "workshop"]:
		State.pending_service = service
		if service == "workshop":
			State.completed_expeditions.append("restore_workshop")
			State.add_item("warden_sword")
			State.add_item("cursed_thorn_relic")
		var view = load("res://scenes/hub/restoration.tscn").instantiate()
		root.add_child(view)
		await shot("C:/GAME/Ashen/mechanics-%s.png" % service)
		view.queue_free()
		await process_frame
	quit()
