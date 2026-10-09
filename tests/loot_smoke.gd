extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Items = preload("res://scripts/item_data.gd")

func _initialize() -> void:
	call_deferred("run_tests")

func run_tests() -> void:
	State.inventory.clear()
	State.equipment.clear()
	State.gold = 5
	assert(not State.purchase_scroll("fire_bolt_scroll"))
	State.gold = 18
	assert(State.purchase_scroll("fire_bolt_scroll"))
	assert(State.gold == 12 and State.inventory["fire_bolt_scroll"] == 1)
	assert(State.purchase_scroll("lightning_bolt_scroll"))
	assert(State.gold == 0)
	assert(not State.purchase_scroll("warden_sword"))
	assert(State.consume_scroll("fire_bolt_scroll"))
	assert(not State.consume_scroll("fire_bolt_scroll"))
	State.add_item("warden_sword")
	assert(not State.equip_item("ranger", "warden_sword"))
	assert(State.equip_item("warden", "warden_sword"))
	assert(State.equipment_bonus("warden", "damage") == 1)
	State.add_item("warden_legend")
	assert(State.equip_item("warden", "warden_legend"))
	assert(State.inventory["warden_sword"] == 1)
	assert(State.equipment_bonus("warden", "damage") == 4)
	assert(State.hero_max_hp("warden") == 63)
	State.unequip_item("warden", "weapon")
	assert(State.hero_max_hp("warden") == 55)
	assert(State.select_expedition("old_road"))
	var counts: Dictionary = {"common": 0, "rare": 0, "epic": 0, "legendary": 0}
	var rng := RandomNumberGenerator.new()
	rng.seed = 123
	for trial in range(10000):
		counts[Items.roll_rarity(rng)] += 1
	assert(abs(int(counts["common"]) - 6000) < 250)
	assert(abs(int(counts["rare"]) - 2500) < 200)
	assert(abs(int(counts["epic"]) - 1000) < 150)
	assert(abs(int(counts["legendary"]) - 500) < 100)
	var scroll_drops: int = 0
	for trial in range(2000):
		State.start_run(trial)
		State.room_position = Vector2i(4, 3)
		State.floor_index = State.floor_count - 1
		var loot: Array[String] = State.claim_room_loot()
		assert(not loot.is_empty())
		var gear: Dictionary = Items.item(loot[0])
		assert(gear["rarity"] == "legendary" and State.party.has(gear["hero"]))
		if loot.size() > 1:
			scroll_drops += 1
		assert(State.claim_room_loot().is_empty())
	assert(abs(scroll_drops - 300) < 75)
	State.inventory.clear()
	State.equipment.clear()
	State.start_run(123)
	State.add_item("lightning_bolt_scroll")
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	battle.enemy_block = 100
	var hp_before: int = battle.enemy_hp
	battle._use_scroll("lightning_bolt_scroll")
	assert(battle.enemy_hp == hp_before - 18)
	assert(battle.hero_state["warden"]["ap"] == 1)
	assert(not State.inventory.has("lightning_bolt_scroll"))
	battle._use_scroll("lightning_bolt_scroll")
	assert(battle.hero_state["warden"]["ap"] == 1)
	State.add_item("fire_bolt_scroll")
	battle._select_hero("ranger")
	battle._use_scroll("fire_bolt_scroll")
	assert(battle.hero_state["ranger"]["ap"] == 1)
	assert(battle.enemy_hp == hp_before - 18)
	battle.queue_free()
	await process_frame
	State.add_item("warden_legend")
	State.add_item("fire_bolt_scroll")
	var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(dungeon)
	await process_frame
	dungeon.inspect_hero("warden")
	await process_frame
	dungeon.equip_from_inventory("warden", "warden_legend")
	await process_frame
	assert(State.equipment_bonus("warden", "damage") == 4)
	dungeon.close_inspection()
	await process_frame
	dungeon.queue_free()
	await process_frame
	var shop = load("res://scenes/hub/item_shop.tscn").instantiate()
	root.add_child(shop)
	await process_frame
	shop.queue_free()
	await process_frame
	print("PASS: rarity distribution, 15% scroll drops, 2000 guaranteed boss legendaries, no duplicate rewards, class restrictions, equipment, shopping, universal single-use spells, inventory UI")
	quit()
