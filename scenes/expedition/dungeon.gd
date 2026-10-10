extends Control

const GameState = preload("res://scripts/game_data.gd")
const FloorEntrance = preload("res://scenes/expedition/floor_entrance.gd")
const ItemButton = preload("res://scenes/ui/item_icon_button.gd")
var inventory_filter: String = "All"
var traveling: bool = false
var message: String = "Choose a connected room. Cleared routes can be crossed in one click. Find the stairs and descend."

func _ready() -> void:
	if not GameState.run_active:
		get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
		return
	var floor_lore: Array = preload("res://scripts/world_lore.gd").FLOOR_NOTES.get(GameState.selected_expedition.get("id", ""), [])
	if GameState.floor_index < floor_lore.size(): message = str(floor_lore[GameState.floor_index])
	if GameState.selected_expedition.get("id", "") == "infested_apothecary":
		message = "Four chambers: weakened acolytes → camp → Oleander → Exuvia. Clear all three fights to restore the apothecary."
	refresh()

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
	var runtime = get_node_or_null("/root/GameSettings")
	if runtime != null: runtime.checkpoint_pending = true
	if GameState.run_active and GameState.floors[GameState.floor_index][GameState.room_position].get("cleared", false): preload("res://scripts/save_files.gd").save(0)
	for child in get_children():
		remove_child(child)
		child.queue_free()
	panel_at(Rect2(0, 0, 1920, 1080), Color("#09080A"))
	panel_at(Rect2(12, 12, 1896, 775), Color("#0D0B0E"))
	label_at("%s  ·  FLOOR %d / %d" % [GameState.selected_expedition.get("name", "Expedition"), GameState.floor_index + 1, GameState.floor_count], Vector2(40, 25), 30)
	label_at(GameState.floor_title(), Vector2(1390, 32), 22)
	var victory_message: String = "VICTORY — the Apothecary is restored! Return to the Hamlet to purchase remedies." if GameState.selected_expedition.get("id", "") == "infested_apothecary" else "VICTORY — the guardian has fallen. Return to the Hamlet."
	label_at(message if not GameState.run_complete else victory_message, Vector2(40, 75), 20)
	var rooms: Dictionary = GameState.floors[GameState.floor_index]
	var map = preload("res://scenes/expedition/dungeon_map.gd").new()
	map.name = "DungeonMap"
	map.position = Vector2(230, 115)
	map.size = Vector2(1500, 620)
	map.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(map)
	var revealed: int = 0
	var cleared: int = 0
	for location in rooms:
		var room: Dictionary = rooms[location]
		if room["cleared"]:
			cleared += 1
		if not room["seen"]:
			continue
		revealed += 1
		var current: bool = location == GameState.room_position
		var rect: Rect2 = map.room_rect(location)
		var button := button_at("", map.position + rect.position, move_to.bind(location))
		button.name = "Room_%d_%d" % [location.x, location.y]
		button.size = rect.size
		button.flat = true
		for state in ["normal", "disabled", "pressed"]:
			button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
		var hover := StyleBoxFlat.new()
		hover.bg_color = Color(0.85, 0.7, 0.45, 0.12)
		hover.border_color = Color("#D3AF72")
		hover.set_border_width_all(2)
		button.add_theme_stylebox_override("hover", hover)
		button.tooltip_text = str(room.get("name", str(room["kind"]).capitalize())) + (" · Cleared" if room["cleared"] else " · Unexplored") + (" · Merchant orb" if room.get("merchant_orb", false) else "")
		if room["kind"] == "event":
			button.tooltip_text = "? · " + str(room.get("event_layout", "room")).capitalize() + " event" + (" · Resolved" if room["cleared"] else " · Unexplored")
		button.tooltip_text += "\n" + GameState.scouting_description(room)
		button.disabled = current or GameState.run_complete or route_to(location).is_empty()
	label_at("Blades: battle    Ringed blades: boss    Chest: treasure    Flame: camp    Blue orb: merchant    Steps: descend    ?: random event", Vector2(40, 742), 18)
	panel_at(Rect2(12, 790, 1896, 278))
	label_at("CLEARED %d%%" % int(100.0 * cleared / rooms.size()), Vector2(45, 810), 22)
	var scout := button_at("SCOUT AREA · %d" % GameState.scout_uses, Vector2(295, 935), scout_area)
	scout.size = Vector2(230, 100)
	scout.tooltip_text = "Reveal encounters within two rooms (three with a restored Watchtower). Hover scouted rooms for their enemies or event risks. Optional; no gold cost."
	scout.disabled = GameState.scout_uses <= 0 or not rooms[GameState.room_position]["cleared"] or GameState.run_complete
	label_at("EXPLORED %d%%" % int(100.0 * revealed / rooms.size()), Vector2(1600, 810), 22)
	label_at("GOLD  %d" % GameState.gold, Vector2(45, 865), 24)
	label_at("RATIONS %d + %d · Food is used every 6 new spaces" % [int(GameState.journey.get("rations",0)),int(GameState.inventory.get("trail_food",0))],Vector2(45,1035),17)
	var retreat_button := button_at("RETURN TO HAMLET" if GameState.run_complete else "RETREAT", Vector2(45, 935), retreat)
	retreat_button.size = Vector2(270, 70)
	if GameState.can_descend():
		var descend_button := button_at("DESCEND", Vector2(1590, 885), descend)
		descend_button.size = Vector2(270, 70)
	label_at("Select a hero to inspect", Vector2(1550, 990), 20)
	if GameState.merchant_orb_available():
		var merchant := button_at("TOUCH MERCHANT ORB", Vector2(1530, 910), open_shop)
		merchant.size = Vector2(320, 65)
	elif GameState.current_room_kind() == "camp":
		var camp := button_at("VISIT CAMP", Vector2(1530, 910), open_camp)
		camp.size = Vector2(320, 65)
	for index in range(GameState.party.size()):
		var hero_id: String = GameState.party[index]
		var state: Dictionary = GameState.run_heroes.get(hero_id, {})
		var hero: Dictionary = GameState.hero(hero_id)
		var position := Vector2(570 + index * 260, 850)
		var button := button_at("", position, inspect_hero.bind(hero_id))
		button.name = "Party_" + hero_id
		button.size = Vector2(230, 200)
		portrait_at(hero_id, Rect2(position + Vector2(10, 4), Vector2(210, 127)))
		label_at(str(hero["name"]).to_upper(), position + Vector2(16, 133), 17 if hero_id == "crusader" else 22)
		label_at("Lv %d · %d HP · %d Stress%s" % [GameState.leveling(hero_id)["level"],int(state.get("hp", hero["max_hp"])), int(state.get("stress", 0)), " · Slain" if state.get("dead", false) else ""], position + Vector2(16, 169), 16)

func inspect_hero(hero_id: String) -> void:
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
	GameState.shop_return_scene = "res://scenes/expedition/dungeon.tscn"
	get_tree().change_scene_to_file("res://scenes/hub/item_shop.tscn")

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
	if GameState.floors[GameState.floor_index][GameState.room_position].get("cleared", false): preload("res://scripts/save_files.gd").save(0)
	var route: Array = route_to(destination)
	if route.is_empty(): return
	for step in route:
		if not GameState.vote_move("local", step): return
	traveling = true
	var passage = preload("res://scenes/expedition/hallway_travel.gd").new()
	add_child(passage)
	await passage.finished
	traveling = false
	var room: Dictionary = GameState.floors[GameState.floor_index][destination]
	if room.has("travel_text"): message = str(room["travel_text"])
	if room["cleared"] and not room.has("travel_text"):
		message = "Returned to %s. Choose a connected passage." % str(room.get("name", room["kind"]))
	if not room["cleared"]:
		var corridor: Dictionary = GameState.enter_corridor()
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
	if GameState.scout_area():
		message = "Scouts reveal nearby encounters. Hover revealed rooms to inspect the danger."
		refresh()
