extends SceneTree
## Controlled UI audit fixtures; not a gameplay/balance test. Output stays outside res://.
const State = preload("res://scripts/game_data.gd")
var destination: String
func _initialize() -> void: call_deferred("run")
func capture(title: String) -> void:
	await create_timer(1.0).timeout
	await RenderingServer.frame_post_draw
	var result := root.get_texture().get_image()
	assert(result.get_size() == root.size)
	result.save_png(destination+"/"+title+".png")
	print("CAPTURE ",title)
func setup() -> void:
	root.get_node("GameControls").close_hero_sheet()
	root.get_node("GameControls").close_guide()
	root.get_node("GameSettings").close_settings()
	State.run_active = false
	State.progress_loaded = true
	State.progress_path = "user://visual_audit_progress.cfg"
	State.party.assign(["warden","ranger","healer"])
	State.hero_names = {"warden":"Sir Vane","ranger":"Thorn","healer":"Sister Mara"}
	State.completed_expeditions.assign(["old_road","path_beast","restore_watchtower","restore_infirmary","restore_workshop","infested_apothecary"])
	State.crusader_unlocked = true
	State.hero_progress.clear()
	State.equipment.clear()
	State.inventory.clear()
	State.Items.histories.clear()
	State.Items.favourites.clear()
	State.modifications.clear()
	State.graves.clear()
	State.gold = 112
	for id in State.party: State.gain_hero_xp(id,105)
	for item in ["warden_sword","warden_armor","ranger_bow","ranger_common_armor","healer_mace","healer_armor","healing_potion","antidote","fire_bolt_scroll"]: State.add_item(item)
	State.equip_item("warden","warden_sword")
	State.equip_item("ranger","ranger_bow")
	State.equip_item("healer","healer_mace")
	State.select_expedition("old_road")
func show(path: String) -> void:
	change_scene_to_file(path)
	for frame in range(6): await process_frame
func run() -> void:
	var args := OS.get_cmdline_user_args()
	destination = args[0]
	DirAccess.make_dir_recursive_absolute(destination)
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	root.size = Vector2i(int(args[1]),int(args[2]))
	setup()
	await show("res://scenes/ui/title_screen.tscn")
	await capture("title")
	await show("res://scenes/hub/settlement.tscn")
	await capture("settlement")
	for id in ["barracks","apothecary","chapel","watchtower","infirmary","workshop","forge","graveyard","road"]:
		var hotspot = current_scene.get_node("MapView/"+id)
		current_scene._on_hotspot_hover(hotspot,true)
		await capture("settlement-hover-"+id)
		current_scene._on_hotspot_hover(hotspot,false)
	current_scene._show_expeditions()
	await capture("settlement-expeditions")
	for id in ["barracks","bestiary","forge","apothecary","item_shop","customization","keepsakes","restoration","graveyard"]:
		setup()
		State.pending_service = "workshop"
		State.shop_return_scene = "res://scenes/hub/settlement.tscn"
		await show("res://scenes/hub/"+id+".tscn")
		await capture(id)
	setup()
	await show("res://scenes/expedition/region_select.tscn")
	await capture("regions")
	await show("res://scenes/expedition/preparation.tscn")
	await capture("preparation")
	State.start_run(27)
	for room in State.floors[0].values(): room.seen = true
	await show("res://scenes/expedition/dungeon.tscn")
	await capture("exploration")
	root.get_node("GameControls").open_hero_sheet("warden")
	await capture("character-sheet")
	root.get_node("GameControls").close_hero_sheet()
	root.get_node("GameControls").open_hero_sheet("warden",true)
	await capture("inventory")
	root.get_node("GameControls").close_hero_sheet()
	root.get_node("GameSettings").open_settings()
	await capture("settings")
	root.get_node("GameSettings").close_settings()
	for kind in ["camp","event","merchant"]:
		for location in State.floors[0]:
			var room: Dictionary = State.floors[0][location]
			if room.kind == kind or kind == "merchant" and room.get("merchant_orb",false):
				State.room_position = location
				if kind == "merchant": room.cleared = true
				break
		await show("res://scenes/expedition/"+{"camp":"camp","event":"event_room","merchant":"merchant_orb_room"}[kind]+".tscn")
		await capture(kind)
	State.room_position = Vector2i.ZERO
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","creature":"ash_raider","enemies":["ash_raider","gallows_scout"],"seen":true,"cleared":false}
	await show("res://scenes/combat/combatscene.tscn")
	await capture("combat")
	var reveal = load("res://scenes/ui/relic_reveal.gd").new()
	reveal.item_id = "warden_legend"
	current_scene.add_child(reveal)
	await capture("relic")
	reveal.dismiss()
	State.room_position = Vector2i.ZERO
	State.floors[0][Vector2i.ZERO] = {"kind":"stairs","seen":true,"cleared":true}
	await show("res://scenes/expedition/dungeon.tscn")
	current_scene.descend()
	await capture("descent")
	State.run_complete = true
	State.end_run()
	await show("res://scenes/expedition/aftermath.tscn")
	await capture("aftermath")
	print("AUDIT_COMPLETE ",destination)
	quit()
