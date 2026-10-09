extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	State.progress_path = "user://crusader_test_progress.cfg"
	State.progress_loaded = true
	State.crusader_unlocked = false
	State.select_expedition("old_road")
	for seed_id in range(100):
		State.start_run(seed_id)
		var found: int = 0
		for floor_id in range(State.floor_count):
			for room in State.floors[floor_id].values():
				if room.get("event_id", "") == "crusader_coffin":
					assert(floor_id == 1 and room["event_layout"] == "room" and not room.get("merchant_orb", false))
					found += 1
		assert(found == 1)
	State.floor_index = 1
	for location in State.floors[1]:
		if State.floors[1][location].get("event_id", "") == "crusader_coffin":
			State.room_position = location
	var hp: int = State.run_heroes["warden"]["hp"]
	assert(State.Events.resolve(State, "", true).is_empty())
	assert(not State.crusader_unlocked)
	State.run_heroes["warden"]["hp"] = 2
	assert(State.Events.resolve(State, "warden").is_empty())
	State.run_heroes["warden"]["hp"] = hp
	var result: Dictionary = State.Events.resolve(State, "warden")
	assert(int(result["damage"]) in [2, 3] and State.run_heroes["warden"]["hp"] == hp - int(result["damage"]))
	assert(State.crusader_unlocked and State.Events.resolve(State, "warden").is_empty())
	State.crusader_unlocked = false
	State.progress_loaded = false
	State.load_progression()
	assert(State.crusader_unlocked)
	State.start_run(3)
	for room in State.floors[1].values():
		assert(room.get("event_id", "") != "crusader_coffin")
	State.party = ["crusader", "ranger", "healer"]
	State.start_run(3)
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	battle._select_hero("crusader")
	battle.hero_state["crusader"]["hp"] = 20
	battle.hero_state["crusader"]["block"] = 50
	battle._play_card("crusader", 2)
	assert(battle.hero_state["crusader"]["hp"] == 25)
	assert(battle.hero_state["crusader"]["block"] == 50 and battle.hero_state["crusader"]["ap"] == 1)
	battle._play_card("crusader", 2)
	assert(battle.hero_state["crusader"]["hp"] == 25 and battle.hero_state["crusader"]["ap"] == 1)
	battle.hero_state["crusader"]["ap"] = 2
	battle.hero_state["crusader"]["hp"] = 2
	battle.hero_state["crusader"]["cooldowns"].clear()
	battle._play_card("crusader", 2)
	assert(battle.hero_state["crusader"]["hp"] == 2 and battle.hero_state["crusader"]["ap"] == 2)
	battle.hero_state["crusader"]["hp"] = 30
	battle.enemies[0]["block"] = 0
	battle._play_card("crusader", 3)
	assert(battle.hero_state["crusader"]["block"] == 56 and battle.hero_state["crusader"]["ap"] == 0)
	assert(battle.enemies[0]["statuses"].has("bleed"))
	battle.enemies[0]["statuses"].clear()
	battle.enemy_block = 100
	battle._resolve_card("crusader", State.card_stats("pc_charge"))
	assert(not battle.enemies[0]["statuses"].has("bleed"))
	battle.queue_free()
	await process_frame
	var rng := RandomNumberGenerator.new()
	for i in range(100):
		assert(State.Items.item(State.Items.roll_equipment(rng, ["crusader"], true))["hero"] == "crusader")
	print("PASS: 100 floor-2 coffin seeds, survivor-only 2–3 HP rescue, permanent unlock, one-use, pain healing/cooldown/AP, charge Block/Bleed and class legendary")
	quit()
