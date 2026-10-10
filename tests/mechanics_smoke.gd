extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
func _initialize() -> void: call_deferred("run")
func battle_for(id: String, boss: bool = false):
	State.select_expedition("old_road")
	State.start_run(20)
	State.floors[0][Vector2i.ZERO] = {"kind": "boss" if boss else "battle", "enemies": [id], "creature": id, "cleared": false, "seen": true, "final_boss": false}
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	return battle
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://mechanics_test.cfg"
	State.completed_expeditions.clear()
	State.formation.clear()
	State.hero_positions.clear()
	State.modifications.clear()
	State.equipment.clear()
	State.inventory.clear()
	State.party = ["warden", "ranger", "occultist"]
	var battle = await battle_for("ash_raider")
	assert(battle._enemy_target() == "warden")
	assert(battle._attack_damage("ranger", {"damage": 10}) == 11)
	battle._resolve_card("ranger", {"effect": "mark", "bonus": 4})
	assert(battle._attack_damage("warden", {"damage": 10}) == 12)
	battle._attack_with_equipment("occultist", {"damage": 1})
	assert(battle.enemies[0]["statuses"].has("poison"))
	battle._select_hero("ranger")
	battle.change_rank()
	assert(State.rank_of("ranger") == "front" and battle.hero_state["ranger"]["ap"] == 1)
	battle._select_hero("warden")
	battle.change_rank()
	assert(State.Depth.position_of(State,"warden") == 1, "Nearest-slot movement exchanges allies")
	battle._select_hero("ranger")
	battle.change_rank()
	assert(State.Depth.position_of(State,"ranger") == 1 and State.rank_of("warden") == "rear", "An ally replaces the protector when moving")
	battle.queue_free()
	await process_frame
	State.formation.clear()
	State.hero_positions.clear()
	battle = await battle_for("keep_wolfguard")
	battle.round_number = 3
	battle._enemy_action()
	assert(State.Depth.position_of(State,"occultist") == 1, "Reach attack pulls the furthest hero")
	battle.queue_free()
	await process_frame
	battle = await battle_for("moth_oleander", true)
	var hp: int = battle.enemy_hp
	battle._deal_enemy_damage(20)
	assert(battle.enemy_hp == hp - 10)
	battle.round_number = 3
	hp = battle.enemy_hp
	battle._deal_enemy_damage(20)
	assert(battle.enemy_hp == hp - 30)
	battle.queue_free()
	await process_frame
	battle = await battle_for("moth_exuvia", true)
	assert(battle.enemies.size() == 2 and battle.enemies[1]["cocoon"])
	battle._enemy_action()
	assert(battle.enemies[1]["age"] == 1)
	battle._enemy_action()
	assert(battle.enemies[1]["creature"] == "moth_metamorph" and battle.enemies[1]["hp"] == 13 and battle.enemies[1]["support"])
	battle.queue_free()
	await process_frame
	State.select_expedition("old_road")
	State.start_run(40)
	assert(State.scout_area() and State.scout_uses == 1)
	assert(State.floors[0][Vector2i.ZERO]["scouted"])
	for service in State.Mechanics.SERVICES:
		State.select_expedition(State.Mechanics.SERVICES[service]["quest"])
		State.start_run(20)
		assert(State.floors[0].size() == 3 and State.floors[0][Vector2i(1, 0)]["kind"] == "camp")
		State.room_position = Vector2i(2, 0)
		State.finish_encounter()
		assert(not State.service_unlocked(service), "Cannot unlock before the first fight")
		State.room_position = Vector2i.ZERO
		State.finish_encounter()
		State.room_position = Vector2i(2, 0)
		State.finish_encounter()
		assert(State.service_unlocked(service))
	State.select_expedition("old_road")
	State.start_run(40)
	assert(State.scout_uses == 3 and State.floors[0][Vector2i.ZERO]["scouted"])
	State.gold = 100
	State.add_item("warden_sword")
	assert(State.modify_equipment("warden_sword", "keen") and State.gold == 88)
	assert(not State.modify_equipment("warden_sword", "fortified"))
	assert(State.equip_item("warden", "warden_sword") and State.equipment_bonus("warden", "damage") == 2)
	State.add_item("cursed_physician_seal")
	assert(State.equip_item("warden", "cursed_physician_seal"))
	var statuses: Dictionary = {}
	assert(State.try_hero_status("warden", statuses, "poison", 1.0, 100.0))
	assert(statuses["poison"]["damage"] == 3)
	State.add_item("bandage")
	Rules.apply_status(State.run_heroes["warden"]["statuses"], "bleed")
	Rules.apply_status(State.run_heroes["warden"]["statuses"], "poison")
	assert(State.apply_potion("warden", "bandage", State.run_heroes))
	assert(not State.run_heroes["warden"]["statuses"].has("bleed") and State.run_heroes["warden"]["statuses"].has("poison"))
	for hero in ["warden", "ranger"]:
		State.room_position = Vector2i.ZERO
		State.floors[0][Vector2i.ZERO] = {"kind": "event", "event_id": "bandit_strongbox", "event_seed": 10, "seen": true, "cleared": false}
		var before: int = State.run_heroes[hero]["hp"]
		var result: Dictionary = State.Events.resolve(State, hero, false, "class")
		assert(not result.is_empty() and (int(result["gold"]) > 0 or result["item"] != ""))
		assert(State.run_heroes[hero]["hp"] == before - (2 if hero == "warden" else 0))
		assert(State.Events.resolve(State, hero, false, "class").is_empty())
	State.end_run()
	for scene in ["res://scenes/expedition/preparation.tscn", "res://scenes/hub/restoration.tscn"]:
		var view = load(scene).instantiate()
		root.add_child(view)
		await process_frame
		view.queue_free()
		await process_frame
	print("PASS: formations, rear damage, mark combo, poison, pull, guard/exposure, cocoon hatch, scouting, restoration gates, modifications, curses, supplies, class events and UI")
	quit()
