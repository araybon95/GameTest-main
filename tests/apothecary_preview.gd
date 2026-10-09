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
	State.completed_expeditions.clear()
	State.progress_path = "user://apothecary_preview.cfg"
	var settlement = load("res://scenes/hub/settlement.tscn").instantiate()
	root.add_child(settlement)
	await create_timer(0.8).timeout
	settlement._on_hotspot_hover(settlement.get_node("MapView/apothecary"), true)
	await create_timer(0.3).timeout
	await shot("C:/GAME/Ashen/apothecary-settlement-preview.png")
	settlement.queue_free()
	await process_frame
	var entrance = load("res://scenes/hub/apothecary.tscn").instantiate()
	root.add_child(entrance)
	await shot("C:/GAME/Ashen/apothecary-entrance-preview.png")
	entrance.queue_free()
	await process_frame
	State.select_expedition("infested_apothecary")
	State.start_run(20)
	for room_x in [0, 2, 3]:
		State.room_position = Vector2i(room_x, 0)
		var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
		root.add_child(battle)
		await shot("C:/GAME/Ashen/apothecary-fight-%d.png" % room_x)
		battle.queue_free()
		await process_frame
	State.room_position = Vector2i(1, 0)
	var camp = load("res://scenes/expedition/camp.tscn").instantiate()
	root.add_child(camp)
	await shot("C:/GAME/Ashen/apothecary-camp-preview.png")
	camp.queue_free()
	await process_frame
	var map = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(map)
	await shot("C:/GAME/Ashen/apothecary-map-preview.png")
	map.queue_free()
	await process_frame
	State.end_run()
	State.completed_expeditions.append("infested_apothecary")
	State.gold = 150
	var shop = load("res://scenes/hub/apothecary.tscn").instantiate()
	root.add_child(shop)
	await shot("C:/GAME/Ashen/apothecary-shop-preview.png")
	shop.queue_free()
	await process_frame
	quit()
