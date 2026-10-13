extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Gear = preload("res://scripts/equipment_art.gd")
const Poses = preload("res://scripts/combat_poses.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://equipment-costumes.cfg"
	Saves.directory = "user://equipment-costume-saves/"
	State.equipment.clear()
	State.inventory.clear()
	State.equipment_appearance = true
	State.select_expedition("old_road")
	State.start_run(17)
	var rng: int = State.loot_rng.state
	var armor_count: int = 0
	for hero in State.HEROES:
		var choices: Array = []
		for id in State.Items.EQUIPMENT:
			var entry: Dictionary = State.Items.item(id)
			if entry.get("hero","") == hero and entry.get("slot","") == "armor": choices.append(id)
		assert(choices.size() == 3)
		armor_count += choices.size()
		assert(Gear.available(hero))
		for index in range(12):
			var image: Texture2D = Gear.frame(hero,index)
			assert(image.get_width() > 50 and image.get_height() > 50)
			assert(not image.get_image().get_used_rect().size == Vector2i.ZERO)
		State.party.assign([hero,"ranger" if hero != "ranger" else "warden","occultist" if hero != "occultist" else "healer"])
		State.hero_outfits[hero] = "alternate"
		for id in choices:
			State.add_item(id)
			assert(State.equip_item(hero,id))
			var look: String = str(State.Items.item(id).equipment_look)
			assert(State.hero(hero).equipment_look == look)
			assert(ResourceLoader.exists(State.hero(hero).art) and ResourceLoader.exists(State.hero(hero).camp_art))
			var wrong: String = "warden" if hero != "warden" else "ranger"
			State.add_item(id)
			assert(not State.equip_item(wrong,id))
			if look == "relic":
				var idle: Texture2D = load(State.hero(hero).art)
				assert(idle.get_meta("appearance_style") == "equipment")
				for pose in ["idle","attack","hurt","guard","cast","windup"]:
					assert(Poses.state_pose(idle,pose).get_meta("appearance_style") == "equipment")
				State.hero_portraits[hero] = "bust"
				assert(load(State.hero(hero).portrait_art).get_meta("portrait_view",false))
				var camp: Texture2D = load(State.hero(hero).camp_art)
				assert(camp.atlas == idle.atlas)
			State.unequip_item(hero,"armor")
		assert(State.hero(hero).equipment_look == "alternate")
	assert(armor_count == 15 and State.loot_rng.state == rng)
	State.party.assign(["warden","ranger","occultist"])
	State.add_item("warden_relic_armor")
	State.equip_item("warden","warden_relic_armor")
	var health: int = State.hero_max_hp("warden")
	State.equipment_appearance = false
	assert(State.hero("warden").equipment_look == "alternate" and State.hero_max_hp("warden") == health)
	assert(Saves.save(1))
	State.equipment_appearance = true
	assert(Saves.load_slot(1) and not State.equipment_appearance)
	State.equipment_appearance = true
	var travel = load("res://scenes/expedition/hallway_travel.gd").new()
	root.add_child(travel)
	await process_frame
	assert(travel.walk_frames.warden.size() == 4)
	assert(travel.walk_frames.warden[0].get_meta("appearance_style") == "equipment")
	State.equip_item("warden","warden_armor")
	travel.update_walkers()
	assert(travel.walk_frames.warden[0].get_meta("appearance_style") == "warden_complete")
	State.equip_item("warden","warden_relic_armor")
	travel.update_walkers()
	assert(travel.walk_frames.warden[0].get_meta("appearance_style") == "equipment")
	travel.queue_free()
	for i in range(3): await process_frame
	var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(dungeon)
	await process_frame
	var route := Control.new()
	route.name = "PreservedPassage"
	dungeon.add_child(route)
	dungeon.traveling = true
	var location: Vector2i = State.room_position
	dungeon.refresh()
	assert(dungeon.has_node("PreservedPassage") and State.room_position == location)
	dungeon.queue_free()
	for i in range(3): await process_frame
	print("PASS: 15 class armour entries, five full equipment pose sets, masks/portraits/camp, class restrictions, costume priority, saved opt-out, unchanged stats/RNG and equipped walking")
	quit()
