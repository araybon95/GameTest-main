extends SceneTree
## Controller integration: enemy effects must queue their presentation without changing outcomes.
const State = preload("res://scripts/game_data.gd")
const Poses = preload("res://scripts/combat_poses.gd")

func _initialize() -> void:
	call_deferred("run")

func settle() -> void:
	for index in range(4):
		await process_frame

func battle_room(expedition: String, depth: int, room: Dictionary) -> Control:
	assert(State.select_expedition(expedition))
	State.start_run(702)
	State.floor_index = depth
	State.room_position = Vector2i.ZERO
	State.floors[depth][Vector2i.ZERO] = room
	if room.get("corridor_encounter", "") == "roamer":
		assert(State.enter_corridor()["kind"] == "roamer")
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await settle()
	battle.presentation.set_process(false)
	if battle.presentation.boss_reveal != null:
		battle.presentation.boss_reveal.finish()
		await settle()
	assert(battle.presentation.active.is_empty() and battle.presentation.pending.is_empty())
	assert(battle._make_cocoon()["creature_class"] == "Insect")
	return battle

func feedback_values(battle: Control) -> Array[String]:
	var values: Array[String] = []
	for entry in [battle.presentation.active] + battle.presentation.pending:
		for item in entry.get("feedback", []):
			values.append(str(item["value"]))
	for child in battle.get_children():
		if child is Label and child.name.begins_with("CombatFeedback"):
			values.append(child.text)
	return values

func value_count(values: Array[String], wanted: String) -> int:
	var count: int = 0
	for value in values:
		if value == wanted:
			count += 1
	return count

func impact(battle: Control) -> bool:
	var cinema: Control = battle.presentation
	cinema.age = float(cinema.active.get("duration", cinema.duration)) * 0.4
	cinema._process(0.0)
	assert(not cinema.active.has("feedback"), "Feedback appears once at impact")
	return true

func finish_cinema(battle: Control) -> bool:
	var heroes: Dictionary = battle.hero_state.duplicate(true)
	var enemies: Array = battle.enemies.duplicate(true)
	var cinema: Control = battle.presentation
	var strikes: int = 0
	while not cinema.active.is_empty():
		strikes += 1
		assert(strikes <= 8)
		assert(impact(battle))
		cinema.age = float(cinema.active.get("duration", cinema.duration)) + 0.1
		cinema._process(0.0)
	assert(cinema.pending.is_empty() and not cinema.visible)
	assert(battle.hero_state == heroes and battle.enemies == enemies, "Playing queued feedback cannot apply mechanics a second time")
	battle.queue_free()
	await settle()
	return true

func test_lament() -> bool:
	var battle: Control = await battle_room("path_beast", 2, {"kind": "boss", "enemies": ["howling_head"], "seen": true, "cleared": false})
	battle.hero_state["ranger"]["dead"] = true
	battle.hero_state["ranger"]["hp"] = 0
	var hp: Dictionary = {}
	for id in State.party:
		hp[id] = battle.hero_state[id]["hp"]
	assert(battle._enemy_move(0)["name"] == "Unending Prayer")
	battle._enemy_action()
	var cinema: Control = battle.presentation
	assert(cinema.active["kind"] == "spell" and cinema.active["title"] == "Unending Prayer" and not cinema.active["hero"])
	assert(cinema.active["source_node"] == battle.enemy_art and cinema.active["target_node"] == battle.hero_portraits["warden"])
	for id in ["warden", "occultist"]:
		assert(battle.hero_state[id]["stress"] == 8 and battle.hero_state[id]["statuses"]["chill"]["turns"] == 2)
		assert(battle.hero_state[id]["hp"] == hp[id])
	assert(battle.hero_state["ranger"]["stress"] == 0 and battle.hero_state["ranger"]["statuses"].is_empty())
	var values: Array[String] = feedback_values(battle)
	assert(value_count(values, "STRESS +8") == 2 and value_count(values, "CHILL") == 2, "The intact choir idol amplifies Lament for living heroes only")
	assert(cinema.feedback_count.get("damage", 0) == 0)
	assert(impact(battle))
	assert(cinema.fighters[1].texture == Poses.state_pose(cinema.active["target"], "hurt"))
	return await finish_cinema(battle)

func test_remake() -> bool:
	var battle: Control = await battle_room("path_beast", 1, {"kind": "boss", "enemies": ["coterie_matron"], "seen": true, "cleared": false})
	battle.round_number = 2
	battle.enemy_hp = battle.enemy_max_hp - 5
	var heroes: Dictionary = battle.hero_state.duplicate(true)
	assert(battle._enemy_move(0)["effect"] == "remake")
	battle._enemy_action()
	var cinema: Control = battle.presentation
	assert(battle.enemy_hp == battle.enemy_max_hp and battle.enemies[0]["hp"] == battle.enemy_max_hp)
	assert(battle.hero_state == heroes)
	assert(cinema.active["kind"] == "heal" and cinema.active["title"] == "Blessed Remaking" and not cinema.active["hero"])
	assert(cinema.active["source_node"] == cinema.active["target_node"] and not cinema.fighters[1].visible)
	assert(feedback_values(battle).has("+5 HP") and not feedback_values(battle).has("+12 HP"), "Healing feedback uses actual capped recovery")
	assert(cinema.feedback_count["heal"] == 1 and cinema.feedback_count.get("damage", 0) == 0)
	assert(impact(battle))
	assert(cinema.fighters[1].texture == cinema.active["target"], "A self-heal has no hurt reaction")
	return await finish_cinema(battle)

func test_ally_guard() -> bool:
	var battle: Control = await battle_room("path_beast", 0, {"kind": "boss", "enemies": ["harrowed_giant"], "support_creature": "anguish_penitent", "seen": true, "cleared": false})
	battle.round_number = 2
	var hp: int = battle.hero_state["warden"]["hp"]
	var damage: int = int(round(battle._enemy_attack_power() * 1.2))
	var block: int = battle.enemies[1]["attack"]
	assert(battle._enemy_move(1)["effect"] == "ally_guard")
	battle._enemy_action()
	var cinema: Control = battle.presentation
	assert(battle.hero_state["warden"]["hp"] == hp - damage and battle.hero_state["warden"]["stress"] == 2)
	assert(battle.enemies[0]["block"] == block and battle.enemies[1]["block"] == 0, "The support covers its living ally")
	assert(cinema.pending.size() == 1 and cinema.pending[0]["kind"] == "block" and cinema.pending[0]["title"] == "Cover Ally")
	assert(cinema.pending[0]["source_node"] == battle.enemy_views[1].get_node("EnemyArt"))
	assert(cinema.pending[0]["target_node"] == battle.enemy_views[0].get_node("EnemyArt"))
	assert(feedback_values(battle).has("+%d BLOCK" % block))
	cinema.next()
	assert(impact(battle))
	assert(cinema.active["kind"] == "block" and cinema.fighters[1].texture == Poses.state_pose(cinema.active["target"], "guard"), "The protected ally braces instead of recoiling")
	assert(cinema.fighters[0].texture == Poses.state_pose(cinema.active["source"], "guard") and cinema.fighters[1].self_modulate == Color.WHITE)
	return await finish_cinema(battle)

func test_mark() -> bool:
	var battle: Control = await battle_room("old_road", 0, {"kind": "battle", "enemies": ["ash_raider", "gallows_scout"], "seen": true, "cleared": false})
	var marked_hp: int = battle.hero_state["occultist"]["hp"]
	var front_hp: int = battle.hero_state["warden"]["hp"]
	var first_damage: int = battle._enemy_attack_power()
	assert(battle._enemy_move(1)["effect"] == "mark_hero")
	battle._enemy_action()
	var cinema: Control = battle.presentation
	assert(battle.hero_state["warden"]["hp"] == front_hp - first_damage)
	assert(battle.hero_state["occultist"]["hp"] == marked_hp and battle.hero_state["occultist"]["enemy_mark"] == 2)
	assert(battle._enemy_target() == "occultist", "The mark redirects subsequent allied attacks")
	assert(cinema.pending.size() == 1 and cinema.pending[0]["kind"] == "spell" and cinema.pending[0]["title"] == "Choose the Victim")
	assert(not cinema.pending[0]["hero"] and cinema.pending[0]["target_node"] == battle.hero_portraits["occultist"])
	assert(value_count(feedback_values(battle), "MARKED") == 1)
	cinema.next()
	assert(impact(battle))
	assert(cinema.active["target_node"] == battle.hero_portraits["occultist"] and not battle.hero_portraits["occultist"].visible)
	return await finish_cinema(battle)

func test_surprised_miss() -> bool:
	var battle: Control = await battle_room("old_road", 0, {"kind": "event", "creature": "ash_raider", "event_layout": "corridor", "corridor_encounter": "roamer", "seen": true, "cleared": false})
	assert(battle.enemies.size() == 1 and battle.enemies[0]["surprised"] and battle.enemies[0]["accuracy"] == 70)
	assert(battle._enemy_attack_power() == int(floor(battle.enemy_attack_base * 0.7)))
	battle.enemies[0]["accuracy"] = 0
	var heroes: Dictionary = battle.hero_state.duplicate(true)
	battle._enemy_action()
	var cinema: Control = battle.presentation
	assert(battle.hero_state == heroes, "A guaranteed miss causes no damage, Stress, status or AP loss")
	assert(cinema.active["kind"] == "sword" and cinema.active["title"] == "Cleaver Slash" and not cinema.active["hero"])
	assert(cinema.active["reaction"] == "miss" and cinema.feedback_count["miss"] == 1)
	assert(value_count(feedback_values(battle), "MISS") == 1 and cinema.feedback_count.get("damage", 0) == 0)
	assert(impact(battle))
	assert(cinema.fighters[1].texture == cinema.active["target"] and cinema.fighters[1].self_modulate == Color.WHITE, "A missed swing keeps the target uninjured")
	return await finish_cinema(battle)

func run() -> void:
	seed(702)
	State.progress_loaded = true
	State.progress_path = "user://enemy_feedback_progress.cfg"
	State.party.assign(["warden", "ranger", "occultist"])
	State.completed_expeditions.clear()
	State.equipment.clear()
	State.inventory.clear()
	State.hero_progress.clear()
	State.formation.clear()
	State.hero_positions.clear()
	State.modifications.clear()
	for method in [test_lament, test_remake, test_ally_guard, test_mark, test_surprised_miss]:
		if not await method.call():
			quit(1)
			return
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: enemy lament/chill, capped remake, queued ally guard/mark, surprised miss strike/reaction/popups, Insect cocoons and unchanged mechanics during presentation")
	quit()
