extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
func _initialize() -> void: call_deferred("run")
func snapshot() -> Dictionary:
	return {"heroes":State.run_heroes.duplicate(true),"inventory":State.inventory.duplicate(true),"equipment":State.equipment.duplicate(true),"floors":State.floors.duplicate(true),"position":State.room_position,"gold":State.gold,"rng":State.loot_rng.state,"journey":State.journey.duplicate(true)}
func run() -> void:
	State.progress_loaded = true
	State.crusader_unlocked = true
	var runtime = root.get_node("GameSettings")
	assert(not runtime.experimental_walking,"Experimental walking is opt-in for new and existing players")
	runtime.ambient_motion = true
	for outfit in ["original","alternate","relic"]:
		for party in [["warden","ranger","occultist"],["healer","crusader","warden"]]:
			State.party.assign(party)
			State.equipment.clear()
			State.hero_outfits.clear()
			State.select_expedition("old_road")
			State.start_run(42)
			State.room_position = Vector2i.RIGHT
			State.floors[0][Vector2i.RIGHT] = {"kind":"camp","cleared":false,"seen":true}
			for id in party: State.hero_outfits[id] = outfit
			State.hero_colors[party[0]] = "blue"
			State.add_item("warden_epic")
			State.equip_item("warden","warden_epic")
			var before := snapshot()
			runtime.experimental_walking = false
			var travel := Travel.new()
			travel.duration = 12.0
			root.add_child(travel)
			travel.set_process(false)
			travel._process(0.2)
			for phase in range(4):
				travel.animation_clock = phase/7.0
				travel.update_walkers()
				for index in range(travel.walkers.size()):
					var picture: TextureRect = travel.walkers[index]
					var id: String = picture.get_meta("walker")
					assert(picture.texture == travel.walk_frames[id][int(travel.warden_clock/0.084)%10 if travel.costume_for_warden(id) else int(phase+index*0.45)%4],"Costume frame cadence restored")
					assert(not picture.material.get_shader_parameter("actor_motion"))
			travel.arrived = true
			travel.update_walkers()
			for picture in travel.walkers: assert(picture.texture == travel.standing_frames[picture.get_meta("walker")],"Original standing pose on arrival")
			travel.arrived = false
			runtime.experimental_walking = true
			travel._process(0)
			var frames: Dictionary = {}
			var profiles: Array = []
			for picture in travel.walkers:
				var id: String = picture.get_meta("walker")
				frames[id] = picture.texture
				profiles.append(picture.material.get_shader_parameter("actor_profile"))
				assert(picture.material.get_shader_parameter("actor_motion") == not travel.costume_for_warden(id))
				assert(picture.texture == travel.walk_frames[id][0 if travel.costume_for_warden(id) else Travel.QUIET_WALK_POSE])
				assert(picture.material.get_shader_parameter("recolor") == (id == party[0] or State.hero_colors.get(id,"original") != "original"))
			assert(profiles[0] != profiles[1] and profiles[1] != profiles[2])
			travel.set_walking(true)
			travel._process(1.0/60.0)
			assert(travel.actor_walking > 0 and travel.actor_walking < 0.2,"Weight shifts ease into walking")
			for frame in range(90): travel._process(1.0/60.0)
			assert(travel.actor_walking > 0.99)
			for picture in travel.walkers:
				if not travel.costume_for_warden(str(picture.get_meta("walker"))): assert(picture.texture == frames[picture.get_meta("walker")])
				assert(picture.position.y+picture.size.y == Travel.GROUND_Y)
				var trim = picture.get_node("EquipmentAccents")
				assert(trim.material.get_shader_parameter("actor_clock") == picture.material.get_shader_parameter("actor_clock"))
			travel.set_walking(false)
			travel._process(1.0/60.0)
			assert(travel.actor_walking > 0.8 and travel.actor_walking < 1.0,"Stopping settles without a pose snap")
			var paused_distance: float = travel.distance_travelled
			var idle_clock: float = travel.actor_clock
			for frame in range(90): travel._process(1.0/60.0)
			assert(travel.actor_walking < 0.001 and travel.actor_clock > idle_clock)
			assert(travel.distance_travelled == paused_distance)
			var clock: float = travel.actor_clock
			travel.advance_actor_motion(2.0,true)
			assert(travel.actor_clock == clock,"Modal panels freeze actor motion")
			runtime.ambient_motion = false
			travel._process(0.4)
			assert(travel.actor_clock == clock and travel.actor_walking == 0.0)
			for picture in travel.walkers: assert(not picture.material.get_shader_parameter("actor_motion"))
			runtime.ambient_motion = true
			travel.manual_direction = -1
			travel.manual_walking = true
			travel._process(0.1)
			for picture in travel.walkers:
				assert(picture.flip_h)
				picture.get_node("EquipmentAccents").sync()
				assert(picture.get_node("EquipmentAccents").flip_h)
			travel.skip_travel()
			travel._process(0.4)
			for picture in travel.walkers: if not travel.costume_for_warden(str(picture.get_meta("walker"))): assert(picture.texture == frames[picture.get_meta("walker")])
			assert(snapshot() == before,"Presentation does not alter travel commits, health, gold, rooms or RNG")
			travel.free()
	await process_frame
	print("PASS: original default frame cadence/arrival and opt-in subtle motion for five heroes/three costumes; grounding, idle breath, eased stops, frozen modals/reduced motion, aligned gear and unchanged gameplay/RNG")
	quit()
