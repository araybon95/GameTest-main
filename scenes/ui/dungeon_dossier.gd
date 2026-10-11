extends Control
const State = preload("res://scripts/game_data.gd")
const Visual = preload("res://scripts/visual_overlays.gd")
var expedition: Dictionary
var tier: int = 0
var status: String = ""
var region: int = 0

func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 var name_label := text(str(expedition["name"]),Rect2(15,5,435,64),30,Color("#EFDCB5"))
 name_label.name = "DossierTitle"
 var image := TextureRect.new()
 image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 image.name = "EntrancePlate"
 image.texture = load(str(expedition.get("combat_background","res://assets/generated/expedition_map_four_regions.png")))
 image.position = Vector2(15,80); image.size = Vector2(435,150)
 image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 image.mouse_filter = Control.MOUSE_FILTER_IGNORE
 image.modulate = Color(0.78,0.71,0.65) if expedition.get("released",true) else Color(0.35,0.33,0.36)
 add_child(image)
 image.set_deferred("size",Vector2(435,150))
 Visual.frame(image,"warden" if region == 0 else "occultist")
 text("TIER %s · %s" % [["I","II","III"][tier],status],Rect2(20,242,430,28),19,Color("#CEB88D"))
 text(str(expedition["blurb"]),Rect2(20,279,430,105),20,Color("#E3D7BE"))
 var bosses: Array = expedition.get("floor_bosses",[]).duplicate()
 if expedition["id"] == "old_road": bosses = ["ash_chieftain","keep_son","undying_lord"]
 var floors: Array = expedition.get("floor_names",[])
 for index in range(3):
  var y := 398+index*64
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
   portrait.set_deferred("size",Vector2(58,56))
  var floor_name: String = str(floors[index]) if index < floors.size() else "Uncharted descent"
  var guardian: String = str(State.creature(foe)["name"]) if foe != "" else "Sealed · Future release"
  var row := text("%s · %s\n%s" % [["I","II","III"][index],floor_name,guardian],Rect2(88,y,365,58),17,Color("#DCC89F"))
  row.name = "FloorSummary_%d" % index
 if expedition.get("released",true):
  var reward := TextureRect.new()
  reward.name = "GuardianRewardIcon"
  reward.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  reward.texture = load(State.Items.icon_path(str(State.party[0])+"_legend" if not State.party.is_empty() else "warden_legend"))
  reward.position = Vector2(20,596); reward.size = Vector2(32,32)
  reward.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  reward.mouse_filter = Control.MOUSE_FILTER_IGNORE
  add_child(reward)
 text("Legendary party gear from guardians" if expedition.get("released",true) else "Awaiting release · No departure available",Rect2(60,601,392,32),17,Color("#D7B56F"))
 set_meta("floor_count",3)

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
