extends Control
## A deterministic, input-transparent interior with independently replaceable art.
const State = preload("res://scripts/game_data.gd")
const Visual = preload("res://scripts/visual_overlays.gd")
const SETTINGS = {
 "chapel":{"art":"chapel_interior.png","fallback":"keep_hall.png","tint":"#CAB47E","name":"The Keeper of Names","lore":"Every account is a candle against oblivion.","material":"devotional"},
 "barracks":{"art":"barracks_interior.png","fallback":"keep_hall.png","tint":"#9AB0BF","name":"The Quartermaster","lore":"A place at this table must be earned again each dawn.","material":"parchment"},
 "forge":{"art":"workshop_interior.png","fallback":"keep_hall.png","tint":"#D49A6A","name":"The Ash Smith","lore":"Steel remembers the hand that survived its tempering.","material":"scorched"},
 "workshop":{"art":"workshop_interior.png","fallback":"keep_hall.png","tint":"#C6A36D","name":"The Threadkeeper","lore":"We mend what the road has not yet taken.","material":"scorched"},
 "apothecary":{"art":"","fallback":"apothecary_reclaimed.png","tint":"#9DBEA7","name":"The Ward Physician","lore":"Mercy is measured in drops, and never promised.","material":"medical"},
 "merchant":{"art":"","fallback":"keep_hall.png","tint":"#A3B5BF","name":"The Lantern Trader","lore":"Everything has a price. Some debts cannot be paid in gold.","material":"parchment"},
 "watchtower":{"art":"barracks_interior.png","fallback":"keep_hall.png","tint":"#9AB0BF","name":"The Last Watch","lore":"Someone must keep an eye upon the road.","material":"parchment"}
}
var kind: String = "barracks"
var restored: bool = true
var clock: float = 0.0
var strength: float = 1.0
var attendant: TextureRect
var origin: Vector2
var npc_rect := Rect2(55,205,330,400)

static func install(scope: Control, style: String, reclaimed: bool = true, portrait_rect: Rect2 = Rect2(55,205,330,400)) -> Control:
 scope.set_meta("interior_kind",style)
 scope.set_meta("surface_material",SETTINGS.get(style,SETTINGS["barracks"])["material"])
 var existing := scope.get_node_or_null("StaticInterior")
 if existing != null:
  scope.remove_child(existing)
  existing.queue_free()
 var interior = load("res://scripts/static_screen_art.gd").new()
 interior.name = "StaticInterior"
 interior.kind = style
 interior.restored = reclaimed
 interior.npc_rect = portrait_rect
 interior.mouse_filter = Control.MOUSE_FILTER_IGNORE
 interior.z_index = -10
 scope.add_child(interior)
 scope.move_child(interior,0)
 for name in ["Background","Overlay"]:
  if scope.has_node(name): scope.get_node(name).hide()
 return interior

static func surface(panel: Control, style: String) -> void:
 var colors: Dictionary = {"parchment":["#261E19","#B29B74"],"devotional":["#20171D","#B3A17B"],"scorched":["#191615","#A07958"],"medical":["#14221D","#8CA597"]}
 var palette: Array = colors.get(style,colors["parchment"])
 var box := StyleBoxFlat.new()
 box.bg_color = Color(palette[0]); box.bg_color.a = 0.85
 box.border_color = Color(palette[1]).darkened(0.25)
 box.set_border_width_all(2)
 box.set_content_margin_all(14)
 box.shadow_color = Color(0,0,0,0.75); box.shadow_size = 5
 panel.add_theme_stylebox_override("panel",box)
 panel.set_meta("surface_material",style)
 Visual.frame(panel,str(panel.get_meta("hero_id","")))

static func transition(scope: Control) -> void:
 # Initial entrances only; rebuilding a shop after a transaction never fades it.
 if scope.has_meta("static_entrance"): return
 scope.set_meta("static_entrance",true)
 var curtain := ColorRect.new()
 curtain.name = "EntranceCurtain"
 curtain.color = Color("#09080A")
 curtain.mouse_filter = Control.MOUSE_FILTER_IGNORE
 curtain.z_index = 80
 curtain.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 scope.add_child(curtain)
 var duration := 0.34
 var settings := scope.get_node_or_null("/root/GameSettings")
 if settings != null and not settings.ambient_motion: duration = 0.05
 var fade := scope.create_tween()
 scope.set_meta("entrance_tween",fade)
 fade.tween_property(curtain,"modulate:a",0.0,duration)
 fade.tween_callback(curtain.queue_free)

func _ready() -> void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var settings: Dictionary = SETTINGS.get(kind,SETTINGS["barracks"])
 var path := "res://assets/art_library/presentation/settlement/" + str(settings["art"])
 if settings["art"] == "" or not ResourceLoader.exists(path): path = "res://assets/art_library/generated/" + str(settings["fallback"])
 var background := TextureRect.new()
 background.name = "InteriorBackground"
 background.texture = load(path)
 background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 background.mouse_filter = Control.MOUSE_FILTER_IGNORE
 background.modulate = Color(0.88,0.85,0.81) if restored else Color(0.48,0.45,0.43)
 add_child(background)
 var shade := ColorRect.new()
 shade.color = Color(0.025,0.018,0.025,0.2)
 shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(shade)
 if restored:
  attendant = TextureRect.new()
  attendant.name = "Attendant"
  attendant.z_index = 11
  attendant.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  var npc_kind := "barracks" if kind == "watchtower" else kind
  attendant.texture = load("res://assets/art_library/presentation/settlement/%s_attendant.png" % npc_kind)
  attendant.position = npc_rect.position; attendant.size = npc_rect.size
  origin = attendant.position
  attendant.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  attendant.mouse_filter = Control.MOUSE_FILTER_IGNORE
  add_child(attendant)
  attendant.set_deferred("size",npc_rect.size)
  if get_parent().get_meta("interior_captions",true): caption(str(settings["name"]),Vector2(npc_rect.position.x,npc_rect.end.y+12),npc_rect.size.x,25,Color(settings["tint"]))
  if get_parent().get_meta("interior_captions",true): caption(str(settings["lore"]),Vector2(npc_rect.position.x,npc_rect.end.y+53),npc_rect.size.x,19,Color("#DDCEB2"))
  var trophies := progress_marks()
  if get_parent().get_meta("interior_captions",true) and not trophies.is_empty():
   if kind != "chapel": caption("RELICS OF THE ROAD\n"+"\n".join(trophies),Vector2(npc_rect.position.x,npc_rect.end.y+118),npc_rect.size.x,16,Color(settings["tint"]))
   var earned: Array[String] = []
   if State.completed_expeditions.has("old_road"): earned.append("warden_legend")
   if State.completed_expeditions.has("path_beast"): earned.append("occultist_legend")
   if State.apothecary_unlocked(): earned.append("cleansing_potion")
   for i in range(earned.size()):
    var icon := TextureRect.new()
    icon.name = "EarnedRelic_%d" % i
    icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    icon.texture = load(State.Items.icon_path(earned[i]))
    icon.position = Vector2(npc_rect.position.x+i*45,650 if kind == "chapel" else npc_rect.end.y-32)
    icon.size = Vector2(32,32)
    icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
    icon.z_index = 11
    add_child(icon)
 var atmosphere := Atmosphere.new()
 atmosphere.name = "InteriorAtmosphere"
 atmosphere.kind = kind
 atmosphere.restored = restored
 atmosphere.mouse_filter = Control.MOUSE_FILTER_IGNORE
 atmosphere.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(atmosphere)

func caption(value: String, point: Vector2, width: float, font_size: int, tint: Color) -> void:
 var label := Label.new()
 label.text = value; label.position = point
 label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 label.size = Vector2(width,100)
 label.add_theme_font_size_override("font_size",font_size)
 if font_size <= 16: label.add_theme_constant_override("line_spacing",-4)
 label.add_theme_color_override("font_color",tint)
 label.add_theme_color_override("font_shadow_color",Color.BLACK)
 label.add_theme_constant_override("shadow_offset_x",2)
 label.add_theme_constant_override("shadow_offset_y",2)
 label.z_index = 11
 label.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(label)
 label.set_deferred("size",Vector2(width,100))
 var runtime := get_node_or_null("/root/GameSettings")
 if runtime == null or runtime.ambient_motion:
  label.modulate.a = 0.0
  var reveal := create_tween()
  reveal.tween_property(label,"modulate:a",1.0,0.4)

func progress_marks() -> Array[String]:
 var result: Array[String] = []
 if State.completed_expeditions.has("old_road"): result.append("◆ Broken lord's crest")
 if State.completed_expeditions.has("path_beast"): result.append("◆ Silent fragment of the Head")
 if State.apothecary_unlocked(): result.append("◆ The ward's sealed vial")
 if kind == "workshop" and State.service_unlocked("workshop"): result.append("◆ Reclaimed artisans' tools")
 return result.slice(0,3)

func _process(delta: float) -> void:
 var settings := get_node_or_null("/root/GameSettings")
 strength = 0.0 if settings != null and not settings.ambient_motion else 1.0
 clock += delta*strength
 if attendant != null: attendant.position = origin+Vector2(0,sin(clock*0.9)*1.6*strength)

class Atmosphere extends Control:
 var kind: String
 var restored: bool
 var clock: float = 0.0
 func _process(delta: float) -> void:
  var settings := get_node_or_null("/root/GameSettings")
  if settings != null and not settings.ambient_motion: return
  clock += delta
  queue_redraw()
 func _draw() -> void:
  var tint := Color("#D49A6A") if kind in ["forge","workshop"] else Color("#A9CDB4") if kind == "apothecary" else Color("#D6C397")
  # Foreground silhouettes and controlled illumination never pass over text.
  draw_colored_polygon(PackedVector2Array([Vector2.ZERO,Vector2(30,0),Vector2(62,1080),Vector2(0,1080)]),Color(0.01,0.01,0.015,0.9))
  draw_colored_polygon(PackedVector2Array([Vector2(1890,0),Vector2(1920,0),Vector2(1920,1080),Vector2(1855,1080)]),Color(0.01,0.01,0.015,0.8))
  for i in range(24):
   var point := Vector2(55+fmod(i*53.7+sin(clock*.2+i)*15,355),145+fmod(i*67.1-clock*(7+i%4),535))
   var light := tint; light.a = 0.12+0.12*sin(clock+i)*sin(clock+i)
   draw_circle(point,1.0+float(i%3)*0.4,light)
  for i in range(6):
   var light := tint; light.a = (0.025+0.003*sin(clock*2.2))*float(6-i)
   draw_circle(Vector2(190,560),24+i*15,light)
  if not restored:
   for i in range(7): draw_line(Vector2(0,100+i*120),Vector2(390,230+i*95),Color(0.3,0.32,0.24,0.13),1.0)
  else:
   # Reclaimed workspaces gain usable furnishings, absent in occupied rooms.
   draw_rect(Rect2(65,790,280,9),Color("#181214"))
   if kind in ["apothecary","merchant"]:
    for i in range(4):
     draw_rect(Rect2(105+i*48,753,20,35),Color("#29453D"))
     draw_rect(Rect2(111+i*48,744,8,12),Color("#C1AA81"))
     draw_line(Vector2(109+i*48,760),Vector2(109+i*48,779),Color("#A4D4B2"),2)
   elif kind in ["forge","workshop"]:
    for i in range(3):
     draw_line(Vector2(120+i*65,750),Vector2(120+i*65,788),Color("#8E9295"),4)
     draw_line(Vector2(108+i*65,751),Vector2(132+i*65,751),Color("#B4A48D"),5)
   else:
    for i in range(3):
     draw_rect(Rect2(105+i*62,775-i*4,47,12),Color("#73513D"))
     draw_line(Vector2(112+i*62,779-i*4),Vector2(146+i*62,779-i*4),Color("#BCA67B"),2)
