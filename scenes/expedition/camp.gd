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
	var backdrop := picture(State.floor_background("camp"), Rect2(0, 0, 1920, 815))
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel(Rect2(520, 45, 880, 265), Color(0.07, 0.05, 0.07, 0.9))
	var heading := label_at("RESPITE · " + str(State.selected_expedition.get("region", "The Ruins")).to_upper(), Vector2(555, 70), 810, 32)
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
		picture(str(State.hero(hero_id)["camp_art"]), Rect2(x - 20, 410, 330, 270), 0.35 if State.run_heroes[hero_id].get("dead", false) else 1.0)
		panel(Rect2(x - 5, 680, 300, 105), Color(0.07, 0.05, 0.07, 0.85))
		var state: Dictionary = State.run_heroes[hero_id]
		label_at(str(State.hero(hero_id)["name"]).to_upper(), Vector2(x + 12, 690), 270, 23)
		label_at("%d / %d HP · %d Stress" % [int(state["hp"]), State.hero_max_hp(hero_id), int(state["stress"])], Vector2(x + 12, 730), 270, 20)
	var room: Dictionary = State.floors[State.floor_index][State.room_position]
	label_at("CAMP PREPARATION · %d / 3 POINTS · %s" % [int(room.get("camp_points",3)),"Watch posted: ambush prevented" if room.get("camp_choices",[]).has("watch") else "Unguarded rests have a 15% ambush risk"],Vector2(330,315),1400,22)
	var choices: Array = State.Depth.CAMP_CHOICES.keys()
	for index in range(choices.size()):
		var id: String = choices[index]
		var entry: Dictionary = State.Depth.CAMP_CHOICES[id]
		var skill := button_at("%s%s · %d %s" % ["✓ " if room.get("camp_choices",[]).has(id) else "",entry["name"],entry["cost"],"POINT" if entry["cost"] == 1 else "POINTS"],Rect2(270 + index * 350,350,335,50),prepare.bind(id))
		skill.add_theme_font_size_override("font_size",20)
		skill.disabled = not used or room.get("camp_choices",[]).has(id) or int(room.get("camp_points",3)) < int(entry["cost"])
		skill.tooltip_text = entry["description"]
	party_bar(leave_camp, "RETURN TO DUNGEON")

func rest_party() -> void:
	if State.rest_at_camp():
		refresh()

func prepare(id: String) -> void:
	if State.Depth.prepare_camp(State,id): refresh()

func leave_camp() -> void:
	if State.Depth.camp_ambush(State):
		get_tree().change_scene_to_file("res://scenes/combat/combatscene.tscn")
		return
	State.floors[State.floor_index][State.room_position]["cleared"] = true
	get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		leave_camp()
