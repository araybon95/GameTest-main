extends "res://scenes/ui/party_screen.gd"

func _ready() -> void:
	State.load_progression()
	refresh()

func refresh() -> void:
	clear_screen()
	var id: String = State.pending_service
	var service: Dictionary = State.Mechanics.SERVICES[id]
	var unlocked: bool = State.service_unlocked(id)
	preload("res://scripts/static_screen_art.gd").install(self,"apothecary" if id == "infirmary" else id,unlocked)
	preload("res://scripts/static_screen_art.gd").transition(self)
	panel(Rect2(440, 175, 1430, 605), Color(0.07, 0.05, 0.07, 0.94))
	label_at(str(service["name"]).to_upper(), Vector2(85, 70), 1720, 42)
	label_at("RESTORED · GOLD %d" % State.gold if unlocked else "RESTORATION QUEST · THREE ROOMS · TWO FIGHTS AND A CAMP", Vector2(85, 145), 1720, 24)
	label_at(str(service["description"]), Vector2(475, 200), 1320, 23).size = Vector2(1320, 110)
	if not unlocked:
		for index in range(2):
			var creature: Dictionary = State.creature(str(service["enemy"] if index == 0 else service["boss"]))
			picture(str(creature["art"]), Rect2(500 + index * 600, 315, 360, 300))
			label_at(str(creature["name"]), Vector2(470 + index * 600, 630), 460, 26)
		button_at("PREPARE RESTORATION PARTY", Rect2(550, 700, 900, 55), prepare_quest)
	elif id == "watchtower":
		label_at("Scouts reveal encounter details within two rooms automatically.\nEach floor also provides three scouting uses, reaching three rooms away.\nInspect scouted rooms on the dungeon map to plan the route.", Vector2(475, 365), 1320, 28)
	elif id == "infirmary":
		label_at("Physicians provide affordable recovery supplies for your next expedition.", Vector2(475, 340), 1320, 26)
		button_at("2 HEALING POTIONS · 12 GOLD", Rect2(480, 455, 630, 90), buy_care.bind("healing_potion", 2, 12))
		button_at("CLEANSING POTION · 8 GOLD", Rect2(1160, 455, 630, 90), buy_care.bind("cleansing_potion", 1, 8))
	else:
		button_at("NAME & COLORS", Rect2(1440, 145, 370, 55), customize)
		label_at("Choose one modification per owned equipment design: Keen +1 damage or Fortified +2 Block. Costs 12 gold.", Vector2(475, 300), 1320, 22)
		var scroll := ScrollContainer.new()
		scroll.position = Vector2(475, 365)
		scroll.size = Vector2(1320, 365)
		add_child(scroll)
		var list := VBoxContainer.new()
		list.custom_minimum_size.x = 1270
		scroll.add_child(list)
		var owned: Array = State.inventory.keys()
		for loadout in State.equipment.values():
			for item_id in loadout.values():
				if not owned.has(item_id): owned.append(item_id)
		for item_id in owned:
			if not State.Items.EQUIPMENT.has(State.Items.base_id(item_id)): continue
			var row := HBoxContainer.new()
			row.custom_minimum_size.y = 75
			list.add_child(row)
			var title := Label.new()
			title.text = str(State.Items.item(item_id)["name"]) + " · " + str(State.modifications.get(item_id, "Unmodified"))
			title.custom_minimum_size.x = 600
			title.add_theme_font_size_override("font_size", 24)
			row.add_child(title)
			for mode in ["keen", "fortified"]:
				var button := Button.new()
				button.text = mode.capitalize() + " · 12 GOLD"
				button.custom_minimum_size = Vector2(320, 65)
				button.disabled = State.gold < 12 or State.modifications.has(item_id)
				button.pressed.connect(modify.bind(str(item_id), mode))
				row.add_child(button)
		if list.get_child_count() == 0:
			var empty := Label.new()
			empty.text = "Purchase or loot equipment, then return here to modify it."
			list.add_child(empty)
	party_bar(return_to_hamlet, "RETURN TO HAMLET")

func prepare_quest() -> void:
	if State.select_expedition(str(State.Mechanics.SERVICES[State.pending_service]["quest"])):
		get_tree().change_scene_to_file("res://scenes/expedition/preparation.tscn")

func buy_care(item_id: String, amount: int, price: int) -> void:
	if State.service_unlocked("infirmary") and State.gold >= price:
		State.gold -= price
		State.add_item(item_id, amount)
		refresh()

func modify(item_id: String, mode: String) -> void:
	if State.modify_equipment(item_id, mode): refresh()

func return_to_hamlet() -> void:
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): return_to_hamlet()

func customize() -> void:
	if State.service_unlocked("workshop"):
		get_tree().change_scene_to_file("res://scenes/hub/customization.tscn")
