extends Control
const State = preload("res://scripts/game_data.gd")
var expedition: Dictionary
var tier: int = 0
var status: String = ""
var region: int = 0
var route_open: bool = false
var overview: Array[Control] = []
var route: Array[Control] = []
var route_toggle: Button
var estate_mode: bool = false

func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 var name_label := text(str(expedition["name"]),Rect2(15,5,435,64),30,Color("#EFDCB5"))
 name_label.name = "DossierTitle"
 var image := TextureRect.new()
 image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 image.name = "EntrancePlate"
 var theme_name: String = "beast" if region == 1 else "bandit"
 image.texture = load(preload("res://scripts/room_scene_art.gd").path_for(theme_name,"combat"))
 image.position = Vector2(15,80); image.size = Vector2(435,150)
 image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 image.mouse_filter = Control.MOUSE_FILTER_IGNORE
 image.modulate = Color(0.78,0.71,0.65) if expedition.get("released",true) else Color(0.35,0.33,0.36)
 add_child(image)
 image.set_deferred("size",Vector2(435,150))
 overview.append(text("TIER %s · %s" % [["I","II","III"][tier],status],Rect2(20,242,430,28),18,Color("#CEB88D")))
 overview.append(text(str(expedition["blurb"]),Rect2(20,279,430,105),20,Color("#D2C5AE")))
 overview.append(text("3 FLOORS · "+str(expedition.get("difficulty","Unreleased")).to_upper(),Rect2(20,397,430,30),18,Color("#CAB48E")))
 var route_header := text("ONE RUN · THREE FLOOR GUARDIANS",Rect2(20,242,430,30),17,Color("#CEB88D"))
 route_header.visible = false
 route.append(route_header)
 var bosses: Array = expedition.get("floor_bosses",[]).duplicate()
 if expedition["id"] == "old_road": bosses = ["ash_chieftain","keep_son","undying_lord"]
 var floors: Array = expedition.get("floor_names",[])
 for index in range(3):
  var y := 298+index*70
  var foe: String = str(bosses[index]) if index < bosses.size() else ""
  if foe != "":
   var portrait := TextureRect.new()
   portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
   portrait.name = "GuardianSilhouette_%d" % index
   portrait.texture = load(str(State.creature(foe)["art"]))
   portrait.position = Vector2(20,y); portrait.size = Vector2(58,56)
   portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   portrait.modulate = Color(0.03,0.025,0.03)
   portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
   add_child(portrait)
   portrait.visible = false
   route.append(portrait)
   portrait.set_deferred("size",Vector2(58,56))
  var floor_name: String = str(floors[index]) if index < floors.size() else "Uncharted descent"
  var guardian: String = str(State.creature(foe)["name"]) if foe != "" else "Sealed · Future release"
  var row := text("%s · %s\n%s" % [["I","II","III"][index],floor_name,guardian],Rect2(88,y,365,58),17,Color("#DCC89F"))
  row.name = "FloorSummary_%d" % index
  row.visible = false
  route.append(row)
 if expedition.get("released",true):
  var reward := TextureRect.new()
  reward.name = "GuardianRewardIcon"
  reward.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  reward.texture = load(State.Items.icon_path(str(State.party[0])+"_legend" if not State.party.is_empty() else "warden_legend"))
  reward.position = Vector2(20,445); reward.size = Vector2(32,32)
  reward.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  reward.mouse_filter = Control.MOUSE_FILTER_IGNORE
  add_child(reward)
  overview.append(reward)
 overview.append(text("Guardian rewards · Legendary party gear" if expedition.get("released",true) else "Awaiting release · No departure available",Rect2(60,445,392,48),17,Color("#BCA576")))
 route_toggle = Button.new()
 route_toggle.name = "RouteToggle"
 route_toggle.text = "VIEW FLOOR ROUTE  ›"
 route_toggle.position = Vector2(20,520)
 route_toggle.size = Vector2(435,44)
 route_toggle.mouse_filter = Control.MOUSE_FILTER_STOP
 route_toggle.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 route_toggle.add_theme_font_size_override("font_size",18)
 var box := StyleBoxFlat.new()
 box.bg_color = Color("#211A1D")
 box.border_color = Color("#6E5A43")
 box.set_border_width_all(1)
 for state in ["normal","hover","focus","pressed"]: route_toggle.add_theme_stylebox_override(state,box)
 route_toggle.pressed.connect(toggle_route)
 add_child(route_toggle)
 set_meta("floor_count",3)
 if estate_mode: estate_layout()

func estate_layout() -> void:
 get_node("EntrancePlate").hide()
 overview[0].position = Vector2(20,90)
 overview[1].position = Vector2(20,130)
 overview[1].set_deferred("size",Vector2(430,150))
 overview[1].add_theme_font_size_override("font_size",22)
 overview[2].position = Vector2(20,315)
 var reward_header := text("GUARDIAN REWARDS",Rect2(20,365,430,48),26,Color("#DAC08C"))
 reward_header.name = "RewardHeading"
 overview.append(reward_header)
 var reward_text: Label = overview[overview.size()-2]
 reward_text.position = Vector2(20,515)
 reward_text.set_deferred("size",Vector2(430,42))
 if expedition.get("released",true):
  reward_text.text = "Possible party-class legendary gear"
  var primary: TextureRect = get_node("GuardianRewardIcon")
  primary.position = Vector2(20,415)
  primary.size = Vector2(80,80)
  for i in range(1,State.party.size()):
   var preview := TextureRect.new()
   preview.name = "RewardPreview_%d" % i
   preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
   preview.texture = load(State.Items.icon_path(str(State.party[i])+"_legend"))
   preview.position = Vector2(20+i*105,415)
   preview.size = Vector2(80,80)
   preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
   add_child(preview)
   overview.append(preview)
 route_toggle.position.y = 570
 route[0].position.y = 95
 for node in route.slice(1):
  var index: int = int(str(node.name).get_slice("_",1))
  node.position.y = 165+index*105

func toggle_route() -> void:
 route_open = not route_open
 for node in route: node.visible = route_open
 for node in overview: node.visible = not route_open
 route_toggle.text = "‹  BACK TO OVERVIEW" if route_open else "VIEW FLOOR ROUTE  ›"

func text(value: String,rect: Rect2,font_size: int,tint: Color) -> Label:
 var label := Label.new()
 label.text = value; label.position = rect.position
 label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 label.size = rect.size
 label.clip_text = true
 label.add_theme_font_size_override("font_size",font_size)
 label.add_theme_color_override("font_color",tint)
 if font_size >= 28:
  var font := SystemFont.new(); font.font_names = PackedStringArray(["Georgia","serif"]); font.font_weight = 700
  label.add_theme_font_override("font",font)
 label.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(label)
 label.set_deferred("size",rect.size)
 return label
