extends "res://scenes/ui/party_screen.gd"
const ItemButton = preload("res://scenes/ui/item_icon_button.gd")
const Accents = preload("res://scripts/equipment_accents.gd")
var selected_item: String = ""
var keepsakes_only: bool = false
var message: String = ""
func _ready() -> void:
	State.load_progression()
	refresh()
func owned_gear() -> Array:
	var result: Array = []
	for id in State.inventory:
		if State.Items.item(id).has("slot"): result.append(id)
	for gear in State.equipment.values():
		for id in gear.values():
			if not result.has(id): result.append(id)
	if keepsakes_only: result = result.filter(func(id): return State.Items.favourites.get(id,false) or State.Items.histories.has(id))
	return result
func refresh() -> void:
	clear_screen()
	set_meta("interior_captions",false)
	preload("res://scripts/static_screen_art.gd").install(self,"workshop",State.service_unlocked("workshop"))
	var attendant := get_node_or_null("StaticInterior/Attendant")
	if attendant != null: attendant.hide()
	label_at("THE WORKSHOP · EQUIPMENT LEGACIES",Vector2(75,65),1750,38)
	button_at("FORGE & COLOURS",Rect2(75,130,400,55),return_to_workshop)
	if not State.service_unlocked("workshop"):
		label_at("Reclaim the Workshop to tend your equipment's legacy.",Vector2(475,320),1300,28)
		party_bar(return_to_workshop,"RETURN")
		return
	button_at("KEEPSAKES" if not keepsakes_only else "ALL EQUIPMENT",Rect2(500,130,400,55),toggle_filter)
	label_at("GOLD %d · One permanent transformation per copy" % State.gold,Vector2(945,142),880,22)
	var owned: Array = owned_gear()
	if not owned.has(selected_item): selected_item = str(owned[0]) if not owned.is_empty() else ""
	panel(Rect2(65,215,480,565),Color("#100D10"))
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(80,230)
	scroll.size = Vector2(450,530)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var list := VBoxContainer.new()
	list.custom_minimum_size.x = 430
	scroll.add_child(list)
	for id in owned:
		var row := HBoxContainer.new()
		list.add_child(row)
		var icon = ItemButton.new()
		icon.configure(id,int(State.inventory.get(id,1)))
		icon.pressed.connect(select_item.bind(id))
		icon.favourite_changed.connect(refresh)
		row.add_child(icon)
		var caption := Label.new()
		caption.text = ("▶ " if id == selected_item else "") + str(State.Items.item(id).name)
		caption.custom_minimum_size.x = 325
		caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		caption.add_theme_font_size_override("font_size",22)
		row.add_child(caption)
	panel(Rect2(570,215,500,565),Color("#120D13"))
	panel(Rect2(1095,215,760,565),Color("#120D13"))
	if not selected_item.is_empty():
		var entry: Dictionary = State.Items.item(selected_item)
		var hero_id: String = str(entry.get("hero",State.party[0]))
		var preview := picture(str(State.hero(hero_id).art),Rect2(620,240,400,465))
		preview.name = "EquipmentPreview"
		Accents.attach(preview,hero_id,selected_item)
		label_at("COSMETIC PREVIEW · " + str(State.HEROES[hero_id].name),Vector2(610,725),435,20)
		var history := RichTextLabel.new()
		history.name = "KeepsakeHistory"
		history.text = State.Items.tooltip(selected_item)
		history.position = Vector2(1120,240)
		history.size = Vector2(705,505)
		history.add_theme_font_size_override("normal_font_size",23)
		add_child(history)
		for index in range(3):
			var mode: String = str(State.ItemStories.TRANSFORMS.keys()[index])
			var choice: Dictionary = State.ItemStories.TRANSFORMS[mode]
			var action := button_at(str(choice.name).to_upper() + " · 75 GOLD",Rect2(65+index*600,800,580,60),transform_item.bind(mode))
			action.name = "Transform_" + mode
			action.disabled = State.gold < choice.cost or State.Items.histories.get(selected_item,{}).has("transformation")
			action.tooltip_text = str(choice.description) + "\nPermanent; cannot stack transformations."
			label_at(str(choice.description),Vector2(75+index*600,874),560,19).size.y = 70
	label_at(message if not message.is_empty() else "Permanent choice · Select an item to read its history. Right-click to mark a favourite.",Vector2(75,950),1230,19)
	button_at("RETURN TO WORKSHOP",Rect2(1330,970,525,65),return_to_workshop)
func select_item(id: String) -> void:
	selected_item = id
	message = ""
	refresh()
func toggle_filter() -> void:
	keepsakes_only = not keepsakes_only
	refresh()
func transform_item(mode: String) -> void:
	var result: String = State.ItemStories.transform(State,selected_item,mode)
	if result.is_empty(): return
	selected_item = result
	message = "Transformation complete. “This bears my mark now.”"
	refresh()
func return_to_workshop() -> void:
	State.pending_service = "workshop"
	get_tree().change_scene_to_file("res://scenes/hub/restoration.tscn")
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): return_to_workshop()
