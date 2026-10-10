extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
const ORB_SCENE = "res://scenes/expedition/merchant_orb_room.tscn"
func _initialize() -> void: call_deferred("run")
func settle() -> void:
	for frame in range(3): await process_frame
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://orb_event_progress.cfg"
	Saves.directory = "user://orb_event_saves/"
	State.party.assign(["warden", "ranger", "occultist"])
	State.select_expedition("old_road")
	State.start_run(42)
	for location in State.floors[0]:
		if State.floors[0][location].get("merchant_orb", false): State.room_position = location
	var position: Vector2i = State.room_position
	change_scene_to_file("res://scenes/expedition/dungeon.tscn")
	await settle()
	current_scene.open_shop()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/expedition/dungeon.tscn")
	assert(not State.merchant_orb_available())
	change_scene_to_file("res://scenes/combat/combatscene.tscn")
	await settle()
	var battle = current_scene
	assert(not battle.has_node("MerchantOrb"))
	battle._enter_merchant_orb()
	assert(not State.floors[0][position]["cleared"])
	while not battle._living_enemies().is_empty(): battle._deal_enemy_damage(999)
	battle._check_battle_over()
	battle._refresh_all()
	assert(battle.battle_over and battle.end_turn_button.text == "INSPECT MERCHANT ORB")
	battle._on_end_turn_button_pressed()
	await settle()
	assert(current_scene.scene_file_path == ORB_SCENE and State.merchant_orb_available())
	var heroes: Dictionary = State.run_heroes.duplicate(true)
	var progress: Dictionary = State.hero_progress.duplicate(true)
	var gold: int = State.gold
	var inventory: Dictionary = State.inventory.duplicate(true)
	var journey: Dictionary = State.journey.duplicate(true)
	var floors: Array = State.floors.duplicate(true)
	assert(current_scene.has_node("MerchantOrbObject") and current_scene.has_node("MerchantOrbProp"))
	assert(root.get_node("GameSettings").safe_to_save())
	# Object handlers cannot bypass the combat gate, even if room state changes.
	State.floors[0][position]["cleared"] = false
	current_scene.touch_orb()
	assert(not current_scene.transitioning)
	State.floors[0][position]["cleared"] = true
	for visit in range(2):
		current_scene.get_node("MerchantOrbObject").pressed.emit()
		await settle()
		assert(current_scene.scene_file_path == "res://scenes/hub/item_shop.tscn")
		assert(State.shop_return_scene == ORB_SCENE and root.get_node("GameSettings").safe_to_save())
		current_scene.return_to_party()
		await settle()
		assert(current_scene.scene_file_path == ORB_SCENE)
		assert(State.run_heroes == heroes and State.hero_progress == progress)
		assert(State.gold == gold and State.inventory == inventory and State.journey == journey)
		assert(State.floors == floors and State.room_position == position)
	assert(Saves.save(1))
	State.gold = 0
	assert(Saves.load_slot(1) and State.gold == gold and State.merchant_orb_available())
	current_scene.continue_exploring()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/expedition/dungeon.tscn")
	current_scene.open_shop()
	await settle()
	assert(current_scene.scene_file_path == ORB_SCENE and State.room_position == position)
	assert(State.run_heroes == heroes and State.floors == floors and State.hero_progress == progress)
	current_scene.queue_free()
	await settle()
	print("PASS: orb absent during combat, post-victory room event, sealed access guard, clickable prop, merchant return/revisit, no repeated rewards or HP/position changes, safe saves and checkpoint continuity")
	quit()
