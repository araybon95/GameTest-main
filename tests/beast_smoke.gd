extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	assert(State.select_expedition("path_beast"))
	State.start_run(410)
	assert(State.floor_count == 3)
	for depth in range(3):
		var rooms: Dictionary = State.floors[depth]
		var boss: Dictionary = rooms[Vector2i(4, 3)]
		assert(boss["kind"] == "boss")
		assert(boss["creature"] == ["harrowed_giant", "coterie_seamkeeper", "howling_head"][depth])
		var orbs: int = 0
		for room in rooms.values():
			orbs += int(room.get("merchant_orb", false))
			if room["kind"] == "battle":
				assert(room["enemies"].size() <= 3)
		assert(orbs == 1)
	State.floor_index = 0
	State.room_position = Vector2i(4, 3)
	assert(not State.can_descend())
	State.finish_encounter()
	assert(not State.run_complete and State.can_descend())
	assert(State.descend())
	State.room_position = Vector2i(4, 3)
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	await process_frame
	assert(combat.enemies.size() == 1)
	var hero_hp: int = combat.hero_state["warden"]["hp"]
	var ap: int = combat.hero_state["warden"]["ap"]
	for phase in range(2):
		combat._deal_enemy_damage(9999, true)
		combat._check_battle_over()
		assert(not combat.battle_over)
		assert(combat.enemies[0]["phase_index"] == phase + 1)
		assert(combat.enemies[0]["statuses"].is_empty())
		assert(combat.hero_state["warden"]["hp"] == hero_hp)
		assert(combat.hero_state["warden"]["ap"] == ap)
	combat._deal_enemy_damage(9999, true)
	combat._check_battle_over()
	assert(combat.battle_over)
	combat.queue_free()
	await process_frame
	# A burn tick can end a form without ending the encounter.
	combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	await process_frame
	combat.enemy_hp = 1
	Rules.apply_status(combat.enemies[0]["statuses"], "burn")
	combat._enemy_action()
	combat._check_battle_over()
	assert(combat.enemies[0]["phase_index"] == 1 and not combat.battle_over)
	combat.round_number = 2
	var stress: int = combat.hero_state["warden"]["stress"]
	combat._enemy_action()
	assert(combat.hero_state["warden"]["stress"] == stress + 4)
	combat._deal_enemy_damage(9999, true)
	combat.enemy_hp = combat.enemy_max_hp - 20
	combat._enemy_action()
	assert(combat.enemy_hp == combat.enemy_max_hp - 8)
	combat.queue_free()
	await process_frame
	State.finish_encounter()
	assert(not State.run_complete and State.descend())
	State.room_position = Vector2i(4, 3)
	State.finish_encounter()
	assert(State.run_complete and State.completed_expeditions.has("path_beast"))
	assert(not State.can_embark("path_lament"))
	assert(not State.select_expedition("path_lament"))
	State.progress_path = "res://tests/.progress_test.cfg"
	State.progress_loaded = true
	State.save_progression()
	State.completed_expeditions.clear()
	State.progress_loaded = false
	State.load_progression()
	assert(State.completed_expeditions.has("path_beast"))
	DirAccess.remove_absolute(State.progress_path)
	var region = load("res://scenes/expedition/region_select.tscn").instantiate()
	root.add_child(region)
	await process_frame
	assert(region.has_node("Expedition_village") and region.has_node("Expedition_path"))
	assert(region.has_node("Dungeon_old_road") and not region.has_node("Dungeon_path_beast"))
	region.get_node("Expedition_path").pressed.emit()
	assert(region.has_node("Dungeon_path_beast") and not region.has_node("Dungeon_old_road"))
	region.choose(1, 1)
	assert(region.get_node("EmbarkButton").disabled)
	region.queue_free()
	await process_frame
	print("BEAST SMOKE PASS: floor guardians, three phases, progression, regional landmarks")
	quit()
