extends SceneTree
## Hold real skill presentations at their distinct anticipation/release/contact/recovery moments.
const State = preload("res://scripts/game_data.gd")
var screenshot_count: int = 0

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	for index in range(4): await process_frame

func shot(name: String) -> void:
	await settle()
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png("C:/GAME/Ashen/profile-%s.png" % name) == OK)
	screenshot_count += 1

func clear_cinema(battle: Control) -> void:
	while not battle.presentation.active.is_empty():
		battle.presentation.age = 2
		battle.presentation._process(0)
	for child in battle.get_children():
		if child is Label and child.name.begins_with("CombatFeedback"): child.queue_free()

func capture_skill(battle: Control, hero: String, skill: String, name: String) -> void:
	clear_cinema(battle)
	battle.hero_state[hero]["ap"] = 2
	battle.hero_state[hero]["cooldowns"].clear()
	battle._select_hero(hero)
	battle._select_enemy(0)
	battle.enemy_hp = int(battle.enemies[0]["max_hp"])
	battle.enemies[0]["hp"] = battle.enemy_hp
	battle.enemies[0]["statuses"].clear()
	assert(State.Depth.skill_allowed(State,hero,skill,battle.enemy_position(0)))
	battle._play_card(hero,battle.hero_state[hero]["abilities"].find(skill))
	var cinema: Control = battle.presentation
	assert(cinema.active["profile"] == name)
	var release: float = cinema.release_time()
	var impact: float = cinema.impact_time()
	var duration: float = float(cinema.active["duration"])
	for phase in [["windup",release*0.78],["release",release+(impact-release)*0.30],["impact",impact+0.04],["recover",duration-0.06]]:
		cinema.age = phase[1]
		cinema._process(0)
		await shot("%s-%s" % [name,phase[0]])
	clear_cinema(battle)

func combat(party: Array) -> Control:
	State.party.assign(party)
	State.hero_progress.clear()
	State.equipment.clear()
	State.modifications.clear()
	State.hero_positions.clear()
	State.formation.clear()
	assert(State.select_expedition("old_road"))
	State.start_run(944)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout","ash_raider"],"cleared":false,"seen":true}
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await settle()
	battle.presentation.set_process(false)
	return battle

func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://attack_profiles_preview.cfg"
	State.crusader_unlocked = true
	var battle: Control = await combat(["warden","ranger","occultist"])
	await capture_skill(battle,"warden","wd_slash","light")
	await capture_skill(battle,"warden","wd_heavy","heavy")
	await capture_skill(battle,"ranger","rg_quick","bow")
	await capture_skill(battle,"occultist","oc_hex","spell")
	battle.queue_free()
	await settle()
	battle = await combat(["warden","crusader","ranger"])
	State.hero_positions = {"warden":1,"crusader":2,"ranger":3}
	battle._refresh_all()
	await capture_skill(battle,"crusader","pc_charge","charge")
	battle.queue_free()
	await settle()
	State.end_run()
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: %d actual skill animation phase previews captured" % screenshot_count)
	quit()
