extends Control

const GameState = preload("res://scripts/game_data.gd")
const FloorEntrance = preload("res://scenes/expedition/floor_entrance.gd")
const ItemButton = preload("res://scenes/ui/item_icon_button.gd")
var inventory_filter: String = "All"
var selected_hero: String = "warden"
var revealed_rooms: Array = []
var map_open: bool = false
var traveling: bool = false
var message: String = "Choose a room on the map. Mysterious chambers hold stories, choices and consequences."

func _ready() -> void:
	if not GameState.run_active:
		get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
		return
	var floor_lore: Array = preload("res://scripts/world_lore.gd").FLOOR_NOTES.get(GameState.selected_expedition.get("id", ""), [])
	if GameState.floor_index < floor_lore.size(): message = str(floor_lore[GameState.floor_index])
	if GameState.selected_expedition.get("id", "") == "infested_apothecary":
		message = "Four chambers: weakened acolytes → camp → Oleander → Exuvia. Clear all three fights to restore the apothecary."
	if not GameState.journey.get("transit",{}).is_empty():
		preload("res://scripts/passage_events.gd").prepare_floor(GameState)
	elif GameState.map_travel_mode: preload("res://scripts/room_discoveries.gd").prepare_floor(GameState)
	else: preload("res://scripts/passage_events.gd").restore_floor(GameState)
	refresh()
	if not GameState.journey.get("transit",{}).is_empty(): resume_map_travel.call_deferred()

func label_at(text: String, pos: Vector2, font_size: int = 24) -> void:
	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.position = pos
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("#EADDD0"))
	add_child(label)

func button_at(text: String, pos: Vector2, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.position = pos
	button.size = Vector2(230, 100)
	button.add_theme_font_size_override("font_size", 22)
	var box := StyleBoxFlat.new()
	box.bg_color = Color("#1B1218")
	box.border_color = Color("#8F4546")
	box.set_border_width_all(2)
	box.set_corner_radius_all(8)
	button.add_theme_stylebox_override("normal", box)
	button.add_theme_stylebox_override("disabled", box)
	button.pressed.connect(action)
	add_child(button)
	return button

func panel_at(rect: Rect2, fill: Color = Color("#21171D")) -> Panel:
	var panel := Panel.new()
	panel.position = rect.position
	panel.size = rect.size
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = Color("#705146")
	style.set_border_width_all(2)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	preload("res://scripts/visual_overlays.gd").frame(panel)
	return panel

func portrait_at(hero_id: String, rect: Rect2) -> void:
	var picture := TextureRect.new()
	picture.texture = load(str(GameState.hero(hero_id)["art"]))
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	picture.position = rect.position
	picture.size = rect.size
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(picture)

func refresh() -> void:
	if traveling:
		# Equipment edits must not rebuild an active passage or reset its progress.
		for child in get_children():
			if child.has_method("refresh_equipment_frames"):
				for id in GameState.party: child.refresh_equipment_frames(id)
		return
	var runtime = get_node_or_null("/root/GameSettings")
	if runtime != null: runtime.checkpoint_pending = true
	if GameState.run_active and GameState.floors[GameState.floor_index][GameState.room_position].get("cleared", false): preload("res://scripts/save_files.gd").save(0)
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for point in GameState.journey.get("recent_discoveries",[]):
		if not revealed_rooms.has(point): revealed_rooms.append(point)
	GameState.journey.erase("recent_discoveries")
	preload("res://scenes/expedition/dungeon_view.gd").build(self)
	preload("res://scripts/dungeon_scenery.gd").decorate(self)

func select_view_hero(id: String) -> void:
	selected_hero = id
	refresh()

func open_inventory() -> void:
	get_node("/root/GameControls").open_hero_sheet(selected_hero,true)

func room_action_available() -> bool:
	return GameState.can_descend() or GameState.merchant_orb_available() or GameState.current_room_kind() == "camp"

func room_action_label() -> String:
	if GameState.can_descend(): return "DESCEND · ENTER"
	if GameState.merchant_orb_available(): return "MERCHANT ORB · ENTER"
	if GameState.current_room_kind() == "camp": return "CAMP · ENTER"
	return "CHOOSE A ROUTE"

func interact_room() -> void:
	if traveling: return
	if GameState.can_descend(): descend()
	elif GameState.merchant_orb_available(): open_shop()
	elif GameState.current_room_kind() == "camp": open_camp()

func inspect_hero(hero_id: String) -> void:
	var controls := get_node_or_null("/root/GameControls")
	if controls != null:
		controls.open_hero_sheet(hero_id)
		return
	if has_node("HeroInspection"):
		get_node("HeroInspection").queue_free()
		remove_child(get_node("HeroInspection"))
	var overlay := Control.new()
	overlay.name = "HeroInspection"
	overlay.size = Vector2(1920, 790)
	add_child(overlay)
	# Reuse builders within a temporary parent; the bottom party bar stays active.
	var previous_children: Array = get_children()
	panel_at(Rect2(12, 12, 1896, 775), Color("#171116"))
	portrait_at(hero_id, Rect2(50, 55, 240, 250))
	var hero: Dictionary = GameState.hero(hero_id)
	var state: Dictionary = GameState.run_heroes.get(hero_id, {})
	label_at(str(hero["name"]).to_upper(), Vector2(60, 325), 24 if hero_id == "crusader" else 32)
	label_at("Level %d · XP %d / %d\nHealth  %d / %d\nStress  %d / 100\nDamage bonus  +%d\nBlock bonus  +%d\nHealing bonus  +%d\n%s" % [GameState.leveling(hero_id)["level"], GameState.leveling(hero_id)["xp"], GameState.xp_required(GameState.leveling(hero_id)["level"]), int(state.get("hp", GameState.hero_max_hp(hero_id))), GameState.hero_max_hp(hero_id), int(state.get("stress", 0)), GameState.hero_bonus(hero_id, "damage"), GameState.hero_bonus(hero_id, "block"), GameState.hero_bonus(hero_id, "heal"), str(state.get("resolve_tag", ""))], Vector2(60, 385), 21)
	label_at("EQUIPMENT", Vector2(390, 55), 28)
	label_at("Trinket bonuses: +%d%% health · +%d%% skill damage · +%d%% accuracy\nBleed resist %d%% · Debuff resist %d%%" % [GameState.equipment_bonus(hero_id, "max_hp_percent"), GameState.equipment_bonus(hero_id, "damage_percent"), GameState.equipment_bonus(hero_id, "accuracy"), GameState.equipment_bonus(hero_id, "bleed_resist"), GameState.equipment_bonus(hero_id, "debuff_resist")], Vector2(390, 720), 17)
	label_at("Select gear in inventory to equip. Click an equipped slot to remove.", Vector2(390, 105), 18)
	for index in range(6):
		var slot_id: String = GameState.Items.SLOTS[index]
		var item_id: String = str(GameState.equipment.get(hero_id, {}).get(slot_id, ""))
		var slot = ItemButton.new()
		slot.configure(item_id)
		slot.position = Vector2(430 + (index % 3) * 235, 150 + (index / 3) * 130)
		slot.size = Vector2(90, 90)
		slot.disabled = item_id == ""
		slot.pressed.connect(remove_equipment.bind(hero_id, slot_id))
		add_child(slot)
		label_at(slot_id.replace("_", " ").capitalize(), slot.position + Vector2(0, 94), 18)
	label_at("PARTY INVENTORY", Vector2(1170, 55), 28)
	label_at("Hover for effects · Click gear to equip / potions to use", Vector2(1170, 108), 19)
	var categories: Array[String] = ["All", "Weapons", "Armor", "Trinkets", "Consumables", "Other"]
	for index in range(categories.size()):
		var category: String = categories[index]
		var filter_button := button_at(("• " if inventory_filter == category else "") + ("Usable" if category == "Consumables" else category), Vector2(1170 + index * 108, 150), filter_inventory.bind(hero_id, category))
		filter_button.size = Vector2(100, 50)
		filter_button.add_theme_font_size_override("font_size", 15)
	panel_at(Rect2(1170, 215, 650, 400), Color("#0D0B0E"))
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(1180, 225)
	scroll.size = Vector2(630, 380)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var inventory_grid := GridContainer.new()
	inventory_grid.columns = 7
	inventory_grid.add_theme_constant_override("h_separation", 8)
	inventory_grid.add_theme_constant_override("v_separation", 8)
	scroll.add_child(inventory_grid)
	for item_id in GameState.inventory:
		var item: Dictionary = GameState.Items.item(item_id)
		var category: String = "Consumables" if item.get("kind", "") in ["scroll", "potion", "provision"] else ("Weapons" if item.get("slot", "") == "weapon" else ("Armor" if item.get("slot", "") in ["armor", "head"] else "Other"))
		if item.get("kind", "") == "trinket":
			category = "Trinkets"
		if inventory_filter != "All" and inventory_filter != category:
			continue
		var icon = ItemButton.new()
		icon.configure(str(item_id), int(GameState.inventory[item_id]))
		# Inspect every item, including scrolls and other-class equipment.
		icon.pressed.connect(choose_inventory_item.bind(hero_id, str(item_id)))
		inventory_grid.add_child(icon)
	if inventory_grid.get_child_count() == 0:
		var empty := Label.new()
		empty.text = "No items in this category."
		empty.add_theme_font_size_override("font_size", 19)
		inventory_grid.add_child(empty)
	label_at("ABILITIES", Vector2(390, 420), 26)
	for index in range(GameState.hero_abilities(hero_id).size()):
		var ability_id: String = GameState.hero_abilities(hero_id)[index]
		var ability: Dictionary = GameState.card_stats(ability_id)
		label_at("%s  ·  %d AP — %s" % [ability["name"], int(ability["cost"]), GameState.card_description(ability)], Vector2(390, 470 + index * 38), 19)
	var close_button := button_at("RETURN TO MAP", Vector2(1500, 660), close_inspection)
	close_button.size = Vector2(300, 75)
	for child in get_children():
		if not previous_children.has(child):
			child.reparent(overlay)

func close_inspection() -> void:
	var controls := get_node_or_null("/root/GameControls")
	if controls != null: controls.close_hero_sheet()
	if has_node("HeroInspection"):
		get_node("HeroInspection").queue_free()

func filter_inventory(hero_id: String, category: String) -> void:
	inventory_filter = category
	inspect_hero(hero_id)

func choose_inventory_item(hero_id: String, item_id: String) -> void:
	var item: Dictionary = GameState.Items.item(item_id)
	if GameState.is_restorative(item_id):
		if GameState.apply_potion(hero_id, item_id, GameState.run_heroes):
			inspect_hero(hero_id)
		return
	if item.get("kind", "") not in ["scroll", "provision"] and (not item.has("hero") or item["hero"] == hero_id):
		equip_from_inventory(hero_id, item_id)
	else:
		var details := AcceptDialog.new()
		details.title = str(item["name"])
		details.dialog_text = GameState.Items.tooltip(item_id)
		add_child(details)
		details.confirmed.connect(func(): details.queue_free())
		details.canceled.connect(func(): details.queue_free())
		details.popup_centered(Vector2i(560, 300))

func equip_from_inventory(hero_id: String, item_id: String) -> void:
	if GameState.equip_item(hero_id, item_id):
		inspect_hero(hero_id)

func remove_equipment(hero_id: String, slot: String) -> void:
	GameState.unequip_item(hero_id, slot)
	inspect_hero(hero_id)

func open_shop() -> void:
	if not GameState.merchant_orb_available():
		return
	get_tree().change_scene_to_file("res://scenes/expedition/merchant_orb_room.tscn")

func open_camp() -> void:
	get_tree().change_scene_to_file("res://scenes/expedition/camp.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_inspection()

func route_to(destination: Vector2i) -> Array:
	if GameState.navigation_voters.size() > 1:
		return [destination] if abs(destination.x - GameState.room_position.x) + abs(destination.y - GameState.room_position.y) == 1 else []
	return preload("res://scripts/dungeon_routes.gd").find(GameState.floors[GameState.floor_index], GameState.room_position, destination)

func move_to(destination: Vector2i) -> void:
	if traveling: return
	if GameState.map_travel_mode:
		var route: Array = route_to(destination)
		if not valid_route(route,GameState.room_position): return
		if not preload("res://scripts/room_discoveries.gd").move(GameState,route):
			message = "The party must agree on the same room before entering."
			return
		map_open = true
		enter_destination(destination)
		return
	if GameState.floors[GameState.floor_index][GameState.room_position].get("cleared", false): preload("res://scripts/save_files.gd").save(0)
	var route: Array = route_to(destination)
	if route.is_empty(): return
	var origin: Vector2i = GameState.room_position
	var departure_floor: int = GameState.floor_index
	var departure_run: String = GameState.run_id
	if not valid_route(route, origin): return
	if not GameState.authorize_move("local", route[0]):
		message = "The party must agree on the same passage before setting out."
		return
	traveling = true
	var passage = preload("res://scenes/expedition/hallway_travel.gd").new()
	passage.route_origin = origin
	passage.route_steps = route.duplicate()
	passage.duration = 5.6 + minf(maxi(route.size() - 1, 0), 5) * 0.7
	add_child(passage)
	await passage.finished
	var reached: bool = passage.reached_destination
	var discovery_action: String = passage.discovery_action
	var investigator: String = passage.investigator
	traveling = false
	# A load, retreat, or floor transition invalidates an old doorway interaction.
	if not GameState.run_active or GameState.run_id != departure_run or GameState.floor_index != departure_floor or GameState.room_position != origin: return
	if not reached:
		message = "Returned to the starting doorway. Choose a passage on the map."
		refresh()
		return
	if not valid_route(route, origin):
		message = "That passage is no longer available. Choose another route."
		refresh()
		return
	for step in route:
		if not GameState.commit_move(step):
			refresh()
			return
	enter_destination(destination,discovery_action,investigator)

func enter_destination(destination: Vector2i, discovery_action: String = "", investigator: String = "") -> void:
	var room: Dictionary = GameState.floors[GameState.floor_index][destination]
	if not discovery_action.is_empty() and room.get("kind","") == "event" and room.has("event_id"):
		var outcome: Dictionary = GameState.Events.resolve(GameState,investigator,discovery_action == "leave",discovery_action)
		if discovery_action == "leave" and not outcome.is_empty():
			message = str(outcome.get("text","Left untouched."))
			refresh()
			return
		if not outcome.is_empty():
			get_tree().change_scene_to_file("res://scenes/expedition/event_room.tscn")
			return
	if room.has("travel_text"): message = str(room["travel_text"])
	if room["cleared"] and not room.has("travel_text"):
		message = "Returned to %s. Choose a connected passage." % str(room.get("name", room["kind"]))
	if not room["cleared"]:
		var corridor: Dictionary = {} if GameState.map_travel_mode else GameState.enter_corridor()
		if corridor.get("kind", "") == "gold":
			message = "Found %d Gold scattered along the hallway." % corridor["amount"]
			refresh()
			return
		match str(room["kind"]):
			"event":
				get_tree().change_scene_to_file("res://scenes/expedition/event_room.tscn")
				return
			"battle", "boss":
				get_tree().change_scene_to_file("res://scenes/combat/combatscene.tscn")
				return
			"treasure":
				GameState.gold += 3
				message = "Recovered 3 Gold from the ruins."
				for item_id in GameState.claim_room_loot():
					message += " Found %s." % GameState.Items.item(item_id)["name"]
			"camp":
				open_camp()
				return
			"stairs":
				message = "Stairs lead deeper. Explore further or descend."
		room["cleared"] = true
	refresh()

func valid_route(route: Array, origin: Vector2i) -> bool:
	if route.is_empty() or not GameState.run_active or GameState.run_complete: return false
	var rooms: Dictionary = GameState.floors[GameState.floor_index]
	if not rooms.has(origin) or not rooms[origin].get("cleared", false): return false
	var previous: Vector2i = origin
	for index in range(route.size()):
		var step: Vector2i = route[index]
		if not rooms.has(step) or not rooms[step].get("seen", false) or abs(step.x - previous.x) + abs(step.y - previous.y) != 1: return false
		if index < route.size() - 1 and not rooms[step].get("cleared", false): return false
		previous = step
	return true

func descend() -> void:
	if not GameState.can_descend() or has_node("FloorEntrancePrompt"):
		return
	var prompt = FloorEntrance.new()
	prompt.on_descend = enter_next_floor
	add_child(prompt)

func enter_next_floor() -> void:
	if GameState.descend():
		message = "The darkness deepens. Find the next passage."
		refresh()

func retreat() -> void:
	GameState.end_run()
	get_tree().change_scene_to_file("res://scenes/expedition/aftermath.tscn")

func scout_area() -> void:
	var before: Array = []
	for point in GameState.floors[GameState.floor_index]:
		if GameState.floors[GameState.floor_index][point].get("seen",false): before.append(point)
	if GameState.scout_area():
		for point in GameState.floors[GameState.floor_index]:
			if GameState.floors[GameState.floor_index][point].get("seen",false) and not before.has(point): revealed_rooms.append(point)
		message = "Scouts reveal nearby encounters. Hover revealed rooms to inspect the danger."
		refresh()

func preview_route(destination: Vector2i) -> void:
	if traveling or not has_node("RouteMap"): return
	var room: Dictionary = GameState.floors[GameState.floor_index].get(destination,{})
	if not room.get("seen",false): return
	var route: Array = route_to(destination)
	get_node("RouteMap").set_route(route)
	get_node("RouteTitle").text = "? · Mysterious Chamber" if room.get("kind","") == "event" and not room.get("cleared",false) else str(room.get("name",str(room.get("kind","Chamber")).capitalize()))
	if room.get("kind","") == "event" and not room.get("cleared",false):
		get_node("RouteDetails").text = "An unknown encounter awaits inside. Select this room to discover its story and choose an outcome."
		return
	var known: String = "Already explored. Retrace a familiar route." if room.get("cleared",false) else GameState.scouting_description(room)
	if room.get("kind","") == "chamber" and not room.get("cleared",false): known = "An unexplored chamber. Select this chamber to explore it."
	get_node("RouteDetails").size.x = 520
	var clue: String = "Select to enter this room directly. Encounters happen inside rooms." if GameState.map_travel_mode else preload("res://scripts/discovery_presentation.gd").route_hint(GameState,GameState.room_position,route)
	get_node("RouteDetails").text = "The route is blocked by an unexplored chamber." if route.is_empty() else "%d passage%s · %s\n\n%s\n\n%s" % [route.size(),"" if route.size() == 1 else "s","Explored" if room.get("cleared",false) else "Unexplored",known,clue]
func resume_map_travel() -> void:
	var passages = preload("res://scripts/passage_events.gd")
	if not passages.valid_transit(GameState):
		GameState.journey.erase("transit")
		if GameState.map_travel_mode: preload("res://scripts/room_discoveries.gd").prepare_floor(GameState)
		message = "That route is no longer available. Choose another room."
		refresh()
		return
	traveling = true
	var travel = preload("res://scenes/expedition/map_travel.gd").new()
	var run: String = GameState.run_id
	var floor: int = GameState.floor_index
	var destination: Vector2i = GameState.journey.transit.route.back()
	# An ambush replaces this scene without emitting finished. Bind completion to
	# this node so freeing it also releases the pending continuation.
	travel.finished.connect(_on_map_travel_finished.bind(travel,run,floor,destination),CONNECT_ONE_SHOT)
	add_child(travel)

func _on_map_travel_finished(travel: Control, run: String, floor: int, destination: Vector2i) -> void:
	traveling = false
	if not GameState.run_active or GameState.run_id != run or GameState.floor_index != floor: return
	if GameState.map_travel_mode: preload("res://scripts/room_discoveries.gd").prepare_floor(GameState)
	if travel.reached_destination:
		enter_destination(destination)
	else:
		message = "The party waits in the last room. Choose another route."
		refresh()

func open_route_map() -> void:
	if traveling: return
	map_open = true
	refresh()

func show_entrance() -> void:
	if traveling: return
	map_open = false
	refresh()
