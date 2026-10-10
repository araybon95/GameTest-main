extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	for frame in range(3): await process_frame

func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://merchant_trade_progress.cfg"
	Saves.directory = "user://merchant_trade_saves/"
	State.party.assign(["warden","ranger","occultist"])
	State.hero_progress.clear()
	State.equipment.clear()
	State.inventory.clear()
	State.completed_expeditions.clear()
	assert(State.select_expedition("old_road"))
	State.start_run(42)
	for location in State.floors[0]:
		if State.floors[0][location].get("merchant_orb",false):
			State.room_position = location
			State.floors[0][location]["cleared"] = true
	assert(State.merchant_orb_available())
	State.inventory.clear()
	State.gold = 75
	State.run_heroes["warden"].merge({"hp":13,"stress":45,"statuses":{"bleed":{"turns":2,"damage":2}}},true)
	State.add_item("warden_sword")
	assert(State.equip_item("warden","warden_sword"))
	for entry in [["healing_potion",3],["warden_legend",1],["healer_mace",1],["outlaw_tally",2],["trail_food",2],["ranger_armor",1],["warden_shield",1]]:
		State.add_item(entry[0],entry[1])
	var party_before: Dictionary = State.run_heroes.duplicate(true)
	var equipment_before: Dictionary = State.equipment.duplicate(true)
	var position_before: Vector2i = State.room_position
	var orb = load("res://scenes/expedition/merchant_orb_room.tscn").instantiate()
	root.add_child(orb)
	current_scene = orb
	await settle()
	orb.get_node("MerchantOrbObject").pressed.emit()
	await settle()
	var shop = current_scene
	assert(shop.scene_file_path == "res://scenes/hub/item_shop.tscn")
	assert(State.shop_return_scene == "res://scenes/expedition/merchant_orb_room.tscn")
	assert(shop.has_node("TradeBuyTab") and shop.has_node("TradeSellTab") and shop.has_node("TradeSort"))
	var catalog: Array[String] = shop.catalog_items()
	assert(not catalog.has("warden_legend") and not catalog.has("healer_mace"),"Buying excludes legendary loot and other-party classes")
	assert(catalog.has("warden_sword") and catalog.has("outlaw_tally"))
	var buy_scroll: ScrollContainer = shop.get_node("TradeScroll")
	buy_scroll.scroll_vertical = 400
	await settle()
	var scroll_before: int = buy_scroll.scroll_vertical
	assert(scroll_before > 0)
	assert(shop.purchase("bandage"))
	await settle()
	assert(shop.get_node("TradeScroll").scroll_vertical == scroll_before,"Buying preserves a long catalog's scroll position")
	assert(State.consume_item("bandage"))
	State.gold = 75
	for category in shop.CATEGORIES:
		shop.set_category(category)
		for id in shop.catalog_items():
			assert(category == "All" or shop.item_category(State.Items.item(id)) == category)
	shop.set_category("Weapons")
	var buy_button: Button = shop.find_child("Buy_warden_sword",true,false)
	buy_button.pressed.emit()
	assert(State.gold == 67 and State.inventory.get("warden_sword",0) == 1)
	assert(shop.get_node("TradeStatus").text.contains("Purchased Iron Longsword for 8 gold"))
	shop.get_node("TradeSellTab").pressed.emit()
	assert(shop.is_selling() and shop.get_node("TradeSellTab").text.begins_with("•"))
	assert(shop.catalog_items().has("warden_legend") and shop.catalog_items().has("healer_mace"),"Other-class and legendary loose loot can be sold")
	assert(not shop.purchase("warden_sword"),"Buy callbacks cannot buy while the sell tab is active")
	shop.set_sort("Value")
	assert(shop.catalog_items()[0] == "warden_legend")
	shop.set_sort("Name")
	assert(shop.catalog_items() == ["warden_sword","warden_legend","healer_mace"])
	shop.set_sort("Rarity")
	assert(shop.catalog_items() == ["warden_sword","healer_mace","warden_legend"])
	var sale: Button = shop.find_child("Sell_warden_sword",true,false)
	sale.pressed.emit()
	assert(State.gold == 69 and not State.inventory.has("warden_sword"))
	assert(State.equipment == equipment_before,"Selling a loose duplicate preserves its equipped copy")
	assert(shop.find_child("Sell_warden_sword",true,false) == null)
	assert(not shop.sell_inventory_item("warden_sword"),"An equipped-only copy cannot be sold")
	shop.set_category("Consumables")
	assert(shop.catalog_items().has("healing_potion") and shop.catalog_items().has("trail_food"))
	var no_value: Button = shop.find_child("Sell_trail_food",true,false)
	assert(no_value.disabled and no_value.text.contains("NO RESALE"))
	var inventory_before: Dictionary = State.inventory.duplicate(true)
	assert(not shop.sell_inventory_item("trail_food") and State.inventory == inventory_before and State.gold == 69)
	for remaining in [2,1,0]:
		var potion_row: HBoxContainer = shop.find_child("TradeRow_healing_potion",true,false)
		assert(potion_row.find_child("ItemName",true,false).text.contains("Stack %d" % (remaining+1)))
		assert(potion_row.find_child("UnitValue",true,false).text.contains("2 GOLD per item"))
		(shop.find_child("Sell_healing_potion",true,false) as Button).pressed.emit()
		assert(int(State.inventory.get("healing_potion",0)) == remaining)
		assert(shop.get_node("TradeStatus").text.contains("%d remaining" % remaining))
		assert(shop.get_node("TradeGold").text == "GOLD  %d" % State.gold)
	assert(State.gold == 75 and shop.find_child("TradeRow_healing_potion",true,false) == null)
	shop.set_category("All")
	var sell_scroll: ScrollContainer = shop.get_node("TradeScroll")
	await settle()
	sell_scroll.scroll_vertical = 110
	await settle()
	scroll_before = sell_scroll.scroll_vertical
	assert(scroll_before > 0)
	assert(shop.sell_inventory_item("outlaw_tally"))
	await settle()
	assert(shop.get_node("TradeScroll").scroll_vertical == scroll_before,"Selling one copy preserves the inventory's scroll position")
	assert(State.inventory["outlaw_tally"] == 1 and State.gold == 85)
	for category in shop.CATEGORIES:
		shop.set_category(category)
		for id in shop.catalog_items():
			assert(category == "All" or shop.item_category(State.Items.item(id)) == category)
	shop.set_category("Weapons")
	assert(shop.sell_inventory_item("warden_legend") and State.gold == 135)
	assert(shop.sell_inventory_item("healer_mace") and State.gold == 137)
	assert(shop.has_node("TradeScroll/TradeRows/TradeEmpty"),"An exhausted filtered inventory shows an explicit empty state")
	assert(shop.get_node("TradeScroll/TradeRows/TradeEmpty").text.contains("Equipped items must first be unequipped"))
	assert(State.run_heroes == party_before and State.room_position == position_before)
	shop.return_to_party()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/expedition/merchant_orb_room.tscn")
	assert(State.run_heroes == party_before and State.room_position == position_before and State.equipment == equipment_before)
	assert(State.merchant_orb_available(),"The cleared orb remains available after trading")
	current_scene.continue_exploring()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/expedition/dungeon.tscn")
	assert(State.run_heroes == party_before and State.room_position == position_before)
	current_scene.queue_free()
	await settle()
	State.run_active = false
	State.completed_expeditions.append("infested_apothecary")
	State.gold = 100
	var apothecary = load("res://scenes/hub/apothecary.tscn").instantiate()
	root.add_child(apothecary)
	await settle()
	assert(apothecary.apothecary_mode and not apothecary.has_node("TradeSellTab") and not apothecary.has_node("TradeBuyTab"))
	apothecary.set_trade_mode("Sell")
	assert(not apothecary.is_selling() and not apothecary.sell_inventory_item("outlaw_tally"))
	assert(not apothecary.purchase("warden_sword") and not apothecary.purchase("warden_legend"))
	assert(apothecary.catalog_items().size() == State.APOTHECARY_CATALOG.size())
	for id in apothecary.catalog_items(): assert(State.APOTHECARY_CATALOG.has(id))
	(apothecary.find_child("Buy_healing_potion",true,false) as Button).pressed.emit()
	assert(State.inventory.get("healing_potion",0) == 1 and State.gold == 92)
	assert(apothecary.get_node("TradeStatus").text.contains("Purchased Healing Potion"))
	apothecary.queue_free()
	await settle()
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: Emporium buy/sell tabs and sorting/filtering, single-copy stack transactions, 25% value, zero-value rejection, equipped duplicates, legendary/other-class sales, empty states, orb return persistence and remedies-only apothecary")
	quit()
