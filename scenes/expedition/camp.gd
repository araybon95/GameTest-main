extends "res://scenes/ui/party_screen.gd"
const Scenery = preload("res://scripts/dungeon_scenery.gd")

func _ready() -> void:
	if not State.run_active or State.current_room_kind() != "camp":
		get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
		return
	State.ensure_run_heroes()
	refresh()
	add_child(preload("res://scenes/expedition/scene_arrival.gd").new())

func refresh() -> void:
	clear_screen()
	panel(Rect2(0, 0, 1920, 1080), Color("#0F0B10"))
	var backdrop := picture(State.floor_background("camp"), Rect2(0, 0, 1920, 815))
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var floor_theme: String = Scenery.theme_for(State.selected_expedition,State.floor_index)
	var ambience = Scenery.new()
	ambience.name = "CampAtmosphere"
	ambience.size = Vector2(1920,815)
	ambience.ground_y = 690.0
	ambience.scene_theme = floor_theme
	ambience.fire_position = {"bandit":Vector2(990,650),"beast":Vector2(990,650),"keep":Vector2(790,455),"medical":Vector2(220,390)}.get(floor_theme,Vector2(990,650))
	ambience.show_foreground = false
	ambience.fire_spent = State.floors[State.floor_index][State.room_position].get("camp_used",false)
	add_child(ambience)
	var whispers: Dictionary = {
		"bandit":"The outlaws used these ruins for shelter. Tonight, the fire belongs to you.",
		"keep":"Beneath the wolf banners, a few stolen hours feel like mercy. Beyond the gate, the old household still keeps its watch.",
		"beast":"Beyond the fire, unseen mouths whisper thanks for the pain. For now, let them pray alone.",
		"medical":"The sickroom is sealed. No wings stir within its lamps. A breath, a bandage, a moment of quiet."
	}
	panel(Rect2(55,70,390,225),Color(0.045,0.035,0.045,0.8))
	label_at("THE FIRE HOLDS",Vector2(80,93),340,23)
	var lore := label_at(str(whispers.get(floor_theme,"The fire offers a moment beyond the dungeon's reach.")),Vector2(80,143),340,20)
	lore.name = "CampLore"
	lore.size = Vector2(340,135)
	lore.clip_text = true
	panel(Rect2(520, 45, 880, 265), Color(0.07, 0.05, 0.07, 0.9))
	var heading := label_at("RESPITE · " + State.floor_title().to_upper(), Vector2(555, 70), 810, 32)
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
		var state: Dictionary = State.run_heroes[hero_id]
		var shadow = preload("res://scenes/combat/ground_shadow.gd").new()
		shadow.position = Vector2(x+140,691)
		add_child(shadow)
		var camper := picture(str(State.hero(hero_id)["camp_art"]), Rect2(x - 20, 410, 330, 280), 0.2 if state.get("dead", false) else 1.0)
		camper.name = "Camper_%s" % hero_id
		camper.texture = Scenery.grounded_texture(str(State.hero(hero_id)["camp_art"]))
		camper.stretch_mode = TextureRect.STRETCH_SCALE
		camper.size = Vector2(280*camper.texture.get_width()/float(camper.texture.get_height()),280)
		camper.position = Vector2(x+140-camper.size.x*.5,410)
		camper.modulate *= Scenery.tint(floor_theme)
		Scenery.apply_hero_palette(camper,hero_id,str(State.hero_colors.get(hero_id,"original")))
		panel(Rect2(x - 5, 700, 300, 98), Color(0.07, 0.05, 0.07, 0.9))
		label_at(str(State.hero(hero_id)["name"]).to_upper(), Vector2(x + 12, 708), 270, 22)
		label_at(str(State.HEROES[hero_id]["name"]),Vector2(x+12,738),270,16)
		label_at("Slain · Remembered at the fire" if state.get("dead",false) else "%d / %d HP · %d Stress" % [int(state["hp"]), State.hero_max_hp(hero_id), int(state["stress"])], Vector2(x + 12, 765), 270, 17)
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
	Scenery.decorate(self)

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
