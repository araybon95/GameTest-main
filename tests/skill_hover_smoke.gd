extends SceneTree
const State = preload("res://scripts/game_data.gd")
var completed: int = 0

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	for index in range(3): await process_frame

func move_pointer(point: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = point
	motion.global_position = point
	root.push_input(motion,true)
	await settle()

func click(point: Vector2) -> void:
	for down in [true,false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = down
		event.position = point
		event.global_position = point
		root.push_input(event,true)
	await settle()

func accept() -> void:
	for down in [true,false]:
		var event := InputEventAction.new()
		event.action = "ui_accept"
		event.pressed = down
		root.push_input(event,true)
	await settle()

func next_focus() -> void:
	var event := InputEventAction.new()
	event.action = "ui_focus_next"
	event.pressed = true
	root.push_input(event,true)
	await settle()

func card(battle: Control, id: String) -> Button:
	return battle.hand_container.get_node("Card_%s" % id)

func prepare(party: Array) -> Control:
	State.party.assign(party)
	State.equipment.clear()
	State.hero_progress.clear()
	State.modifications.clear()
	State.hero_positions.clear()
	State.formation.clear()
	State.crusader_unlocked = true
	assert(State.select_expedition("old_road"))
	State.start_run(945)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout","ash_raider"],"cleared":false,"seen":true}
	var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await settle()
	return battle

func inspect(battle: Control, id: String, code: String, phrase: String) -> void:
	var view: Button = card(battle,id)
	assert(view.data["availability"]["code"] == code)
	assert(view.size == Vector2(280,148),"Skills keep the original card dimensions")
	var heroes: Dictionary = battle.hero_state.duplicate(true)
	var enemies: Array = battle.enemies.duplicate(true)
	await move_pointer(Vector2(20,620))
	await move_pointer(view.get_global_rect().get_center())
	assert(view.inspecting and view.preview != null and view.preview.visible,"Actual pointer movement opens the preview even for disabled buttons")
	assert(view.preview.get_node("Availability").text.contains(phrase))
	var popup_rect: Rect2 = view.preview.get_global_rect()
	assert(Rect2(0,0,1920,1080).encloses(popup_rect) and popup_rect.end.y < view.get_global_rect().position.y)
	assert(view.preview.mouse_filter == Control.MOUSE_FILTER_IGNORE and view.preview.focus_mode == Control.FOCUS_NONE)
	for child in view.preview.get_children():
		if child is Control: assert(child.mouse_filter == Control.MOUSE_FILTER_IGNORE)
	assert(view.preview.get_node("Effects").text.begins_with(view.get_node("Contents/Description").text),"Popup and inline description use the same computed skill values")
	if view.disabled:
		assert(view.focus_mode == Control.FOCUS_NONE and view.inspect_focus.focus_mode == Control.FOCUS_ALL)
		view.inspect_focus.grab_focus()
		assert(root.gui_get_focus_owner() == view.inspect_focus)
		await accept()
		await click(view.get_global_rect().get_center())
		battle._play_card(battle.selected_hero,battle.hero_state[battle.selected_hero]["abilities"].find(id))
		assert(battle.hero_state == heroes and battle.enemies == enemies,"Inspecting or activating an unavailable skill cannot spend AP or change combat")
		view.inspect_focus.release_focus()
	else:
		assert(view.focus_mode == Control.FOCUS_ALL and view.inspect_focus.focus_mode == Control.FOCUS_NONE)
		assert(battle.hero_state == heroes and battle.enemies == enemies,"Hovering a ready skill does not activate it")
	await move_pointer(Vector2(20,620))
	assert(not view.inspecting and not view.preview.visible,"Leaving the card closes the popup without lingering input surfaces")

func normal_skills() -> void:
	var battle: Control = await prepare(["warden","ranger","occultist"])
	battle._select_hero("warden")
	battle.hero_state["warden"]["name"] = "Mara"
	battle.hero_state["warden"]["damage_mod"] = 3
	battle._refresh_hand()
	var ready: Button = card(battle,"wd_slash")
	var locked_color: Color
	assert(ready.data["hero_name"] == "Mara" and ready.data["class_name"] == "Warden")
	assert(ready.data["description"].contains("9 damage"),"Current hero damage modifiers appear in both skill views")
	var ready_color: Color = ready.get_theme_stylebox("normal").border_color
	await inspect(battle,"wd_slash","ready","AVAILABLE")
	battle.hero_state["warden"]["ap"] = 0
	battle._refresh_hand()
	card(battle,"wd_slash").inspect_focus.grab_focus()
	await next_focus()
	assert(root.gui_get_focus_owner() == card(battle,"wd_guard").inspect_focus,"Tab navigation reaches unavailable skills through their inspection focus targets")
	card(battle,"wd_guard").inspect_focus.release_focus()
	locked_color = card(battle,"wd_heavy").get_theme_stylebox("disabled").border_color
	assert(ready_color != locked_color)
	await inspect(battle,"wd_heavy","ap","Costs 2 AP; this hero has 0 AP")
	battle.hero_state["warden"]["ap"] = 2
	battle.hero_state["warden"]["cooldowns"]["wd_heavy"] = 3
	battle._refresh_hand()
	await inspect(battle,"wd_heavy","cooldown","3 party turn(s) remaining")
	battle.hero_state["warden"]["cooldowns"].clear()
	State.hero_positions = {"warden":3,"ranger":1,"occultist":2}
	battle._refresh_hand()
	await inspect(battle,"wd_slash","hero_position","Hero is at P3")
	State.hero_positions = {"warden":1,"ranger":2,"occultist":3}
	battle._select_enemy(2)
	await inspect(battle,"wd_slash","target_range","Target is at P3")
	battle._select_enemy(0)
	battle.hero_state["warden"]["dead"] = true
	battle._refresh_hand()
	await inspect(battle,"wd_slash","dead","hero is slain")
	battle.hero_state["warden"]["dead"] = false
	battle.battle_over = true
	battle._refresh_hand()
	await inspect(battle,"wd_slash","battle_over","battle is over")
	battle.battle_over = false
	battle._refresh_hand()
	# The real ready button still resolves one action; repeated input is gated by AP/cooldown.
	var before: int = battle.enemy_hp
	await click(card(battle,"wd_heavy").get_global_rect().get_center())
	assert(battle.hero_state["warden"]["ap"] == 0 and battle.enemy_hp < before and battle.presentation.active["profile"] == "heavy")
	var hp: int = battle.enemy_hp
	await click(card(battle,"wd_heavy").get_global_rect().get_center())
	assert(battle.enemy_hp == hp and battle.hero_state["warden"]["ap"] == 0)
	battle.queue_free()
	await settle()
	completed += 1

func pain_skill() -> void:
	var battle: Control = await prepare(["warden","crusader","ranger"])
	battle._select_hero("crusader")
	battle.hero_state["crusader"]["hp"] = 2
	battle._refresh_hand()
	await inspect(battle,"pc_pain","health","Needs more than 2 HP; currently 2 HP")
	battle.queue_free()
	await settle()
	completed += 1

func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://skill_hover_smoke.cfg"
	await normal_skills()
	await pain_skill()
	assert(completed == 2,"Every coroutine check must finish before reporting PASS")
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: actual ready/disabled pointer hover, readable shared previews, clamped noninteractive popup, Tab/keyboard inspection, all eligibility reasons and real activation limits")
	quit()
