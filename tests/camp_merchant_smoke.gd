extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
func _initialize() -> void:
	call_deferred("run_tests")
func run_tests() -> void:
	State.select_expedition("old_road")
	for seed_value in range(200):
		State.start_run(seed_value)
		for rooms in State.floors:
			var orbs: int = 0
			var camps: int = 0
			for room in rooms.values():
				if room.get("merchant_orb", false):
					orbs += 1
					assert(room["kind"] == "battle" and not room["cleared"])
				if room["kind"] == "camp":
					camps += 1
			assert(orbs == 1 and camps >= 1)
	State.start_run(42)
	assert(not State.rest_at_camp())
	assert(not State.merchant_orb_available())
	var campsite: Vector2i
	var orb_location: Vector2i
	for location in State.floors[0]:
		if State.floors[0][location]["kind"] == "camp":
			campsite = location
		if State.floors[0][location].get("merchant_orb", false):
			orb_location = location
	State.room_position = campsite
	State.add_item("warden_legend")
	assert(State.equip_item("warden", "warden_legend"))
	var hero: Dictionary = State.run_heroes["warden"]
	hero["hp"] = 0
	hero["stress"] = 99
	hero["deaths_door"] = true
	hero["damage_mod"] = -2
	hero["stress_per_turn"] = 3
	hero["resolved"] = true
	hero["resolve_tag"] = "Fearful"
	hero["resolve_type"] = "affliction"
	for effect in ["burn", "bleed", "poison", "chill"]:
		Rules.apply_status(hero["statuses"], effect)
	State.run_heroes["ranger"]["dead"] = true
	State.run_heroes["ranger"]["hp"] = 0
	assert(State.rest_at_camp())
	assert(hero["hp"] == 63 and hero["max_hp"] == 63)
	assert(hero["stress"] == 9 and hero["statuses"].is_empty())
	assert(not hero["deaths_door"] and hero["damage_mod"] == 0 and hero["stress_per_turn"] == 0)
	assert(not hero["resolved"] and hero["resolve_tag"] == "" and hero["resolve_type"] == "")
	assert(State.run_heroes["ranger"]["dead"] and State.run_heroes["ranger"]["hp"] == 0)
	hero["hp"] = 1
	assert(not State.rest_at_camp() and hero["hp"] == 1)
	var camp = load("res://scenes/expedition/camp.tscn").instantiate()
	root.add_child(camp)
	assert(camp.get_node("RestButton").disabled)
	camp.queue_free()
	await process_frame
	State.room_position = orb_location
	assert(not State.merchant_orb_available())
	State.finish_encounter()
	assert(State.merchant_orb_available())
	State.gold = 1000
	var original_position: Vector2i = State.room_position
	var original_hp: int = hero["hp"]
	var before: int = State.gold
	assert(State.purchase_item("warden_shield"))
	assert(State.gold == before - 18)
	assert(State.purchase_item("fire_bolt_scroll"))
	assert(not State.purchase_item("healer_mace"))
	assert(State.purchase_item("warden_epic"))
	assert(State.purchase_item("storm_lance_scroll"))
	for item_id in State.Items.EQUIPMENT.keys() + State.Items.SCROLLS.keys():
		if State.Items.item(item_id)["rarity"] == "legendary":
			assert(not State.purchase_item(item_id))
	assert(not State.purchase_scroll("sunfire_scroll"))
	assert(State.room_position == original_position and hero["hp"] == original_hp)
	State.gold = 0
	assert(not State.purchase_item("warden_sword"))
	State.floors[0][orb_location]["cleared"] = false
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	assert(battle.has_node("MerchantOrb") and battle.merchant_orb.disabled)
	while not battle._living_enemies().is_empty():
		battle._deal_enemy_damage(999)
	battle._check_battle_over()
	battle._refresh_all()
	assert(not battle.merchant_orb.disabled)
	current_scene = battle
	battle._enter_merchant_orb()
	await process_frame
	await process_frame
	var shop = current_scene
	assert(shop.scene_file_path == "res://scenes/hub/item_shop.tscn")
	assert(State.room_position == original_position and State.run_heroes["warden"]["hp"] == original_hp)
	for filter_name in ["All", "Weapons", "Armor", "Relics", "Scrolls"]:
		shop.set_category(filter_name)
	shop.return_to_party()
	await process_frame
	await process_frame
	assert(current_scene.scene_file_path == "res://scenes/expedition/dungeon.tscn")
	assert(State.room_position == original_position and State.run_heroes["warden"]["hp"] == original_hp)
	current_scene.queue_free()
	await process_frame
	print("PASS: 200 seeds, one orb/floor, guaranteed camps, full equipped-health recovery, debuff cleanse, 90% stress relief, no resurrection/repeated rest, post-victory orbs, gold purchases, legendary exclusion and position persistence")
	quit()
