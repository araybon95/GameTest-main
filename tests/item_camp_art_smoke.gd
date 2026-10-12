extends SceneTree
const State = preload("res://scripts/game_data.gd")
const CampArt = preload("res://scripts/camp_art.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	var original_rng := State.loot_rng.state
	var ids: Array = State.Items.SCROLLS.keys()+State.Items.POTIONS.keys()+State.Items.PROVISIONS.keys()+State.Items.EQUIPMENT.keys()
	assert(ids.size() == 87)
	var regions: Dictionary = {}
	for id in ids:
		var path: String = State.Items.icon_path(id)
		assert(path.begins_with("res://assets/art_library/items/") and path.ends_with(".tres"))
		var texture: AtlasTexture = load(path)
		assert(texture != null and texture.get_size() == Vector2(256,256))
		assert(Rect2(Vector2.ZERO,texture.atlas.get_size()).encloses(texture.region))
		var key: String = texture.atlas.resource_path+str(texture.region)
		assert(not regions.has(key),"Every item has its own illustration")
		regions[key] = true
	State.Items.histories["art_test_heirloom"] = {"base":"healing_potion","name":"Handed-down medicine"}
	assert(State.Items.icon_path("art_test_heirloom") == State.Items.icon_path("healing_potion"))
	State.Items.histories.erase("art_test_heirloom")
	# Existing PNG/atlas pair exercises PNG priority without writing to product assets.
	State.Items.histories["art_test_override"] = {"base":"../generated/hero_ranger"}
	assert(State.Items.icon_path("art_test_override").ends_with("hero_ranger.png"))
	State.Items.histories.erase("art_test_override")
	assert(CampArt.path_for("../generated/hero_ranger").ends_with("hero_ranger.png"))
	for id in ["watch","ward","sharpen","scout","rest"]:
		assert(CampArt.texture_for(id).get_size() == Vector2(256,256))
	assert(State.loot_rng.state == original_rng)
	State.select_expedition("old_road")
	State.start_run(42)
	for location in State.floors[0]:
		if State.floors[0][location].kind == "camp": State.room_position = location; break
	State.run_heroes.warden.hp = 7
	State.run_heroes.warden.stress = 80
	var camp = load("res://scenes/expedition/camp.tscn").instantiate()
	root.add_child(camp)
	for id in State.Depth.CAMP_CHOICES:
		var card: Button = camp.get_node("CampSkill_"+id)
		assert(card.disabled and card.get_node("CampIcon").texture != null)
		assert(card.get_node("CampIcon").mouse_filter == Control.MOUSE_FILTER_IGNORE)
	camp.get_node("RestButton").pressed.emit()
	assert(State.run_heroes.warden.hp == State.hero_max_hp("warden"))
	assert(State.run_heroes.warden.stress == 8)
	assert(camp.get_node("RestButton").disabled)
	for id in State.Depth.CAMP_CHOICES: assert(not camp.get_node("CampSkill_"+id).disabled)
	camp.get_node("CampSkill_watch").pressed.emit()
	assert(camp.get_node("CampSkill_watch").disabled)
	assert(State.floors[0][State.room_position].camp_points == 1)
	camp.get_node("CampSkill_ward").pressed.emit()
	assert(State.floors[0][State.room_position].camp_points == 0)
	assert(State.journey.boons.ward)
	for id in State.Depth.CAMP_CHOICES: assert(camp.get_node("CampSkill_"+id).disabled)
	assert(not State.Depth.camp_ambush(State))
	var sheet := preload("res://scenes/ui/hero_sheet.gd").new()
	root.add_child(sheet)
	for id in State.Depth.CAMP_CHOICES:
		assert(sheet.get_node("CampSkill_"+id).disabled)
		assert(sheet.get_node("CampSkill_"+id).get_node("CampIcon").texture != null)
	sheet.free()
	camp.free()
	await process_frame
	print("PASS: 87 unique item illustrations, PNG overrides/base IDs, five camp icons and actual rest/preparation button behavior")
	quit()
