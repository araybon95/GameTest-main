extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
const Accents = preload("res://scripts/equipment_accents.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://legacies-test.cfg"
	Saves.directory = "user://legacies-saves/"
	State.inventory.clear()
	State.equipment.clear()
	State.Items.histories.clear()
	State.Items.favourites.clear()
	State.completed_expeditions.clear()
	State.hero_journals.clear()
	State.party.assign(["warden","ranger","occultist"])
	State.select_expedition("old_road")
	State.start_run(54)
	State.gold = 300
	State.add_item("warden_sword",2)
	assert(State.ItemStories.transform(State,"warden_sword","restored").is_empty())
	State.completed_expeditions.append(State.Mechanics.SERVICES.workshop.quest)
	State.Items.favourites.warden_sword = true
	var rng: int = State.loot_rng.state
	var id: String = State.ItemStories.transform(State,"warden_sword","restored")
	assert(not id.is_empty() and State.inventory.warden_sword == 1 and State.inventory[id] == 1)
	assert(State.Items.favourites[id] and State.gold == 225)
	assert(State.Items.item(id).max_hp == 4 and not State.Items.item("warden_sword").has("max_hp"))
	assert(State.ItemStories.transform(State,id,"corrupted").is_empty() and State.gold == 225)
	assert(State.equip_item("warden",id))
	var hp: int = State.run_heroes.warden.hp
	var block: int = State.equipment_bonus("warden","block")
	State.add_item("warden_shield")
	State.equip_item("warden","warden_shield")
	var shield: String = State.ItemStories.transform(State,"warden_shield","consecrated")
	assert(State.equipment_bonus("warden","debuff_resist") == 10)
	State.add_item("ranger_bow")
	State.equip_item("ranger","ranger_bow")
	var bow: String = State.ItemStories.transform(State,"ranger_bow","corrupted")
	assert(State.equipment_bonus("ranger","damage_percent") == 8 and State.equipment_bonus("ranger","curse_stress") == 1)
	assert(State.Items.tooltip(bow).contains("+1 Stress"))
	assert(State.run_heroes.warden.hp == hp)
	for i in range(3):
		State.run_id = "run%d" % i
		State.ItemStories.guardian(State,"warden","A guardian")
	assert(State.Items.histories[id].victories.size() == 3 and State.Items.histories[id].has("milestone"))
	State.ItemStories.guardian(State,"warden","A guardian")
	assert(State.Items.histories[id].victories.size() == 3)
	assert(Accents.profile(id).etched and Accents.profile(bow).pattern == 3)
	assert(Accents.profile("ranger_venombow").colour != Accents.profile("warden_frostblade").colour)
	assert(State.loot_rng.state == rng)
	assert(Saves.save(1))
	State.Items.histories.clear()
	assert(Saves.load_slot(1))
	assert(State.Items.histories[id].transformation == "restored")
	var page = load("res://scenes/hub/keepsakes.tscn").instantiate()
	page.selected_item = id
	root.add_child(page)
	await process_frame
	assert(page.has_node("EquipmentPreview") and page.has_node("KeepsakeHistory"))
	assert(page.get_node("EquipmentPreview").has_node("EquipmentAccents"))
	assert(page.get_node("Transform_corrupted").disabled)
	page.toggle_filter()
	assert(page.owned_gear().has(id))
	State.Items.histories[id]["owners"] = ["Alden"]
	assert(State.ItemStories.equipped_line(State,"warden",id).contains("Alden"))
	assert(State.Stories.biography(State,"warden").contains("heirloom of Alden"))
	page.queue_free()
	for i in range(3): await process_frame
	print("PASS: workshop gate/cost, one-copy transformations, balanced stats and curse, no free healing, saved identity, cosmetic milestones/RNG, accent profiles, keepsake display and inheritance reaction")
	quit()
