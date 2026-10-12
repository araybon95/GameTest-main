extends RefCounted
## Builds the settled room using the same stage as walking passages.
const State = preload("res://scripts/game_data.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
const Map = preload("res://scenes/expedition/dungeon_map.gd")

static func build(owner: Control) -> void:
	owner.panel_at(Rect2(0,0,1920,1080),Color("#09080A")).get_node("IronFittings").hide()
	var view = Travel.new()
	view.room_mode = true
	view.route_origin = State.room_position
	owner.add_child(view)
	view.name = "RoomView"
	view.build_exploration_frame()
	view.room_interaction.connect(owner.interact_room)
	view.destination_button.disabled = not owner.room_action_available()
	view.destination_button.tooltip_text = owner.room_action_label()
	owner.label_at("%s · %s" % [State.selected_expedition.get("name","Expedition"),State.floor_title()],Vector2(55,28),28)
	owner.panel_at(Rect2(1120,775,775,202),Color("#100E10"))
	var id: String = owner.selected_hero
	if not State.party.has(id): id = str(State.party[0])
	owner.selected_hero = id
	var hero: Dictionary = State.hero(id)
	var stats: Dictionary = State.run_heroes.get(id,{})
	owner.label_at("%s · %s" % [hero["name"],hero["class"]],Vector2(55,865),24)
	owner.label_at("HP %d / %d   STRESS %d   GOLD %d   RATIONS %d" % [stats.get("hp",State.hero_max_hp(id)),State.hero_max_hp(id),stats.get("stress",0),State.gold,State.journey.get("rations",0)],Vector2(55,908),20)
	owner.label_at("Choose a route · W / Enter interacts · Tab inventory · I controls",Vector2(55,1048),15)
	for index in range(State.party.size()):
		var hero_id: String = str(State.party[index])
		var member: Dictionary = State.run_heroes.get(hero_id,{})
		var button: Button = owner.button_at("%s · %s\n%s" % [State.hero(hero_id)["name"],State.hero(hero_id)["class"],"Slain" if member.get("dead",false) else "HP %d · Stress %d" % [member.get("hp",0),member.get("stress",0)]],Vector2(55+index*245,974),owner.select_view_hero.bind(hero_id))
		button.name = "Party_"+hero_id
		button.set_meta("hero_id",hero_id)
		button.size = Vector2(235,60)
		button.add_theme_font_size_override("font_size",16)
		if hero_id == id: button.add_theme_color_override("font_color",Color("#FFE0A0"))
	var inventory: Button = owner.button_at("INVENTORY · TAB",Vector2(800,974),owner.open_inventory)
	inventory.size = Vector2(270,60)
	owner.label_at("ROUTE · FLOOR %d / %d" % [State.floor_index+1,State.floor_count],Vector2(1150,783),20)
	var map = Map.new()
	map.name = "DungeonMap"
	map.position = Vector2(1145,835)
	map.size = Vector2(720,130)
	map.compact = true
	owner.add_child(map)
	var rooms: Dictionary = State.floors[State.floor_index]
	var revealed: int = 0
	var cleared: int = 0
	for room in rooms.values():
		if room.get("seen",false): revealed += 1
		if room.get("cleared",false): cleared += 1
	owner.label_at("CLEARED %d%%   EXPLORED %d%%" % [int(100.0*cleared/rooms.size()),int(100.0*revealed/rooms.size())],Vector2(1150,815),15)
	for location in rooms:
		var room: Dictionary = rooms[location]
		if not room.get("seen",false): continue
		var rect: Rect2 = map.room_rect(location)
		var button: Button = owner.button_at("",map.position+rect.position,owner.move_to.bind(location))
		button.name = "Room_%d_%d" % [location.x,location.y]
		button.size = rect.size
		for state in ["normal","disabled","pressed"]: button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
		var hover := StyleBoxFlat.new()
		hover.bg_color = Color(0.85,0.7,0.45,0.18)
		hover.border_color = Color("#FFE0A0")
		hover.set_border_width_all(2)
		button.add_theme_stylebox_override("hover",hover)
		button.tooltip_text = "%s · %s\n%s" % [str(room.get("name",str(room["kind"]).capitalize())),"Cleared" if room.get("cleared",false) else "Unexplored",State.scouting_description(room)]
		button.disabled = location == State.room_position or State.run_complete or owner.route_to(location).is_empty()
	var scout: Button = owner.button_at("SCOUT · %d" % State.scout_uses,Vector2(1150,985),owner.scout_area)
	scout.size = Vector2(180,45)
	scout.disabled = State.scout_uses <= 0 or State.run_complete or not rooms[State.room_position].get("cleared",false)
	var interact: Button = owner.button_at(owner.room_action_label(),Vector2(1340,985),owner.interact_room)
	interact.size = Vector2(285,45)
	interact.disabled = not owner.room_action_available()
	var retreat: Button = owner.button_at("HAMLET" if State.run_complete else "RETREAT",Vector2(1640,985),owner.retreat)
	retreat.size = Vector2(220,45)
	var note := Label.new()
	note.text = owner.message if not State.run_complete else ("VICTORY — the Apothecary is restored. Return to the Hamlet to purchase remedies." if State.selected_expedition.get("id","") == "infested_apothecary" else "VICTORY — the guardian has fallen. Return to the Hamlet.")
	note.position = Vector2(55,790)
	note.size = Vector2(1030,60)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.add_theme_font_size_override("font_size",18)
	note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	owner.add_child(note)
