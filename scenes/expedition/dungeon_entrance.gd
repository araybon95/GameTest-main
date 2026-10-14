extends RefCounted
## The first room is a physical threshold; map access never moves the party.
const State = preload("res://scripts/game_data.gd")
const Standing = preload("res://scripts/standing_party.gd")
class EntranceBackdrop extends TextureRect:
 func _process(_delta: float) -> void:
  var settings = get_node_or_null("/root/GameSettings")
  material.set_shader_parameter("animate",settings == null or settings.ambient_motion)
static func available() -> bool:
 return State.run_active and State.floor_index == 0 and State.room_position == Vector2i.ZERO and State.floors[0].get(Vector2i.ZERO,{}).get("kind","") == "entry" and State.journey.get("transit",{}).is_empty()
static func build(owner: Control) -> void:
 var backdrop := EntranceBackdrop.new()
 backdrop.name = "EntranceBackground"
 backdrop.texture = load("res://assets/art_library/generated/dungeon_entrance.png")
 backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 backdrop.size = Vector2(1920,900)
 backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
 var light := ShaderMaterial.new()
 light.shader = preload("res://assets/shaders/dungeon_gate.gdshader")
 var settings = owner.get_node_or_null("/root/GameSettings")
 light.set_shader_parameter("animate",settings == null or settings.ambient_motion)
 backdrop.material = light
 owner.add_child(backdrop)
 var shade := ColorRect.new()
 shade.size = Vector2(1920,145)
 shade.color = Color(0.02,0.015,0.025,0.68)
 shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
 owner.add_child(shade)
 owner.label_at(State.selected_expedition.get("name","The Dungeon").to_upper()+" · THE THRESHOLD",Vector2(65,50),32)
 owner.label_at("The iron gate waits. Choose a path into the dark.",Vector2(65,105),21)
 var order: Array = State.party.duplicate()
 order.sort_custom(func(a,b): return int(State.hero_positions.get(a,1)) > int(State.hero_positions.get(b,1)))
 for index in range(order.size()):
  var id: String = order[index]
  var centre: float = 280+index*360
  var shadow = preload("res://scenes/combat/ground_shadow.gd").new()
  shadow.position = Vector2(centre,795)
  owner.add_child(shadow)
  var actor = Standing.create(id,Vector2(centre,800),390)
  actor.name = "Party_"+id
  actor.mouse_filter = Control.MOUSE_FILTER_STOP
  actor.gui_input.connect(func(event):
   if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT: owner.inspect_hero(id)
  )
  owner.add_child(actor)
 var gate: Button = owner.button_at("",Vector2(1270,180),owner.open_route_map)
 gate.name = "EntranceGate"
 gate.size = Vector2(555,595)
 gate.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 gate.tooltip_text = "Open the dungeon map and choose your first chamber."
 for state in ["normal","disabled","pressed","hover","focus"]: gate.add_theme_stylebox_override(state,StyleBoxEmpty.new())
 gate.mouse_entered.connect(func(): light.set_shader_parameter("gate_focus",1.0))
 gate.mouse_exited.connect(func(): light.set_shader_parameter("gate_focus",0.0))
 gate.focus_entered.connect(func(): light.set_shader_parameter("gate_focus",1.0))
 gate.focus_exited.connect(func(): light.set_shader_parameter("gate_focus",0.0))
 owner.label_at("ENTER THE DUNGEON",Vector2(1320,785),24)
 owner.label_at("Click the iron gate to choose your route",Vector2(1265,830),18)
 owner.panel_at(Rect2(0,900,1920,180),Color("#100D12"))
 for index in range(order.size()):
  var id: String = order[index]
  var hero: Dictionary = State.run_heroes.get(id,{})
  owner.label_at(str(State.hero(id).name).to_upper(),Vector2(65+index*360,930),22)
  owner.label_at("Fallen" if hero.get("dead",false) else "HP %d / %d · STRESS %d" % [hero.get("hp",0),State.hero_max_hp(id),hero.get("stress",0)],Vector2(65+index*360,971),19)
 owner.label_at("GOLD %d · RATIONS %d" % [State.gold,State.journey.get("rations",0)],Vector2(65,1033),19)
 var map: Button = owner.button_at("DUNGEON MAP",Vector2(1220,930),owner.open_route_map)
 map.size = Vector2(280,65)
 var inventory: Button = owner.button_at("INVENTORY · TAB",Vector2(1515,930),owner.open_inventory)
 inventory.size = Vector2(330,65)
 var retreat: Button = owner.button_at("RETURN TO HAMLET",Vector2(1220,1005),owner.retreat)
 retreat.size = Vector2(625,50)
 retreat.add_theme_font_size_override("font_size",20)
