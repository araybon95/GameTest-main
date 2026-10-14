extends SceneTree
## Real hallway input and the dungeon's deferred gameplay commit, not a cutscene timer.
const State = preload("res://scripts/game_data.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
const Saves = preload("res://scripts/save_files.gd")
var passages_completed: int = 0

func _initialize() -> void:
	call_deferred("run")

func settle() -> void:
	await process_frame
	await process_frame

func key(code: Key, pressed: bool = true) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed
	root.push_input(event, true)
	await process_frame

func snapshot() -> Dictionary:
	return {"gold": State.gold, "position": State.room_position, "floor": State.floor_index,
		"rooms": State.floors.duplicate(true), "heroes": State.run_heroes.duplicate(true),
		"journey": State.journey.duplicate(true), "inventory": State.inventory.duplicate(true),
		"rng": State.loot_rng.state}

func fixture() -> void:
	State.navigation_voters.assign(["local"])
	State.navigation_votes.clear()
	assert(State.select_expedition("old_road"))
	State.start_run(924)
	assert(State.floors[0][Vector2i.ZERO].get("travel_counted", false), "The entrance is already a visited space")
	State.floors[0] = {
		Vector2i.ZERO: {"kind": "entry", "cleared": true, "seen": true, "travel_counted": true},
		Vector2i.RIGHT: {"kind": "event", "event_layout": "corridor", "corridor_encounter": "gold", "small_gold": 3, "cleared": false, "seen": true},
		Vector2i(2, 0): {"kind": "event", "event_layout": "corridor", "corridor_encounter": "roamer", "creature": "ash_raider", "cleared": false, "seen": false}
	}
	State.gold = 28
	State.journey["steps"] = 5
	State.journey["rations"] = 1
	State.run_heroes["warden"]["hp"] = 7
	assert(change_scene_to_file("res://scenes/expedition/dungeon.tscn") == OK)
	await settle()

func open_passage(destination: Vector2i) -> Control:
	var dungeon = current_scene
	dungeon.move_to(destination)
	var passage = null
	for child in dungeon.get_children():
		if child.get_script() == Travel: passage = child
	assert(passage != null and dungeon.traveling)
	passage.set_process(false)
	assert(not passage.auto_walk, "A route waits for the player's walking input")
	assert(not passage.reached_destination)
	return passage

func arrive_and_enter(passage) -> void:
	passage.skip_travel()
	assert(passage.arrived and not passage.complete)
	await key(KEY_ENTER)
	await key(KEY_ENTER, false)
	if is_instance_valid(passage) and not passage.is_queued_for_deletion(): await passage.finished
	await settle()
	assert(not is_instance_valid(passage), "The reached doorway accepts Enter once")
	passages_completed += 1

func run() -> void:
	root.size = Vector2i(1920, 1080)
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.map_travel_mode = false # Explicit legacy-walking fixture.
	State.progress_loaded = true
	State.progress_path = "user://hallway_navigation_progress.cfg"
	Saves.directory = "user://hallway_navigation_saves/"
	State.party.assign(["warden", "ranger", "occultist"])
	await fixture()
	var before: Dictionary = snapshot()
	var passage = await open_passage(Vector2i.RIGHT)
	assert(snapshot() == before, "Selecting a passage preserves the source, costs and loot stream")
	passage.find_child("Party_warden", true, false).grab_focus()
	await key(KEY_ENTER)
	await key(KEY_ENTER, false)
	assert(is_instance_valid(passage) and not passage.complete and snapshot() == before, "Enter cannot resolve a doorway before it is reached")
	assert(not root.get_node("GameControls").is_modal_open(), "Focused hero buttons cannot consume Enter while walking")
	passage._process(0.6)
	assert(is_zero_approx(passage.elapsed), "Idle heroes do not progress toward the room")
	await key(KEY_D)
	passage._process(0.8)
	assert(passage.elapsed > 0.7 and not passage.arrived)
	assert(snapshot() == before, "Walking part of a hallway spends no ration and reveals no room")
	await key(KEY_D, false)
	var stopped: float = passage.elapsed
	passage._process(0.5)
	assert(is_equal_approx(passage.elapsed, stopped), "Releasing D stops immediately")
	await key(KEY_A)
	passage._process(0.4)
	assert(passage.elapsed < stopped and passage.elapsed > 0.0, "A walks back along the passage")
	await key(KEY_A, false)
	var backed_up: float = passage.elapsed
	passage._process(0.3)
	assert(is_equal_approx(passage.elapsed, backed_up), "Releasing A stops backward movement")
	await key(KEY_A)
	passage._process(5.0)
	await key(KEY_A, false)
	await settle()
	assert(not is_instance_valid(passage) and not current_scene.traveling and snapshot() == before, "Walking back through the source cancels the route without gameplay effects")
	passage = await open_passage(Vector2i.RIGHT)
	await key(KEY_A)
	await key(KEY_A, false)
	assert(not is_instance_valid(passage) and snapshot() == before, "A at the source exits safely during native input dispatch")

	# A reached encounter may still be backed away from until it is entered.
	passage = await open_passage(Vector2i.RIGHT)
	passage.skip_travel()
	assert(passage.arrived and snapshot() == before)
	await key(KEY_A)
	passage._process(0.5)
	await key(KEY_A, false)
	assert(not passage.arrived and passage.elapsed < passage.duration)
	assert(not passage.travel_stage.get_node("DestinationInteract").visible, "Leaving the doorway hides its action target")
	assert(snapshot() == before)
	# Neither the settings nor the controls guide may advance or resolve a passage.
	var settings = root.get_node("GameSettings")
	settings.open_settings()
	await settle()
	var blocked_at: float = passage.elapsed
	await key(KEY_D)
	passage._process(1.0)
	await key(KEY_D, false)
	assert(is_equal_approx(passage.elapsed, blocked_at) and not passage.footsteps.playing)
	settings.close_settings()
	await settle()
	await key(KEY_I)
	await key(KEY_I, false)
	assert(passage.settings_open(), "The I controls guide blocks movement")
	await key(KEY_D)
	passage._process(1.0)
	await key(KEY_D, false)
	assert(is_equal_approx(passage.elapsed, blocked_at))
	await key(KEY_I)
	await key(KEY_I, false)
	assert(not passage.settings_open())
	passage.find_child("Party_warden", true, false).grab_focus()
	await arrive_and_enter(passage)
	assert(not root.get_node("GameControls").is_modal_open(), "Enter enters the reached encounter even when a hero button has focus")
	assert(State.room_position == Vector2i.RIGHT and State.gold == int(before["gold"]) + 3)
	assert(State.floors[0][Vector2i.RIGHT]["cleared"] and State.floors[0][Vector2i.RIGHT]["corridor_claimed"])
	assert(State.floors[0][Vector2i(2, 0)]["seen"], "Neighbors reveal after the reached room is entered")
	assert(State.journey["steps"] == 6 and State.journey["rations"] == 0)
	assert(State.run_heroes["warden"]["hp"] == 10, "Entering the sixth new space applies its ration recovery once")
	var collected: Dictionary = snapshot()
	passage = await open_passage(Vector2i.ZERO)
	await arrive_and_enter(passage)
	assert(State.room_position == Vector2i.ZERO)
	assert(State.gold == collected["gold"] and State.journey == collected["journey"] and State.run_heroes == collected["heroes"], "Retracing the entrance spends no ration or hunger effect")
	passage = await open_passage(Vector2i.RIGHT)
	await arrive_and_enter(passage)
	assert(State.gold == collected["gold"] and State.journey == collected["journey"])
	assert(State.enter_corridor().is_empty(), "A revisited hallway never awards its coins twice")
	passage = await open_passage(Vector2i(2, 0))
	await arrive_and_enter(passage)
	assert(current_scene.scene_file_path == "res://scenes/combat/combatscene.tscn")
	assert(current_scene.enemies.size() == 1 and current_scene.enemies[0]["accuracy"] == 70)
	assert(State.floors[0][Vector2i(2, 0)]["corridor_surprise"] and State.current_room_kind() == "battle", "The entered roaming creature becomes one weakened battle")

	# Approval agrees on direction while the physical arrival remains authoritative.
	await fixture()
	before = snapshot()
	State.navigation_voters.assign(["local", "remote"])
	assert(not State.authorize_move("intruder", Vector2i.RIGHT))
	current_scene.move_to(Vector2i.RIGHT)
	assert(not current_scene.traveling and snapshot() == before, "An unmatched co-op vote does not launch travel")
	State.navigation_votes.clear()
	assert(not State.authorize_move("remote", Vector2i.RIGHT))
	passage = await open_passage(Vector2i.RIGHT)
	assert(snapshot() == before and State.navigation_votes.is_empty(), "Agreement launches the passage without committing a room")
	passage.return_to_origin()
	await settle()
	assert(snapshot() == before)
	State.navigation_voters.assign(["local"])
	assert(not State.authorize_move("local", Vector2i(2, 0)), "A direction must be adjacent")
	assert(not State.commit_move(Vector2i(9, 0)), "A destination must belong to this floor")
	assert(snapshot() == before)

	# Stale callbacks and changed routes must not move even part of an accepted chain.
	passage = await open_passage(Vector2i.RIGHT)
	State.run_id += "-replacement"
	await arrive_and_enter(passage)
	assert(snapshot() == before and not current_scene.traveling, "A replaced run rejects an old hallway arrival")
	await fixture()
	State.floors[0][Vector2i.RIGHT] = {"kind": "entry", "seen": true, "cleared": true, "travel_counted": true}
	State.floors[0][Vector2i(2, 0)] = {"kind": "treasure", "seen": true, "cleared": false}
	current_scene.refresh()
	passage = await open_passage(Vector2i(2, 0))
	State.floors[0][Vector2i.RIGHT]["cleared"] = false
	before = snapshot()
	await arrive_and_enter(passage)
	assert(snapshot() == before and State.room_position == Vector2i.ZERO, "A changed intermediate room rejects the complete route before its first commit")
	# Consumables used from the modal inventory update the still-open hallway HUD.
	await fixture()
	State.add_item("healing_potion", 1)
	State.add_item("solace_potion", 1)
	State.run_heroes["warden"]["stress"] = 40
	passage = await open_passage(Vector2i.RIGHT)
	var controls = root.get_node("GameControls")
	controls.current_hero = "warden"
	await key(KEY_TAB)
	await key(KEY_TAB, false)
	assert(controls.hero_sheet != null and controls.hero_sheet.inventory_mode and passage.settings_open())
	var old_bar_width: float = passage.hero_summaries["warden"]["bar"].size.x
	controls.hero_sheet.choose_item("healing_potion")
	controls.hero_sheet.choose_item("solace_potion")
	State.gold += 2
	passage._process(0.5)
	assert(is_zero_approx(passage.elapsed) and is_instance_valid(passage), "Inventory interactions preserve the open hallway and pause movement")
	assert(passage.hero_summaries["warden"]["health"].text == "HP %d / %d" % [State.run_heroes["warden"]["hp"], State.hero_max_hp("warden")])
	assert(passage.hero_summaries["warden"]["bar"].size.x > old_bar_width)
	assert(passage.hero_summaries["warden"]["stress"].text == "STRESS %d" % State.run_heroes["warden"]["stress"])
	assert(State.run_heroes["warden"]["stress"] < 40)
	assert(passage.gold_counter.text == "GOLD  %d" % State.gold, "The live footer refreshes health, stress, recovery bar and gold")
	await key(KEY_TAB)
	await key(KEY_TAB, false)
	assert(not passage.settings_open())
	passage.return_to_origin()
	await settle()
	State.end_run()
	preload("res://scripts/settlement_music.gd").stop()
	for slot in [0, 1, 2, 3]: DirAccess.remove_absolute(Saves.path(slot))
	DirAccess.remove_absolute(State.progress_path)
	await create_timer(0.12).timeout
	print("PASS: manual A/D travel, release/retreat, arrival reversal, I/settings/inventory pause, live recovery footer, %d entered passages, once-only corridor gold/rations, retracing, surprised combat, co-op approval and stale-route rejection" % passages_completed)
	quit()
