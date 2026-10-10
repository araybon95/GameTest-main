extends SceneTree
## Exercise matchup rules through the live combat controller and real inventory gear.
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
const Matchups = preload("res://scripts/creature_matchups.gd")
var completed_checks: int = 0

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	for index in range(4): await process_frame

func battle_room(ids: Array, party: Array = ["warden","ranger","occultist"], boss: bool = false) -> Control:
	State.equipment.clear()
	State.inventory.clear()
	State.hero_progress.clear()
	State.modifications.clear()
	State.formation.clear()
	State.hero_positions.clear()
	State.party.assign(party)
	assert(State.select_expedition("old_road"))
	State.start_run(841)
	State.room_position = Vector2i.ZERO
	State.floors[0][Vector2i.ZERO] = {"kind":"boss" if boss else "battle","enemies":ids,"seen":true,"cleared":false}
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await settle()
	battle.presentation.set_process(false)
	if battle.presentation.boss_reveal != null:
		battle.presentation.boss_reveal.finish()
		await settle()
	return battle

func end_cinema(battle: Control) -> void:
	while not battle.presentation.active.is_empty():
		battle.presentation.age = 2.0
		battle.presentation._process(0)
	for child in battle.get_children():
		if child is Label and child.name.begins_with("CombatFeedback"): child.queue_free()

func dispose(battle: Control) -> void:
	end_cinema(battle)
	battle.queue_free()
	await settle()

func equip(hero: String, item: String) -> void:
	State.add_item(item)
	assert(State.equip_item(hero,item))

func prepare_skill(battle: Control, hero: String, index: int, skill: String) -> void:
	battle._select_hero(hero)
	battle._select_enemy(index)
	battle.hero_state[hero]["ap"] = 2
	battle.hero_state[hero]["cooldowns"].clear()
	assert(State.Depth.skill_allowed(State,hero,skill,battle.enemy_position(index)))
	assert(State.hero_accuracy(hero,battle.hero_state[hero]) == 100.0,"These checks must not depend on a random hit roll")

func use_skill(battle: Control, hero: String, index: int, skill: String) -> int:
	prepare_skill(battle,hero,index,skill)
	var before: int = battle.enemy_hp
	var ability_index: int = battle.hero_state[hero]["abilities"].find(skill)
	assert(ability_index >= 0)
	battle._play_card(hero,ability_index)
	var damage: int = before-int(battle.enemies[index]["hp"])
	assert(battle.presentation.active.get("source_node") == battle.hero_portraits[hero])
	assert(battle.presentation.active.get("target_node") == battle.enemy_views[index].get_node("EnemyArt"),"The selected enemy, rather than the first portrait, receives the strike")
	end_cinema(battle)
	return damage

func use_scroll(battle: Control, hero: String, index: int, scroll: String) -> int:
	battle._select_hero(hero)
	battle._select_enemy(index)
	battle.hero_state[hero]["ap"] = 2
	State.add_item(scroll)
	var before: int = battle.enemy_hp
	battle._use_scroll(scroll)
	assert(not State.inventory.has(scroll) and battle.hero_state[hero]["ap"] == 1,"A real offensive scroll is consumed once for one AP")
	assert(battle.presentation.active.get("source_node") == battle.hero_portraits[hero] and battle.presentation.active.get("target_node") == battle.enemy_views[index].get_node("EnemyArt"))
	var damage: int = before-int(battle.enemies[index]["hp"])
	end_cinema(battle)
	return damage

func test_hunts() -> void:
	for entry in [
		["outlaw_tally","warden","ash_raider","keep_footman","wd_heavy",10],
		["warden_gravewatch","warden","keep_footman","ash_raider","wd_heavy",15],
		["occultist_severed_litany","occultist","anguish_vessel","ash_raider","oc_blast",15],
		["ranger_chitin_lens","ranger","moth_metamorph","ash_raider","rg_volley",15]]:
		var battle: Control = await battle_room([entry[2],entry[3]])
		var baseline: int = use_skill(battle,entry[1],0,entry[4])
		equip(entry[1],entry[0])
		var boosted: int = use_skill(battle,entry[1],0,entry[4])
		assert(boosted == int(round(baseline*(1.0+entry[5]/100.0))) and boosted > baseline,"Matching hunt gear increases the real hero skill")
		assert(use_skill(battle,entry[1],1,entry[4]) == baseline,"Wrong creature class receives no skill bonus")
		# Piercing scroll proves direct-hit amplification is shared but still skips Block.
		battle._select_enemy(0)
		battle.enemy_hp = battle.enemy_max_hp
		battle.enemy_block = 50
		battle._store_enemy()
		assert(use_scroll(battle,entry[1],0,"lightning_bolt_scroll") == int(round(18*(1.0+entry[5]/100.0))))
		assert(battle.enemies[0]["block"] == 50,"Hunt amplification does not change scroll piercing")
		assert(use_scroll(battle,entry[1],1,"lightning_bolt_scroll") == 18,"Wrong type also receives no offensive scroll bonus")
		# Status ticking has no attacking hero and must not inherit equipped hunt damage.
		battle._select_enemy(0)
		battle.enemy_hp = battle.enemy_max_hp
		battle.enemies[0]["statuses"].clear()
		Rules.apply_status(battle.enemies[0]["statuses"],"burn",20.0/3.0)
		var before: int = battle.enemy_hp
		battle._tick_enemy_statuses(0)
		assert(before-battle.enemy_hp == 20 and battle.enemy_block == 50,"Hunt gear and Block do not alter enemy damage-over-time")
		battle.enemy_hp = battle.enemy_max_hp
		battle._store_enemy()
		var other_hero: String = "ranger" if entry[1] != "ranger" else "warden"
		assert(use_scroll(battle,other_hero,0,"lightning_bolt_scroll") == 18,"Hunt equipment benefits its wearer, rather than any selected party member")
		await dispose(battle)
	completed_checks += 1

func test_wards() -> void:
	for entry in [
		["warden","roadward_seal","ash_raider","keep_footman",10],
		["warden","graveward_locket","keep_footman","ash_raider",10],
		["crusader","crusader_penitent_stitch","anguish_vessel","ash_raider",15],
		["healer","healer_chrysalis_rosary","moth_metamorph","ash_raider",15]]:
		var battle: Control = await battle_room([entry[2],entry[3]],["warden","crusader","healer"])
		equip(entry[0],entry[1])
		battle._load_enemy(0)
		var hero: Dictionary = battle.hero_state[entry[0]]
		hero["block"] = 5
		var before: int = hero["hp"]
		var expected: int = int(round(20*(1.0-entry[4]/100.0)))-5
		assert(battle._apply_damage(entry[0],20) == expected and before-int(hero["hp"]) == expected and hero["block"] == 0,"The source's ward reduces the incoming hit before Block")
		battle._load_enemy(1)
		hero["hp"] = hero["max_hp"]
		hero["block"] = 5
		assert(battle._apply_damage(entry[0],20) == 15,"A different acting creature class bypasses this ward")
		for status in ["burn","bleed","poison"]:
			battle._load_enemy(0)
			hero["hp"] = hero["max_hp"]
			hero["block"] = 7
			hero["statuses"].clear()
			Rules.apply_status(hero["statuses"],status,20.0/int(Rules.STATUS[status]["damage"]))
			before = int(hero["hp"])
			battle._tick_hero_statuses(entry[0])
			assert(before-int(hero["hp"]) == 20 and hero["block"] == 7,"Type wards exclude %s ticks; periodic damage also bypasses Block" % status)
		await dispose(battle)
	# Integration regression: the selected target is not necessarily the attacking source.
	var mixed: Control = await battle_room(["ash_raider","keep_footman"])
	equip("warden","roadward_seal")
	var expected_total: int = 0
	for index in range(2):
		mixed._load_enemy(index)
		var raw: int = int(round(mixed._enemy_attack_power()*float(mixed._enemy_move(index).get("scale",1.0))))
		expected_total += int(round(raw*0.9)) if index == 0 else raw
	mixed._load_enemy(0)
	var before: int = mixed.hero_state["warden"]["hp"]
	mixed._enemy_action()
	assert(before-int(mixed.hero_state["warden"]["hp"]) == expected_total,"Every live enemy turn uses its own class, then restores the selected target")
	assert(mixed.selected_enemy_index == 0)
	await dispose(mixed)
	completed_checks += 1

func test_resistance_feedback() -> void:
	var battle: Control = await battle_room(["keep_footman","anguish_vessel","moth_metamorph"])
	var cinema: Control = battle.presentation
	for entry in [[0,"bleed",20],[1,"chill",15],[2,"poison",20]]:
		var index: int = entry[0]
		var effect: String = entry[1]
		var target: TextureRect = battle.enemy_views[index].get_node("EnemyArt")
		var prior_feedback: int = int(target.get_meta("feedback_sequence",0))
		var prior_status: int = int(cinema.feedback_count.get("status",0))
		var prior_resist: int = int(cinema.feedback_count.get("resist",0))
		assert(not battle._apply_enemy_status(index,effect,1.0,false,float(entry[2])-0.01))
		assert(battle.enemies[index]["statuses"].is_empty() and cinema.feedback_count["resist"] == prior_resist+1 and int(cinema.feedback_count.get("status",0)) == prior_status)
		assert(int(target.get_meta("feedback_sequence",0)) == prior_feedback+1,"Resistance feedback follows the explicit enemy index even when another target is selected")
		assert(battle._apply_enemy_status(index,effect,1.0,false,float(entry[2])))
		var existing: Dictionary = battle.enemies[index]["statuses"][effect].duplicate(true)
		assert(existing["stacks"] == 1 and existing["turns"] == 2 and cinema.feedback_count["status"] == prior_status+1)
		assert(not battle._apply_enemy_status(index,effect,2.0,true,0.0))
		assert(battle.enemies[index]["statuses"][effect] == existing,"Resisted stacking does not refresh or strengthen the existing status")
		assert(battle._apply_enemy_status(index,effect,2.0,true,99.0))
		assert(battle.enemies[index]["statuses"][effect]["stacks"] == 2)
		var found_resist: bool = false
		var found_status: bool = false
		for child in battle.get_children():
			if child is Label and child.name.begins_with("CombatFeedback"):
				found_resist = found_resist or child.text == "RESISTED · "+effect.to_upper()
				found_status = found_status or child.text == effect.to_upper()
		assert(found_resist and found_status,"Application and resistance each use their own clear popup")
	var statuses_before: Array = battle.enemies.map(func(enemy): return enemy["statuses"].duplicate(true))
	var feedback_before: Dictionary = cinema.feedback_count.duplicate()
	assert(not battle._apply_enemy_status(2,"unknown_status",1.0,true,99))
	assert(cinema.feedback_count == feedback_before and battle.enemies.map(func(enemy): return enemy["statuses"]) == statuses_before,"Ignored status IDs produce no phantom success feedback")
	assert(cinema.feedback_count.get("damage",0) == 0 and cinema.feedback_count.get("status_tick",0) == 0)
	assert(battle.selected_enemy_index == 0,"Status application does not switch the player-selected enemy")
	await dispose(battle)
	completed_checks += 1

func test_types_and_cocoons() -> void:
	for id in State.CREATURES:
		for mode in [[false,false],[true,false],[false,true]]:
			var creature: Dictionary = Rules.make_enemy(State.creature(id),id,1,mode[0],mode[1])
			assert(creature["creature_class"] == State.creature(id)["creature_class"] and Matchups.class_of(creature) == State.creature(id)["creature_class"])
	var battle: Control = await battle_room(["moth_exuvia"],["warden","ranger","occultist"],true)
	assert(battle.enemies.size() == 2 and battle.enemies[1]["cocoon"] and battle.enemies[1]["creature_class"] == "Insect")
	assert(battle._make_cocoon()["creature_class"] == "Insect")
	battle._enemy_action()
	assert(battle.enemies[1]["cocoon"] and battle.enemies[1]["creature_class"] == "Insect")
	end_cinema(battle)
	battle._enemy_action()
	assert(not battle.enemies[1].get("cocoon",false) and battle.enemies[1]["creature"] == "moth_metamorph" and battle.enemies[1]["creature_class"] == "Insect","A hatching cocoon keeps its Insect matchup class")
	await dispose(battle)
	completed_checks += 1

func run() -> void:
	seed(841)
	State.progress_loaded = true
	State.progress_path = "user://creature_matchup_combat_progress.cfg"
	State.crusader_unlocked = true
	State.completed_expeditions.clear()
	await test_hunts()
	await test_wards()
	await test_resistance_feedback()
	await test_types_and_cocoons()
	if completed_checks != 4:
		push_error("A matchup integration section aborted before completion")
		quit(1)
		return
	State.end_run()
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: real four-class hunt skills/scrolls, selected target and acting-source routing, ward before Block, unmodified DOT, resisted/applied/invalid status feedback and Insect cocoon hatch")
	quit()
