extends "res://scenes/ui/party_screen.gd"
func _ready() -> void:
 State.load_progression()
 clear_screen()
 picture("res://assets/generated/hamlet_vista_apothecary.png",Rect2(0,0,1920,1080),0.28)
 panel(Rect2(45,40,1830,880),Color("#18171B"))
 label_at("THE GRAVEYARD",Vector2(85,75),1720,42)
 label_at("The hamlet keeps their names, even when the roads forget their footsteps.",Vector2(85,140),1720,25)
 picture("res://assets/generated/graveyard.svg",Rect2(65,260,380,410))
 label_at("%d MEMORIALS" % State.graves.size(),Vector2(85,720),330,24)
 var scroll := ScrollContainer.new()
 scroll.position = Vector2(500,225)
 scroll.size = Vector2(1300,640)
 scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 add_child(scroll)
 var list := VBoxContainer.new()
 list.custom_minimum_size.x = 1250
 list.add_theme_constant_override("separation",24)
 scroll.add_child(list)
 if State.graves.is_empty():
  var empty := Label.new()
  empty.text = "No names have yet been carved.\nMay these stones remain unwritten."
  empty.add_theme_font_size_override("font_size",28)
  list.add_child(empty)
 for index in range(State.graves.size()-1,-1,-1):
  var grave: Dictionary = State.graves[index]
  var row := PanelContainer.new()
  var box := StyleBoxFlat.new()
  box.bg_color = Color("#292327")
  box.border_color = Color("#796858")
  box.set_border_width_all(2)
  box.set_content_margin_all(22)
  row.add_theme_stylebox_override("panel",box)
  list.add_child(row)
  var contents := VBoxContainer.new()
  row.add_child(contents)
  var name_label := Label.new()
  name_label.text = str(grave["name"]) + " - " + str(grave["class"])
  name_label.add_theme_font_size_override("font_size",30)
  contents.add_child(name_label)
  var account := Label.new()
  account.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
  account.custom_minimum_size.x = 1180
  var deeds: Dictionary = grave.get("deeds",{})
  account.text = "Fell in %s, floor %d - %s\nLast trial: %s\nSurvived %d battles. Dealt %d damage. Recovered %d health." % [grave["dungeon"],int(grave["floor"]),grave["date"],grave["cause"],int(deeds.get("battles",0)),int(deeds.get("damage",0)),int(deeds.get("healing",0))]
  account.add_theme_font_size_override("font_size",23)
  contents.add_child(account)
 button_at("RETURN TO HAMLET",Rect2(1400,965,440,65),back)
func back() -> void:
 get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
func _unhandled_input(event: InputEvent) -> void:
 if event.is_action_pressed("ui_cancel"): back()
