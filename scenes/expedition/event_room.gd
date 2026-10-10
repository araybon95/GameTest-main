extends "res://scenes/ui/party_screen.gd"

var selected_hero: String = ""

func _ready() -> void:
	if not State.run_active or State.current_room_kind() != "event":
		get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn")
		return
	State.ensure_run_heroes()
	for id in State.party:
		if not State.run_heroes[id].get("dead", false) and int(State.run_heroes[id]["hp"]) > 0:
			selected_hero = id
			break
	refresh()

func refresh() -> void:
	clear_screen()
	var room: Dictionary = State.floors[State.floor_index][State.room_position]
	var id: String = str(room["event_id"])
	var event: Dictionary = State.Events.definition(id)
	var resolved: bool = room.get("event_resolved", false)
	var corridor: bool = room.get("event_layout", "room") == "corridor"
	var background: String = State.floor_background("combat")
	if corridor and not (State.selected_expedition.get("id", "") == "old_road" and State.floor_index > 0):
		background = "res://assets/generated/event_%s_corridor.png" % ("beast" if State.selected_expedition.get("faction", "") == "remade" else "bandit")
	var backdrop := picture(background, Rect2(0, 0, 1920, 815))
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel(Rect2(35, 35, 620, 735), Color(0.06, 0.04, 0.06, 0.94))
	label_at("? · CORRIDOR EVENT" if corridor else "? · ROOM EVENT", Vector2(65, 60), 560, 24)
	label_at(str(event["name"]), Vector2(65, 115), 560, 35).size = Vector2(560, 90)
	var description := label_at(str(event["description"]), Vector2(65, 220), 560, 24)
	description.size = Vector2(560, 140)
	description.clip_text = true
	var outcome := label_at(str(room["event_result"]["text"]) if resolved else str(event["risk"]), Vector2(65, 380), 560, 23)
	outcome.size = Vector2(560, 160)
	outcome.clip_text = true
	if not resolved:
		label_at("CHOOSE WHO INVESTIGATES", Vector2(65, 555), 560, 21)
		for index in range(State.party.size()):
			var hero_id: String = State.party[index]
			var choose := button_at(("▶ " if hero_id == selected_hero else "") + str(State.hero(hero_id)["name"]), Rect2(65 + index * 183, 600, 175, 55), select_hero.bind(hero_id))
			choose.add_theme_font_size_override("font_size", 20)
			choose.disabled = State.run_heroes[hero_id].get("dead", false) or int(State.run_heroes[hero_id]["hp"]) <= 0
			choose.tooltip_text = "Any harmful outcome affects this hero only."
		var option: Dictionary = State.Mechanics.event_option(id, selected_hero)
		if not option.is_empty():
			var special := button_at(str(option["name"]).to_upper(), Rect2(65, 670, 560, 50), investigate_as_class)
			special.add_theme_font_size_override("font_size", 20)
			special.disabled = int(State.run_heroes[selected_hero]["hp"]) <= int(option["cost"])
			label_at(str(option["risk"]), Vector2(65, 728), 560, 17)
		var supply_id: String = State.Depth.EVENT_SUPPLIES.get(id, "")
		if supply_id != "":
			var supply := button_at("USE %s ×%d" % [State.Items.item(supply_id)["name"],State.inventory.get(supply_id,0)], Rect2(760,740,930,50), investigate_with_supply)
			supply.disabled = int(State.inventory.get(supply_id,0)) <= 0 or selected_hero.is_empty() or (id == "crusader_coffin" and int(State.run_heroes.get(selected_hero,{}).get("hp",0)) <= 1)
			supply.tooltip_text = "Bandages reduce the coffin opening damage to 1 HP." if id == "crusader_coffin" else "Consume this supply for a guaranteed reward without a harmful effect."
	var object_button := button_at("", Rect2(760, 150, 930, 560), investigate)
	object_button.name = "EventObject"
	object_button.disabled = resolved or selected_hero == "" or (id == "crusader_coffin" and int(State.run_heroes[selected_hero]["hp"]) <= 3)
	object_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	object_button.tooltip_text = "Investigate as " + str(State.hero(selected_hero).get("name", "a hero"))
	for state in ["normal", "disabled", "pressed"]:
		object_button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	var prop := picture("res://assets/generated/event_%s.png" % id, Rect2(885, 180, 680, 480))
	prop.modulate.a = 0.6 if resolved else 1.0
	label_at("Event resolved" if resolved else "Click the object to investigate", Vector2(930, 715), 650, 27)
	party_bar(return_to_dungeon if resolved else leave_untouched, "RETURN TO DUNGEON" if resolved else "LEAVE UNTOUCHED")

func select_hero(id: String) -> void:
	selected_hero = id
	refresh()

func investigate() -> void:
	if not State.Events.resolve(State, selected_hero).is_empty():
		refresh()

func leave_untouched() -> void:
	State.Events.resolve(State, "", true)
	return_to_dungeon()

func investigate_as_class() -> void:
	if not State.Events.resolve(State, selected_hero, false, "class").is_empty():
		refresh()

func return_to_dungeon() -> void:
	get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		leave_untouched()

func investigate_with_supply() -> void:
	if not State.Events.resolve(State,selected_hero,false,"supply").is_empty(): refresh()
