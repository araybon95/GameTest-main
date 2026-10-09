extends SceneTree
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("run")

func screenshot(path: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)

func run() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.select_expedition("path_beast")
	State.start_run(20)
	for room in State.floors[0].values():
		room["seen"] = true
	for id in State.Items.EQUIPMENT:
		if State.Items.item(id).get("kind", "") == "trinket":
			State.add_item(id)
	State.equip_item("warden", "vitality_locket")
	State.equip_item("warden", "warden_relic")
	var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(dungeon)
	await screenshot("res://../../rooms-hallways-preview.png")
	dungeon.inspect_hero("warden")
	await screenshot("res://../../trinkets-inventory-preview.png")
	dungeon.queue_free()
	await process_frame
	var shop = load("res://scenes/hub/item_shop.tscn").instantiate()
	root.add_child(shop)
	shop.set_category("Trinkets")
	await screenshot("res://../../trinkets-shop-preview.png")
	shop.queue_free()
	await process_frame
	quit()
