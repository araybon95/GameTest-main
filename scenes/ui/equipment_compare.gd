extends "res://scenes/ui/party_screen.gd"
signal equip_requested
signal closed
const Compare = preload("res://scripts/equipment_comparison.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
var hero_id: String = "warden"
var item_id: String = ""
func _ready() -> void:
	name = "EquipmentComparison"
	z_index = 150
	size = Vector2(1920,1080)
	mouse_filter = Control.MOUSE_FILTER_STOP
	clear_screen()
	var shade := ColorRect.new()
	shade.color = Color(0,0,0,0.87)
	shade.size = size
	add_child(shade)
	panel(Rect2(200,110,1520,850),Color("#130C12"))
	label_at("EQUIPMENT COMPARISON",Vector2(245,140),1420,32)
	var data: Dictionary = Compare.compare(State,hero_id,item_id)
	var item: Dictionary = State.Items.item(item_id)
	label_at(str(item.name),Vector2(245,205),1415,30)
	var current := picture(str(State.hero(hero_id).art),Rect2(245,285,320,435))
	current.name = "CurrentAppearance"
	current.mouse_filter = Control.MOUSE_FILTER_IGNORE
	current.texture = Scenery.grounded_texture(str(State.hero(hero_id).art))
	var preview := picture(str(State.hero(hero_id,item_id).art),Rect2(585,285,320,435))
	preview.name = "ProposedAppearance"
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview.texture = Scenery.grounded_texture(str(State.hero(hero_id,item_id).art))
	var candidate: Texture2D = preload("res://scripts/weapon_visuals.gd").selected(State,hero_id,"idle",item_id) if data.get("compatible",false) else null
	if candidate != null: preview.texture = preload("res://scripts/weapon_visuals.gd").display_texture(candidate)
	label_at("CURRENT",Vector2(280,748),300,21)
	label_at("IF EQUIPPED",Vector2(620,748),300,21)
	var record := RichTextLabel.new()
	record.name = "ComparisonChanges"
	record.text = Compare.text(State,hero_id,item_id) + "\n\n" + State.Items.tooltip(item_id)
	record.position = Vector2(965,285)
	record.size = Vector2(695,510)
	record.add_theme_font_size_override("normal_font_size",23)
	add_child(record)
	var equip := button_at("EQUIP",Rect2(970,860,670,60),request_equip)
	equip.name = "ConfirmEquip"
	equip.disabled = not data.get("compatible",false) or int(State.inventory.get(item_id,0)) <= 0 or State.run_heroes.get(hero_id,{}).get("dead",false)
	button_at("KEEP CURRENT",Rect2(245,860,650,60),dismiss)
func request_equip() -> void:
	equip_requested.emit()
	queue_free()
func dismiss() -> void:
	closed.emit()
	queue_free()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		dismiss()
		get_viewport().set_input_as_handled()
