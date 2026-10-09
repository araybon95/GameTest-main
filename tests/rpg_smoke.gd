extends SceneTree

const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("run_tests")

func run_tests() -> void:
	assert(State.select_expedition("old_road"))
	for seed_value in range(100):
		State.start_run(seed_value)
		assert(State.floor_count in [2, 3])
		for rooms in State.floors:
			var reachable: Array = [Vector2i.ZERO]
			var index: int = 0
			while index < reachable.size():
				for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
					var next: Vector2i = reachable[index] + direction
					if rooms.has(next) and not reachable.has(next):
						reachable.append(next)
				index += 1
			assert(reachable.size() == rooms.size())
			assert(reachable.has(Vector2i(4, 3)))
	State.start_run(42)
	State.navigation_voters = ["one", "two"]
	var destination: Vector2i
	for direction in [Vector2i.RIGHT, Vector2i.DOWN]:
		if State.floors[0].has(direction):
			destination = direction
	assert(not State.vote_move("intruder", destination))
	assert(not State.vote_move("one", destination))
	assert(State.room_position == Vector2i.ZERO)
	assert(State.vote_move("two", destination))
	State.navigation_voters = ["local"]
	State.start_run(42)
	var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(dungeon)
	await process_frame
	dungeon.queue_free()
	await process_frame
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	assert(battle.hero_state["warden"]["abilities"].size() == 5)
	assert(not battle.hero_state["warden"].has("hand"))
	battle._play_card("warden", 0)
	assert(battle.hero_state["warden"]["ap"] == 1)
	battle._select_hero("ranger")
	battle._play_card("ranger", 0)
	assert(battle.hero_state["ranger"]["ap"] == 1)
	battle._select_hero("warden")
	battle._end_turn()
	assert(battle.hero_state["warden"]["ap"] == 2)
	battle._play_card("warden", 2)
	assert(battle.hero_state["warden"]["cooldowns"]["wd_bash"] == 2)
	battle._end_turn()
	assert(battle.hero_state["warden"]["cooldowns"]["wd_bash"] == 1)
	var before: int = battle.hero_state["warden"]["ap"]
	battle._play_card("warden", 2)
	assert(battle.hero_state["warden"]["ap"] == before)
	State.run_heroes = battle.hero_state.duplicate(true)
	State.run_heroes["warden"]["hp"] = 12
	battle.queue_free()
	await process_frame
	battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	assert(battle.hero_state["warden"]["hp"] == 12)
	assert(battle.hero_state["warden"]["ap"] == 2)
	assert(battle.hero_state["warden"]["cooldowns"].is_empty())
	battle.enemy_hp = 0
	battle.battle_over = true
	battle._refresh_all()
	assert(not battle.end_turn_button.disabled)
	battle.queue_free()
	await process_frame
	# Walk every floor's connected path, resolve encounters and finish the boss.
	State.start_run(83)
	while not State.run_complete:
		var rooms: Dictionary = State.floors[State.floor_index]
		var pending: Array = [State.room_position]
		var parents: Dictionary = {State.room_position: State.room_position}
		while not pending.is_empty():
			var location: Vector2i = pending.pop_front()
			for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
				var next: Vector2i = location + direction
				if rooms.has(next) and not parents.has(next):
					parents[next] = location
					pending.append(next)
		var path: Array = []
		var cursor := Vector2i(4, 3)
		while cursor != State.room_position:
			path.push_front(cursor)
			cursor = parents[cursor]
		for destination_room in path:
			assert(State.vote_move("local", destination_room))
			State.finish_encounter()
		if not State.run_complete:
			assert(State.descend())
	assert(State.floor_index == State.floor_count - 1)
	State.end_run()
	assert(not State.run_active)
	print("PASS: 100 connected seeds, navigation agreement, dungeon UI, shared turns, cooldowns, persistence, victory controls")
	quit()
