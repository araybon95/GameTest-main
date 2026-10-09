extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")

func _initialize() -> void:
	call_deferred("run_tests")

func run_tests() -> void:
	State.inventory.clear()
	State.equipment.clear()
	State.select_expedition("old_road")
	for seed_value in range(100):
		State.start_run(seed_value)
		for floor_rooms in State.floors:
			for room in floor_rooms.values():
				if room["kind"] == "battle":
					assert(room["enemies"].size() >= 1 and room["enemies"].size() <= 3)
				if room["kind"] == "boss":
					assert(room["enemies"].size() == 1 and room.has("support_creature"))
	for depth in range(3):
		var support: Dictionary = Rules.make_enemy(State.creature("gallows_scout"), "gallows_scout", depth, false, true)
		assert(support["max_hp"] == int(round((46 + depth * 10) * 0.3)))
		assert(support["attack"] == int(round((10 + depth * 2) * 0.3)))
	State.start_run(5)
	State.floors[0][Vector2i.ZERO]["enemies"] = ["ash_raider", "gallows_scout", "ash_raider"]
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	assert(battle.enemies.size() == 3 and battle.enemy_views.size() == 3)
	battle._select_enemy(1)
	var hp0: int = int(battle.enemies[0]["hp"])
	var hp1: int = battle.enemy_hp
	battle._play_card("warden", 0)
	assert(battle.enemies[0]["hp"] == hp0 and battle.enemies[1]["hp"] == hp1 - 6)
	# Marks stay attached to their chosen enemy, even after changing targets.
	battle.enemy_mark_bonus = 5
	battle._select_enemy(2)
	battle._deal_enemy_damage(1)
	assert(battle.enemies[1]["mark"] == 5)
	# A killed target is replaced automatically; victory requires the whole group.
	battle._deal_enemy_damage(999)
	battle._check_battle_over()
	assert(not battle.battle_over and battle.selected_enemy_index != 2)
	battle._deal_enemy_damage(999)
	battle._check_battle_over()
	assert(not battle.battle_over)
	battle._deal_enemy_damage(999)
	battle._check_battle_over()
	assert(battle.battle_over)
	battle.queue_free()
	await process_frame
	State.start_run(6)
	State.floors[0][Vector2i.ZERO]["enemies"] = ["ash_raider"]
	battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	Rules.apply_status(battle.hero_state["warden"]["statuses"], "bleed")
	battle.hero_state["warden"]["block"] = 99
	var hero_hp: int = int(battle.hero_state["warden"]["hp"])
	battle._tick_hero_statuses("warden")
	assert(battle.hero_state["warden"]["hp"] == hero_hp - 2)
	battle._tick_hero_statuses("warden")
	assert(battle.hero_state["warden"]["hp"] == hero_hp - 4)
	assert(not battle.hero_state["warden"]["statuses"].has("bleed"))
	Rules.apply_status(battle.enemies[0]["statuses"], "burn")
	var enemy_hp: int = battle.enemy_hp
	battle._tick_enemy_statuses(0)
	assert(battle.enemy_hp == enemy_hp - 3)
	battle._tick_enemy_statuses(0)
	assert(battle.enemy_hp == enemy_hp - 6)
	assert(not battle.enemies[0]["statuses"].has("burn"))
	Rules.apply_status(battle.hero_state["warden"]["statuses"], "poison")
	var poisoned_hp: int = int(battle.hero_state["warden"]["hp"])
	battle._tick_hero_statuses("warden")
	battle._tick_hero_statuses("warden")
	assert(battle.hero_state["warden"]["hp"] == poisoned_hp - 4)
	assert(not battle.hero_state["warden"]["statuses"].has("poison"))
	Rules.apply_status(battle.hero_state["warden"]["statuses"], "chill")
	assert(battle._attack_damage("warden", {"damage": 8}) == 6)
	battle._advance_chill(battle.hero_state["warden"]["statuses"])
	assert(battle._attack_damage("warden", {"damage": 8}) == 6)
	battle._advance_chill(battle.hero_state["warden"]["statuses"])
	assert(battle._attack_damage("warden", {"damage": 8}) == 8)
	# Full Block prevents on-hit statuses. Raider first move is bleed.
	battle.hero_state["warden"]["statuses"].clear()
	battle.hero_state["warden"]["block"] = 99
	battle._enemy_action()
	assert(not battle.hero_state["warden"]["statuses"].has("bleed"))
	# Multi-hit move lands both hits on the predicted target.
	battle.round_number = 2
	var predicted: String = battle._enemy_target()
	assert(predicted == "warden", "Melee attacks respect front formation")
	battle.hero_state[predicted]["block"] = 0
	var before: int = int(battle.hero_state[predicted]["hp"])
	var per_hit: int = int(round(battle._enemy_attack_power() * 0.6))
	battle._enemy_action()
	assert(battle.hero_state[predicted]["hp"] == before - per_hit * 2)
	# Poison/burn can trigger Death's Door and a subsequent tick can slay.
	battle.hero_state["occultist"]["hp"] = 1
	Rules.apply_status(battle.hero_state["occultist"]["statuses"], "poison")
	battle._tick_hero_statuses("occultist")
	assert(battle.hero_state["occultist"]["deaths_door"])
	battle._tick_hero_statuses("occultist")
	assert(battle.hero_state["occultist"]["dead"])
	# Burn can finish the last foe before it acts.
	battle.enemy_hp = 2
	battle._store_enemy()
	Rules.apply_status(battle.enemies[0]["statuses"], "burn")
	var unhurt: int = int(battle.hero_state["ranger"]["hp"])
	battle._enemy_action()
	battle._check_battle_over()
	assert(battle.battle_over and battle.hero_state["ranger"]["hp"] == unhurt)
	battle.queue_free()
	await process_frame
	State.start_run(7)
	State.floor_index = State.floor_count - 1
	State.room_position = Vector2i(4, 3)
	battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	assert(battle.enemies.size() == 2 and battle.enemies[1]["support"])
	assert(battle.enemies[1]["max_hp"] == int(round((46 + State.floor_index * 10) * 0.3)))
	battle._select_enemy(1)
	battle.round_number = 2
	assert(battle._enemy_move(1)["effect"] == "ally_guard")
	battle._enemy_action()
	assert(battle.enemies[0]["block"] > 0)
	print("PASS: 100 encounter seeds, 3-enemy cap, boss plus 30% support, targeting, mark isolation, full-group victory, timed DoT/chill, blocked effects and multiple hits")
	quit()
