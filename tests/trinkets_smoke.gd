extends SceneTree
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	State.select_expedition("old_road")
	State.start_run(20)
	State.add_item("vitality_locket")
	assert(State.equip_item("warden", "vitality_locket"))
	assert(State.hero_max_hp("warden") == 60)
	State.add_item("warden_relic")
	assert(not State.equip_item("ranger", "warden_relic"))
	assert(State.equip_item("warden", "warden_relic"))
	assert(State.hero_max_hp("warden") == 71)
	var statuses: Dictionary = {}
	assert(not State.try_hero_status("warden", statuses, "burn", 1.0, 0.0))
	assert(statuses.is_empty())
	assert(State.try_hero_status("warden", statuses, "burn", 1.0, 99.0))
	State.add_item("clotting_seal")
	State.equip_item("ranger", "clotting_seal")
	statuses.clear()
	assert(not State.try_hero_status("ranger", statuses, "bleed", 1.0, 20.0))
	assert(State.try_hero_status("ranger", statuses, "burn", 1.0, 20.0))
	State.add_item("ranger_sight")
	State.equip_item("ranger", "ranger_sight")
	assert(State.hero_accuracy("ranger", {"statuses": {"chill": {}}, "resolve_type": "affliction"}) == 95.0)
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	await process_frame
	assert(combat._attack_damage("ranger", {"damage": 20}) == 24)
	State.formation["ranger"] = "front"
	assert(combat._attack_damage("ranger", {"damage": 20}) == 23)
	combat.queue_free()
	await process_frame
	var rng := RandomNumberGenerator.new()
	rng.seed = 200
	var universal_found: bool = false
	for index in range(1000):
		var id: String = State.Items.roll_equipment(rng, State.party)
		var item: Dictionary = State.Items.item(id)
		universal_found = universal_found or not item.has("hero")
		assert(not item.has("hero") or State.party.has(item["hero"]))
		id = State.Items.roll_equipment(rng, State.party, true)
		assert(State.Items.item(id)["rarity"] == "legendary" and State.party.has(State.Items.item(id)["hero"]))
	assert(universal_found)
	State.gold = 1000
	assert(State.purchase_item("warding_eye"))
	assert(not State.purchase_item("warden_relic"))
	for id in State.Items.EQUIPMENT:
		if State.Items.item(id).get("kind", "") == "trinket":
			assert(ResourceLoader.exists(State.Items.icon_path(id)))
	print("PASS: universal and class trinkets, health stacking, damage, accuracy, status resistance, loot pools and merchant legendary exclusion")
	quit()
