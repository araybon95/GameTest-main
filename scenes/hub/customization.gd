extends "res://scenes/ui/party_screen.gd"
const Appearance = preload("res://scripts/hero_appearance.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
var chosen: String = "warden"
var chosen_color: String = "original"
var chosen_outfit: String = "original"
var chosen_portrait: String = "full"
var name_edit: LineEdit
var preview: TextureRect
var portrait_preview: TextureRect
var preview_caption: Label
var saved_notice: Label
func _ready() -> void:
 if not State.service_unlocked("workshop"):
  get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
  return
 select_hero(chosen)
func refresh() -> void:
 clear_screen()
 set_meta("interior_captions",false)
 var interior := preload("res://scripts/static_screen_art.gd").install(self,"workshop")
 if interior.has_node("Attendant"): interior.get_node("Attendant").hide()
 preload("res://scripts/static_screen_art.gd").transition(self)
 panel(Rect2(55,185,1810,610))
 label_at("THE WORKSHOP · A FACE OF YOUR OWN",Vector2(85,55),1720,38)
 label_at("Choose clothing, armour and a portrait. Keep the name and colours that make this hero yours.",Vector2(85,125),1720,23)
 var roster: Array = ["warden","ranger","occultist","healer"]
 if State.crusader_unlocked: roster.append("crusader")
 for index in range(roster.size()):
  var id: String = roster[index]
  var option := button_at(str(State.HEROES[id]["name"]),Rect2(75+index*352,205,330,55),select_hero.bind(id))
  option.add_theme_font_size_override("font_size",22)
  if id == chosen: option.add_theme_color_override("font_color",Color("#FFE0A0"))
 preview = picture(str(State.HEROES[chosen]["art"]),Rect2(105,290,360,440))
 preview.name = "OutfitPreview"
 preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
 preview.set_meta("palette_preview",true)
 portrait_preview = picture(str(State.HEROES[chosen]["art"]),Rect2(485,325,170,220))
 portrait_preview.name = "PortraitPreview"
 portrait_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
 portrait_preview.set_meta("palette_preview",true)
 label_at("PORTRAIT",Vector2(485,290),175,17).add_theme_color_override("font_color",Color("#BDA77D"))
 preview_caption = label_at("",Vector2(100,741),560,22)
 label_at("HERO NAME",Vector2(700,290),1080,22)
 name_edit = LineEdit.new()
 name_edit.position = Vector2(700,332)
 name_edit.size = Vector2(1080,55)
 name_edit.max_length = 20
 name_edit.text = State.hero_names.get(chosen,"")
 name_edit.placeholder_text = "Choose a name · Leave blank to use the class name"
 name_edit.add_theme_font_size_override("font_size",25)
 add_child(name_edit)
 label_at("CLOTHING & ARMOUR",Vector2(700,414),1080,22)
 var outfits: Array[String] = ["original","alternate"]
 if chosen == "warden": outfits.append("ashen_wolf")
 var choice_width: float = 1080.0/outfits.size()
 for index in range(outfits.size()):
  var style: String = outfits[index]
  var title: String = "Ashen Wolf" if style == "ashen_wolf" else "Original attire" if style == "original" else str(Appearance.TITLES[chosen])
  var option := button_at(title,Rect2(700+index*choice_width,455,choice_width-20,57),change_outfit.bind(style))
  option.set_meta("outfit_style",style)
  option.disabled = style == chosen_outfit or outfit_locked(style)
  if style == "ashen_wolf": option.tooltip_text = "Complete cosmetic armor set · earned by defeating the Undying Lord" if not outfit_locked(style) else "Locked · defeat the Undying Lord at the end of the Old Road"
 label_at("CLOTH / ACCENT COLOUR",Vector2(700,536),1080,21)
 for index in range(5):
  var color: String = ["original","red","green","blue","gold"][index]
  var option := button_at(color.capitalize(),Rect2(700+index*220,574,200,48),change_color.bind(color))
  option.set_meta("palette_color",color)
  option.disabled = color == chosen_color
  option.add_theme_font_size_override("font_size",20)
 label_at("PORTRAIT VIEW",Vector2(700,644),220,20)
 for index in range(2):
  var mode: String = ["full","bust"][index]
  var option := button_at("Full figure" if mode == "full" else "Character portrait",Rect2(960+index*415,634,395,48),change_portrait.bind(mode))
  option.set_meta("portrait_view",mode)
  option.disabled = mode == chosen_portrait
  option.add_theme_font_size_override("font_size",20)
 button_at("SAVE APPEARANCE",Rect2(700,700,1080,55),save_appearance).name = "SaveAppearance"
 saved_notice = label_at("Appearance choices do not change equipment or combat stats.",Vector2(700,760),1080,16)
 var gear_toggle := button_at("EQUIPMENT COSTUMES · " + ("ON" if State.equipment_appearance else "OFF"),Rect2(75,770,565,35),toggle_equipment_costumes)
 gear_toggle.add_theme_font_size_override("font_size",18)
 party_bar(return_to_workshop,"RETURN TO WORKSHOP")
 update_preview()
func select_hero(id: String) -> void:
 chosen = id
 chosen_color = State.hero_colors.get(id,"original")
 chosen_outfit = State.hero_outfits.get(id,"original")
 chosen_portrait = State.hero_portraits.get(id,"full")
 refresh()
func toggle_equipment_costumes() -> void:
 State.equipment_appearance = not State.equipment_appearance
 State.save_progression()
 State._save_economy()
 refresh()
func change_color(color: String) -> void:
 chosen_color = color
 update_preview()
func change_outfit(style: String) -> void:
 chosen_outfit = style
 update_preview()
func change_portrait(mode: String) -> void:
 chosen_portrait = mode
 update_preview()
func outfit_locked(style: String) -> bool:
 return (style == "alternate" and not Appearance.available(chosen)) or (style == "ashen_wolf" and (chosen != "warden" or not State.completed_expeditions.has("old_road")))

func update_preview() -> void:
 var idle_path: String = Appearance.path(chosen) if chosen_outfit == "alternate" else str(State.HEROES[chosen]["art"])
 if chosen == "warden" and chosen_outfit in ["original","ashen_wolf"]:
  idle_path = preload("res://scripts/warden_outfits.gd").path(chosen_outfit,"camp")
 preview.texture = Scenery.grounded_texture(idle_path)
 var face_path: String = Appearance.path(chosen,"portrait" if chosen_outfit == "alternate" else "original_portrait") if chosen_portrait == "bust" else idle_path
 if chosen == "warden" and chosen_outfit in ["original","ashen_wolf"] and chosen_portrait == "bust":
  face_path = preload("res://scripts/warden_outfits.gd").path(chosen_outfit,"portrait")
 portrait_preview.texture = Scenery.grounded_texture(face_path if ResourceLoader.exists(face_path) else idle_path)
 var visuals = preload("res://scripts/weapon_visuals.gd")
 if State.equipment_appearance and visuals.Manifest.ENABLED.get(chosen,false):
  var weapon: String = visuals.weapon_id(State,chosen)
  preview.texture = visuals.display_texture(visuals.runtime_frame(chosen,chosen_outfit,"idle",weapon))
  if chosen_portrait != "bust": portrait_preview.texture = visuals.display_texture(visuals.runtime_frame(chosen,chosen_outfit,"portrait",weapon))
 for image in [preview,portrait_preview]:
  image.material = null
  Scenery.apply_hero_palette(image,chosen,chosen_color)
 preview_caption.text = "Ashen Wolf · boss-reward armor set" if chosen_outfit == "ashen_wolf" else str(Appearance.TITLES[chosen]) if chosen_outfit == "alternate" else "Original attire"
 for child in get_children():
  if child is Button:
   if child.has_meta("palette_color"): child.disabled = child.get_meta("palette_color") == chosen_color
   if child.has_meta("outfit_style"): child.disabled = child.get_meta("outfit_style") == chosen_outfit or outfit_locked(str(child.get_meta("outfit_style")))
   if child.has_meta("portrait_view"): child.disabled = child.get_meta("portrait_view") == chosen_portrait
func save_appearance() -> void:
 if State.customize_hero(chosen,name_edit.text,chosen_color,chosen_outfit,chosen_portrait):
  refresh()
  saved_notice.text = "Appearance saved for "+str(State.hero(chosen)["name"])+"."
func return_to_workshop() -> void:
 State.pending_service = "workshop"
 get_tree().change_scene_to_file("res://scenes/hub/restoration.tscn")
func _unhandled_input(event: InputEvent) -> void:
 if event.is_action_pressed("ui_cancel"): return_to_workshop()
