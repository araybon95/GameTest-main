extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
const TravelAudio = preload("res://scripts/travel_audio.gd")

func _initialize() -> void: call_deferred("run")

func select_run(id: String, floor: int = 0) -> void:
	for expedition in State.EXPEDITIONS:
		if expedition["id"] == id: State.selected_expedition = expedition
	State.start_run(27)
	State.floor_index = floor
	State.room_position = Vector2i.ZERO

func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://exploration_polish_test.cfg"
	for context in [["old_road",0,"bandit"],["old_road",1,"keep"],["path_beast",0,"beast"],["infested_apothecary",0,"medical"]]:
		select_run(context[0],context[1])
		State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"camp","cleared":false,"seen":true}
		var camp = load("res://scenes/expedition/camp.tscn").instantiate()
		root.add_child(camp)
		await process_frame
		assert(camp.get_node("CampAtmosphere").scene_theme == context[2])
		for id in State.party:
			var camper: TextureRect = camp.get_node("Camper_%s" % id)
			assert(is_equal_approx(camper.position.y+camper.size.y,690.0),"Resting heroes share the camp ground")
		camp.rest_party()
		assert(camp.get_node("CampAtmosphere").fire_spent)
		camp.queue_free()
		await process_frame
		var event_id: String = "beast_reliquary" if context[2] == "beast" else "bandit_strongbox"
		State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"event","event_id":event_id,"event_layout":"room","cleared":false,"seen":true}
		var event = load("res://scenes/expedition/event_room.tscn").instantiate()
		root.add_child(event)
		await process_frame
		assert(event.get_node("EventAtmosphere").scene_theme == context[2])
		assert(event.get_node("Investigator").position.y+event.get_node("Investigator").size.y == 690.0)
		assert(is_equal_approx(event.get_node("EventProp").position.y+event.get_node("EventProp").size.y,690.0))
		if event_id == "bandit_strongbox":
			assert(event.get_node("EventProp").size.y < event.get_node("Investigator").size.y,"Portable caches fit the investigating hero's scale")
		var material: ShaderMaterial = event.get_node("EventProp").material
		event.get_node("EventObject").mouse_entered.emit()
		assert(is_equal_approx(float(material.get_shader_parameter("strength")),0.9))
		event.get_node("EventObject").mouse_exited.emit()
		assert(is_equal_approx(float(material.get_shader_parameter("strength")),0.25))
		event.queue_free()
		await process_frame
		State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"entry","cleared":true,"seen":true}
		var travel = Travel.new()
		travel.duration = 20.0
		travel.arrival_duration = 20.0
		root.add_child(travel)
		await process_frame
		travel._process(0.31)
		assert(travel.scene_theme == context[2] and travel.footsteps_played > 0)
		assert(travel.encounter.texture.atlas.resource_path == Scenery.threshold_path(context[2]))
		assert(travel.encounter.size.y > travel.walkers[0].size.y,"Threshold architecture has a human-sized opening")
		# A newly added hero may not yet have a walking atlas; the standing art remains usable.
		var fallback_id: String = travel.walkers[0].get_meta("walker")
		travel.walk_frames.erase(fallback_id)
		travel._process(0.01)
		assert(travel.walkers[0].texture.resource_path == State.hero(fallback_id)["art"])
		travel.skip_travel()
		travel._process(0.01)
		assert(travel.arrived and not travel.footsteps.playing,"Footsteps stop at the encounter")
		var steps: int = travel.footsteps_played
		travel._process(0.5)
		assert(travel.footsteps_played == steps)
		travel.finish()
		await process_frame
	var stone: AudioStreamWAV = TravelAudio.footstep("keep")
	assert(stone == TravelAudio.footstep("keep") and stone.data.size() > 1000)
	assert(stone.data != TravelAudio.footstep("bandit").data,"Stone and gravel have distinct footfalls")
	select_run("old_road",0)
	State.floors[0][Vector2i.ZERO] = {"kind":"stairs","cleared":true,"seen":true}
	var entrance = preload("res://scenes/expedition/floor_entrance.gd").new()
	var replies: Array = []
	entrance.on_descend = func(): replies.append("descend")
	root.add_child(entrance)
	await process_frame
	assert(entrance.get_node("ThemedThreshold").texture.resource_path == Scenery.threshold_path("keep"))
	assert(entrance.get_node("PreparationHint").text.contains("camp") and entrance.preparation_hint().contains("level points"))
	State.floor_index = 1
	assert(entrance.preparation_hint().contains("support survives"))
	State.floor_index = 0
	entrance.accept_entrance()
	entrance.accept_entrance()
	entrance.stay_here()
	assert(replies == ["descend"],"A threshold accepts only one navigation response")
	await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: four themed thresholds, grounded camps and events, hover silhouette, distinct footsteps, arrival stop and single descent")
	quit()
