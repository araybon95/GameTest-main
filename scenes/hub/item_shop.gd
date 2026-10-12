extends "res://scenes/ui/party_screen.gd"
const ItemButton = preload("res://scenes/ui/item_icon_button.gd")
var category: String = "All"
var apothecary_mode: bool = false
var trade_mode: String = "Buy"
var sort_order: String = "Rarity"
var transaction_message: String = ""
const CATEGORIES: Array[String] = ["All", "Weapons", "Armor", "Trinkets", "Relics", "Consumables"]
const SORTS: Array[String] = ["Rarity", "Name", "Value"]
const RARITIES: Array[String] = ["common", "rare", "epic", "unique", "legendary"]

func _ready() -> void:
	refresh()

func refresh() -> void:
	if apothecary_mode:
		trade_mode = "Buy"
		category = "All"
	clear_screen()
	set_meta("interior_captions",false)
	preload("res://scripts/static_screen_art.gd").install(self,"apothecary" if apothecary_mode else "merchant",true,Rect2(70,185,320,300))
	preload("res://scripts/static_screen_art.gd").transition(self)
	panel(Rect2(30, 30, 400, 755), Color(0.09, 0.06, 0.08, 0.94))
	label_at("THE APOTHECARY" if apothecary_mode else "THE EMPORIUM", Vector2(65, 75), 350, 32 if apothecary_mode else 38)
	label_at("The ward is reclaimed" if apothecary_mode else "Beyond the blue orb", Vector2(65, 140), 350, 24)
	var vendor_text: String = "Remedies for a ruined world.\n\nHealing potions and scrolls.\nCleansing draughts.\nMight · Focus · Warding\n\nTonics last 2 party turns.\nThey refresh without stacking." if apothecary_mode else "Gear for your party's classes. Universal scrolls and potions.\n\nCommon · Rare · Epic · Unique\nLegendary items are loot-only.\n\nReturn through the orb to continue your expedition."
	if is_selling(): vendor_text = "Sell spare inventory copies.\nEquipped items must first be unequipped.\n\nResale: 25% of listed value,\nrounded down.\nOne copy per click.\nZero-value items cannot be sold."
	var vendor_lore := label_at(vendor_text, Vector2(65, 515), 325, 20 if is_selling() else 21 if apothecary_mode else 22)
	vendor_lore.name = "VendorLore"
	vendor_lore.size = Vector2(325,260)
	vendor_lore.clip_text = true
	panel(Rect2(460, 30, 1430, 755), Color(0.09, 0.06, 0.08, 0.94))
	label_at("REMEDIES AND TONICS" if apothecary_mode else "PARTY INVENTORY" if is_selling() else "MERCHANT WARES", Vector2(500, 65), 1000, 34)
	var gold_label := label_at("GOLD  %d" % State.gold, Vector2(1600, 75), 250, 25)
	gold_label.name = "TradeGold"
	if not apothecary_mode:
		var buy_tab := button_at(("• " if trade_mode == "Buy" else "") + "BUY ITEMS",Rect2(500,125,240,45),set_trade_mode.bind("Buy"))
		buy_tab.name = "TradeBuyTab"
		var sell_tab := button_at(("• " if is_selling() else "") + "SELL ITEMS",Rect2(760,125,240,45),set_trade_mode.bind("Sell"))
		sell_tab.name = "TradeSellTab"
		buy_tab.add_theme_font_size_override("font_size",22)
		sell_tab.add_theme_font_size_override("font_size",22)
		label_at("SORT",Vector2(1210,133),95,20)
		var sorting := OptionButton.new()
		sorting.name = "TradeSort"
		sorting.position = Vector2(1310,125)
		sorting.size = Vector2(290,45)
		sorting.add_theme_font_size_override("font_size",21)
		for order in SORTS: sorting.add_item("Value ↓" if order == "Value" else order)
		sorting.select(maxi(0,SORTS.find(sort_order)))
		sorting.item_selected.connect(func(index): set_sort(SORTS[index]))
		add_child(sorting)
	for index in range(0 if apothecary_mode else CATEGORIES.size()):
		var filter_name: String = CATEGORIES[index]
		var filter_button := button_at(("• " if category == filter_name else "") + filter_name, Rect2(500 + index * 220, 188, 205, 45), set_category.bind(filter_name))
		filter_button.name = "Filter_%s" % filter_name
		filter_button.add_theme_font_size_override("font_size", 21)
	var instructions := label_at("Choose remedies for your party." if apothecary_mode else "Unequipped inventory only · 25% unit value · One copy per sale" if is_selling() else "Buy gear for your party's classes · Legendary items remain loot-only",Vector2(500,140 if apothecary_mode else 248),1340,18)
	instructions.name = "TradeInstructions"
	var scroll := ScrollContainer.new()
	scroll.name = "TradeScroll"
	scroll.position = Vector2(500, 205 if apothecary_mode else 286)
	scroll.size = Vector2(1340, 513 if apothecary_mode else 432)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var rows := VBoxContainer.new()
	rows.name = "TradeRows"
	rows.add_theme_constant_override("separation", 12)
	rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(rows)
	var catalog: Array[String] = catalog_items()
	if catalog.is_empty():
		var empty := Label.new()
		empty.name = "TradeEmpty"
		empty.text = "No unequipped items to sell in this category. Equipped items must first be unequipped." if is_selling() else "No merchant items in this category."
		empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		empty.custom_minimum_size = Vector2(1200,95)
		empty.add_theme_font_size_override("font_size",23)
		rows.add_child(empty)
	for item_id in catalog:
		var item: Dictionary = State.Items.item(str(item_id))
		var row := HBoxContainer.new()
		row.name = "TradeRow_%s" % item_id
		row.custom_minimum_size.y = 126 if is_selling() else 106
		row.add_theme_constant_override("separation", 20)
		rows.add_child(row)
		var icon = ItemButton.new()
		icon.configure(str(item_id), int(State.inventory.get(item_id, 0)))
		icon.favourite_changed.connect(refresh)
		icon.custom_minimum_size = Vector2(90, 90)
		icon.mouse_default_cursor_shape = Control.CURSOR_HELP
		row.add_child(icon)
		var description := VBoxContainer.new()
		description.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(description)
		var name_label := Label.new()
		name_label.name = "ItemName"
		name_label.text = "%s · %s · %s %d" % [item["name"], str(item["rarity"]).capitalize(),"Stack" if is_selling() else "Owned",int(State.inventory.get(item_id, 0))]
		name_label.add_theme_font_size_override("font_size", 23 if is_selling() else 25)
		description.add_child(name_label)
		if is_selling():
			var unit_value := Label.new()
			unit_value.name = "UnitValue"
			unit_value.text = "%d GOLD per item · 25%% of listed value" % State.item_sell_price(item_id)
			unit_value.add_theme_font_size_override("font_size",18)
			unit_value.add_theme_color_override("font_color",Color("#D8B981"))
			description.add_child(unit_value)
		var details := Label.new()
		details.text = State.Items.description(str(item_id))
		details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		details.custom_minimum_size.x = 825
		details.add_theme_font_size_override("font_size", 20)
		description.add_child(details)
		var buy := Button.new()
		var unit_price: int = State.item_sell_price(item_id) if is_selling() else State.item_price(item_id)
		buy.name = ("Sell_" if is_selling() else "Buy_") + item_id
		buy.text = "SELL ONE\n%d GOLD" % unit_price if is_selling() and unit_price > 0 else "NO RESALE\nVALUE" if is_selling() else "BUY\n%d GOLD" % unit_price
		buy.custom_minimum_size = Vector2(230, 90)
		buy.add_theme_font_size_override("font_size", 23)
		buy.disabled = unit_price <= 0 if is_selling() else State.gold < unit_price
		if is_selling() and State.Items.favourites.get(item_id,false):
			buy.disabled = true
			buy.text = "★ PROTECTED"
		buy.tooltip_text = "Sell one unequipped copy." if is_selling() and unit_price > 0 else "The 25% value rounds down to 0 gold. This item stays in your inventory." if is_selling() else "Buy one copy for your inventory."
		if is_selling() and State.Items.favourites.get(item_id,false): buy.tooltip_text = "Favourite protected. Right-click its icon to allow selling."
		buy.pressed.connect(sell_inventory_item.bind(item_id) if is_selling() else purchase.bind(item_id))
		row.add_child(buy)
	var status := label_at(transaction_message,Vector2(500,738),1340,20)
	status.name = "TradeStatus"
	status.size = Vector2(1340,36)
	status.clip_text = true
	status.add_theme_color_override("font_color",Color("#D8B981"))
	party_bar(return_to_party, "RETURN THROUGH ORB" if State.run_active else "RETURN TO HAMLET")

func is_selling() -> bool:
	return trade_mode == "Sell" and not apothecary_mode

func item_category(item: Dictionary) -> String:
	if item.get("kind","") in ["scroll","potion","provision"]: return "Consumables"
	if item.get("kind","") == "trinket": return "Trinkets"
	if item.get("slot","") == "weapon": return "Weapons"
	if item.get("slot","") in ["armor","head"]: return "Armor"
	return "Relics"

func catalog_items() -> Array[String]:
	var source: Array = State.inventory.keys() if is_selling() else State.APOTHECARY_CATALOG.duplicate() if apothecary_mode else State.Items.EQUIPMENT.keys()+State.Items.SCROLLS.keys()+State.Items.POTIONS.keys()+State.Items.PROVISIONS.keys()
	var catalog: Array[String] = []
	for id in source:
		var item: Dictionary = State.Items.item(str(id))
		if item.is_empty(): continue
		if is_selling():
			if int(State.inventory.get(id,0)) <= 0: continue
		else:
			if item.get("rarity","") == "legendary" or (item.has("hero") and not State.party.has(item["hero"])): continue
			if not apothecary_mode and item.get("apothecary",false): continue
		if category != "All" and category != item_category(item): continue
		catalog.append(str(id))
	catalog.sort_custom(_catalog_before)
	return catalog

func _catalog_before(a: String, b: String) -> bool:
	var left: Dictionary = State.Items.item(a)
	var right: Dictionary = State.Items.item(b)
	if sort_order == "Value":
		var left_price: int = State.item_sell_price(a) if is_selling() else State.item_price(a)
		var right_price: int = State.item_sell_price(b) if is_selling() else State.item_price(b)
		if left_price != right_price: return left_price > right_price
	elif sort_order == "Rarity":
		var left_rarity: int = RARITIES.find(str(left.get("rarity","common")))
		var right_rarity: int = RARITIES.find(str(right.get("rarity","common")))
		if left_rarity != right_rarity: return left_rarity < right_rarity
	return str(left["name"]).to_lower() < str(right["name"]).to_lower()

func set_trade_mode(value: String) -> void:
	if apothecary_mode or value not in ["Buy","Sell"] or value == trade_mode: return
	trade_mode = value
	transaction_message = ""
	refresh()

func set_sort(value: String) -> void:
	if value not in SORTS: return
	sort_order = value
	refresh()

func set_category(value: String) -> void:
	category = value
	refresh()

func refresh_after_transaction() -> void:
	var old_scroll: ScrollContainer = get_node_or_null("TradeScroll")
	var position_y: int = old_scroll.scroll_vertical if old_scroll != null else 0
	refresh()
	# Keep a long inventory at the sold/purchased row as its quantity changes.
	get_node("TradeScroll").set_deferred("scroll_vertical",position_y)

func purchase(item_id: String) -> bool:
	if is_selling(): return false
	var price: int = State.item_price(item_id)
	var purchased: bool = State.purchase_apothecary_item(item_id) if apothecary_mode else State.purchase_item(item_id)
	transaction_message = "Purchased %s for %d gold." % [State.Items.item(item_id).get("name",item_id),price] if purchased else "Purchase unavailable: check gold and party classes."
	refresh_after_transaction()
	return purchased

func sell_inventory_item(item_id: String) -> bool:
	if apothecary_mode or not is_selling(): return false
	var value: int = State.item_sell_price(item_id)
	var sold: bool = State.sell_item(item_id)
	transaction_message = "Sold 1 %s for %d gold · %d remaining." % [State.Items.item(item_id).get("name",item_id),value,int(State.inventory.get(item_id,0))] if sold else "Sale unavailable: an unequipped copy with resale value is required."
	if State.Items.favourites.get(item_id,false): transaction_message = "Favourite protected. Right-click its icon to allow selling."
	refresh_after_transaction()
	return sold

func return_to_party() -> void:
	get_tree().change_scene_to_file(State.shop_return_scene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		return_to_party()
