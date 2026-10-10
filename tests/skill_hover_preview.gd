extends SceneTree
const State = preload("res://scripts/game_data.gd")
var screenshot_count: int = 0

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	for index in range(4): await process_frame

func hover(battle: Control, id: String, name: String, keyboard: bool = false) -> void:
	var view: Button = battle.hand_container.get_node("Card_%s" % id)
	var event := InputEventMouseMotion.new()
	event.position = Vector2(20,620) if keyboard else view.get_global_rect().get_center()
	event.global_position = event.position
	root.push_input(event,true)
	if keyboard: view.inspect_focus.grab_focus()
	await settle()
	assert(view.preview != null and view.preview.visible)
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png("C:/GAME/Ashen/skill-hover-%s.png" % name) == OK)
	screenshot_count += 1

func combat(party: Array) -> Control:
	State.party.assign(party)
	State.equipment.clear()
	State.hero_progress.clear()
	State.modifications.clear()
	State.hero_positions.clear()
	State.formation.clear()
	State.crusader_unlocked = true
	assert(State.select_expedition("old_road"))
	State.start_run(946)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout","ash_raider"],"cleared":false,"seen":true}
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await settle()
	return battle

func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://skill_hover_preview.cfg"
	var battle: Control = await combat(["warden","ranger","occultist"])
	battle._select_hero("warden")
	battle.hero_state["warden"]["name"] = "Mara"
	battle.hero_state["warden"]["damage_mod"] = 3
	battle._refresh_all()
	await hover(battle,"wd_slash","available")
	battle.hero_state["warden"]["ap"] = 0
	battle._refresh_all()
	await hover(battle,"wd_heavy","insufficient-ap")
	battle.hero_state["warden"]["ap"] = 2
	battle.hero_state["warden"]["cooldowns"]["wd_heavy"] = 3
	battle._refresh_all()
	await hover(battle,"wd_heavy","cooldown-keyboard",true)
	battle.hero_state["warden"]["cooldowns"].clear()
	State.hero_positions = {"warden":3,"ranger":1,"occultist":2}
	battle._refresh_all()
	await hover(battle,"wd_slash","hero-position")
	State.hero_positions = {"warden":1,"ranger":2,"occultist":3}
	battle._select_enemy(2)
	await hover(battle,"wd_slash","target-range")
	battle._select_hero("occultist")
	await hover(battle,"oc_hex","spell-effects")
	battle.queue_free()
	await settle()
	battle = await combat(["warden","crusader","ranger"])
	battle._select_hero("crusader")
	battle.hero_state["crusader"]["hp"] = 2
	battle._refresh_all()
	await hover(battle,"pc_pain","health-cost")
	battle.queue_free()
	await settle()
	State.end_run()
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: %d mouse/keyboard skill availability previews captured" % screenshot_count)
	quit()
