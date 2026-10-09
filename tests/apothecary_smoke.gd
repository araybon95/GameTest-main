extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://apothecary_test_progress.cfg"
	State.completed_expeditions.clear()
	State.gold = 500
	State.inventory.clear()
	assert(not State.apothecary_unlocked())
	assert(not State.purchase_apothecary_item("healing_potion"))
	assert(not State.purchase_item("might_tonic"))
	var locked_building = load("res://scenes/hub/apothecary.tscn").instantiate()
	root.add_child(locked_building)
	await process_frame
	assert(not locked_building.apothecary_mode)
	locked_building.queue_free()
	await process_frame
	assert(State.select_expedition("infested_apothecary"))
	for seed_id in range(100):
		State.start_run(seed_id)
		assert(State.floor_count == 1 and State.floors[0].size() == 4)
		assert(State.floors[0][Vector2i.ZERO]["enemies"].size() == 3)
		assert(State.floors[0][Vector2i(1, 0)]["kind"] == "camp")
		assert(not State.vote_move("local", Vector2i(1, 0)))
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	assert(battle.enemies.size() == 3)
	for enemy in battle.enemies:
		assert(enemy["hp"] == 27 and enemy["attack"] == 4)
		assert(enemy["moves"].size() == 3)
		assert(enemy["art"].ends_with("enemy_moth_metamorph.png"))
	State.add_item("healing_scroll", 2)
	battle.hero_state["warden"]["hp"] = 5
	var enemy_hp: int = battle.enemy_hp
	battle._use_scroll("healing_scroll")
	assert(battle.hero_state["warden"]["hp"] == 35 and battle.hero_state["warden"]["ap"] == 1)
	assert(battle.enemy_hp == enemy_hp and State.inventory["healing_scroll"] == 1)
	State.run_heroes = battle.hero_state.duplicate(true)
	battle.queue_free()
	await process_frame
	State.finish_encounter()
	assert(not State.apothecary_unlocked())
	assert(State.vote_move("local", Vector2i(1, 0)))
	State.run_heroes["warden"]["stress"] = 80
	Rules.apply_status(State.run_heroes["warden"]["statuses"], "poison")
	assert(State.rest_at_camp())
	assert(State.run_heroes["warden"]["hp"] == State.hero_max_hp("warden"))
	assert(State.run_heroes["warden"]["stress"] == 8 and State.run_heroes["warden"]["statuses"].is_empty())
	assert(not State.rest_at_camp())
	assert(State.vote_move("local", Vector2i(2, 0)))
	State.finish_encounter()
	assert(not State.run_complete and not State.apothecary_unlocked())
	assert(State.vote_move("local", Vector2i(3, 0)))
	State.finish_encounter()
	assert(State.run_complete and State.apothecary_unlocked())
	State.completed_expeditions.clear()
	State.progress_loaded = false
	State.load_progression()
	assert(State.apothecary_unlocked(), "Unlock survives progression reload")
	for item_id in State.APOTHECARY_CATALOG:
		assert(State.Items.item(item_id)["rarity"] != "legendary")
		assert(State.purchase_apothecary_item(item_id))
	assert(not State.purchase_apothecary_item("warden_sword"))
	State.gold = 0
	assert(not State.purchase_apothecary_item("healing_potion"))
	State.add_item("might_tonic", 3)
	assert(State.apply_potion("warden", "might_tonic", State.run_heroes))
	assert(State.apply_potion("warden", "might_tonic", State.run_heroes))
	assert(State.buff_bonus(State.run_heroes["warden"], "might") == 20)
	State.tick_buffs(State.run_heroes["warden"])
	assert(State.buff_bonus(State.run_heroes["warden"], "might") == 20)
	State.tick_buffs(State.run_heroes["warden"])
	assert(State.buff_bonus(State.run_heroes["warden"], "might") == 0)
	State.add_item("focus_tonic")
	Rules.apply_status(State.run_heroes["warden"]["statuses"], "chill")
	assert(State.hero_accuracy("warden", State.run_heroes["warden"]) == 90)
	assert(State.apply_potion("warden", "focus_tonic", State.run_heroes))
	assert(State.hero_accuracy("warden", State.run_heroes["warden"]) == 100)
	State.add_item("might_tonic")
	State.add_item("ward_tonic", 2)
	battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	var base_damage: int = battle._attack_damage("warden", {"damage": 10})
	battle._use_scroll("might_tonic")
	assert(battle._attack_damage("warden", {"damage": 10}) > base_damage)
	battle._use_scroll("ward_tonic")
	assert(battle.hero_state["warden"]["block"] == 4)
	assert(battle.hero_state["warden"]["ap"] == 0)
	State.tick_buffs(battle.hero_state["warden"])
	assert(State.buff_bonus(battle.hero_state["warden"], "ward") == 4)
	State.tick_buffs(battle.hero_state["warden"])
	assert(State.buff_bonus(battle.hero_state["warden"], "ward") == 0)
	battle.queue_free()
	await process_frame
	State.end_run()
	var shop = load("res://scenes/hub/apothecary.tscn").instantiate()
	root.add_child(shop)
	await process_frame
	assert(shop.apothecary_mode)
	assert(shop.get_node("ShopBackground").texture.resource_path.ends_with("apothecary_reclaimed.png"))
	shop.queue_free()
	await process_frame
	print("PASS: 100 four-room seeds, 3 weakened acolytes, camp, ordered victories, persistent unlock, shop restrictions, healing scroll/AP, refreshing buffs and expiry")
	quit()
