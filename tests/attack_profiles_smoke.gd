extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Profiles = preload("res://scripts/attack_profiles.gd")
const Effects = preload("res://scenes/combat/strike_effects.gd")
var charge_checks_completed: bool = false

func _initialize() -> void: call_deferred("run")

func at(cinema: Control, time: float) -> void:
	cinema.age = time
	cinema._process(0)

func finish(cinema: Control) -> void:
	at(cinema,2.0)

func foot(fighter: TextureRect) -> Vector2:
	return fighter.get_global_transform()*Vector2(fighter.size.x*0.5,fighter.size.y)

func verify_stage(cinema: Control) -> void:
	for fighter in cinema.fighters:
		assert(absf(foot(fighter).y-430.0)<2,"Each changed pose, recoil and charge keeps its foot anchor on the floor")
		assert(fighter.position.x >= 24 and fighter.position.x+fighter.size.x <= 1896)

func painted_rect(portrait: TextureRect) -> Rect2:
	# Idle art includes transparent padding. Compare painted bounds rather than
	# treating those margins as bodies that overlap the adjacent party member.
	var pixels: Rect2 = Rect2(portrait.texture.get_image().get_used_rect())
	if portrait.flip_h: pixels.position.x = portrait.texture.get_width()-pixels.end.x
	if portrait.flip_v: pixels.position.y = portrait.texture.get_height()-pixels.end.y
	var factor: Vector2 = portrait.size/portrait.texture.get_size()
	var local := Rect2(pixels.position*factor,pixels.size*factor)
	var transform: Transform2D = portrait.get_global_transform()
	var result := Rect2(transform*local.position,Vector2.ZERO)
	for point in [local.position+Vector2(local.size.x,0),local.end,local.position+Vector2(0,local.size.y)]:
		result = result.expand(transform*point)
	return result

func painted_overlap(first: TextureRect, second: TextureRect) -> bool:
	var overlap: Rect2 = painted_rect(first).intersection(painted_rect(second))
	if not overlap.has_area(): return false
	var first_image: Image = first.texture.get_image()
	var second_image: Image = second.texture.get_image()
	var first_inverse: Transform2D = first.get_global_transform().affine_inverse()
	var second_inverse: Transform2D = second.get_global_transform().affine_inverse()
	# A weapon's rectangle can extend behind a fighter without touching an ally.
	# Sample both actual alpha silhouettes in the shared stage coordinates.
	for y in range(int(overlap.position.y),int(ceil(overlap.end.y)),3):
		for x in range(int(overlap.position.x),int(ceil(overlap.end.x)),3):
			var point := Vector2(x+0.5,y+0.5)
			var first_pixel: Vector2 = (first_inverse*point)/first.size*Vector2(first_image.get_size())
			var second_pixel: Vector2 = (second_inverse*point)/second.size*Vector2(second_image.get_size())
			if first.flip_h: first_pixel.x = first_image.get_width()-1-first_pixel.x
			if second.flip_h: second_pixel.x = second_image.get_width()-1-second_pixel.x
			if first.flip_v: first_pixel.y = first_image.get_height()-1-first_pixel.y
			if second.flip_v: second_pixel.y = second_image.get_height()-1-second_pixel.y
			if first_pixel.x < 0 or first_pixel.y < 0 or first_pixel.x >= first_image.get_width() or first_pixel.y >= first_image.get_height(): continue
			if second_pixel.x < 0 or second_pixel.y < 0 or second_pixel.x >= second_image.get_width() or second_pixel.y >= second_image.get_height(): continue
			if first_image.get_pixel(int(first_pixel.x),int(first_pixel.y)).a > 0.25 and second_image.get_pixel(int(second_pixel.x),int(second_pixel.y)).a > 0.25: return true
	return false

func crusader_charge() -> void:
	State.crusader_unlocked = true
	State.party.assign(["warden","crusader","ranger"])
	State.equipment.clear()
	State.modifications.clear()
	State.hero_progress.clear()
	State.formation.clear()
	State.hero_positions.clear()
	State.start_run(943)
	State.hero_positions = {"warden":1,"crusader":2,"ranger":3}
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout"],"seen":true,"cleared":false}
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	for index in range(4): await process_frame
	var cinema: Control = battle.presentation
	cinema.set_process(false)
	var hero: Dictionary = battle.hero_state["crusader"]
	hero["ap"] = 2
	battle._select_hero("crusader")
	battle._select_enemy(0)
	assert(State.Depth.position_of(State,"crusader") == 2)
	var before_hp: int = int(battle.enemies[0]["hp"])
	var damage: int = battle._attack_damage("crusader",State.card_stats("pc_charge"))
	battle._play_card("crusader",hero["abilities"].find("pc_charge"))
	assert(cinema.active["profile"] == "charge" and cinema.active["skill_id"] == "pc_charge")
	assert(cinema.active["source_node"] == battle.hero_portraits["crusader"] and str(cinema.active["source"].get_meta("pose_id","")) == "crusader","The actual Crusader skill uses its own artwork and charge profile")
	var source: TextureRect = battle.hero_portraits["crusader"]
	assert(absf(float(cinema.active["source_position"].x)-(source.get_global_rect().position.x-cinema.global_position.x)) < 1.0,"Charge snapshots the arranged P1 lane before animation, so the displaced ally cannot overlap its old slot")
	assert(hero["ap"] == 0 and hero["block"] == 6 and State.Depth.position_of(State,"crusader") == 1)
	assert(before_hp-int(battle.enemies[0]["hp"]) == damage and battle.enemies[0]["statuses"]["bleed"]["turns"] == 2)
	var after_heroes: Dictionary = battle.hero_state.duplicate(true)
	var after_enemies: Array = battle.enemies.duplicate(true)
	var heard: Array[String] = []
	cinema.action_sound.connect(func(kind: String): heard.append(kind))
	for time in [0.10,cinema.release_time()+0.03,cinema.impact_time()+0.04,0.85]:
		at(cinema,time)
		verify_stage(cinema)
		var source_rect: Rect2 = painted_rect(cinema.fighters[0])
		var ally_rect: Rect2 = painted_rect(battle.hero_portraits["warden"])
		assert(not painted_overlap(cinema.fighters[0],battle.hero_portraits["warden"]),"Charge at %.2fs: source %s overlaps displaced ally %s" % [time,source_rect,ally_rect])
	finish(cinema)
	assert(heard == ["sword","impact"] and battle.hero_state == after_heroes and battle.enemies == after_enemies,"Playing every charge phase applies AP, Block, Bleed and damage exactly once")
	battle.queue_free()
	for index in range(4): await process_frame
	charge_checks_completed = true

func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://attack_profiles_smoke.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.equipment.clear()
	State.hero_progress.clear()
	State.formation.clear()
	State.hero_positions.clear()
	State.select_expedition("old_road")
	State.start_run(942)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout"],"seen":true,"cleared":false}
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	for index in range(4): await process_frame
	var cinema: Control = battle.presentation
	cinema.set_process(false)
	var hero: TextureRect = battle.hero_portraits["warden"]
	var ranger: TextureRect = battle.hero_portraits["ranger"]
	var caster: TextureRect = battle.hero_portraits["occultist"]
	var target: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
	var heroes_before: Dictionary = battle.hero_state.duplicate(true)
	var enemies_before: Array = battle.enemies.duplicate(true)
	var heard: Array[Dictionary] = []
	cinema.action_sound.connect(func(kind: String): heard.append({"kind":kind,"title":cinema.active.get("title",""),"age":cinema.age}))
	# No metadata means exact old event times, even for a heavy sounding caption.
	cinema.strike(hero,target,"sword","Heavy legacy attack")
	assert(cinema.active["profile"] == "legacy" and is_equal_approx(cinema.release_time(),0.13) and is_equal_approx(cinema.impact_time(),0.28))
	at(cinema,0.28)
	assert(is_equal_approx(cinema.event_clock(),0.28))
	finish(cinema)
	var light: Dictionary = Profiles.resolve("sword","Slash",{"skill_id":"wd_slash"})
	var heavy: Dictionary = Profiles.resolve("sword","Heavy Strike",{"skill_id":"wd_heavy"})
	var charge: Dictionary = Profiles.resolve("sword","Thornbound Charge",{"skill_id":"pc_charge"})
	assert(heavy["release"] > light["release"]*2 and heavy["hold"] > light["hold"]*2)
	assert(Profiles.motion(heavy,0.54)["source_x"] == Profiles.motion(heavy,0.64)["source_x"],"The heavy impact holds its contact pose")
	assert(charge["travel"] > light["travel"]*3)
	var source_origins: Dictionary = {}
	for entry in [["wd_slash","light"],["wd_heavy","heavy"],["pc_charge","charge"]]:
		cinema.strike(hero,target,"sword",entry[1],true,{"skill_id":entry[0]})
		assert(cinema.active["profile"] == entry[1])
		var initial: float = foot(cinema.fighters[0]).x
		at(cinema,0.18)
		source_origins[entry[1]] = foot(cinema.fighters[0]).x-initial
		for time in [cinema.release_time()+0.03,cinema.impact_time()+0.04,float(cinema.active["duration"])-0.04]:
			at(cinema,time)
			verify_stage(cinema)
		assert(battle.hero_portraits["ranger"].visible and not hero.visible and not target.visible)
		finish(cinema)
	assert(source_origins["light"] > 0 and source_origins["heavy"] < 0,"Light cuts release while a heavy strike is still pulling back")
	# A heavy swing emits at release and its fully mitigated impact emits a separate block.
	cinema.strike(hero,target,"sword","Heavy timing",true,{"skill_id":"wd_heavy"})
	assert(cinema.queue_sound("sword") and cinema.queue_sound("sword"))
	cinema.feedback(target,"block")
	assert(cinema.queue_sound("block"))
	var before: int = heard.size()
	at(cinema,cinema.release_time()-0.001)
	assert(heard.size() == before and cinema.active.has("feedback"))
	at(cinema,cinema.release_time())
	assert(heard.size() == before+1 and heard[-1]["kind"] == "sword")
	at(cinema,cinema.impact_time()-0.001)
	assert(heard.size() == before+1 and cinema.active.has("feedback"))
	at(cinema,cinema.impact_time())
	assert(heard.size() == before+2 and heard[-1]["kind"] == "block" and not cinema.active.has("feedback"))
	assert(not Effects.sample(cinema)["harmful"] and cinema.fighters[1].self_modulate == Color.WHITE)
	var popups: int = cinema.popup_sequence
	at(cinema,cinema.impact_time()+0.05)
	assert(cinema.popup_sequence == popups and heard.size() == before+2,"Repeated held impact frames do not repeat audio or feedback")
	# Each queued actor owns its release cue, with no cue played by the previous actor.
	cinema.strike(ranger,target,"bow","Draw and release",true,{"skill_id":"rg_quick"})
	assert(cinema.queue_sound("bow"))
	cinema.feedback(target,"miss")
	cinema.strike(caster,target,"spell","Spell buildup",true,{"skill_id":"oc_hex"})
	assert(cinema.queue_sound("spell"))
	finish(cinema)
	assert(cinema.active["profile"] == "bow" and heard.size() == before+2)
	at(cinema,cinema.release_time()-0.01)
	var drawn: float = foot(cinema.fighters[0]).x
	at(cinema,cinema.release_time()+0.045)
	assert(heard[-1]["kind"] == "bow" and heard[-1]["title"] == "Draw and release")
	assert(foot(cinema.fighters[0]).x < drawn,"The drawn bow recoils at release")
	at(cinema,cinema.impact_time())
	assert(is_equal_approx(float(Effects.sample(cinema)["progress"]),1.0),"An arrow reaches its aim at the same contact event as feedback/audio")
	at(cinema,cinema.impact_time()+0.04)
	assert(not Effects.sample(cinema)["harmful"] and cinema.fighters[1].self_modulate == Color.WHITE)
	finish(cinema)
	assert(cinema.active["profile"] == "spell")
	at(cinema,cinema.release_time()-0.01)
	assert(heard[-1]["kind"] == "bow" and cinema.animation_sample()["phase"] == "windup")
	at(cinema,cinema.release_time())
	assert(heard[-1]["kind"] == "spell" and heard[-1]["title"] == "Spell buildup")
	verify_stage(cinema)
	finish(cinema)
	# A late cue emits once; actions discarded before staging emit no ghost cue.
	cinema.strike(hero,target,"sword","Late cue",true,{"skill_id":"wd_slash"})
	at(cinema,0.40)
	before = heard.size()
	assert(cinema.queue_sound("sword") and heard.size() == before+1)
	var doomed := TextureRect.new()
	doomed.texture = target.texture
	doomed.position = target.position
	doomed.size = target.size
	battle.add_child(doomed)
	cinema.strike(ranger,doomed,"bow","Canceled actor",true,{"skill_id":"rg_quick"})
	assert(cinema.queue_sound("bow"))
	doomed.free()
	var doomed_source := TextureRect.new()
	doomed_source.texture = hero.texture
	doomed_source.position = hero.position
	doomed_source.size = hero.size
	battle.add_child(doomed_source)
	cinema.strike(doomed_source,target,"spell","Canceled source",true,{"profile":"spell"})
	assert(cinema.queue_sound("spell"))
	doomed_source.free()
	finish(cinema)
	assert(heard.size() == before+1 and heard[-1]["kind"] == "sword" and cinema.active.is_empty() and cinema.pending.is_empty())
	assert(not cinema.queue_sound("spell"),"No action returns false for the controller's immediate fallback")
	# Reduced motion preserves poses/timing while removing travel, rotation and camera motion.
	cinema.motion_strength = 0
	cinema.strike(hero,target,"sword","Quiet charge",true,{"skill_id":"pc_charge"})
	var planted: Vector2 = foot(cinema.fighters[0])
	at(cinema,cinema.impact_time()+0.04)
	assert(foot(cinema.fighters[0]).is_equal_approx(planted) and cinema.fighters[0].rotation == 0 and cinema.fighters[0].scale == Vector2.ONE)
	verify_stage(cinema)
	finish(cinema)
	assert(battle.hero_state == heroes_before and battle.enemies == enemies_before,"Every animation and cue leaves damage, status and AP untouched")
	assert(hero.visible and target.visible and ranger.visible and caster.visible)
	cinema.strike(hero,target,"sword","Departing cue",true,{"skill_id":"wd_heavy"})
	cinema.queue_sound("sword")
	before = heard.size()
	battle.queue_free()
	for index in range(4): await process_frame
	assert(heard.size() == before,"Scene teardown does not emit late audio")
	await crusader_charge()
	assert(charge_checks_completed,"Every actual Crusader integration assertion must complete before PASS")
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: legacy timing, distinct grounded profiles/hitlag/recoil, queued/late/canceled audio, single feedback, harmless block/miss, reduced motion, unchanged combat state and actual Crusader charge mechanics applied once")
	quit()
