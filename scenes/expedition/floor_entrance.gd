extends "res://scenes/ui/party_screen.gd"
## Reusable themed threshold shown after a floor guardian or when using stairs.
const Scenery = preload("res://scripts/dungeon_scenery.gd")
var on_descend: Callable
var on_stay: Callable
var answered: bool = false
func _ready() -> void:
	name = "FloorEntrancePrompt"
	z_index = 100
	size = Vector2(1920, 1080)
	mouse_filter = Control.MOUSE_FILTER_STOP
	clear_screen()
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.83)
	shade.size = size
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(shade)
	var entry: Dictionary = State.next_floor_entrance()
	panel(Rect2(395, 130, 1130, 815), Color("#161017"))
	var next_theme: String = Scenery.theme_for(State.selected_expedition,State.floor_index+1)
	var backdrop := picture(Scenery.stage_path(str(entry.get("art", State.floor_background("combat")))), Rect2(415, 150, 1090, 420))
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.modulate = Color(0.75,0.75,0.8)
	var threshold := picture(Scenery.threshold_path(next_theme),Rect2(825,175,270,375))
	threshold.name = "ThemedThreshold"
	label_at("FLOOR %d  →  FLOOR %d" % [State.floor_index+1,State.floor_index+2],Vector2(470,185),420,22)
	label_at(str(entry.get("floor","The Descent")),Vector2(470,240),345,30)
	panel(Rect2(415, 570, 1090, 355), Color("#161017"))
	label_at("THE WAY OPENS", Vector2(450, 590), 1020, 22)
	label_at(str(entry.get("name", "The Descent")), Vector2(450, 630), 1020, 34)
	label_at(str(entry.get("description", "The passage below waits for the party.")), Vector2(450, 685), 1020, 21).size = Vector2(1020,64)
	var hint: String = preparation_hint()
	if not hint.is_empty():
		var advice := label_at(hint,Vector2(450,757),1020,18)
		advice.name = "PreparationHint"
		advice.add_theme_color_override("font_color",Color("#D8B981"))
	label_at("Continue to floor %d of %d · %s" % [State.floor_index + 2, State.floor_count, str(entry.get("floor", ""))], Vector2(450, 809), 1020, 17)
	var proceed := button_at("DESCEND", Rect2(470, 840, 445, 60), accept_entrance)
	proceed.name = "DescendButton"
	proceed.disabled = not State.can_descend()
	var stay := button_at("STAY ON THIS FLOOR", Rect2(1005, 840, 445, 60), stay_here)
	stay.name = "StayButton"
	stay.grab_focus()
	Scenery.decorate(self)
	add_child(preload("res://scenes/expedition/scene_arrival.gd").new())

func preparation_hint() -> String:
	if State.selected_expedition.get("id","") != "old_road": return ""
	if State.floor_index == 0:
		return "The keep's guards hit harder. Explore for a camp and recover before descending. Spend level points at the barracks between runs."
	if State.floor_index == 1:
		return "The Undying Lord receives healing while its support survives. Defeat that attendant first to end the healing."
	return ""
func accept_entrance() -> void:
	if answered or not State.can_descend():
		return
	answered = true
	get_node("DescendButton").disabled = true
	get_node("StayButton").disabled = true
	queue_free()
	if on_descend.is_valid():
		on_descend.call()
func stay_here() -> void:
	if answered: return
	answered = true
	queue_free()
	if on_stay.is_valid():
		on_stay.call()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		stay_here()
