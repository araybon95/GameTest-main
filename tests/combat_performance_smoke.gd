extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Poses = preload("res://scripts/combat_poses.gd")
const Profiles = preload("res://scripts/attack_profiles.gd")
var heard: Array[String] = []

func _initialize() -> void: call_deferred("run")

func at(cinema: Control, time: float) -> void:
	cinema.age = time
	cinema._process(0)

func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://combat_performance.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.equipment.clear()
	State.select_expedition("old_road")
	State.start_run(2304)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout"],"seen":true,"cleared":false}
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	for frame in range(4): await process_frame
	var cinema: Control = battle.presentation
	cinema.set_process(false)
	cinema.action_sound.connect(func(kind: String): heard.append(kind))
	var hero: TextureRect = battle.hero_portraits["warden"]
	var target: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
	for model in [hero,target]:
		var seen: Array[Rect2] = []
		for state in ["attack","windup","guard","hurt","death"]:
			var pose: Texture2D = Poses.state_pose(model.texture,state)
			if model == hero:
				assert(pose.get_width() > 0 and pose.get_height() > 0 and pose.get_meta("appearance_style","") == "warden_weapon")
				assert(pose.get_meta("combat_state") == state, "Painted Warden routes simplified poses to every action state")
			else:
				assert(pose is AtlasTexture)
				assert(not seen.has(pose.region), "Raider keeps five distinct reaction poses")
				assert(pose.region.end.x <= pose.atlas.get_width() and pose.region.end.y <= pose.atlas.get_height())
				seen.append(pose.region)
	var hp: int = battle.enemy_hp
	var rng: int = State.loot_rng.state
	cinema.strike(hero,target,"sword","Heavy Strike",true,{"skill_id":"wd_heavy"})
	at(cinema,0.2)
	assert(cinema.fighters[0].texture == Poses.state_pose(hero.texture,"windup"))
	cinema.feedback(target,"status",0,"burn")
	at(cinema,cinema.impact_time()-0.001)
	assert(cinema.status_bursts.bursts.is_empty(),"Application bursts wait until contact")
	at(cinema,cinema.impact_time()+0.001)
	assert(cinema.status_bursts.bursts.size() == 1)
	assert(cinema.fighters[1].material.get_shader_parameter("burn") == 1.0)
	for fighter in cinema.fighters:
		var foot: Vector2 = fighter.get_global_transform()*Vector2(fighter.size.x*0.5,fighter.size.y)
		assert(absf(foot.y-430)<2,"Changed poses remain planted")
	at(cinema,cinema.impact_time()+0.001)
	assert(cinema.status_bursts.bursts.size() == 1,"Held contact cannot repeat the burst")
	at(cinema,2)
	cinema.strike(hero,target,"sword","Shield Bash",true,{"skill_id":"wd_bash"})
	at(cinema,cinema.impact_time()+0.04)
	assert(cinema.fighters[0].texture == Poses.state_pose(hero.texture,"guard"),"Shield Bash leads with the shield instead of a sword swing")
	at(cinema,2)
	for effect in ["bleed","poison","chill"]:
		cinema.feedback(target,"status_tick",2,effect)
	assert(cinema.status_bursts.bursts.size() == 4)
	for burst in cinema.status_bursts.bursts:
		assert(burst["rect"].end.y <= 600,"Bursts stay above the HUD")
	cinema.status_bursts._process(1)
	assert(cinema.status_bursts.bursts.is_empty())
	assert(battle.enemy_hp == hp and State.loot_rng.state == rng,"Cosmetic bursts cannot change damage or loot")
	heard.clear()
	cinema.strike(hero,target,"sword","Final Slash",true,{"skill_id":"wd_slash"})
	battle._play_attack_sound("sword")
	battle._deal_enemy_damage(1000,true,"warden")
	assert(cinema.active.get("defeated",false))
	var enemies_after: Array = battle.enemies.duplicate(true)
	var heroes_after: Dictionary = battle.hero_state.duplicate(true)
	at(cinema,cinema.impact_time()+float(cinema.active["timing"]["hold"])+0.04)
	assert(cinema.fighters[1].texture == Poses.state_pose(cinema.active["target"],"death"))
	assert(heard == ["sword","impact","death"],"Release, contact and defeat cues each play once")
	at(cinema,2)
	assert(heard == ["sword","impact","death"] and battle.enemies == enemies_after and battle.hero_state == heroes_after)
	for boss in ["harrowed_giant","keep_son","undying_lord","moth_oleander"]:
		assert(Profiles.resolve("sword","Strike",{"effect":"attack","creature":boss},true)["id"] == "heavy")
	var inspection := TextureRect.new()
	inspection.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	inspection.texture = hero.texture
	inspection.position = Vector2(100,100)
	inspection.size = Vector2(140,170)
	root.add_child(inspection)
	var visual = preload("res://scenes/combat/status_visual.gd").new()
	visual.attach_to(inspection)
	visual.sync({},0,55,true)
	assert(inspection.texture == Poses.state_pose(hero.texture,"death"))
	var next_hero: Texture2D = battle.hero_portraits["ranger"].texture
	inspection.texture = next_hero
	visual.sync({},40,40,false)
	assert(inspection.texture == next_hero and inspection.size == Vector2(140,170),"Inspecting a living hero after a fallen one restores the new art and original frame")
	inspection.queue_free()
	# An actual queued phase reveal emits its own cue once, even if finished early.
	heard.clear()
	cinema.reveal_boss(battle.enemy_views[1].get_node("EnemyArt"),"The Coterie","The hymn resumes.","remade",2,3)
	var reveal: Control = cinema.boss_reveal
	reveal.set_process(false)
	reveal._process(0.3)
	reveal._process(0)
	assert(heard == ["phase"] and reveal.marker.text.contains("PHASE 2 / 3"))
	reveal.finish()
	await process_frame
	await process_frame
	assert(heard == ["phase"] and not cinema.visible)
	battle.queue_free()
	await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: distinct Warden/bandit poses, planted feet, impact-only status bursts, bounded/expired FX, actual kill/reaction/audio once, weighted bosses and phase cue without changing mechanics")
	quit()
