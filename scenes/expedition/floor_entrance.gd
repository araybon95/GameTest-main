extends "res://scenes/ui/party_screen.gd"
## Reusable themed threshold shown after a floor guardian or when using stairs.
const Scenery = preload("res://scripts/dungeon_scenery.gd")
const Readiness = preload("res://scripts/expedition_readiness.gd")
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
	panel(Rect2(230, 65, 1460, 970), Color("#161017"))
	var next_theme: String = Scenery.theme_for(State.selected_expedition,State.floor_index+1)
	var backdrop := picture(Scenery.stage_path(str(entry.get("art", State.floor_background("combat")))), Rect2(250, 85, 1420, 300))
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.modulate = Color(0.75,0.75,0.8)
	var threshold := picture(Scenery.threshold_path(next_theme),Rect2(1370,110,230,255))
	threshold.name = "ThemedThreshold"
	label_at("THE WAY OPENS · FLOOR %d  →  FLOOR %d" % [State.floor_index+1,State.floor_index+2],Vector2(300,115),970,22)
	label_at(str(entry.get("floor","The Descent")),Vector2(300,161),970,32).size = Vector2(970,45)
	label_at(str(entry.get("name", "The Descent")), Vector2(300, 220), 970, 29).size = Vector2(970,40)
	label_at(str(entry.get("description", "The passage below waits for the party.")), Vector2(300, 274), 970, 21).size = Vector2(970,80)
	panel(Rect2(250, 385, 1420, 630), Color("#161017"))
	label_at("THE PARTY BEFORE THE DESCENT", Vector2(290, 407), 1340, 24)
	var party: Array[Dictionary] = Readiness.party_snapshot(State,true)
	for index in range(party.size()):
		var hero: Dictionary = party[index]
		var x: float = 290+index*455
		panel(Rect2(x,455,430,150),Color("#21161C"))
		picture(str(State.hero(hero["id"])["art"]),Rect2(x+10,463,80,130),0.25 if hero["dead"] else 1.0)
		var chosen := label_at(str(hero["name"]).to_upper(),Vector2(x+105,466),310,20)
		chosen.name = "DescentName_%s" % hero["id"]
		chosen.size = Vector2(310,28)
		chosen.clip_text = true
		var growth := label_at("%s · Lv %d" % [hero["class"],hero["level"]],Vector2(x+105,495),310,17)
		growth.name = "DescentClass_%s" % hero["id"]
		growth.size = Vector2(310,27)
		var vitality := label_at("HP %d / %d · Stress %d" % [hero["hp"],hero["max_hp"],hero["stress"]],Vector2(x+105,525),310,19)
		vitality.name = "DescentVitality_%s" % hero["id"]
		vitality.add_theme_color_override("font_color",Color("#E69187") if hero["deaths_door"] or hero["hp"] < hero["max_hp"]*0.5 else Color("#EADDD0"))
		var effects: String = "Slain · cannot be revived" if hero["dead"] else "DEATH'S DOOR" if hero["deaths_door"] else "No active debuffs"
		if not hero["dead"] and not hero["statuses"].is_empty(): effects = ("DEATH'S DOOR · " if hero["deaths_door"] else "") + ", ".join(hero["statuses"])
		var status := label_at(effects,Vector2(x+105,557),310,17)
		status.name = "DescentStatus_%s" % hero["id"]
		status.size = Vector2(310,42)
		status.clip_text = true
		status.add_theme_color_override("font_color",Color("#D8B981") if hero["deaths_door"] or not hero["statuses"].is_empty() else Color("#CDBCAE"))
	label_at("BEYOND THE THRESHOLD",Vector2(290,625),1340,20)
	var threat := label_at(Readiness.next_threat(State),Vector2(290,655),1340,20)
	threat.name = "NextFloorThreat"
	threat.size = Vector2(1340,72)
	threat.clip_text = true
	var advice := RichTextLabel.new()
	advice.name = "PreparationHint"
	advice.position = Vector2(290,735)
	advice.size = Vector2(1340,164)
	advice.text = Readiness.descent_advice(State)
	advice.add_theme_font_size_override("normal_font_size",19)
	advice.add_theme_color_override("default_color",Color("#D8B981"))
	add_child(advice)
	label_at("Continue to floor %d of %d · You may stay and explore before leaving." % [State.floor_index + 2, State.floor_count], Vector2(290, 912), 1340, 17)
	var proceed := button_at("DESCEND", Rect2(290, 944, 625, 55), accept_entrance)
	proceed.name = "DescendButton"
	proceed.disabled = not State.can_descend()
	var stay := button_at("STAY ON THIS FLOOR", Rect2(1015, 944, 605, 55), stay_here)
	stay.name = "StayButton"
	stay.grab_focus()
	Scenery.decorate(self)
	add_child(preload("res://scenes/expedition/scene_arrival.gd").new())

func preparation_hint() -> String:
	var hint: String = Readiness.next_threat(State)
	if State.selected_expedition.get("id","") == "old_road" and State.floor_index == 0:
		hint += " Explore for a camp and recover. Spend level points at the barracks between runs."
	return hint
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
