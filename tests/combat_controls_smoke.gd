extends SceneTree
const State = preload("res://scripts/game_data.gd")
var battle: Control

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	for frame in range(3): await process_frame

func key(code: int, echo: bool = false) -> void:
	for down in [true, false]:
		var event := InputEventKey.new()
		event.keycode = code
		event.physical_keycode = code
		if code >= KEY_0 and code <= KEY_9: event.unicode = code
		event.pressed = down
		event.echo = echo and down
		root.push_input(event, true)
	await settle()

func click(point: Vector2) -> void:
	for down in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = down
		event.position = point
		event.global_position = point
		root.push_input(event, true)
	await settle()

func snapshot() -> Dictionary:
	return {"heroes":battle.hero_state.duplicate(true),"enemies":battle.enemies.duplicate(true),"inventory":State.inventory.duplicate(true),"gold":State.gold}

func view(id: String) -> Button:
	return battle.hand_container.get_node("Card_%s" % id)

func clear_cinematic() -> void:
	while not battle.presentation.active.is_empty():
		battle.presentation.age = 10.0
		battle.presentation._process(0.0)
	await settle()

func run() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://combat_controls_progress.cfg"
	State.party.assign(["warden", "ranger", "occultist"])
	State.equipment.clear()
	State.hero_progress.clear()
	State.modifications.clear()
	State.hero_positions.clear()
	State.formation.clear()
	assert(State.select_expedition("old_road"))
	State.start_run(968)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout","ash_raider"],"cleared":false,"seen":true}
	assert(change_scene_to_file("res://scenes/combat/combatscene.tscn") == OK)
	await settle()
	battle = current_scene
	var before: Dictionary = snapshot()
	await key(KEY_1)
	assert(battle.selected_skill_id == "wd_slash" and root.gui_get_focus_owner() == view("wd_slash"))
	assert(view("wd_slash").preview.visible and view("wd_slash").preview.get_node("PreviewNote").text.contains("ENTER"))
	assert(view("wd_slash").get_node("Contents/Header").text.begins_with("[1]"))
	assert(snapshot() == before, "Quick select previews a skill without spending AP or attacking")
	await key(KEY_5, true)
	assert(battle.selected_skill_id == "wd_slash", "Held-key repeats do not change the selected skill")
	# Native pointer retargeting preserves the keyboard choice, without attacking.
	await click(battle.enemy_views[1].get_global_rect().get_center())
	assert(battle.selected_enemy_index == 1 and battle.selected_skill_id == "wd_slash")
	assert(snapshot() == before, "Selecting an enemy does not fire the armed skill")
	await click(battle.enemy_views[2].get_global_rect().get_center())
	assert(battle.selected_skill_id == "wd_slash" and view("wd_slash").data["availability"]["code"] == "target_range")
	await key(KEY_ENTER)
	assert(snapshot() == before, "Retargeting outside skill reach cannot spend AP")
	await click(battle.enemy_views[1].get_global_rect().get_center())
	var hp: int = int(battle.enemies[1]["hp"])
	await key(KEY_ENTER)
	assert(battle.hero_state["warden"]["ap"] == 1 and int(battle.enemies[1]["hp"]) < hp)
	assert(int(battle.enemies[0]["hp"]) == int(before["enemies"][0]["hp"]) and battle.selected_skill_id.is_empty())
	await clear_cinematic()
	# Disabled skills focus their existing reason card and cannot execute.
	battle.hero_state["warden"]["ap"] = 0
	battle._refresh_hand()
	before = snapshot()
	await key(KEY_KP_5)
	assert(battle.selected_skill_id == "wd_heavy" and root.gui_get_focus_owner() == view("wd_heavy").inspect_focus)
	assert(view("wd_heavy").preview.get_node("Availability").text.contains("Costs 2 AP"))
	await key(KEY_KP_ENTER)
	assert(snapshot() == before, "Enter cannot use a skill without AP")
	battle.hero_state["warden"]["ap"] = 2
	battle.hero_state["warden"]["cooldowns"]["wd_heavy"] = 2
	battle._refresh_hand()
	before = snapshot()
	await key(KEY_5)
	await key(KEY_ENTER)
	assert(snapshot() == before and view("wd_heavy").data["availability"]["code"] == "cooldown")
	battle.hero_state["warden"]["cooldowns"].clear()
	State.hero_positions = {"warden":3,"ranger":1,"occultist":2}
	battle._refresh_hand()
	before = snapshot()
	await key(KEY_1)
	await key(KEY_ENTER)
	assert(snapshot() == before and view("wd_slash").data["availability"]["code"] == "hero_position")
	State.hero_positions = {"warden":1,"ranger":2,"occultist":3}
	battle._refresh_hand()
	# Focused text fields receive typed numbers rather than combat shortcuts.
	var edit := LineEdit.new()
	edit.position = Vector2(200, 80)
	edit.size = Vector2(200, 45)
	battle.add_child(edit)
	edit.grab_focus()
	var selected: String = battle.selected_skill_id
	before = snapshot()
	await key(KEY_5)
	await key(KEY_ENTER)
	assert(battle.selected_skill_id == selected and snapshot() == before and edit.text == "5")
	edit.queue_free()
	await settle()
	# Settings and the shared guide/sheet must block keyboard actions.
	var settings: Node = root.get_node("GameSettings")
	settings.open_settings()
	before = snapshot()
	await key(KEY_5)
	await key(KEY_ENTER)
	assert(battle.selected_skill_id == selected and snapshot() == before)
	settings.close_settings()
	await settle()
	var controls: Node = root.get_node_or_null("GameControls")
	if controls != null:
		await key(KEY_I)
		assert(is_instance_valid(controls.overlay), "I opens the shared controls guide from combat")
		before = snapshot()
		await key(KEY_5)
		await key(KEY_ENTER)
		assert(battle.selected_skill_id == selected and snapshot() == before)
		await key(KEY_I)
		assert(not is_instance_valid(controls.overlay))
		controls.open_hero_sheet("warden")
		before = snapshot()
		await key(KEY_5)
		await key(KEY_ENTER)
		assert(battle.selected_skill_id == selected and snapshot() == before)
		controls.close_hero_sheet()
		await settle()
	assert(battle.hero_buttons["warden"].get_meta("hero_id") == "warden" and battle.hero_portraits["warden"].get_meta("hero_id") == "warden")
	# A hero change clears the previous hero's skill selection.
	battle._select_hero("ranger")
	assert(battle.selected_skill_id.is_empty())
	assert(battle.selected_portrait.get_meta("hero_id") == "ranger")
	current_scene = null
	battle.queue_free()
	await settle()
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: native 1–5/keypad skill preview, Enter confirmation, retargeting without attacks, disabled AP/cooldown/position guards, text/modal blocking and hero identity metadata")
	quit()
