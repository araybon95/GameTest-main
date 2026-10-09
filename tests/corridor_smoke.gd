extends SceneTree
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	State.select_expedition("old_road")
	var kinds: Dictionary = {}
	for seed_value in range(100):
		State.start_run(seed_value)
		for floor_rooms in State.floors:
			for room in floor_rooms.values():
				if room.get("event_layout", "") == "corridor":
					kinds[room["corridor_encounter"]] = true
	assert(kinds.has("gold") and kinds.has("roamer") and kinds.has("object"))
	State.start_run(22)
	State.floors[0][Vector2i.ZERO] = {"kind": "event", "cleared": false, "seen": true, "event_layout": "corridor", "corridor_encounter": "gold", "small_gold": 3}
	var before: int = State.gold
	assert(State.enter_corridor()["amount"] == 3)
	assert(State.gold == before + 3)
	assert(State.enter_corridor().is_empty() and State.gold == before + 3)
	State.floors[0][Vector2i.ZERO] = {"kind": "event", "cleared": false, "seen": true, "event_layout": "corridor", "corridor_encounter": "roamer", "creature": "ash_raider", "enemies": ["ash_raider", "gallows_scout"]}
	assert(State.enter_corridor()["kind"] == "roamer")
	assert(State.current_room_kind() == "battle")
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	await process_frame
	assert(combat.enemies.size() == 1 and combat.enemies[0]["accuracy"] == 70)
	assert(combat._enemy_attack_power() == int(floor(combat.enemy_attack_base * 0.7)))
	combat.enemies[0]["accuracy"] = 0
	var hp: int = combat.hero_state["warden"]["hp"]
	combat._enemy_action()
	assert(combat.hero_state["warden"]["hp"] == hp and combat.hero_state["warden"]["statuses"].is_empty())
	combat._deal_enemy_damage(9999)
	combat._check_battle_over()
	assert(combat.battle_over)
	State.finish_encounter()
	assert(State.enter_corridor().is_empty())
	combat.queue_free()
	await process_frame
	print("PASS: corridor gold/object/roamer generation, one-use coins, one enemy, surprise damage/accuracy, missed debuffs and cleared encounter")
	quit()
