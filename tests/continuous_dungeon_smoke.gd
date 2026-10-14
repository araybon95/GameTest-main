extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	await process_frame
	await process_frame

func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	State.map_travel_mode = false # Explicit legacy-walking fixture.
	State.progress_loaded = true
	State.progress_path = "user://continuous_dungeon_progress.cfg"
	State.party.assign(["warden","ranger","occultist"])
	assert(State.select_expedition("old_road"))
	State.start_run(42)
	State.floors[0] = {
		Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true,"travel_counted":true},
		Vector2i.RIGHT:{"kind":"battle","cleared":false,"seen":true,"enemies":["ash_raider"]}
	}
	assert(change_scene_to_file("res://scenes/expedition/dungeon.tscn") == OK)
	await settle()
	var room = current_scene.get_node("RoomView")
	assert(room.room_mode and not room.destination_button.disabled == current_scene.room_action_available())
	assert(is_equal_approx(room.source_door.position.y+room.source_door.size.y,Travel.GROUND_Y))
	assert(is_equal_approx(room.encounter.position.y+room.encounter.size.y,Travel.GROUND_Y))
	assert(current_scene.get_node("DungeonMap").compact)
	var rng: int = State.loot_rng.state
	current_scene.get_node("Party_ranger").pressed.emit()
	await settle()
	assert(current_scene.selected_hero == "ranger")
	current_scene.open_inventory()
	await settle()
	assert(root.get_node("GameControls").hero_sheet.hero_id == "ranger")
	root.get_node("GameControls").close_hero_sheet()
	assert(State.loot_rng.state == rng, "Inspecting a room and inventory cannot reroll loot")
	preload("res://scripts/local_dungeon_art.gd").configure("C:/missing-dungeon-art",false)
	current_scene.get_node("Room_1_0").pressed.emit()
	await settle()
	var travel = current_scene.get_node("HallwayTravel")
	assert(current_scene.traveling and not travel.room_mode)
	assert(travel.hero_summaries["warden"]["health"].position.y >= 840 and travel.hero_summaries["warden"]["health"].position.y < 963)
	travel.skip_travel()
	travel.interact_destination()
	await create_timer(0.22).timeout
	await settle()
	assert(current_scene.has_method("_play_card"))
	assert(current_scene.GROUND_Y == Travel.GROUND_Y)
	assert(current_scene.get_node("BattlefieldBackdrop/BattlefieldLayers").background.texture.resource_path.ends_with("rooms/bandit_combat.png"), "Combat uses the independent themed room backdrop without a local installation")
	assert(current_scene.journey_map.visible and not current_scene.journey_log.visible)
	current_scene.toggle_journey_panel()
	assert(not current_scene.journey_map.visible and current_scene.journey_log.visible)
	current_scene.toggle_journey_panel()
	assert(current_scene.journey_map.visible)
	current_scene.get_node("JourneyTabITEMS").pressed.emit()
	await settle()
	assert(root.get_node("GameControls").hero_sheet.inventory_mode)
	assert(State.room_position == Vector2i.RIGHT)
	print("PASS: continuous room, compact routes, selected hero inventory, grounded doorways, hallway entry, combat map/log/items")
	quit()
