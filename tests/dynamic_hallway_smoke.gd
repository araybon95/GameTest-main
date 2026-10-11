extends SceneTree
## Presentation regression: corridor movement must never resolve gameplay itself.
const State = preload("res://scripts/game_data.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
const LocalArt = preload("res://scripts/local_dungeon_art.gd")
const THEMES = [["old_road", 0, "bandit", "ash_raider"], ["old_road", 1, "keep", "keep_footman"], ["path_beast", 0, "beast", "anguish_penitent"], ["infested_apothecary", 0, "medical", "moth_metamorph"]]

func _initialize() -> void: call_deferred("run")

func fixture(context: Array, kind: String) -> void:
	assert(State.select_expedition(context[0]))
	State.start_run(42)
	State.floor_index = int(context[1])
	State.room_position = Vector2i(1, 0)
	var room: Dictionary = {"kind": kind, "cleared": false, "seen": true}
	match kind:
		"battle": room["enemies"] = [context[3]]
		"gold": room.merge({"kind": "event", "event_layout": "corridor", "corridor_encounter": "gold"}, true)
		"curio": room.merge({"kind": "event", "event_layout": "corridor", "event_id": "beast_reliquary" if context[2] == "beast" else "bandit_strongbox"}, true)
		"threshold": room.merge({"kind": "entry", "cleared": true}, true)
	State.floors[State.floor_index][State.room_position] = room

func gameplay_snapshot() -> Dictionary:
	return {"gold": State.gold, "heroes": State.run_heroes.duplicate(true), "inventory": State.inventory.duplicate(true), "equipment": State.equipment.duplicate(true), "room": State.room_position, "floor": State.floor_index, "floors": State.floors.duplicate(true), "loot_rng": State.loot_rng.state}

func passage(steps: Array = [Vector2i(1, 0)]) -> Control:
	var travel = Travel.new()
	travel.duration = 12.0
	travel.route_origin = Vector2i.ZERO
	travel.route_steps = steps.duplicate()
	root.add_child(travel)
	await process_frame
	travel.set_process(false)
	assert(not travel.auto_walk, "A hallway opens in manual movement mode")
	travel.set_walking(true)
	return travel

func key(code: Key, pressed: bool = true) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed
	root.push_input(event, true)
	await process_frame

func mouse_press(position: Vector2, pressed: bool) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.position = position
	event.global_position = position
	event.pressed = pressed
	root.push_input(event, true)
	await process_frame

func advance(travel, delta: float) -> void:
	travel._process(delta)
	travel.atmosphere._process(0.0)

func run() -> void:
	LocalArt.configure(LocalArt.DEFAULT_ROOT, false)
	root.size = Vector2i(1920, 1080)
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://dynamic_hallway_progress.cfg"
	State.party.assign(["warden", "ranger", "occultist"])
	State.hero_colors["warden"] = "blue"
	for context in THEMES:
		for kind in ["battle", "gold", "curio", "camp", "threshold"]:
			fixture(context, kind)
			var before: Dictionary = gameplay_snapshot()
			var travel = await passage()
			assert(travel.scene_theme == context[2] and travel.walkers.size() == 3)
			assert(is_equal_approx(travel.progress.size.y, 4.0), "Progress rail stays thin under the global Gothic theme")
			assert(travel.progress.get_global_rect().end.y <= travel.passage_map.get_parent().get_global_rect().position.y, "Progress rail does not cover the map header")
			assert(travel.encounter != null and travel.encounter.texture != null)
			assert(not travel.arrived and not travel.travel_stage.get_node("DestinationInteract").visible, "Destination remains hidden until reached")
			var completions: Array = []
			travel.finished.connect(func(): completions.append(true))
			travel.travel_stage.get_node("DestinationInteract").pressed.emit()
			assert(not travel.complete and completions.is_empty(), "Destination cannot activate before arrival")
			var start: float = travel.scenery.position.x
			advance(travel, 0.8)
			assert(travel.scenery.position.x < start and travel.distance_travelled > 0.0)
			assert(travel.footsteps_played > 0, "Footsteps accompany walking")
			var first_frame: Texture2D = travel.walkers[0].texture
			advance(travel, 0.2)
			assert(travel.walkers[0].texture != first_frame, "Walking advances the hero animation frames")
			for walker in travel.walkers:
				if walker.get_meta("walker") == "warden": assert(walker.material is ShaderMaterial, "Workshop palette survives walking")
				assert(is_equal_approx(walker.position.y + walker.size.y, Travel.GROUND_Y), "Walkers remain on the scene contact plane")
			travel.set_walking(false)
			advance(travel, 0.0)
			var paused_elapsed: float = travel.elapsed
			var paused_scenery: Vector2 = travel.scenery.position
			var paused_steps: int = travel.footsteps_played
			var paused_clock: float = travel.animation_clock
			var paused_frame: Texture2D = travel.walkers[0].texture
			advance(travel, 0.8)
			assert(travel.elapsed == paused_elapsed and travel.scenery.position == paused_scenery)
			assert(travel.animation_clock == paused_clock and travel.walkers[0].texture == paused_frame, "Paused walkers hold their animation frame")
			assert(not travel.footsteps.playing and travel.footsteps_played == paused_steps)
			travel.get_node("WalkToggle").pressed.emit()
			advance(travel, 0.8)
			assert(travel.elapsed > paused_elapsed, "Native walk button resumes movement")
			travel.skip_travel()
			advance(travel, 0.0)
			assert(travel.arrived and not travel.complete and completions.is_empty())
			assert(travel.travel_stage.get_node("DestinationInteract").visible and not travel.travel_stage.get_node("DestinationInteract").disabled)
			var stopped: Vector2 = travel.walkers[0].position
			var arrived_steps: int = travel.footsteps_played
			advance(travel, 30.0)
			assert(not travel.complete and completions.is_empty(), "Arriving waits for explicit interaction")
			assert(travel.walkers[0].position == stopped and travel.footsteps_played == arrived_steps and not travel.footsteps.playing)
			assert(gameplay_snapshot() == before, "Walking, stopping and arrival preserve room, cleared flags, HP, equipment and gold")
			if kind == "threshold":
				assert(travel.encounter.texture.atlas.resource_path == Scenery.threshold_path(context[2]))
				assert(travel.encounter.size.y > travel.walkers[0].size.y)
			travel.travel_stage.get_node("DestinationInteract").pressed.emit()
			travel.finish()
			assert(completions.size() == 1, "Destination and legacy finish resolve only once")
			await process_frame
	# Maximum camera travel must keep the panorama covering the complete stage.
	for context in THEMES:
		fixture(context, "threshold")
		var steps: Array = []
		var rooms: Dictionary = {Vector2i.ZERO: {"kind": "entry", "cleared": true, "seen": true}}
		for index in range(1, 7):
			steps.append(Vector2i(index, 0))
			rooms[steps.back()] = {"kind": "entry", "cleared": true, "seen": true}
		State.floors[State.floor_index] = rooms
		State.room_position = Vector2i(6, 0)
		var before: Dictionary = gameplay_snapshot()
		var travel = await passage(steps)
		advance(travel, travel.duration)
		assert(is_equal_approx(travel.distance_travelled, 2600.0))
		assert(travel.scenery.position.x <= 0.0 and travel.scenery.position.x + travel.scenery.size.x >= travel.travel_stage.size.x, "Longest route reveals no empty background edge")
		for position in travel.passage_map.positions.values():
			assert(is_equal_approx(position.y, travel.passage_map.size.y * 0.5), "A single-row floor is vertically centered in the minimap")
		assert(gameplay_snapshot() == before, "Long routes preserve gameplay and loot RNG state")
		travel.finish()
		await process_frame
	fixture(THEMES[0], "threshold")
	var column_steps: Array = []
	var column_rooms: Dictionary = {Vector2i.ZERO: {"kind": "entry", "cleared": true, "seen": true}}
	for index in range(1, 7):
		column_steps.append(Vector2i(0, index))
		column_rooms[column_steps.back()] = {"kind": "entry", "cleared": true, "seen": true}
	State.floors[0] = column_rooms
	State.room_position = Vector2i(0, 6)
	var column_travel = await passage(column_steps)
	for position in column_travel.passage_map.positions.values():
		assert(is_equal_approx(position.x, column_travel.passage_map.size.x * 0.5), "A single-column floor is horizontally centered in the minimap")
	column_travel.finish()
	await process_frame
	# Real keyboard propagation must respect both manual pause and settings overlays.
	fixture(THEMES[0], "curio")
	var before: Dictionary = gameplay_snapshot()
	var travel = await passage()
	await key(KEY_SPACE)
	assert(not travel.auto_walk)
	advance(travel, 0.5)
	var stopped_time: float = travel.elapsed
	await key(KEY_D)
	advance(travel, 0.5)
	assert(travel.elapsed > stopped_time, "Holding D walks from manual pause")
	await key(KEY_D, false)
	var released_time: float = travel.elapsed
	advance(travel, 0.5)
	assert(travel.elapsed == released_time and not travel.auto_walk, "Releasing D stops held movement")
	await mouse_press(travel.travel_stage.get_global_rect().get_center(), true)
	advance(travel, 0.5)
	assert(travel.elapsed > released_time, "Holding the hallway stage walks")
	await mouse_press(Vector2(1850, 1065), false)
	var outside_release_time: float = travel.elapsed
	advance(travel, 0.5)
	assert(travel.elapsed == outside_release_time, "Releasing outside the hallway stage still stops movement")
	var walk_center: Vector2 = travel.get_node("WalkToggle").get_global_rect().get_center()
	await mouse_press(walk_center, true)
	await mouse_press(walk_center, false)
	assert(travel.auto_walk, "Clicking Walk On resumes automatic movement")
	await mouse_press(walk_center, true)
	await mouse_press(walk_center, false)
	assert(not travel.auto_walk and travel.get_node("WalkToggle").has_focus(), "Clicking Pause stops and focuses the native button")
	await key(KEY_RIGHT)
	advance(travel, 0.5)
	assert(travel.elapsed > outside_release_time, "Right Arrow walks while a hallway button has GUI focus")
	await key(KEY_RIGHT, false)
	var focused_release_time: float = travel.elapsed
	advance(travel, 0.5)
	assert(travel.elapsed == focused_release_time and not travel.auto_walk)
	await key(KEY_SPACE)
	assert(travel.auto_walk)
	var settings = root.get_node("GameSettings")
	settings.open_settings()
	await process_frame
	var settings_time: float = travel.elapsed
	advance(travel, 0.5)
	await key(KEY_SPACE)
	await key(KEY_E)
	await key(KEY_RIGHT)
	travel.get_node("SkipTravel").pressed.emit()
	advance(travel, 0.5)
	assert(travel.elapsed == settings_time and not travel.complete and not travel.footsteps.playing, "Settings block hallway shortcuts and footsteps")
	await key(KEY_RIGHT, false)
	settings.close_settings()
	await process_frame
	advance(travel, 0.5)
	assert(travel.elapsed > settings_time, "Closing settings resumes the prior automatic walk")
	travel.set_walking(false)
	settings.open_settings()
	advance(travel, 0.5)
	settings.close_settings()
	await process_frame
	var manual_time: float = travel.elapsed
	advance(travel, 0.5)
	assert(travel.elapsed == manual_time, "Closing settings preserves manual pause")
	travel.set_walking(true)
	var fallback_id: String = str(travel.walkers[0].get_meta("walker"))
	travel.walk_frames.erase(fallback_id)
	advance(travel, 0.5)
	assert(travel.walkers[0].texture == travel.standing_frames[fallback_id], "Missing atlas uses standing art")
	travel.skip_travel()
	advance(travel, 0.0)
	assert(gameplay_snapshot() == before)
	settings.open_settings()
	travel.travel_stage.get_node("DestinationInteract").pressed.emit()
	assert(not travel.complete, "Reached destination stays blocked while settings are open")
	settings.close_settings()
	await process_frame
	await key(KEY_ENTER)
	await process_frame
	assert(not is_instance_valid(travel), "Enter explicitly enters the reached encounter")
	fixture(THEMES[0], "gold")
	var click_before: Dictionary = gameplay_snapshot()
	travel = await passage()
	travel.skip_travel()
	var click_completions: Array = []
	travel.finished.connect(func(): click_completions.append(true))
	var destination_center: Vector2 = travel.travel_stage.get_node("DestinationInteract").get_global_rect().get_center()
	await mouse_press(destination_center, true)
	await mouse_press(destination_center, false)
	assert(not is_instance_valid(travel) and click_completions.size() == 1, "Clicking the reached world prop enters once")
	assert(gameplay_snapshot() == click_before, "A native destination click leaves loot resolution to the dungeon")
	fixture(THEMES[0], "battle")
	State.run_heroes["ranger"]["dead"] = true
	travel = await passage()
	assert(travel.walkers.size() == 2, "Fallen heroes do not walk")
	travel.finish()
	await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: dynamic walking and 20 themed arrivals; explicit activation, state and RNG safety, footsteps, native controls, settings pause, palette, fallback, surviving party, longest-route coverage and centered minimaps")
	quit()
