extends SceneTree
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("run")

func event_location() -> Vector2i:
	for location in State.floors[0]:
		if State.floors[0][location]["kind"] == "event":
			return location
	return Vector2i(-1, -1)

func run() -> void:
	for id in ["old_road", "path_beast"]:
		State.select_expedition(id)
		for seed_value in range(100):
			State.start_run(seed_value)
			for rooms in State.floors:
				var events: int = 0
				for room in rooms.values():
					if room["kind"] == "event":
						events += 1
						assert(State.Events.pool(str(State.selected_expedition.get("faction", ""))).has(room["event_id"]) or (id == "old_road" and State.floors.find(rooms) == 1 and room["event_id"] == "crusader_coffin"))
				assert(events >= 3 and events <= 5)
	State.start_run(12)
	State.room_position = event_location()
	var room: Dictionary = State.floors[0][State.room_position]
	var location: Vector2i = State.room_position
	var original: Dictionary = room.duplicate(true)
	var saw_gold: bool = false
	var saw_item: bool = false
	var saw_curse: bool = false
	for seed_value in range(200):
		State.floors[0][location] = original.duplicate(true)
		State.floors[0][location]["event_seed"] = seed_value
		for hero in State.run_heroes.values():
			hero["statuses"].clear()
		var result: Dictionary = State.Events.resolve(State, "ranger")
		saw_gold = saw_gold or int(result["gold"]) > 0
		saw_item = saw_item or result["item"] != ""
		saw_curse = saw_curse or result["status"] != ""
		assert(State.run_heroes["warden"]["statuses"].is_empty())
		assert(State.run_heroes["occultist"]["statuses"].is_empty())
		var gold: int = State.gold
		assert(State.Events.resolve(State, "ranger").is_empty())
		assert(State.gold == gold)
	assert(saw_gold and saw_item and saw_curse)
	State.floors[0][location] = original.duplicate(true)
	State.run_heroes["warden"]["dead"] = true
	assert(State.Events.resolve(State, "warden").is_empty())
	assert(State.Events.resolve(State, "outsider").is_empty())
	var inventory: Dictionary = State.inventory.duplicate()
	var gold: int = State.gold
	assert(State.Events.resolve(State, "", true)["left"])
	assert(State.gold == gold and State.inventory == inventory)
	State.run_heroes["warden"]["dead"] = false
	State.floors[0][location] = original.duplicate(true)
	for seed_value in range(200):
		State.floors[0][location]["event_seed"] = seed_value
		var result: Dictionary = State.Events.resolve(State, "ranger")
		if result["status"] != "":
			break
		State.floors[0][location] = original.duplicate(true)
	var status: String = State.floors[0][location]["event_result"]["status"]
	assert(status != "")
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	await process_frame
	assert(combat.hero_state["ranger"]["statuses"].has(status))
	assert(combat.hero_state["warden"]["statuses"].is_empty())
	combat.queue_free()
	await process_frame
	State.floors[0][location] = original.duplicate(true)
	var event = load("res://scenes/expedition/event_room.tscn").instantiate()
	root.add_child(event)
	await process_frame
	event.select_hero("ranger")
	event.get_node("EventObject").pressed.emit()
	assert(State.floors[0][location]["event_resolved"])
	assert(event.get_node("EventObject").disabled)
	event.queue_free()
	await process_frame
	print("PASS: themed events across 200 dungeon seeds, gold/items/curses, hero isolation, one-use and safe leave, combat persistence, clickable event scene")
	quit()
