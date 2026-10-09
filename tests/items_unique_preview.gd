extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void:
	call_deferred("run")
func shot(path: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)
func run() -> void:
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.select_expedition("old_road")
	State.start_run(20)
	for id in State.Items.EQUIPMENT.keys() + State.Items.POTIONS.keys() + State.Items.SCROLLS.keys():
		State.add_item(id, 5 if State.Items.item(id).get("kind", "") in ["potion", "scroll"] else 1)
	var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
	root.add_child(dungeon)
	dungeon.inspect_hero("warden")
	await shot("C:/GAME/Ashen/items-unique-preview.png")
	dungeon.filter_inventory("warden", "Consumables")
	await shot("C:/GAME/Ashen/potion-stacks-preview.png")
	dungeon.queue_free()
	await process_frame
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await shot("C:/GAME/Ashen/consumables-combat-preview.png")
	battle.queue_free()
	await process_frame
	quit()
