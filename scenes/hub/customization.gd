extends "res://scenes/ui/party_screen.gd"
var chosen: String = "warden"
var chosen_color: String = "original"
var name_edit: LineEdit
var preview: TextureRect
func _ready() -> void:
 if not State.service_unlocked("workshop"):
  get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
  return
 refresh()
func refresh() -> void:
 clear_screen()
 picture("res://assets/generated/hamlet_vista_apothecary.png",Rect2(0,0,1920,1080),0.4)
 panel(Rect2(45,40,1830,740))
 label_at("THE WORKSHOP - HERO APPEARANCE",Vector2(85,70),1720,38)
 label_at("A personal name and a simple cloth/accent color. Armor, silhouettes and class remain the same.",Vector2(85,135),1720,23)
 var roster: Array = ["warden","ranger","occultist","healer"]
 if State.crusader_unlocked: roster.append("crusader")
 for index in range(roster.size()):
  var id: String = roster[index]
  button_at(str(State.HEROES[id]["name"]),Rect2(85+index*345,200,325,55),select_hero.bind(id))
 preview = picture(str(State.hero(chosen)["art"]),Rect2(160,300,450,405))
 label_at(str(State.HEROES[chosen]["name"]),Vector2(700,300),900,30)
 label_at("HERO NAME (20 characters; blank restores the class name)",Vector2(700,355),1000,22)
 name_edit = LineEdit.new()
 name_edit.position = Vector2(700,400)
 name_edit.size = Vector2(1040,55)
 name_edit.max_length = 20
 name_edit.text = State.hero_names.get(chosen,"")
 name_edit.add_theme_font_size_override("font_size",25)
 add_child(name_edit)
 chosen_color = State.hero_colors.get(chosen,"original")
 label_at("ACCENT COLOR",Vector2(700,480),1000,22)
 for index in range(5):
  var color: String = ["original","red","green","blue","gold"][index]
  var button := button_at(color.capitalize(),Rect2(700+index*210,525,195,60),change_color.bind(color))
  button.set_meta("palette_color",color)
  button.disabled = color == chosen_color
 button_at("SAVE NAME & COLOR",Rect2(700,640,1040,65),save_appearance)
 party_bar(return_to_workshop,"RETURN TO WORKSHOP")
func select_hero(id: String) -> void:
 chosen = id
 refresh()
func change_color(color: String) -> void:
 preview.set_meta("palette_preview", false)
 var runtime = get_node_or_null("/root/GameSettings")
 if color == "original": preview.material = null
 elif runtime != null:
  var previous: String = State.hero_colors.get(chosen,"original")
  State.hero_colors[chosen] = color
  runtime.style_portraits(preview)
  State.hero_colors[chosen] = previous
 preview.set_meta("palette_preview", true)
 chosen_color = color
 for child in get_children():
  if child is Button and child.has_meta("palette_color"): child.disabled = child.get_meta("palette_color") == color
func save_appearance() -> void:
 if State.customize_hero(chosen,name_edit.text,chosen_color): refresh()
func return_to_workshop() -> void:
 State.pending_service = "workshop"
 get_tree().change_scene_to_file("res://scenes/hub/restoration.tscn")
func _unhandled_input(event: InputEvent) -> void:
 if event.is_action_pressed("ui_cancel"): return_to_workshop()
