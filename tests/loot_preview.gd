extends SceneTree
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("capture")

func screenshot(path: String) -> void:
	for frame in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)

func capture() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.select_expedition("old_road")
	State.start_run(42)
	State.gold = 24
	for item_id in ["warden_sword", "warden_legend", "ranger_bow", "healer_symbol", "fire_bolt_scroll", "lightning_bolt_scroll", "sunfire_scroll"]:
		State.add_item(item_id)
	var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(dungeon)
	dungeon.inspect_hero("warden")
	await screenshot("res://../../loot-inventory-preview.png")
	dungeon.queue_free()
	await process_frame
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await screenshot("res://../../scroll-combat-preview.png")
	battle.queue_free()
	await process_frame
	var shop = load("res://scenes/hub/item_shop.tscn").instantiate()
	root.add_child(shop)
	await screenshot("res://../../scroll-shop-preview.png")
	shop.queue_free()
	await process_frame
	var title = load("res://scenes/ui/title_screen.tscn").instantiate()
	root.add_child(title)
	title._on_start_pressed()
	await screenshot("res://../../adult-confirmation-preview.png")
	quit()
