extends "res://scenes/ui/party_screen.gd"

func _ready() -> void:
	if not State.run_active or State.current_room_kind() != "camp":
		get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
		return
	State.ensure_run_heroes()
	refresh()

func refresh() -> void:
	clear_screen()
	panel(Rect2(0, 0, 1920, 1080), Color("#0F0B10"))
	var backdrop := picture("res://assets/generated/camp_ruins.png", Rect2(0, 0, 1920, 815))
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel(Rect2(520, 45, 880, 265), Color(0.07, 0.05, 0.07, 0.9))
	var heading := label_at("RESPITE IN THE RUINS", Vector2(555, 70), 810, 40)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var used: bool = State.floors[State.floor_index][State.room_position].get("camp_used", false)
	var description := label_at("The fire has burned low. This camp's rest is spent." if used else "Restore 100% health · Clear all debuffs\nReduce current stress by 90%\nOne rest at this camp. Slain heroes cannot be revived.", Vector2(555, 132), 810, 23)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var rest := button_at("REST SPENT" if used else "REST BY THE FIRE", Rect2(750, 240, 420, 55), rest_party)
	rest.name = "RestButton"
	rest.disabled = used
	for index in range(State.party.size()):
		var hero_id: String = State.party[index]
		var x: float = [310.0, 660.0, 1270.0][index]
		picture(str(State.hero(hero_id)["art"]), Rect2(x, 330, 290, 330), 0.35 if State.run_heroes[hero_id].get("dead", false) else 1.0)
		panel(Rect2(x - 5, 680, 300, 105), Color(0.07, 0.05, 0.07, 0.85))
		var state: Dictionary = State.run_heroes[hero_id]
		label_at(str(State.hero(hero_id)["name"]).to_upper(), Vector2(x + 12, 690), 270, 23)
		label_at("%d / %d HP · %d Stress" % [int(state["hp"]), State.hero_max_hp(hero_id), int(state["stress"])], Vector2(x + 12, 730), 270, 20)
	party_bar(leave_camp, "RETURN TO DUNGEON")

func rest_party() -> void:
	if State.rest_at_camp():
		refresh()

func leave_camp() -> void:
	State.floors[State.floor_index][State.room_position]["cleared"] = true
	get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		leave_camp()
