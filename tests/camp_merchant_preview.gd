extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void:
	call_deferred("capture")
func screenshot(path: String) -> void:
	for frame in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)
func capture() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.select_expedition("old_road")
	State.start_run(42)
	State.gold = 75
	var orb: Vector2i
	for location in State.floors[0]:
		if State.floors[0][location]["kind"] == "camp":
			State.room_position = location
		if State.floors[0][location].get("merchant_orb", false):
			orb = location
	for hero in State.run_heroes.values():
		hero["hp"] = 13
		hero["stress"] = 80
	var camp = load("res://scenes/expedition/camp.tscn").instantiate()
	root.add_child(camp)
	await screenshot("res://../../camp-preview.png")
	camp.rest_party()
	await screenshot("res://../../camp-rested-preview.png")
	camp.queue_free()
	await process_frame
	var shop = load("res://scenes/hub/item_shop.tscn").instantiate()
	root.add_child(shop)
	await screenshot("res://../../emporium-preview.png")
	shop.set_category("Scrolls")
	await screenshot("res://../../emporium-scrolls-preview.png")
	shop.queue_free()
	await process_frame
	State.room_position = orb
	State.reveal_neighbors()
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await screenshot("res://../../merchant-orb-combat-preview.png")
	while not battle._living_enemies().is_empty():
		battle._deal_enemy_damage(999)
	battle._check_battle_over()
	battle._refresh_all()
	await screenshot("res://../../merchant-orb-victory-preview.png")
	battle.queue_free()
	await process_frame
	State.finish_encounter()
	var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(dungeon)
	await screenshot("res://../../merchant-orb-map-preview.png")
	dungeon.queue_free()
	await process_frame
	quit()
