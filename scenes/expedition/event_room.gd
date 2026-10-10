extends "res://scenes/ui/party_screen.gd"
const Scenery = preload("res://scripts/dungeon_scenery.gd")

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
	add_child(preload("res://scenes/expedition/scene_arrival.gd").new())

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
	else:
		background = Scenery.stage_path(background)
	var backdrop := picture(background, Rect2(0, 0, 1920, 815))
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var floor_theme: String = Scenery.theme_for(State.selected_expedition,State.floor_index)
	var ambience = Scenery.new()
	ambience.name = "EventAtmosphere"
	ambience.size = Vector2(1920,815)
	ambience.ground_y = 690.0
	ambience.scene_theme = floor_theme
	ambience.show_foreground = false
	add_child(ambience)
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
			var supply := button_at("USE %s ×%d" % [State.Items.item(supply_id)["name"],State.inventory.get(supply_id,0)], Rect2(1090,740,730,50), investigate_with_supply)
			supply.disabled = int(State.inventory.get(supply_id,0)) <= 0 or selected_hero.is_empty() or (id == "crusader_coffin" and int(State.run_heroes.get(selected_hero,{}).get("hp",0)) <= 1)
			supply.tooltip_text = "Bandages reduce the coffin opening damage to 1 HP." if id == "crusader_coffin" else "Consume this supply for a guaranteed reward without a harmful effect."
	if not selected_hero.is_empty():
		var hero_shadow = preload("res://scenes/combat/ground_shadow.gd").new()
		hero_shadow.position = Vector2(875,690)
		add_child(hero_shadow)
		var investigator := picture(str(State.hero(selected_hero)["art"]),Rect2(740,320,270,370))
		investigator.name = "Investigator"
		investigator.texture = Scenery.grounded_texture(str(State.hero(selected_hero)["art"]))
		investigator.stretch_mode = TextureRect.STRETCH_SCALE
		investigator.size = Vector2(370*investigator.texture.get_width()/float(investigator.texture.get_height()),370)
		investigator.position = Vector2(875-investigator.size.x*.5,320)
		investigator.modulate = Scenery.tint(floor_theme)
		Scenery.apply_hero_palette(investigator,selected_hero,str(State.hero_colors.get(selected_hero,"original")))
		label_at(str(State.hero(selected_hero)["name"]),Vector2(720,705),310,23).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_at(str(State.HEROES[selected_hero]["name"]),Vector2(720,738),310,17).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var prop_shadow = preload("res://scenes/combat/ground_shadow.gd").new()
	prop_shadow.position = Vector2(1450,690)
	add_child(prop_shadow)
	var object_button := button_at("", Rect2(1110, 180, 710, 540), investigate)
	object_button.name = "EventObject"
	object_button.disabled = resolved or selected_hero == "" or (id == "crusader_coffin" and int(State.run_heroes[selected_hero]["hp"]) <= 3)
	object_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	# The silhouette is the hover target; a rectangular button fill would hide the room.
	for state in ["normal", "disabled", "pressed", "hover", "focus"]:
		object_button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	var prop := picture("res://assets/generated/event_%s.png" % id, Rect2(1240, 250, 420, 440))
	prop.name = "EventProp"
	prop.texture = Scenery.grounded_texture("res://assets/generated/event_%s.png" % id,4)
	# Supply crates and chests sit below shoulder height; shrines and the coffin can stand tall.
	var max_prop_height: float = 270.0 if id in ["bandit_strongbox","bandit_supplies"] else 430.0
	var max_prop_width: float = 380.0 if id in ["bandit_strongbox","bandit_supplies"] else 520.0
	var prop_height: float = minf(max_prop_height,max_prop_width*prop.texture.get_height()/float(prop.texture.get_width()))
	prop.size = Vector2(prop_height*prop.texture.get_width()/float(prop.texture.get_height()),prop_height)
	prop.position = Vector2(1450-prop.size.x*.5,690-prop_height)
	prop.stretch_mode = TextureRect.STRETCH_SCALE
	var highlight := ShaderMaterial.new()
	highlight.shader = preload("res://assets/shaders/curio_highlight.gdshader")
	highlight.set_shader_parameter("glow_color",Color("#DE718B") if floor_theme == "beast" else Color("#BDD28F") if floor_theme == "medical" else Color("#E9C071"))
	highlight.set_shader_parameter("strength",0.0 if resolved else 0.25)
	prop.material = highlight
	object_button.mouse_entered.connect(func(): highlight.set_shader_parameter("strength",0.0 if resolved else 0.9))
	object_button.mouse_exited.connect(func(): highlight.set_shader_parameter("strength",0.0 if resolved else 0.25))
	object_button.focus_entered.connect(func(): highlight.set_shader_parameter("strength",0.0 if resolved else 0.9))
	object_button.focus_exited.connect(func(): highlight.set_shader_parameter("strength",0.0 if resolved else 0.25))
	prop.modulate.a = 0.6 if resolved else 1.0
	label_at("Event resolved" if resolved else "Click the object to investigate", Vector2(1090, 705), 730, 24).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	party_bar(return_to_dungeon if resolved else leave_untouched, "RETURN TO DUNGEON" if resolved else "LEAVE UNTOUCHED")
	Scenery.decorate(self)

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
