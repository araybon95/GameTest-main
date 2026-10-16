extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.party = ["crusader", "occultist", "healer"]
	State.start_run(3)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout"],"seen":true,"cleared":false}
	assert(State.HEROES.crusader.name == "Witch Hunter", "Approved hero name")
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	var cinema = battle.presentation
	cinema.set_process(false)
	battle._select_hero("crusader")
	battle.hero_state.crusader.hp = 2
	battle._play_card("crusader",2)
	assert(cinema.active.get("skill_id","") == "pc_pain")
	assert(not preload("res://scenes/combat/strike_effects.gd").harmful_contact(cinema.active), "A binding rite does not depict a physical wound")
	assert(battle.enemy_weak_rounds == 2 and battle.hero_state.crusader.hp == 2)
	assert(battle.hero_state.crusader.ap == 1)
	battle._select_enemy(1)
	assert(battle.enemy_weak_rounds == 0)
	battle._select_enemy(0)
	assert(battle.enemy_weak_rounds == 2)
	var base: int = battle._attack_damage("crusader",State.card_stats("pc_verdict"))
	battle.enemy_weak_rounds = 0
	assert(base == battle._attack_damage("crusader",State.card_stats("pc_verdict")) + 4)
	battle._resolve_card("occultist",State.card_stats("oc_weak"))
	assert(base == battle._attack_damage("crusader",State.card_stats("pc_verdict")))
	battle.enemy_hp = 100
	battle.enemy_block = 12
	var hp: int = battle.enemy_hp
	battle._resolve_card("crusader",State.card_stats("pc_charge"))
	assert(battle.enemy_hp == hp - 4 and battle.enemy_block == 0, "Strip six Block before ten damage")
	assert(not battle.enemies[0].statuses.has("bleed"))
	assert(State.Depth.position_of(State,"crusader") == 1)
	battle.enemy_block = 20
	battle._resolve_card("crusader",State.card_stats("pc_charge"))
	assert(battle.enemy_block == 4 and battle.enemy_hp == hp - 4)
	battle.hero_state.crusader.statuses["chill"] = {"turns":2}
	battle.hero_state.crusader.resolve_type = "affliction"
	var miss_seed: int = 0
	for candidate in range(100):
		seed(candidate)
		if randf() >= 0.8:
			miss_seed = candidate
			break
	seed(miss_seed)
	battle.enemy_block = 12
	battle._resolve_card("crusader",State.card_stats("pc_charge"))
	assert(battle.enemy_block == 12 and battle.enemy_hp == hp-4, "A miss does not destroy Block")
	battle.presentation = null
	for hero in battle.hero_state.values():
		hero.hp = 100
		hero.statuses.clear()
	battle.round_number = 2
	battle._enemy_action()
	assert(battle.enemy_weak_rounds == 2, "Guarding does not consume Weakness")
	battle.round_number = 3
	var weak_power: int = battle._enemy_attack_power()
	battle.enemy_weak_rounds = 0
	assert(battle._enemy_attack_power() == weak_power+3)
	battle.enemy_weak_rounds = 2
	battle._enemy_action()
	assert(battle.enemy_weak_rounds == 1)
	battle.round_number = 4
	battle._enemy_action()
	assert(battle.enemy_weak_rounds == 0, "Exactly two attack actions consume Weakness")
	assert("Weakness" in State.card_description(State.card_stats("pc_pain")))
	var released: bool = await preload("res://tests/support/audio_cleanup.gd").finish(self,[battle])
	assert(released,"Stopped audio must release before test shutdown")
	print("PASS: Witch Hunter identity, low-HP binding/AP, ally Weakness bonus, Sunder Block absorption and stable formation")
	quit()
