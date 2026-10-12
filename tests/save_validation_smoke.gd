extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
	for frame in range(3): await process_frame
func write_data(data: Dictionary, version: int = 1) -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("save","version",version)
	cfg.set_value("save","data",data)
	assert(cfg.save(Saves.path(2)) == OK)
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://save_validation_progress.cfg"
	Saves.directory = "user://save_validation/"
	State.party.assign(["warden","ranger","healer"])
	State.hero_progress.clear()
	State.equipment.clear()
	State.modifications = {"warden_sword":"keen"}
	State.Items.histories.clear()
	State.select_expedition("old_road")
	State.start_run(62)
	State.gold = 35
	State.run_heroes.warden.hp = 12
	State.add_item("warden_sword")
	assert(State.equip_item("warden","warden_sword"))
	assert(Saves.save(1))
	var valid: Dictionary = Saves.slot_info(1).data.duplicate(true)
	var rng: int = State.loot_rng.state
	assert(Saves.slot_info(1).loadable and Saves.slot_info(1).detail.contains("Healer Lv 1"))
	for mutation in ["party","floor","room","hero","inactive_hero","status","colors","equipment","progress","inventory","discovered","position"]:
		var invalid: Dictionary = valid.duplicate(true)
		match mutation:
			"party": invalid.party = ["warden","warden","healer"]
			"floor": invalid.floors[0] = []
			"room": invalid.floors[0][Vector2i.ZERO] = []
			"hero": invalid.heroes.warden = []
			"inactive_hero": invalid.active = false; invalid.heroes.warden = []
			"status": invalid.heroes.warden.statuses = {"bleed":{"turns":[]}}
			"colors": invalid.colors.warden = []
			"equipment": invalid.equipment.warden = []
			"progress": invalid.hero_progress.warden = []
			"inventory": invalid.inventory["healing_potion"] = []
			"discovered": invalid.discovered = [123]
			"position": invalid.position = "not a location"
		write_data(invalid)
		assert(not Saves.slot_info(2).loadable and not Saves.load_slot(2))
		assert(State.gold == 35 and State.run_heroes.warden.hp == 12 and State.equipment.warden.weapon == "warden_sword" and State.loot_rng.state == rng,"Rejected saves leave the active journey intact")
	write_data(valid,2)
	assert(Saves.slot_info(2).summary == "Unsupported save version" and not Saves.load_slot(2))
	var old: Dictionary = valid.duplicate(true)
	for key in ["hero_progress","hero_positions","journey","last_report","item_histories","item_favourites","hero_journals","hero_outfits","hero_portraits"]: old.erase(key)
	write_data(old)
	assert(Saves.load_slot(2),"Version-1 saves without later optional fields still load")
	assert(State.equipment.warden.weapon == "warden_sword" and State.modifications.warden_sword == "keen" and State.run_heroes.warden.hp == 12 and not State.journey.is_empty() and State.loot_rng.state == rng)
	change_scene_to_file("res://scenes/expedition/dungeon.tscn")
	await settle()
	var settings = root.get_node("GameSettings")
	settings.open_settings()
	assert(settings.safe_to_save() and not settings.overlay.get_node("SaveSlot1").disabled)
	var checkpoint_text: String = FileAccess.get_file_as_string(Saves.path(0))
	State.gold += 1
	settings.save_elapsed = 10
	settings.elapsed = 1
	settings._process(0.5)
	assert(FileAccess.get_file_as_string(Saves.path(0)) == checkpoint_text,"Opening saved-journey previews pauses autosave so AUTO cannot change under a load confirmation")
	State.gold -= 1
	settings.request_save(1)
	var confirmation = settings.overlay.get_node("SaveOverwriteConfirmation")
	assert(confirmation.dialog_text.contains("SLOT 1"))
	confirmation.canceled.emit()
	await settle()
	assert(Saves.slot_info(1).data == valid,"Canceling overwrite keeps the previous save")
	settings.close_settings()
	await settle()
	current_scene.traveling = true
	settings.open_settings()
	assert(settings.overlay.get_node("SaveSlot1").disabled and settings.overlay.get_node("SaveAvailability").text.contains("hallway"))
	settings.close_settings()
	current_scene.traveling = false
	write_data(valid,2)
	settings.open_settings()
	assert(settings.overlay.get_node("LoadSlot2").disabled)
	settings.close_settings()
	assert(settings.load_slot(1))
	await settle()
	assert(current_scene.scene_file_path.ends_with("dungeon.tscn") and State.run_heroes.warden.hp == 12 and State.equipment.warden.weapon == "warden_sword")
	print("PASS: save previews, transactional rejection, legacy optional fields, gear/HP/RNG roundtrip, overwrite cancellation, disabled corrupt loads and hallway save reason")
	quit()
