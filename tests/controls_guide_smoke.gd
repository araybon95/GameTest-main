extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
	await process_frame
	await process_frame
func press(controls: Node, key: Key) -> void:
	var event := InputEventKey.new()
	event.keycode = key
	event.pressed = true
	controls._input(event)
func native_key(code: Key) -> void:
	for down in [true, false]:
		var event := InputEventKey.new()
		event.keycode = code
		event.physical_keycode = code
		event.pressed = down
		root.push_input(event, true)
	await settle()
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://controls_test_progress.cfg"
	State.party = ["warden", "ranger", "occultist"]
	State.hero_names["warden"] = "Iris"
	State.inventory.clear()
	State.equipment.clear()
	State.select_expedition("old_road")
	State.start_run(36)
	State.add_item("healing_potion", 2)
	State.run_heroes["warden"]["hp"] = 12
	change_scene_to_file("res://scenes/expedition/dungeon.tscn")
	await settle()
	var controls := root.get_node("GameControls")
	assert(not controls.is_modal_open())
	press(controls, KEY_I)
	assert(controls.overlay != null and controls.input_blocked())
	assert(controls.context_name() == "EXPEDITION")
	var guide_text := str(controls.guide_sections())
	assert(guide_text.contains("A / ←") and guide_text.contains("D / →") and guide_text.contains("RIGHT-CLICK") and guide_text.contains("TAB"))
	var settings := root.get_node("GameSettings")
	await native_key(KEY_F10)
	assert(settings.overlay != null and not controls.is_modal_open(), "Native F10 opens settings from the controls guide")
	await native_key(KEY_F10)
	assert(settings.overlay == null)
	press(controls, KEY_I)
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("C:/GAME/Ashen/controls-guide-preview.png")
	press(controls, KEY_I)
	assert(not controls.is_modal_open())
	await settle()
	var party_card: Control = current_scene.get_node("Party_warden")
	assert(controls.hero_from_control(party_card) == "warden", "Right-click resolves the hero from a party card")
	if DisplayServer.get_name() != "headless":
		var motion := InputEventMouseMotion.new()
		motion.position = party_card.get_global_rect().get_center()
		motion.global_position = motion.position
		root.push_input(motion, true)
		await settle()
		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_RIGHT
		click.position = motion.position
		click.global_position = motion.position
		click.pressed = true
		root.push_input(click, true)
		await settle()
		assert(controls.hero_sheet != null, "Native right-click opens the party hero sheet")
	else: controls.open_hero_sheet(controls.hero_from_control(party_card))
	assert(controls.current_hero == "warden" and controls.hero_sheet.hero_state()["hp"] == 12)
	await native_key(KEY_F10)
	assert(settings.overlay != null and not controls.is_modal_open(), "Native F10 opens settings from the character sheet")
	await native_key(KEY_F10)
	assert(settings.overlay == null)
	press(controls, KEY_C)
	assert(controls.hero_sheet != null and controls.hero_sheet.hero_id == "warden")
	if DisplayServer.get_name() != "headless":
		await settle()
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("C:/GAME/Ashen/character-record-preview.png")
	press(controls, KEY_E)
	assert(controls.current_hero == "ranger" and controls.hero_sheet.hero_id == "ranger")
	press(controls, KEY_Q)
	assert(controls.current_hero == "warden")
	press(controls, KEY_Q)
	assert(controls.current_hero == "occultist", "Cycling wraps through the party")
	press(controls, KEY_ESCAPE)
	assert(not controls.is_modal_open())
	press(controls, KEY_TAB)
	assert(controls.hero_sheet.inventory_mode)
	controls.hero_sheet.select_hero("warden")
	controls.hero_sheet.choose_item("healing_potion")
	assert(State.inventory["healing_potion"] == 1 and State.run_heroes["warden"]["hp"] == 32)
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("C:/GAME/Ashen/hero-sheet-preview.png")
	press(controls, KEY_TAB)
	assert(not controls.is_modal_open())
	await settle()
	var hp_visible: bool = false
	for label in current_scene.find_children("*", "Label", true, false):
		if label.text.contains("HP 32 / "): hp_visible = true
	assert(hp_visible and current_scene.get_node("Party_warden").text.contains("HP 32"), "Closing the sheet refreshes selected hero and party health in the room HUD")
	var editing := LineEdit.new()
	current_scene.add_child(editing)
	editing.grab_focus()
	await settle()
	press(controls, KEY_I)
	press(controls, KEY_C)
	press(controls, KEY_TAB)
	assert(not controls.is_modal_open(), "Typing I/C/Tab in a text field never opens gameplay overlays")
	editing.release_focus()
	editing.queue_free()
	press(controls, KEY_C)
	assert(controls.hero_sheet != null)
	root.get_node("GameSettings").open_settings()
	assert(not controls.is_modal_open() and controls.input_blocked(), "Settings replaces the character sheet")
	root.get_node("GameSettings").close_settings()
	current_scene.traveling = true
	assert(not root.get_node("GameSettings").safe_to_save(), "An unfinished hallway cannot be saved")
	current_scene.traveling = false
	change_scene_to_file("res://scenes/combat/combatscene.tscn")
	await settle()
	controls.open_hero_sheet("warden")
	var remaining: int = int(State.inventory["healing_potion"])
	controls.hero_sheet.choose_item("healing_potion")
	assert(State.inventory["healing_potion"] == remaining, "The sheet cannot bypass combat consumable AP")
	assert(controls.hero_sheet.hero_state()["hp"] == current_scene.hero_state["warden"]["hp"])
	assert(str(controls.guide_sections()).contains("ENTER"))
	if DisplayServer.get_name() != "headless":
		for id in ["ranger", "occultist", "healer", "crusader"]:
			controls.open_hero_sheet(id)
			await settle()
			assert(controls.hero_sheet.get_node("HeroBackdrop").size == Vector2(386, 616))
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("C:/GAME/Ashen/character-record-%s-preview.png" % id)
	controls.close_hero_sheet()
	State.end_run()
	change_scene_to_file("res://scenes/hub/barracks.tscn")
	await settle()
	var roster: Node = current_scene.get_node("Roster")
	var card: Control = roster.get_child(1).get_child(0)
	assert(not controls.hero_from_control(card).is_empty(), "Roster portraits resolve for right-click without changing party selection")
	print("PASS: I contextual guide, native F10 across modals, hero right-click resolution, Q/E wrapping, C/Tab panels, text focus, combat consumable safety and travel save gate")
	quit()
