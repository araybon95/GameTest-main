extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func shot(label: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("C:/GAME/Ashen/boss-objective-%s.png" % label)
func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://boss_objectives_preview.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.select_expedition("path_beast")
	for entry in [[0,"harrowed_giant","chains"],[1,"coterie_matron","rite"],[2,"howling_head","idol"]]:
		State.start_run(160)
		State.floor_index = entry[0]
		State.room_position = Vector2i.ZERO
		State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"boss","creature":entry[1],"support_creature":"anguish_penitent"}
		var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
		root.add_child(battle)
		for frame in range(4): await process_frame
		battle.presentation.set_process(false)
		if battle.presentation.boss_reveal != null: battle.presentation.boss_reveal.finish()
		for frame in range(4): await process_frame
		battle.round_number = 2 if entry[2] == "rite" else 1
		battle._refresh_all()
		await shot(entry[2]+"-intact")
		battle._interact_boss_objective()
		battle.presentation.age = 2.0
		battle.presentation._process(0.0)
		await shot(entry[2]+"-broken")
		battle.queue_free()
		await process_frame
	State.end_run()
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: six boss objective previews")
	quit()
