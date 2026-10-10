extends SceneTree
## Integration checks exercise the live controller, AP cost, intents and phase state.
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
const Objectives = preload("res://scripts/boss_objectives.gd")

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	for index in range(4): await process_frame

func battle_room(depth: int, room: Dictionary) -> Control:
	State.hero_progress.clear()
	State.equipment.clear()
	State.inventory.clear()
	State.select_expedition("path_beast")
	State.start_run(160)
	State.floor_index = depth
	State.room_position = Vector2i.ZERO
	State.floors[depth][Vector2i.ZERO] = room
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await settle()
	battle.presentation.set_process(false)
	if battle.presentation.boss_reveal != null:
		battle.presentation.boss_reveal.finish()
		await settle()
	return battle

func discard(battle: Control) -> void:
	battle.queue_free()
	await settle()

func giant() -> void:
	var battle: Control = await battle_room(0,{"kind":"boss","creature":"harrowed_giant","support_creature":"anguish_penitent"})
	assert(battle.enemies.size() == 2 and battle._objective_index() == 0)
	var support: Dictionary = battle.enemies[1]
	assert(support["max_hp"] == int(round(support["normal_hp"]*0.3)))
	assert(support["attack"] == int(round(support["normal_attack"]*0.3)))
	var start_power: int = battle._enemy_attack_power()
	var heavy: Dictionary = State.card_stats("wd_heavy")
	var normal_heavy: int = battle._attack_damage("warden",heavy)
	assert(battle._direct_enemy_damage(normal_heavy,"warden") == int(round(normal_heavy*0.9)))
	var heavy_index: int = battle.hero_state["warden"]["abilities"].find("wd_heavy")
	assert(battle.hand_container.get_child(heavy_index).get_node("Contents/Description").text.contains("%d damage" % int(round(normal_heavy*0.9))),"The visible skill damage includes chain defense")
	assert(battle._deal_enemy_damage(20,true) == 18,"Intact chains reduce incoming direct damage by 10%")
	assert(battle.objective_button.text.contains("1 AP") and not battle.objective_prop.disabled)
	assert(battle._interact_boss_objective())
	assert(battle.hero_state["warden"]["ap"] == 1 and battle.enemies[0]["objective"]["spent"] == 1)
	assert(battle._deal_enemy_damage(20,true) == 19)
	assert(battle._enemy_attack_power() == int(round(start_power*0.9)))
	assert(battle._interact_boss_objective())
	assert(battle.hero_state["warden"]["ap"] == 0 and battle.objective_button.disabled and battle.objective_prop.disabled)
	assert(battle._deal_enemy_damage(20,true) == 20)
	assert(battle._enemy_attack_power() == int(round(start_power*0.8)))
	battle.enemy_mark_bonus = 4
	battle._refresh_hand()
	assert(battle.enemy_mark_bonus == 4,"Refreshing damage previews cannot spend Mark")
	battle.enemy_mark_bonus = 0
	assert(not battle._interact_boss_objective(),"A completed objective cannot be farmed or charge more AP")
	battle._select_hero("ranger")
	assert(not battle._interact_boss_objective() and battle.hero_state["ranger"]["ap"] == 2)
	battle.battle_over = true
	battle._refresh_boss_objective()
	assert(not battle.objective_panel.visible and not battle.objective_prop.visible)
	await discard(battle)

func rites() -> void:
	var battle: Control = await battle_room(1,{"kind":"boss","creature":"coterie_matron"})
	battle.round_number = 2
	battle.enemy_hp -= 20
	battle.hero_state["warden"]["ap"] = 0
	assert(not battle._interact_boss_objective(),"No AP means no free interruption")
	battle._select_hero("ranger")
	battle.hero_state["ranger"]["dead"] = true
	assert(not battle._interact_boss_objective(),"Dead heroes cannot break rites")
	battle._select_hero("occultist")
	assert(battle._interact_boss_objective())
	assert(battle._enemy_move(0)["effect"] == "falter" and battle._enemy_intent_text().contains("Canceled"))
	var hp: int = battle.enemy_hp
	var heroes: Dictionary = battle.hero_state.duplicate(true)
	battle._enemy_action()
	assert(battle.enemy_hp == hp and battle.hero_state == heroes,"Interrupted Remaking cannot heal or hurt")
	assert(not battle.enemies[0]["objective"]["suppression_pending"])
	assert(not battle._interact_boss_objective())
	assert(battle._enemy_move(0)["effect"] == "remake","Suppression lasts one enemy action")
	battle._enemy_action()
	assert(battle.enemy_hp == hp+12,"Later normal Remaking remains available")
	await discard(battle)
	# A damaging rite preserves hit count but halves strength and removes its debuff.
	battle = await battle_room(1,{"kind":"boss","creature":"coterie_seamkeeper","boss_phases":["coterie_seamkeeper","coterie_cantor","coterie_matron"]})
	var power: int = battle._enemy_attack_power()
	assert(battle._interact_boss_objective())
	assert(is_equal_approx(battle._enemy_move(0)["scale"],0.5) and not battle._enemy_move(0).has("status"))
	var hero_hp: int = battle.hero_state["warden"]["hp"]
	battle._enemy_action()
	assert(battle.hero_state["warden"]["hp"] == hero_hp-int(round(power*0.5)))
	assert(battle.hero_state["warden"]["statuses"].is_empty())
	for phase in [1,2]:
		battle._deal_enemy_damage(9999,true)
		assert(not battle.battle_over and battle.enemies[0]["phase_index"] == phase)
		assert(battle.enemies[0]["objective"]["spent"] == 0 and Objectives.available(battle.enemies[0]["objective"]),"Each form receives its own rite")
		assert(not battle.reward_given,"Phase changes never grant a boss reward")
		battle.hero_state["ranger"]["ap"] = 2
		battle._select_hero("ranger")
		battle.round_number = 2
		assert(battle._interact_boss_objective())
		assert(battle._enemy_move(0)["effect"] == "falter")
		var before: Dictionary = battle.hero_state.duplicate(true)
		var before_hp: int = battle.enemy_hp
		battle._enemy_action()
		assert(battle.hero_state == before and battle.enemy_hp == before_hp,"An interrupted lament/remaking causes no effects")
	await discard(battle)

func idol() -> void:
	var battle: Control = await battle_room(2,{"kind":"boss","creature":"howling_head"})
	assert(battle._enemy_move(0)["stress"] == 8 and battle._enemy_move(0).has("status"))
	battle.objective_prop.pressed.emit()
	assert(battle.hero_state["warden"]["ap"] == 1 and battle._enemy_move(0)["stress"] == 4)
	assert(not battle._enemy_move(0).has("status") and battle._enemy_intent_text().contains("+4 Stress"))
	assert(not battle._interact_boss_objective())
	battle._enemy_action()
	for id in State.party:
		assert(battle.hero_state[id]["stress"] == 4 and battle.hero_state[id]["statuses"].is_empty())
	await discard(battle)
	battle = await battle_room(0,{"kind":"battle","creature":"anguish_penitent"})
	assert(battle.objective_panel == null and not battle._interact_boss_objective(),"Ordinary encounters do not receive boss objectives")
	await discard(battle)

func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://boss_objectives_test.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.completed_expeditions.clear()
	State.hero_positions.clear()
	State.formation.clear()
	await giant()
	await rites()
	await idol()
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: legal one-AP boss actions, chained damage/attack, one-use rites, phase reset, canceled heal/lament, permanent idol relief and support limits")
	quit()
