extends "res://scenes/ui/party_screen.gd"
const ItemButton = preload("res://scenes/ui/item_icon_button.gd")
var category: String = "All"

func _ready() -> void:
	refresh()

func refresh() -> void:
	clear_screen()
	panel(Rect2(0, 0, 1920, 1080), Color("#0D0A0E"))
	var background := picture("res://assets/generated/settlement_hamlet.png", Rect2(0, 0, 1920, 815), 0.25)
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel(Rect2(30, 30, 400, 755), Color(0.09, 0.06, 0.08, 0.94))
	picture("res://assets/generated/building_forge.png", Rect2(70, 190, 320, 305))
	label_at("THE EMPORIUM", Vector2(65, 75), 350, 38)
	label_at("Beyond the blue orb", Vector2(65, 140), 350, 24)
	label_at("Gear for your party's classes. Universal spell scrolls.\n\nCommon · Rare · Epic\nLegendary items are loot-only.\n\nReturn through the orb to continue your expedition.", Vector2(65, 515), 325, 22)
	panel(Rect2(460, 30, 1430, 755), Color(0.09, 0.06, 0.08, 0.94))
	label_at("MERCHANT WARES", Vector2(500, 65), 1000, 34)
	label_at("GOLD  %d" % State.gold, Vector2(1600, 75), 250, 25)
	for index in range(5):
		var filter_name: String = ["All", "Weapons", "Armor", "Relics", "Scrolls"][index]
		var filter_button := button_at(("• " if category == filter_name else "") + filter_name, Rect2(500 + index * 265, 130, 250, 55), set_category.bind(filter_name))
		filter_button.add_theme_font_size_override("font_size", 21)
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(500, 205)
	scroll.size = Vector2(1340, 550)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var rows := VBoxContainer.new()
	rows.add_theme_constant_override("separation", 12)
	rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(rows)
	var catalog: Array = State.Items.EQUIPMENT.keys() + State.Items.SCROLLS.keys()
	catalog.sort_custom(func(a, b): return ["common", "rare", "epic", "legendary"].find(State.Items.item(a)["rarity"]) < ["common", "rare", "epic", "legendary"].find(State.Items.item(b)["rarity"]))
	for item_id in catalog:
		var item: Dictionary = State.Items.item(str(item_id))
		if item.get("rarity", "") == "legendary":
			continue
		if item.has("hero") and not State.party.has(item["hero"]):
			continue
		var item_category: String = "Scrolls" if item.get("kind", "") == "scroll" else ("Weapons" if item.get("slot", "") == "weapon" else ("Armor" if item.get("slot", "") in ["armor", "head"] else "Relics"))
		if category != "All" and category != item_category:
			continue
		var row := HBoxContainer.new()
		row.custom_minimum_size.y = 106
		row.add_theme_constant_override("separation", 20)
		rows.add_child(row)
		var icon = ItemButton.new()
		icon.configure(str(item_id))
		icon.custom_minimum_size = Vector2(90, 90)
		icon.mouse_default_cursor_shape = Control.CURSOR_HELP
		row.add_child(icon)
		var description := VBoxContainer.new()
		description.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(description)
		var name_label := Label.new()
		name_label.text = "%s · %s · Owned %d" % [item["name"], str(item["rarity"]).capitalize(), int(State.inventory.get(item_id, 0))]
		name_label.add_theme_font_size_override("font_size", 25)
		description.add_child(name_label)
		var details := Label.new()
		details.text = State.Items.description(str(item_id))
		details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		details.custom_minimum_size.x = 825
		details.add_theme_font_size_override("font_size", 20)
		description.add_child(details)
		var buy := Button.new()
		buy.text = "BUY\n%d GOLD" % State.item_price(str(item_id))
		buy.custom_minimum_size = Vector2(230, 90)
		buy.add_theme_font_size_override("font_size", 23)
		buy.disabled = State.gold < State.item_price(str(item_id))
		buy.pressed.connect(purchase.bind(str(item_id)))
		row.add_child(buy)
	party_bar(return_to_party, "RETURN THROUGH ORB" if State.run_active else "RETURN TO HAMLET")

func set_category(value: String) -> void:
	category = value
	refresh()

func purchase(item_id: String) -> void:
	if State.purchase_item(item_id):
		refresh()

func return_to_party() -> void:
	get_tree().change_scene_to_file(State.shop_return_scene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		return_to_party()
