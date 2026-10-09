extends Control

const GameState = preload("res://scripts/game_data.gd")
const ItemButton = preload("res://scenes/ui/item_icon_button.gd")
var inventory_filter: String = "All"
var message: String = "Choose an adjacent room. Find the stairs and descend to the final boss."

func _ready() -> void:
	if not GameState.run_active:
		get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
		return
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
	for child in get_children():
		remove_child(child)
		child.queue_free()
	panel_at(Rect2(0, 0, 1920, 1080), Color("#09080A"))
	panel_at(Rect2(12, 12, 1896, 775), Color("#0D0B0E"))
	label_at("%s  ·  FLOOR %d / %d" % [GameState.selected_expedition.get("name", "Expedition"), GameState.floor_index + 1, GameState.floor_count], Vector2(40, 25), 30)
	label_at(message if not GameState.run_complete else "VICTORY — the guardian has fallen. Return to the Hamlet.", Vector2(40, 75), 20)
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
		button.tooltip_text = str(room["kind"]).capitalize() + (" · Cleared" if room["cleared"] else " · Unexplored") + (" · Merchant orb" if room.get("merchant_orb", false) else "")
		button.disabled = current or GameState.run_complete or abs(location.x - GameState.room_position.x) + abs(location.y - GameState.room_position.y) != 1
	label_at("Crossed blades: battle    Ringed blades: boss    Chest: treasure    Flame: camp    Blue orb: merchant    Steps: descend", Vector2(40, 742), 18)
	panel_at(Rect2(12, 790, 1896, 278))
	label_at("CLEARED %d%%" % int(100.0 * cleared / rooms.size()), Vector2(45, 810), 22)
	label_at("EXPLORED %d%%" % int(100.0 * revealed / rooms.size()), Vector2(1600, 810), 22)
	label_at("GOLD  %d" % GameState.gold, Vector2(45, 865), 24)
	var retreat_button := button_at("RETURN TO HAMLET" if GameState.run_complete else "RETREAT", Vector2(45, 935), retreat)
	retreat_button.size = Vector2(270, 70)
	if GameState.current_room_kind() == "stairs":
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
		label_at(str(hero["name"]).to_upper(), position + Vector2(16, 133), 22)
		label_at("%d HP  ·  %d Stress%s" % [int(state.get("hp", hero["max_hp"])), int(state.get("stress", 0)), " · Slain" if state.get("dead", false) else ""], position + Vector2(16, 169), 16)

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
	label_at(str(hero["name"]).to_upper(), Vector2(60, 325), 32)
	label_at("Health  %d / %d\nStress  %d / 100\nDamage bonus  +%d\nBlock bonus  +%d\nHealing bonus  +%d\n%s" % [int(state.get("hp", GameState.hero_max_hp(hero_id))), GameState.hero_max_hp(hero_id), int(state.get("stress", 0)), GameState.equipment_bonus(hero_id, "damage"), GameState.equipment_bonus(hero_id, "block"), GameState.equipment_bonus(hero_id, "heal"), str(state.get("resolve_tag", ""))], Vector2(60, 385), 21)
	label_at("EQUIPMENT", Vector2(390, 55), 28)
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
	label_at("Hover for effects · Click class gear to equip", Vector2(1170, 108), 19)
	var categories: Array[String] = ["All", "Weapons", "Armor", "Scrolls", "Other"]
	for index in range(categories.size()):
		var category: String = categories[index]
		var filter_button := button_at(("• " if inventory_filter == category else "") + category, Vector2(1170 + index * 128, 150), filter_inventory.bind(hero_id, category))
		filter_button.size = Vector2(120, 50)
		filter_button.add_theme_font_size_override("font_size", 17)
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
		var category: String = "Scrolls" if item.get("kind", "") == "scroll" else ("Weapons" if item.get("slot", "") == "weapon" else ("Armor" if item.get("slot", "") in ["armor", "head"] else "Other"))
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
	if item.get("hero", "") == hero_id:
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

func move_to(destination: Vector2i) -> void:
	if not GameState.vote_move("local", destination):
		return
	var room: Dictionary = GameState.floors[GameState.floor_index][destination]
	if not room["cleared"]:
		match str(room["kind"]):
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
	if GameState.descend():
		message = "The darkness deepens. Find the next passage."
		refresh()

func retreat() -> void:
	GameState.end_run()
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
