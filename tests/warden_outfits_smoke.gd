extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://warden-outfit-test.cfg"
	Saves.directory = "user://warden-outfit-saves/"
	State.completed_expeditions.assign(["restore_workshop"])
	State.hero_outfits.clear()
	State.equipment.clear()
	assert(not State.customize_hero("warden","","original","ashen_wolf"),"Boss set remains locked")
	State.select_expedition("old_road")
	State.start_run(58)
	State.floor_index = 2
	for location in State.floors[2]:
		if State.floors[2][location].kind == "boss": State.room_position = location
	State.finish_encounter()
	assert(State.completed_expeditions.has("old_road"))
	assert(State.customize_hero("warden","","original","ashen_wolf"),"Final boss unlocks the complete cosmetic set")
	assert(not State.customize_hero("ranger","","original","ashen_wolf"))
	var health: int = State.hero_max_hp("warden")
	State.add_item("warden_relic_armor")
	State.equip_item("warden","warden_relic_armor")
	assert(State.hero("warden").equipment_look == "ashen_wolf","Equipped stat armor cannot replace a selected reward cosmetic")
	var idle: Texture2D = load(State.hero("warden").art)
	assert(idle.get_meta("appearance_style") == "warden_complete")
	var attack: Texture2D = preload("res://scripts/combat_poses.gd").state_pose(idle,"attack")
	assert(attack.get_meta("warden_outfit") == "ashen_wolf")
	assert(attack != idle)
	assert(Saves.save(1))
	State.hero_outfits.clear()
	State.completed_expeditions.clear()
	assert(Saves.load_slot(1))
	assert(State.hero_outfits.warden == "ashen_wolf" and State.completed_expeditions.has("old_road"))
	assert(State.hero_max_hp("warden") >= health,"Cosmetic selection does not remove stat equipment")
	State.finish_encounter() # Repeated completion after legendary-loot reveal.
	State.end_run()
	assert(State.last_report.get("cosmetic_reward", "") == "Ashen Wolf")
	State.start_run(58)
	var travel = load("res://scenes/expedition/hallway_travel.gd").new()
	root.add_child(travel)
	await process_frame
	assert(travel.walk_frames.warden.size() == 10)
	for frame in travel.walk_frames.warden:
		assert(frame.get_meta("warden_outfit") == "ashen_wolf")
		assert(frame.get_meta("travel_unarmed",false))
	travel.set_process(false)
	var settings = root.get_node("GameSettings")
	settings.ambient_motion = true
	travel.set_walking(true)
	var clock: float = travel.warden_clock
	travel._process(0.084)
	assert(travel.warden_clock > clock, "Moving advances the painted stride")
	for left in [false,true]:
		travel.facing_left = left
		for phase in range(10):
			travel.warden_clock = (phase+0.1)*0.084
			travel.update_walkers()
			for picture in travel.walkers:
				if picture.get_meta("walker") != "warden": continue
				var anchor: float = picture.texture.get_meta("stride_anchor")
				if left: anchor = 1.0-anchor
				var index: int = travel.walkers.find(picture)
				assert(absf(picture.position.x+picture.size.x*anchor-travel.bases[index].x) < 0.01,"Body anchor remains steady in both directions")
	travel.set_walking(false)
	clock = travel.warden_clock
	travel._process(0.2)
	assert(travel.warden_clock == clock, "Stopped stride freezes")
	settings.ambient_motion = false
	travel.set_walking(true)
	travel._process(0.2)
	assert(travel.warden_clock == clock, "Reduced motion freezes stride")
	settings.ambient_motion = true
	var fighter := TextureRect.new()
	fighter.texture = idle
	fighter.size = Vector2(380,400)
	root.add_child(fighter)
	preload("res://scripts/warden_idle_motion.gd").attach(fighter)
	var motion = fighter.get_node("WardenIdleMotion")
	motion.set_process(false)
	motion._process(0.9)
	assert(fighter.scale.y > 1.0 and fighter.scale.y <= 1.0031)
	assert(fighter.pivot_offset.y == 400, "Breathing keeps feet planted")
	fighter.texture = preload("res://scripts/combat_poses.gd").state_pose(idle,"attack")
	motion._process(0.1)
	assert(fighter.scale.y == 1.0, "Attack pose does not breathe")
	fighter.queue_free()
	for outfit in ["original","ashen_wolf"]:
		var catalog = preload("res://scripts/warden_outfits.gd")
		for index in range(2,12):
			var scaled_height: float = (catalog.GROUNDS[outfit][index]-catalog.HEAD_TOPS[outfit][index])*catalog.frame(outfit,index).get_meta("stride_scale")
			assert(absf(scaled_height-(catalog.GROUNDS[outfit][0]-catalog.HEAD_TOPS[outfit][0])) < 0.01,"Stride preserves approved body scale")
	for outfit in ["original","ashen_wolf"]:
		for frame in preload("res://scripts/warden_outfits.gd").walks(outfit):
			assert(frame.has_meta("stride_anchor"),"Walking frames need a body anchor, not rectangle centering")
	var screen = load("res://scenes/hub/customization.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	screen.change_outfit("original")
	assert(State.hero_outfits.warden == "ashen_wolf", "Preview does not equip draft")
	screen.change_outfit("ashen_wolf")
	screen.change_portrait("bust")
	assert(screen.preview.texture.get_meta("warden_outfit") == "ashen_wolf")
	assert(screen.portrait_preview.texture.get_meta("warden_outfit") == "ashen_wolf")
	assert(screen.portrait_preview.texture.get_meta("portrait_view"))
	assert(not screen.outfit_locked("ashen_wolf"))
	State.completed_expeditions.erase("old_road")
	assert(screen.outfit_locked("ashen_wolf"))
	assert(State.hero("warden").equipment_look != "ashen_wolf", "Incomplete saves cannot grant reward art")
	screen.queue_free()
	travel.queue_free()
	await process_frame
	print("PASS: Warden boss unlock, manual cosmetic priority, armed poses, save reload and ten unarmed travel frames")
	quit()
