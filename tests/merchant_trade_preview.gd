extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")

func _initialize() -> void: call_deferred("run")

func shot(path: String) -> void:
	await create_timer(0.20).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)

func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://merchant_trade_preview.cfg"
	Saves.directory = "user://merchant_trade_preview_saves/"
	State.party.assign(["warden","ranger","occultist"])
	State.hero_progress.clear()
	State.equipment.clear()
	assert(State.select_expedition("old_road"))
	State.start_run(42)
	State.gold = 75
	State.inventory.clear()
	State.run_heroes["warden"].merge({"hp":13,"stress":45},true)
	for entry in [["healing_potion",3],["cleansing_potion",2],["warden_legend",1],["healer_mace",1],["outlaw_tally",2],["trail_food",2],["ranger_armor",1],["warden_shield",1],["ranger_epic",1]]:
		State.add_item(entry[0],entry[1])
	var shop = load("res://scenes/hub/item_shop.tscn").instantiate()
	root.add_child(shop)
	await shot("C:/GAME/Ashen/merchant-trade-buy.png")
	shop.set_trade_mode("Sell")
	await shot("C:/GAME/Ashen/merchant-trade-sell.png")
	shop.set_category("Weapons")
	shop.set_sort("Value")
	await shot("C:/GAME/Ashen/merchant-trade-sell-weapons.png")
	shop.set_category("Consumables")
	shop.set_sort("Name")
	await shot("C:/GAME/Ashen/merchant-trade-sell-consumables.png")
	shop.sell_inventory_item("healing_potion")
	await shot("C:/GAME/Ashen/merchant-trade-after-sale.png")
	shop.set_category("Relics")
	State.inventory.erase("warden_shield")
	shop.refresh()
	await shot("C:/GAME/Ashen/merchant-trade-empty.png")
	shop.queue_free()
	await process_frame
	State.run_active = false
	State.completed_expeditions.append("infested_apothecary")
	var apothecary = load("res://scenes/hub/apothecary.tscn").instantiate()
	root.add_child(apothecary)
	await shot("C:/GAME/Ashen/merchant-trade-apothecary.png")
	apothecary.queue_free()
	await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	quit()
