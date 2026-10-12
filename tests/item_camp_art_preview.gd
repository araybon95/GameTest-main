extends SceneTree
const State = preload("res://scripts/game_data.gd")
var destination: String
var capture_filter: PackedStringArray = []
func _initialize() -> void: call_deferred("run")
func capture(title: String) -> void:
	if not capture_filter.is_empty() and not capture_filter.has(title): return
	await create_timer(0.7).timeout
	await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	assert(image.get_size() == root.size)
	assert(image.save_png(destination+"/"+title+".png") == OK)
	print("CAPTURE ",title)
func show(path: String) -> void:
	change_scene_to_file(path)
	for i in range(6): await process_frame
func run() -> void:
	var args := OS.get_cmdline_user_args()
	destination = args[0]
	if args.size() > 3: capture_filter = args[3].split(",")
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(int(args[1]),int(args[2]))
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://item_art_preview.cfg"
	State.party.assign(["warden","ranger","healer"])
	State.completed_expeditions.assign(["old_road","path_beast","restore_workshop","infested_apothecary"])
	State.gold = 120
	State.select_expedition("old_road")
	State.start_run(42)
	for id in State.Items.SCROLLS.keys()+State.Items.POTIONS.keys()+State.Items.PROVISIONS.keys()+State.Items.EQUIPMENT.keys(): State.add_item(id,2)
	for location in State.floors[0]:
		if State.floors[0][location].kind == "camp": State.room_position = location; break
	State.run_heroes.warden.hp = 12
	State.run_heroes.warden.stress = 75
	await show("res://scenes/expedition/camp.tscn")
	await capture("camp-rest-first")
	current_scene.get_node("RestButton").pressed.emit()
	await capture("camp-ready")
	current_scene.get_node("CampSkill_watch").pressed.emit()
	await capture("camp-watch-posted")
	current_scene.get_node("CampSkill_ward").pressed.emit()
	await capture("camp-points-spent")
	root.get_node("GameControls").open_hero_sheet("warden")
	await capture("character-camp-skills")
	root.get_node("GameControls").close_hero_sheet()
	root.get_node("GameControls").open_hero_sheet("warden",true)
	await capture("item-inventory")
	root.get_node("GameControls").close_hero_sheet()
	State.shop_return_scene = "res://scenes/hub/settlement.tscn"
	await show("res://scenes/hub/item_shop.tscn")
	current_scene.set_category("Consumables")
	await capture("merchant-consumables")
	current_scene.set_category("Weapons")
	await capture("merchant-weapons")
	current_scene.set_category("Armor")
	await capture("merchant-armour")
	print("ART_PREVIEW_COMPLETE ",destination)
	quit()
