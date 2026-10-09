extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
func _initialize() -> void:
	call_deferred("capture")
func screenshot(path: String) -> void:
	for frame in range(15):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)
func capture() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.select_expedition("old_road")
	State.start_run(42)
	for location in State.floors[0]:
		if State.floors[0][location]["kind"] == "camp":
			State.room_position = location
	var camp = load("res://scenes/expedition/camp.tscn").instantiate()
	root.add_child(camp)
	await screenshot("res://../../camp-poses-preview.png")
	camp.queue_free()
	await process_frame
	State.party = ["warden", "healer", "occultist"]
	State.ensure_run_heroes()
	camp = load("res://scenes/expedition/camp.tscn").instantiate()
	root.add_child(camp)
	await screenshot("res://../../camp-healer-pose-preview.png")
	camp.queue_free()
	await process_frame
	State.party = ["warden", "ranger", "occultist"]
	State.start_run(5)
	State.floors[0][Vector2i.ZERO]["enemies"] = ["ash_raider", "gallows_scout", "ash_raider"]
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	Rules.apply_status(battle.hero_state["warden"]["statuses"], "burn")
	Rules.apply_status(battle.hero_state["ranger"]["statuses"], "bleed")
	Rules.apply_status(battle.hero_state["ranger"]["statuses"], "chill")
	Rules.apply_status(battle.hero_state["occultist"]["statuses"], "poison")
	for hero in battle.hero_state.values():
		hero["hp"] = 11
	Rules.apply_status(battle.enemies[0]["statuses"], "burn")
	Rules.apply_status(battle.enemies[1]["statuses"], "bleed")
	Rules.apply_status(battle.enemies[2]["statuses"], "poison")
	Rules.apply_status(battle.enemies[2]["statuses"], "chill")
	battle.enemies[2]["weak"] = 2
	battle.enemy_hp = 16
	battle._store_enemy()
	battle._refresh_all()
	await screenshot("res://../../combat-status-effects-preview.png")
	battle.queue_free()
	await process_frame
	quit()
