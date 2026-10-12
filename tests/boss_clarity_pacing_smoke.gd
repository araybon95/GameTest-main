extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Objectives = preload("res://scripts/boss_objectives.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
	for frame in range(3): await process_frame
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://boss_clarity.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.select_expedition("old_road")
	State.start_run(42)
	State.floors[0][Vector2i.ZERO] = {"kind":"boss","creature":"undying_lord","support_creature":"keep_crossbow","seen":true,"cleared":false}
	change_scene_to_file("res://scenes/combat/combatscene.tscn")
	await settle()
	var battle = current_scene
	var cinema = battle.presentation
	cinema.set_process(false)
	await settle()
	if cinema.boss_reveal != null: cinema.boss_reveal.finish()
	await settle()
	battle._refresh_all()
	assert(battle.objective_panel.visible and not battle.objective_button.visible and not battle.objective_prop.visible)
	assert(battle.objective_hint.text.contains("TRIBUTE ACTIVE") and battle.objective_hint.text.contains("8 HP"))
	Objectives.consume_action(battle.enemies[0].objective)
	battle._refresh_all()
	assert(battle.enemies[0].objective.is_empty() and not battle.objective_button.visible,"Passive bosses never acquire an interactive objective when their turn ends")
	battle.enemies[1].hp = 0
	battle._refresh_all()
	assert(battle.objective_hint.text.contains("TRIBUTE STOPPED"))
	battle.enemies[0].creature = "keep_son"
	for pair in [[1,"GUARDING"],[2,"HEAVY STRIKE"],[3,"EXPOSED"]]:
		battle.round_number = pair[0]
		battle._refresh_all()
		assert(battle.objective_hint.text.contains(pair[1]))
	battle.enemies[0].objective = Objectives.create("coterie_cantor")
	battle.enemies[0].phase_index = 1
	battle._refresh_all()
	assert(battle.objective_hint.text.contains("COTERIE 2/3") and battle.objective_button.visible)
	battle.hero_state[battle.selected_hero].ap = 0
	battle._refresh_all()
	assert(battle.objective_button.disabled and battle.objective_button.tooltip_text.contains("at least 1 AP"))
	Objectives.interact(battle.enemies[0].objective)
	battle._refresh_all()
	assert(battle.objective_hint.text.contains("RITE BROKEN"))
	Objectives.consume_action(battle.enemies[0].objective)
	battle._refresh_all()
	assert(battle.objective_hint.text.contains("Rite spent"))
	var settings = root.get_node("GameSettings")
	settings.settings_path = "user://pacing_settings.cfg"
	settings.set_combat_speed(2.0)
	var cfg := ConfigFile.new()
	assert(cfg.load(settings.settings_path) == OK and cfg.get_value("settings","combat_speed") == 2.0)
	var before: Dictionary = battle.hero_state.duplicate(true)
	var hp: int = battle.enemies[0].hp
	var rng: int = State.loot_rng.state
	var heard: Array[String] = []
	cinema.action_sound.connect(func(kind): heard.append(kind))
	cinema.strike(battle.hero_portraits.warden,battle.enemy_views[0].get_node("EnemyArt"),"sword","Heavy Strike",true,{"skill_id":"wd_heavy"})
	cinema.queue_sound("impact")
	cinema._process(0.1)
	assert(is_equal_approx(cinema.age,0.2) and battle._combat_shortcuts_blocked())
	cinema.age = cinema.impact_time()-0.001
	cinema._process(0)
	assert(heard.is_empty(),"Fast playback keeps sound behind the impact boundary")
	cinema.age = cinema.impact_time()+0.001
	cinema._process(0)
	assert(heard == ["impact"],"Impact sound occurs once")
	cinema._process(5.0)
	assert(heard == ["impact"] and not cinema.visible and not battle._combat_shortcuts_blocked())
	cinema.reveal_boss(battle.enemy_views[0].get_node("EnemyArt"),"Test boss","Lore","keep")
	var reveal = cinema.boss_reveal
	reveal.set_process(false)
	reveal.age = 0
	reveal._process(0.1)
	assert(is_equal_approx(reveal.age,0.2))
	reveal.finish()
	await settle()
	assert(battle.hero_state == before and battle.enemies[0].hp == hp and State.loot_rng.state == rng,"Playback speed changes no combat state or RNG")
	settings.set_combat_speed(99)
	assert(settings.combat_speed == 1.0)
	print("PASS: live support/guard/exposure/form cues, AP availability, persisted playback, synchronized impact sound, reveal speed and unchanged gameplay/RNG")
	quit()
