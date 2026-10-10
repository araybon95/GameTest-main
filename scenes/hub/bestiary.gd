extends Control
const State = preload("res://scripts/game_data.gd")
const Matchups = preload("res://scripts/creature_matchups.gd")
const Objectives = preload("res://scripts/boss_objectives.gd")
const CONTENTS = {
 "old_road": ["ash_raider", "gallows_scout", "ash_chieftain", "keep_footman", "keep_crossbow", "keep_son", "keep_wolfguard", "undying_lord"],
 "path_beast": ["anguish_penitent", "anguish_vessel", "harrowed_giant", "coterie_seamkeeper", "coterie_cantor", "coterie_matron", "howling_head"],
 "infested_apothecary": ["moth_metamorph", "moth_oleander", "moth_exuvia"],
 "restore_watchtower": ["gallows_scout", "ash_chieftain"], "restore_infirmary": ["moth_metamorph", "moth_oleander"], "restore_workshop": ["ash_raider", "ash_chieftain"],
 "bone_warrens": ["bone_rabble"], "tangled_weald": ["weald_stalker"]
}
var volume_id: String = "old_road"
var page: int = -1
var book_view: Control
func _ready() -> void:
 $Header/Subtitle.text = "Dungeon volumes  |  Field notes  |  Creature lore"
 $Entries.hide()
 $CountLabel.hide()
 $BackButton.pressed.connect(_on_back_pressed)
 book_view = Control.new()
 add_child(book_view)
 refresh()
func entries() -> Array:
 return CONTENTS.get(volume_id, [])
func open_volume(id: String) -> void:
 volume_id = id
 page = -1
 refresh()
func turn_page(index: int) -> void:
 page = clampi(index, -1, entries().size() - 1)
 refresh()
func refresh() -> void:
 for child in book_view.get_children():
  book_view.remove_child(child)
  child.queue_free()
 panel(Rect2(45,145,345,810), Color("#241A1C"), Color("#8B6542"))
 label("THE SHELF", Rect2(70,165,295,35),26,Color("#DECBB0"))
 var shelf := ScrollContainer.new()
 shelf.position = Vector2(65,220)
 shelf.size = Vector2(305,710)
 book_view.add_child(shelf)
 var list := VBoxContainer.new()
 list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 list.add_theme_constant_override("separation",10)
 shelf.add_child(list)
 for expedition in State.EXPEDITIONS:
  var button := Button.new()
  button.text = ("OPEN  |  " if expedition["id"] == volume_id else "") + str(expedition["name"])
  button.custom_minimum_size = Vector2(280,74)
  button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
  button.add_theme_font_size_override("font_size",20)
  button.add_theme_stylebox_override("normal",style(Color("#412831"),Color("#9D794B")))
  button.pressed.connect(open_volume.bind(str(expedition["id"])))
  list.add_child(button)
 panel(Rect2(425,145,1450,800),Color("#35211C"),Color("#A47D48"))
 panel(Rect2(448,165,696,750),Color("#BAA383"),Color("#776145"))
 panel(Rect2(1150,165,700,750),Color("#D5C3A1"),Color("#776145"))
 panel(Rect2(1130,170,28,735),Color("#68503A"),Color("#68503A"))
 var expedition: Dictionary = State.expedition_by_id(volume_id)
 var ids: Array = entries()
 label(str(expedition.get("name","Unwritten Volume")),Rect2(490,188,610,70),32)
 var recorded: int = 0
 for id in ids:
  if State.is_discovered(str(id)): recorded += 1
 label("FIELD RECORDS  |  %d / %d" % [recorded,ids.size()],Rect2(490,266,610,32),18)
 if page == -1:
  label("CONTENTS",Rect2(1195,210,595,45),30)
  label(str(expedition.get("blurb","These pages await a future expedition.")),Rect2(490,325,610,270),24)
  label("Encounter each creature to uncover its portrait, lore and field notes.",Rect2(490,645,610,140),22)
  if ids.is_empty(): label("UNWRITTEN\nThis dungeon has not yet been charted.",Rect2(1195,330,595,180),26)
  for index in range(ids.size()):
   var id: String = str(ids[index])
   var title: String = str(State.creature(id)["name"]) if State.is_discovered(id) else "Unrecorded creature"
   button_at("%02d   %s" % [index+1,title],Rect2(1195,285+index*65,595,56),turn_page.bind(index))
 else:
  var id: String = str(ids[page])
  var creature: Dictionary = State.creature(id)
  var known: bool = State.is_discovered(id)
  if known:
   var portrait := TextureRect.new()
   portrait.position = Vector2(515,315)
   portrait.size = Vector2(550,350)
   portrait.texture = load(str(creature["art"]))
   portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
   portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
   book_view.add_child(portrait)
  else: label("?",Rect2(710,405,150,170),120)
  label(str(creature["name"]) if known else "Unrecorded creature",Rect2(1195,215,595,90),32)
  var category := label("CLASS: " + str(creature.get("creature_class","Corrupted")) if known else "CLASS: UNRECORDED",Rect2(1195,305,595,32),20)
  category.name = "CreatureClass"
  var resistance := label(Matchups.resistance_text(creature) if known else "Innate traits not yet recorded.",Rect2(1195,348,595,32),19)
  resistance.name = "CreatureResistance"
  label("LORE",Rect2(1195,389,595,35),22)
  var lore := RichTextLabel.new()
  lore.position = Vector2(1195,430)
  lore.size = Vector2(595,170)
  lore.text = str(creature.get("lore","The archive awaits an account of this creature.")) if known else "These pages remain blank. Face this creature in the dungeon to record its story."
  lore.add_theme_color_override("default_color",Color("#332721"))
  lore.add_theme_color_override("font_shadow_color",Color.TRANSPARENT)
  lore.add_theme_font_size_override("normal_font_size",23)
  book_view.add_child(lore)
  label("FIELD NOTES",Rect2(1195,620,595,35),22)
  var notes: String = "No observations recorded."
  if known:
   notes = "%s\nBase health %d  |  Base attack %d\nValues vary with floor and encounter." % [", ".join(creature.get("tags",[])),int(creature["hp"]),int(creature["attack"])]
   var hint: String = State.Mechanics.boss_hint(id,1)
   if not hint.is_empty(): notes += "\n" + hint
   if volume_id == "path_beast":
    var objective: Dictionary = Objectives.create(id)
    if not objective.is_empty(): notes += "\n" + Objectives.hint(objective) + "\nSelected hero spends 1 AP."
  var field_notes := RichTextLabel.new()
  field_notes.name = "CreatureNotes"
  field_notes.position = Vector2(1195,670)
  field_notes.size = Vector2(595,165)
  field_notes.text = notes
  field_notes.add_theme_color_override("default_color",Color("#332721"))
  field_notes.add_theme_color_override("font_shadow_color",Color.TRANSPARENT)
  field_notes.add_theme_font_size_override("normal_font_size",20)
  book_view.add_child(field_notes)
  if known:
   label("TACTICS",Rect2(490,685,610,32),22)
   var tactics := label(Matchups.tactics(creature),Rect2(490,725,610,125),19)
   tactics.name = "CreatureTactics"
  label("PLATE %02d" % (page+1),Rect2(945,267,155,32),16)
 button_at("CONTENTS",Rect2(490,855,240,45),turn_page.bind(-1))
 var previous := button_at("PREVIOUS",Rect2(1195,855,250,45),turn_page.bind(page-1))
 previous.disabled = page < 0
 var next := button_at("NEXT",Rect2(1515,855,275,45),turn_page.bind(page+1))
 next.disabled = page >= ids.size()-1
func label(value: String,rect: Rect2,font_size: int,color: Color = Color("#332721")) -> Label:
 var node := Label.new()
 node.position = rect.position
 node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 node.size = rect.size
 node.text = value
 node.clip_text = true
 node.add_theme_font_size_override("font_size",font_size)
 node.add_theme_color_override("font_color",color)
 node.add_theme_color_override("font_shadow_color",Color.TRANSPARENT)
 node.mouse_filter = Control.MOUSE_FILTER_IGNORE
 book_view.add_child(node)
 node.size = Vector2(rect.size.x, maxf(rect.size.y, font_size * 1.6))
 return node
func button_at(value: String,rect: Rect2,action: Callable) -> Button:
 var node := Button.new()
 node.text = value
 node.position = rect.position
 node.size = rect.size
 node.add_theme_font_size_override("font_size",19)
 node.add_theme_color_override("font_color",Color("#332721"))
 node.add_theme_stylebox_override("normal",style(Color("#C4AD89"),Color("#8F7551")))
 node.add_theme_stylebox_override("hover",style(Color("#E5D5B5"),Color("#705034")))
 node.pressed.connect(action)
 book_view.add_child(node)
 return node
func style(fill: Color,border: Color) -> StyleBoxFlat:
 var box := StyleBoxFlat.new()
 box.bg_color = fill
 box.border_color = border
 box.set_border_width_all(2)
 box.set_corner_radius_all(4)
 return box
func panel(rect: Rect2,fill: Color,border: Color) -> void:
 var node := Panel.new()
 node.position = rect.position
 node.size = rect.size
 node.mouse_filter = Control.MOUSE_FILTER_IGNORE
 node.add_theme_stylebox_override("panel",style(fill,border))
 book_view.add_child(node)
func _on_back_pressed() -> void:
 get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")
func _unhandled_input(event: InputEvent) -> void:
 if event.is_action_pressed("ui_cancel"): _on_back_pressed()
