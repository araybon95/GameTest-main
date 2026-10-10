extends SceneTree
## Controlled victory fixtures verify survivor eligibility, not expedition balance.
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")

func _initialize() -> void:
	call_deferred("run")

func settle() -> void:
	for frame in range(3): await process_frame

func reset_fixture() -> void:
	State.run_active = false
	State.run_complete = false
	State.progress_loaded = true
	State.progress_path = "user://survivor_xp_progress.cfg"
	Saves.directory = "user://survivor_xp_saves/"
	State.party.assign(["warden", "ranger", "occultist"])
	State.hero_progress.clear()
	State.inventory.clear()
	State.equipment.clear()
	State.modifications.clear()
	State.card_levels.clear()
	State.formation.clear()
	State.hero_positions.clear()
	State.completed_expeditions.clear()
	State.graves.clear()
	State.hero_names.clear()
	State.gold = 0
	State.crusader_unlocked = false

func create_battle(kind: String, depth: int, surprise: bool = false, phases: bool = false):
	reset_fixture()
	assert(State.select_expedition("path_beast" if phases else "old_road"))
	State.start_run(2026)
	State.floor_index = depth
	State.room_position = Vector2i.ZERO
	var id: String = "coterie_seamkeeper" if phases else "ash_chieftain" if kind=="boss" else "ash_raider"
	var room: Dictionary = {"kind":kind, "creature":id, "enemies":[id], "cleared":false, "seen":true, "final_boss":false}
	if surprise: room["corridor_surprise"] = true
	if phases: room["boss_phases"] = ["coterie_seamkeeper", "coterie_cantor", "coterie_matron"]
	State.floors[depth][Vector2i.ZERO] = room
	assert(change_scene_to_file("res://scenes/combat/combatscene.tscn")==OK)
	await settle()
	var battle = current_scene
	battle.presentation.set_process(false)
	if battle.presentation.boss_reveal != null:
		battle.presentation.boss_reveal.finish()
		await settle()
	return battle

func kill_enemies(battle) -> void:
	while not battle._living_enemies().is_empty():
		battle._load_enemy(battle._living_enemies()[0])
		battle._deal_enemy_damage(999,true)
	battle._check_battle_over()

func test_controller_levelup_and_save() -> bool:
	var battle = await create_battle("battle",0)
	State.hero_progress["warden"] = {"level":1,"xp":28,"points":0,"stats":{}}
	var old_max: int = State.hero_max_hp("warden")
	battle._apply_damage("warden",old_max,true,"Survivor XP fixture")
	assert(battle.hero_state["warden"]["hp"]==0 and battle.hero_state["warden"]["deaths_door"] and not battle.hero_state["warden"]["dead"])
	battle._apply_damage("ranger",State.hero_max_hp("ranger"),true,"Survivor XP fixture")
	battle._apply_damage("ranger",1,true,"Survivor XP fixture")
	assert(battle.hero_state["ranger"]["dead"])
	kill_enemies(battle)
	assert(battle.battle_over and battle.reward_given)
	assert(State.leveling("warden")["level"]==2 and State.leveling("warden")["xp"]==0 and State.leveling("warden")["points"]==2)
	assert(State.journey["xp"]["warden"]==12 and State.journey["xp"]["occultist"]==12 and not State.journey["xp"].has("ranger"))
	assert(State.leveling("ranger")["xp"]==0 and State.leveling("occultist")["xp"]==12)
	assert(State.run_heroes["warden"]["hp"]==0 and State.run_heroes["warden"]["deaths_door"] and not State.run_heroes["warden"]["dead"])
	assert(State.run_heroes["warden"]["max_hp"]==old_max+2 and battle.hero_state["warden"]["max_hp"]==old_max+2)
	assert(battle.hero_state["warden"]["hp"]==0 and battle.hero_state["warden"]["deaths_door"],"Level capacity growth must not heal Death's Door")
	var progress: Dictionary = State.hero_progress.duplicate(true)
	var earned: Dictionary = State.journey["xp"].duplicate(true)
	battle._check_battle_over()
	assert(State.hero_progress==progress and State.journey["xp"]==earned)
	battle._on_end_turn_button_pressed()
	await settle()
	assert(State.floors[0][Vector2i.ZERO]["cleared"] and State.floors[0][Vector2i.ZERO]["xp_awarded"])
	assert(Saves.save(1))
	State.hero_progress.clear()
	State.run_heroes.clear()
	State.journey["xp"].clear()
	State.floors[0][Vector2i.ZERO].erase("xp_awarded")
	assert(Saves.load_slot(1))
	assert(State.hero_progress==progress and State.journey["xp"]==earned)
	assert(State.run_heroes["warden"]["hp"]==0 and State.run_heroes["warden"]["deaths_door"])
	assert(State.run_heroes["ranger"]["dead"])
	assert(State.floors[0][Vector2i.ZERO]["xp_awarded"] and State.award_victory_xp().is_empty())
	# A reload preserves the award flag independently of the cleared-room guard.
	State.floors[0][Vector2i.ZERO]["cleared"] = false
	assert(State.award_victory_xp().is_empty() and State.hero_progress==progress)
	State.hero_progress.clear()
	State.progress_loaded = false
	State.load_progression()
	assert(State.hero_progress==progress,"Death's Door level-up persists through the normal progression file")
	return true

func test_controller_rates() -> bool:
	for depth in range(3):
		for kind in ["battle","boss","corridor"]:
			var battle = await create_battle("battle" if kind=="corridor" else kind,depth,kind=="corridor")
			battle._apply_damage("warden",State.hero_max_hp("warden"),true,"XP rate fixture")
			kill_enemies(battle)
			var expected: int = 6+depth*2 if kind=="corridor" else (35 if kind=="boss" else 12)+depth*4
			for id in State.party:
				assert(State.journey["xp"][id]==expected,"Existing battle/boss/corridor XP rates stay unchanged")
			assert(State.run_heroes["warden"]["hp"]==0 and State.run_heroes["warden"]["deaths_door"])
			assert(State.award_victory_xp().is_empty())
	return true

func test_missing_and_nonparty_excluded() -> bool:
	reset_fixture()
	assert(State.select_expedition("old_road"))
	State.start_run(2026)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","cleared":false,"seen":true}
	State.run_heroes["warden"]["hp"] = 0
	State.run_heroes["warden"]["deaths_door"] = true
	State.run_heroes["ranger"]["dead"] = true
	State.run_heroes.erase("occultist")
	State.run_heroes["healer"] = {"hp":42,"dead":false}
	var rewards: Dictionary = State.award_victory_xp()
	assert(rewards.keys()==["warden"] and rewards["warden"]["xp"]==12)
	assert(State.leveling("ranger")["xp"]==0 and State.leveling("occultist")["xp"]==0 and State.leveling("healer")["xp"]==0)
	assert(State.journey["xp"].keys()==["warden"])
	return true

func test_coterie_final_form_only() -> bool:
	var battle = await create_battle("boss",1,false,true)
	battle._apply_damage("warden",State.hero_max_hp("warden"),true,"Coterie XP fixture")
	for phase in range(3):
		battle._load_enemy(0)
		assert(int(battle.enemies[0]["phase_index"])==phase)
		battle._deal_enemy_damage(999,true)
		battle._check_battle_over()
		if phase<2:
			assert(not battle.battle_over and not battle.reward_given)
			assert(not State.floors[1][Vector2i.ZERO].get("xp_awarded",false))
			assert(State.journey["xp"].is_empty() and State.hero_progress.is_empty(),"Intermediate forms cannot award XP")
		else:
			assert(battle.battle_over and battle.reward_given)
			for id in State.party: assert(State.journey["xp"][id]==39)
	assert(State.run_heroes["warden"]["hp"]==0 and State.run_heroes["warden"]["deaths_door"])
	battle._check_battle_over()
	assert(State.journey["xp"]["warden"]==39)
	return true

func run() -> void:
	seed(701)
	if not await test_controller_levelup_and_save(): quit(1);return
	if not await test_controller_rates(): quit(1);return
	if not test_missing_and_nonparty_excluded(): quit(1);return
	if not await test_coterie_final_form_only(): quit(1);return
	if is_instance_valid(current_scene): current_scene.queue_free()
	await settle()
	print("PASS: living Death's Door survivor XP; controller level-up without healing; unchanged rates; dead/missing/nonparty exclusion; saved once-only XP; final-form rewards")
	quit(0)
