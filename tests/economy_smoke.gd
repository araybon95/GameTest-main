extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")

func _initialize() -> void:
	call_deferred("run")

func unchanged(snapshot: Dictionary) -> void:
	assert(State.gold == snapshot["gold"])
	assert(State.inventory == snapshot["inventory"])
	assert(State.equipment == snapshot["equipment"])
	assert(State.journey == snapshot["journey"])

func money_snapshot() -> Dictionary:
	return {"gold": State.gold, "inventory": State.inventory.duplicate(true), "equipment": State.equipment.duplicate(true), "journey": State.journey.duplicate(true)}

func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://economy_progress.cfg"
	Saves.directory = "user://economy_saves/"
	State.party.assign(["warden", "ranger", "occultist"])
	State.hero_progress.clear()
	State.completed_expeditions.clear()
	State.inventory.clear()
	State.equipment.clear()
	assert(State.select_expedition("old_road"))
	State.start_run(20)
	State.gold = 1000
	var expected: Dictionary = {"common": 8, "rare": 40, "epic": 100, "unique": 150, "legendary": 200}
	for id in State.Items.EQUIPMENT:
		assert(State.item_price(id) == expected[State.Items.EQUIPMENT[id]["rarity"]])
		assert(State.item_sell_price(id) == int(floor(expected[State.Items.EQUIPMENT[id]["rarity"]] / 4.0)))
	for catalog in [State.Items.POTIONS, State.Items.SCROLLS, State.Items.PROVISIONS]:
		for id in catalog:
			assert(State.item_price(id) == int(catalog[id]["price"]))
	assert(State.item_price("unknown_item") == 0 and State.item_sell_price("unknown_item") == 0)
	assert(State.item_sell_price("trail_food") == 0 and State.item_sell_price("cleansing_herbs") == 0)
	assert(State.item_sell_price("lock_tools") == 1 and State.item_sell_price("fire_bolt_scroll") == 1)
	assert(State.item_sell_price("warden_frostblade") == 37)

	# A purchase preserves stock stacking and writes both money and inventory.
	State.inventory["healing_potion"] = 2
	assert(State.purchase_item("healing_potion"))
	assert(State.gold == 992 and State.inventory["healing_potion"] == 3)
	State.gold = 1
	State.inventory.clear()
	assert(Saves.load_slot(0))
	assert(State.gold == 992 and State.inventory["healing_potion"] == 3)
	var sale_journey: Dictionary = State.journey.duplicate(true)
	assert(State.sell_item("healing_potion"))
	assert(State.gold == 994 and State.inventory["healing_potion"] == 2)
	assert(State.journey == sale_journey)
	State.gold = 0
	State.inventory.clear()
	assert(Saves.load_slot(0))
	assert(State.gold == 994 and State.inventory["healing_potion"] == 2)

	# Equipped-only copies cannot be sold; a loose duplicate is independent.
	State.add_item("warden_shield")
	assert(State.equip_item("warden", "warden_shield"))
	var equipped: Dictionary = State.equipment.duplicate(true)
	var before: Dictionary = money_snapshot()
	assert(not State.sell_item("warden_shield"))
	unchanged(before)
	State.add_item("warden_shield")
	assert(State.sell_item("warden_shield"))
	assert(State.gold == int(before["gold"]) + 10 and not State.inventory.has("warden_shield"))
	assert(State.equipment == equipped)
	assert(Saves.load_slot(0))
	assert(State.equipment == equipped and not State.inventory.has("warden_shield"))

	# Junk from another class and loot-only legendary gear may be sold.
	State.add_item("healer_mace")
	State.add_item("warden_legend")
	before = money_snapshot()
	assert(State.sell_item("healer_mace") and State.sell_item("warden_legend"))
	assert(State.gold == int(before["gold"]) + 52)
	assert(not State.inventory.has("healer_mace") and not State.inventory.has("warden_legend"))
	before = money_snapshot()
	assert(not State.purchase_item("healer_mace"))
	for id in State.Items.EQUIPMENT.keys() + State.Items.SCROLLS.keys():
		if State.Items.item(id)["rarity"] == "legendary":
			assert(not State.purchase_item(id))
	assert(not State.purchase_scroll("sunfire_scroll"))
	unchanged(before)

	# Invalid requests and low-value provisions leave both currencies intact.
	State.inventory["unknown_item"] = 2
	State.inventory["warden_sword"] = 0
	State.inventory["ranger_bow"] = -2
	State.add_item("trail_food", 2)
	State.add_item("cleansing_herbs", 2)
	before = money_snapshot()
	for id in ["unknown_item", "warden_sword", "ranger_bow", "warden_epic", "trail_food", "cleansing_herbs"]:
		assert(not State.sell_item(id))
	assert(not State.purchase_item("unknown_item") and not State.purchase_scroll("warden_sword"))
	unchanged(before)
	State.inventory.erase("unknown_item")
	State.inventory.erase("warden_sword")
	State.inventory.erase("ranger_bow")
	State.gold = 39
	before = money_snapshot()
	assert(not State.purchase_item("warden_shield"))
	unchanged(before)

	# Every legal purchase-to-sale round trip loses gold, including cheap supplies.
	State.completed_expeditions.append("infested_apothecary")
	State.gold = 10000
	var world_before: Dictionary = {"floors": State.floors.duplicate(true), "heroes": State.run_heroes.duplicate(true), "position": State.room_position, "progress": State.hero_progress.duplicate(true), "completed": State.completed_expeditions.duplicate(), "deeds": State.run_deeds.duplicate(true)}
	for id in State.Items.EQUIPMENT.keys() + State.Items.POTIONS.keys() + State.Items.SCROLLS.keys() + State.Items.PROVISIONS.keys():
		var item: Dictionary = State.Items.item(id)
		if item["rarity"] == "legendary" or (item.has("hero") and not State.party.has(item["hero"])):
			continue
		var initial_gold: int = State.gold
		var initial_count: int = int(State.inventory.get(id, 0))
		assert(State.purchase_item(id))
		if State.item_sell_price(id) > 0:
			assert(State.sell_item(id))
			assert(int(State.inventory.get(id, 0)) == initial_count)
		else:
			assert(not State.sell_item(id))
			assert(int(State.inventory.get(id, 0)) == initial_count + 1)
		assert(State.gold < initial_gold)
	assert(State.floors == world_before["floors"] and State.run_heroes == world_before["heroes"])
	assert(State.room_position == world_before["position"] and State.hero_progress == world_before["progress"])
	assert(State.completed_expeditions == world_before["completed"] and State.run_deeds == world_before["deeds"])
	assert(State.journey["rations"] == 3)
	assert(not State.inventory.has("rations"))

	# Legacy scroll buying follows the same checkpoint and restriction contract.
	before = money_snapshot()
	assert(State.purchase_scroll("fire_bolt_scroll"))
	assert(State.gold == int(before["gold"]) - 6)
	assert(int(State.inventory["fire_bolt_scroll"]) == int(before["inventory"].get("fire_bolt_scroll", 0)) + 1)
	var persisted: Dictionary = money_snapshot()
	State.gold = 0
	State.inventory.clear()
	assert(Saves.load_slot(0))
	unchanged(persisted)

	# Failure to write a checkpoint must not partially apply a transaction.
	var blocked: String = "user://economy_blocked_directory"
	var blocker: FileAccess = FileAccess.open(blocked, FileAccess.WRITE)
	assert(blocker != null)
	blocker.store_string("This file deliberately prevents a directory at the same path.")
	blocker.close()
	Saves.directory = blocked + "/"
	before = money_snapshot()
	assert(not State.sell_item("healing_potion"))
	unchanged(before)
	assert(not State.purchase_item("warden_sword"))
	unchanged(before)
	Saves.directory = "user://economy_saves/"
	assert(DirAccess.remove_absolute(blocked) == OK)
	print("ECONOMY_SMOKE_PASS prices, inventory-only sales, checkpoints, rollback, restrictions, no arbitrage")
	quit()
