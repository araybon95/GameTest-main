extends RefCounted
const State = preload("res://scripts/game_data.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
static func build(owner: Control) -> void:
 owner.panel_at(Rect2(0,0,1920,1080),Color("#0C0A0E"))
 owner.label_at("%s · %s" % [State.selected_expedition.get("name","Expedition"),State.floor_title()],Vector2(65,55),32)
 owner.label_at("Choose your next chamber. The passages between rooms hold their own dangers.",Vector2(65,110),21)
 owner.panel_at(Rect2(50,165,1190,725),Color("#171216"))
 owner.label_at("THE DUNGEON · FLOOR %d / %d" % [State.floor_index+1,State.floor_count],Vector2(80,185),23)
 var map = preload("res://scenes/expedition/route_map.gd").new()
 map.name = "RouteMap"
 map.position = Vector2(80,240)
 map.size = Vector2(1130,620)
 owner.add_child(map)
 var rooms: Dictionary = State.floors[State.floor_index]
 for location in rooms:
  var room: Dictionary = rooms[location]
  if not room.get("seen",false): continue
  var rect: Rect2 = map.room_rect(location)
  var option: Button = owner.button_at("",map.position+rect.position,owner.move_to.bind(location))
  option.name = "Room_%d_%d" % [location.x,location.y]
  option.size = rect.size
  option.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
  for style in ["normal","disabled","pressed","hover","focus"]: option.add_theme_stylebox_override(style,StyleBoxEmpty.new())
  option.disabled = location == State.room_position or State.run_complete or owner.route_to(location).is_empty()
  option.tooltip_text = "%s · %s" % [str(room.get("name",str(room.kind).capitalize())),"Explored" if room.get("cleared",false) else "Unexplored"]
  var guidance: String = preload("res://scenes/expedition/dungeon_map.gd").room_guidance(room)
  if guidance != "": option.tooltip_text += "\n"+guidance
  option.mouse_entered.connect(owner.preview_route.bind(location))
  option.focus_entered.connect(owner.preview_route.bind(location))
 owner.panel_at(Rect2(1270,165,600,725),Color("#191318"))
 owner.label_at("NEXT CHAMBER",Vector2(1305,195),24)
 var title := Label.new()
 title.name = "RouteTitle"
 title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 title.text = "Where will you venture?"
 title.position = Vector2(1305,245)
 title.size = Vector2(520,90)
 title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 title.add_theme_font_size_override("font_size",30)
 owner.add_child(title)
 var detail := Label.new()
 detail.name = "RouteDetails"
 detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 detail.text = "Hover a reachable room to trace your route. Click to travel.\n\nGold routes show the passages you will cross. Unseen rooms reveal themselves as you explore."
 detail.position = Vector2(1305,345)
 detail.size = Vector2(520,195)
 detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 detail.add_theme_font_size_override("font_size",22)
 owner.add_child(detail)
 owner.label_at("YOUR PARTY",Vector2(1305,565),21)
 for i in range(State.party.size()):
  var id: String = State.party[i]
  var image := TextureRect.new()
  image.texture = Scenery.grounded_texture(State.hero(id).camp_art)
  image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  image.position = Vector2(1285+i*180,610)
  image.size = Vector2(175,200)
  image.name = "Party_"+id
  image.set_meta("hero_id",id)
  image.mouse_filter = Control.MOUSE_FILTER_STOP
  image.gui_input.connect(func(event):
   if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT: owner.inspect_hero(id)
  )
  owner.add_child(image)
  Scenery.apply_hero_palette(image,id,str(State.hero_colors.get(id,"original")))
  var hero: Dictionary = State.run_heroes.get(id,{})
  owner.label_at("%s\n%s" % [State.hero(id).name,"Fallen" if hero.get("dead",false) else "%d/%d HP" % [hero.get("hp",0),State.hero_max_hp(id)]],Vector2(1300+i*180,815),16)
 owner.label_at("GOLD %d · RATIONS %d · SCOUTING %d" % [State.gold,State.journey.get("rations",0),State.scout_uses],Vector2(70,920),22)
 var note := Label.new()
 note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 note.text = owner.message
 note.name = "MapMessage"
 note.position = Vector2(70,958)
 note.size = Vector2(890,88)
 note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 note.add_theme_font_size_override("font_size",18)
 owner.add_child(note)
 var inventory: Button = owner.button_at("INVENTORY · TAB",Vector2(990,935),owner.open_inventory)
 inventory.size = Vector2(245,60)
 var scout: Button = owner.button_at("SCOUT",Vector2(1250,935),owner.scout_area)
 scout.size = Vector2(150,60)
 scout.disabled = State.scout_uses <= 0 or State.run_complete or not rooms[State.room_position].get("cleared",false)
 var interact: Button = owner.button_at(owner.room_action_label(),Vector2(1415,935),owner.interact_room)
 interact.size = Vector2(260,60)
 interact.disabled = not owner.room_action_available()
 var retreat: Button = owner.button_at("HAMLET" if State.run_complete else "RETREAT",Vector2(1690,935),owner.retreat)
 retreat.size = Vector2(170,60)
 owner.label_at("CLICK A ROOM TO TRAVEL · TAB INVENTORY · I CONTROLS",Vector2(990,1020),16)
