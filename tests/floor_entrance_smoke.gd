extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Entrance = preload("res://scenes/expedition/floor_entrance.gd")
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://entrance_test_progress.cfg"
	for expedition in ["old_road", "path_beast"]:
		State.select_expedition(expedition)
		State.start_run(20)
		State.floor_index = 1 if expedition == "old_road" else 0
		State.room_position = Vector2i(4, 3)
		var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
		root.add_child(battle)
		await process_frame
		battle.enemies[0]["hp"] = 0
		battle.enemy_hp = 0
		battle._check_battle_over()
		await process_frame
		assert(not battle.has_node("FloorEntrancePrompt"), "Support must fall before the entrance opens")
		for enemy in battle.enemies:
			enemy["hp"] = 0
		battle._check_battle_over()
		await process_frame
		await process_frame
		assert(battle.has_node("FloorEntrancePrompt"))
		assert(State.can_descend() and not State.run_complete)
		assert(State.run_heroes == battle.hero_state)
		var reward_gold: int = State.gold
		battle._check_battle_over()
		assert(State.gold == reward_gold)
		var old_floor: int = State.floor_index
		var prompt = battle.get_node("FloorEntrancePrompt")
		prompt.on_stay = Callable()
		prompt.stay_here()
		await process_frame
		assert(State.floor_index == old_floor and State.can_descend())
		var reopened = Entrance.new()
		reopened.on_descend = func(): State.descend()
		root.add_child(reopened)
		reopened.accept_entrance()
		assert(State.floor_index == old_floor + 1 and State.room_position == Vector2i.ZERO)
		battle.queue_free()
		await process_frame
	State.select_expedition("path_beast")
	State.start_run(20)
	State.floor_index = 1
	State.room_position = Vector2i(4, 3)
	var coterie = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(coterie)
	await process_frame
	for phase in range(3):
		coterie.enemy_hp = 0
		coterie._check_battle_over()
		await process_frame
		await process_frame
		assert(coterie.has_node("FloorEntrancePrompt") == (phase == 2))
	coterie.queue_free()
	await process_frame
	State.select_expedition("old_road")
	State.start_run(20)
	State.floor_index = 2
	State.room_position = Vector2i(4, 3)
	var final_battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(final_battle)
	await process_frame
	for enemy in final_battle.enemies:
		enemy["hp"] = 0
	final_battle.enemy_hp = 0
	final_battle._check_battle_over()
	await process_frame
	assert(not final_battle.has_node("FloorEntrancePrompt"))
	final_battle.queue_free()
	await process_frame
	print("PASS: floor entrances wait for support, preserve rewards and party, allow staying and descent, exclude final bosses")
	quit()
