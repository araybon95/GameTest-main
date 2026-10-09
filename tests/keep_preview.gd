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
	State.crusader_unlocked = true
	State.party = ["warden", "ranger", "crusader"]
	State.select_expedition("old_road")
	for depth in [1, 2]:
		State.start_run(20)
		State.floor_index = depth
		State.room_position = Vector2i(4, 3)
		var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
		root.add_child(battle)
		await shot("C:/GAME/Ashen/keep-boss-floor-%d.png" % (depth + 1))
		if depth == 1:
			for enemy in battle.enemies:
				enemy["hp"] = 0
			battle.enemy_hp = 0
			battle._check_battle_over()
			await shot("C:/GAME/Ashen/keep-entrance-preview.png")
		battle.queue_free()
		await process_frame
	State.start_run(20)
	State.floor_index = 2
	State.floors[2][Vector2i.ZERO]["enemies"] = ["keep_footman", "keep_crossbow", "keep_wolfguard"]
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await shot("C:/GAME/Ashen/keep-elites-preview.png")
	battle.queue_free()
	await process_frame
	quit()
