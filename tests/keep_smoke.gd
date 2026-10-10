extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://keep_test_progress.cfg"
	State.crusader_unlocked = false
	State.select_expedition("old_road")
	for seed_id in range(200):
		State.start_run(seed_id)
		assert(State.floor_count == 3)
		for depth in range(3):
			var rooms: Dictionary = State.floors[depth]
			var camps: int = 0
			var orbs: int = 0
			var rescue: int = 0
			var pool: Array = State.floor_enemy_pool(depth)
			for room in rooms.values():
				if room["kind"] == "battle":
					assert(room["enemies"].size() <= 3)
					for id in room["enemies"]:
						assert(pool.has(id))
				camps += 1 if room["kind"] == "camp" else 0
				orbs += 1 if room.get("merchant_orb", false) else 0
				rescue += 1 if room.get("event_id", "") == "crusader_coffin" else 0
			assert(camps >= 1 and orbs == 1 and rescue == (1 if depth == 1 else 0))
			var exit: Dictionary = rooms[Vector2i(4, 3)]
			if depth == 0:
				assert(exit["kind"] == "stairs")
			else:
				assert(exit["kind"] == "boss" and exit["creature"] == ("keep_son" if depth == 1 else "undying_lord"))
				assert(pool.has(exit["support_creature"]) and exit["enemies"].size() == 1)
				assert(exit["final_boss"] == (depth == 2))
	State.floor_index = 1
	State.room_position = Vector2i(4, 3)
	assert(not State.can_descend())
	State.finish_encounter()
	assert(not State.run_complete and State.can_descend())
	assert(State.claim_room_loot().size() >= 1)
	assert(State.descend() and State.floor_index == 2 and State.room_position == Vector2i.ZERO)
	State.room_position = Vector2i(4, 3)
	State.finish_encounter()
	assert(State.run_complete and not State.can_descend())
	for depth in [1, 2]:
		State.start_run(20)
		State.floor_index = depth
		State.room_position = Vector2i(4, 3)
		var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
		root.add_child(battle)
		await process_frame
		assert(battle.enemies.size() == 2 and battle.enemies[1]["support"])
		assert(battle.enemies[1]["max_hp"] == int(round(battle.enemies[1]["normal_hp"] * 0.3)))
		assert(battle.enemies[1]["attack"] == int(round(battle.enemies[1]["normal_attack"] * 0.3)))
		assert(battle.enemies[0]["undead"] and battle.enemies[0]["moves"].size() == 3)
		assert(battle.get_node("BattlefieldBackdrop/BackgroundArt").texture.resource_path == "res://assets/generated/keep_battle_stage.png")
		battle.queue_free()
		await process_frame
	var stronger: Dictionary = Rules.make_enemy(State.creature("keep_footman"), "keep_footman", 1)
	var raider: Dictionary = Rules.make_enemy(State.creature("ash_raider"), "ash_raider", 0)
	assert(stronger["hp"] > raider["hp"] and stronger["attack"] > raider["attack"])
	print("PASS: 200 floor-specific keep seeds, original first floor, stronger elites, preserved rescue/camps/orbs, guardian-gated descent, final victory, boss supports and background routing")
	quit()
