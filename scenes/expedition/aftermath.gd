extends "res://scenes/ui/party_screen.gd"
func _ready() -> void:
	preload("res://scripts/settlement_music.gd").play()
	clear_screen()
	var report: Dictionary = State.last_report
	picture(State.floor_background("camp"),Rect2(0,0,1920,1080),0.28)
	panel(Rect2(55,45,1810,970),Color(0.06,0.045,0.055,0.95))
	label_at("EXPEDITION COMPLETE" if report.get("complete",false) else "THE PARTY RETURNS",Vector2(95,75),1700,38)
	label_at(str(report.get("dungeon","Expedition")),Vector2(95,135),1700,28)
	label_at("Floor %d · %d spaces explored · %d foes defeated · Gold change %+d" % [report.get("floor",1),report.get("rooms",0),report.get("kills",0),report.get("gold",0)],Vector2(95,185),1700,23)
	var flavor: String = "The road releases its survivors. Count the spoils. Remember the fallen."
	if State.selected_expedition.get("faction","") == "remade": flavor = "The hymn follows you home. Beneath the earth, the congregation still begs to be remade."
	label_at(flavor,Vector2(95,235),1700,22)
	var heroes: Array = report.get("survivors",[]) + report.get("fallen",[])
	for index in range(heroes.size()):
		var entry: Dictionary = heroes[index]
		var x: float = 105 + index * 570
		panel(Rect2(x,295,535,340))
		picture(str(State.hero(entry["id"])["art"]),Rect2(x+15,315,160,210),0.5 if report.get("fallen",[]).has(entry) else 1.0)
		label_at(str(entry["name"]),Vector2(x+190,315),320,26)
		label_at("%s · Level %d%s" % [entry["class"],entry["level"]," ↑" if int(entry["level"]) > int(entry["old_level"]) else ""],Vector2(x+190,365),320,20)
		var deeds: Dictionary = entry.get("deeds",{})
		label_at("%s · +%d XP\n%d HP · %d Stress\nBattles survived: %d\nDamage dealt: %d\nHealing given: %d" % ["FALLEN" if report.get("fallen",[]).has(entry) else "SURVIVED",entry["xp"],entry["hp"],entry["stress"],deeds.get("battles",0),deeds.get("damage",0),deeds.get("healing",0)],Vector2(x+190,405),320,22).size.y = 210
	label_at("ACQUIRED ITEMS",Vector2(105,665),1700,25)
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(105,710)
	scroll.size = Vector2(1700,180)
	add_child(scroll)
	var list := VBoxContainer.new()
	scroll.add_child(list)
	var loot: Dictionary = report.get("loot",{})
	for id in loot:
		var line := Label.new()
		line.text = "%s ×%d" % [State.Items.item(id).get("name",id),loot[id]]
		line.add_theme_font_size_override("font_size",22)
		list.add_child(line)
	if loot.is_empty():
		var empty := Label.new()
		empty.text = "No items recovered."
		list.add_child(empty)
	label_at("Fallen heroes are remembered in the settlement graveyard. Unspent leveling points can be used in the Barracks.",Vector2(105,920),1280,20).size.y = 70
	button_at("RETURN TO THE HAMLET",Rect2(1430,925,380,65),return_home)
func return_home() -> void:
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): return_home()
