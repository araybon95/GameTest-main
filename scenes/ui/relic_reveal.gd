extends "res://scenes/ui/party_screen.gd"
## Loot is already awarded. This reveal never grants or consumes items.
signal dismissed
var item_id: String = ""
var answered: bool = false
func relic_text(value: String, pos: Vector2, width: float, font_size: int = 24, colour: Color = Color("#F5E9CF")) -> Label:
	var result := label_at(value,pos,width,font_size)
	result.add_theme_color_override("font_color",colour)
	return result
func _ready() -> void:
	name = "RelicLootReveal"
	z_index = 110
	size = Vector2(1920,1080)
	mouse_filter = Control.MOUSE_FILTER_STOP
	clear_screen()
	var shade := ColorRect.new()
	shade.size = size
	shade.color = Color(0.015,0.005,0.01,0.88)
	add_child(shade)
	panel(Rect2(370,175,1180,725),Color("#120C11"))
	relic_text("A TROPHY OF THE FALLEN",Vector2(435,218),1050,26,Color("#D5AF64"))
	var entry: Dictionary = State.Items.item(item_id)
	relic_text(str(entry.get("name","Relic")),Vector2(680,294),790,34,Color("#FFE2A2"))
	var art := picture(State.Items.icon_path(item_id),Rect2(430,298,210,260))
	art.name = "RelicArt"
	var lore := relic_text(str(entry.get("lore","")),Vector2(680,361),770,24,Color("#DBC7B2"))
	lore.size.y = 120
	relic_text("Taken from " + str(State.Items.histories.get(item_id,{}).get("origin","the guardian")),Vector2(680,498),770,22,Color("#BE9E78"))
	var effects := relic_text(State.Items.description(item_id).replace(" · ","\n"),Vector2(450,595),1000,23,Color("#F5E9CF"))
	effects.size.y = 150
	relic_text("Legendary · Already added to party inventory",Vector2(450,550),1000,20,Color("#E7C467"))
	var mark := button_at("★ MARK FAVOURITE",Rect2(435,799,470,65),toggle_favourite)
	mark.name = "RelicFavourite"
	button_at("CONTINUE",Rect2(980,799,470,65),dismiss)
	var tween := create_tween()
	art.modulate.a = 0.2
	tween.tween_property(art,"modulate:a",1.0,0.35)

func toggle_favourite() -> void:
	State.toggle_item_favourite(item_id)
	get_node("RelicFavourite").text = "★ FAVOURITE · PROTECTED" if State.Items.favourites.get(item_id,false) else "★ MARK FAVOURITE"

func dismiss() -> void:
	if answered: return
	answered = true
	dismissed.emit()
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		dismiss()
		get_viewport().set_input_as_handled()
