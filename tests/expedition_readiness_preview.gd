extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Entrance = preload("res://scenes/expedition/floor_entrance.gd")
func _initialize() -> void: call_deferred("run")

func shot(label: String) -> void:
	await create_timer(0.18).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("C:/GAME/Ashen/readiness-%s.png" % label)

func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://readiness_preview_progress.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.hero_names = {"warden":"Sir Vane","ranger":"Thorn","occultist":"Mother Ash"}
	State.hero_progress.clear()
	State.equipment.clear()
	State.inventory.clear()
	State.run_active = false
	State.gold = 70
	State.select_expedition("path_beast")
	var preparation = load("res://scenes/expedition/preparation.tscn").instantiate()
	root.add_child(preparation)
	await shot("veteran-new")
	for id in State.party: State.gain_hero_xp(id,105)
	preparation.refresh()
	await shot("veteran-unspent")
	for entry in [["warden","warden_gravewatch"],["ranger","ranger_chitin_lens"],["occultist","occultist_severed_litany"]]:
		for stat in ["max_hp","damage_percent","block","debuff_resist"]: State.train_hero(entry[0],stat)
		State.add_item(entry[1])
		State.equip_item(entry[0],entry[1])
	preparation.refresh()
	await shot("veteran-trained")
	preparation.queue_free()
	await process_frame
	for entry in [["old_road",0,"keep"],["old_road",1,"lord"],["path_beast",0,"coterie"],["path_beast",1,"head"]]:
		State.select_expedition(entry[0])
		State.start_run(147)
		State.floor_index = entry[1]
		State.room_position = Vector2i.ZERO
		State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"stairs","cleared":true,"seen":true}
		for room in State.floors[State.floor_index].values():
			if room["kind"] == "camp": room["seen"] = false
		State.floors[State.floor_index][Vector2i(3,1)] = {"kind":"camp","cleared":false,"seen":true,"name":"The Stolen Watchfire"}
		State.run_heroes["warden"].merge({"hp":0,"deaths_door":true,"stress":85,"statuses":{"bleed":{"turns":2,"damage":2},"poison":{"turns":2,"damage":2}}},true)
		State.run_heroes["ranger"].merge({"hp":11,"statuses":{"chill":{"turns":2,"damage":0}}},true)
		State.run_heroes["occultist"].merge({"hp":0,"dead":true},true)
		var prompt = Entrance.new()
		root.add_child(prompt)
		await shot("descent-%s" % entry[2])
		prompt.queue_free()
		await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	quit()
