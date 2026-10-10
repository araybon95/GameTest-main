extends Control
## Presentation only: navigation authority has already accepted the destination.
signal finished
const State = preload("res://scripts/game_data.gd")
const Regions = preload("res://scripts/ink_sprite_regions.gd")
var duration: float = 1.8
var elapsed: float = 0.0
var complete: bool = false
var scenery: TextureRect
var walkers: Array[TextureRect] = []
var bases: Array[Vector2] = []
var walk_frames: Dictionary = {}
var progress: ProgressBar
var encounter: TextureRect
var arrival_label: Label
var arrived: bool = false
var arrival_duration: float = 0.6
var travel_stage: Control

func _ready() -> void:
 name = "HallwayTravel"
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 mouse_filter = Control.MOUSE_FILTER_STOP
 z_index = 100
 var backdrop := ColorRect.new()
 backdrop.color = Color("#08070A")
 backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(backdrop)
 var stage := Control.new()
 travel_stage = stage
 stage.position = Vector2(0,100)
 stage.size = Vector2(1920,710)
 stage.clip_contents = true
 stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(stage)
 scenery = TextureRect.new()
 var path: String = State.floor_background("combat")
 var stages: Dictionary = {"bandit_combat.png":"bandit_battle_stage.png", "keep_hall.png":"keep_battle_stage.png", "beast_sanctuary.png":"beast_battle_stage.png", "apothecary_interior.png":"apothecary_battle_stage.png"}
 if stages.has(path.get_file()): path = "res://assets/generated/" + stages[path.get_file()]
 scenery.texture = load(path)
 scenery.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 scenery.size = Vector2(2400,1000)
 scenery.position = Vector2(-100,-170)
 scenery.modulate = Color(0.72,0.72,0.77)
 stage.add_child(scenery)
 for id in State.HEROES:
  var path_walk: String = "res://assets/generated/hero_%s_walk.png" % id
  if not ResourceLoader.exists(path_walk): continue
  var sheet: Texture2D = load(path_walk)
  var frames: Array[Texture2D] = []
  for region in Regions.WALK[id]:
   var frame := AtlasTexture.new()
   frame.atlas = sheet
   frame.region = region
   frame.filter_clip = true
   frames.append(frame)
  walk_frames[id] = frames
 var party: Array = State.party.duplicate()
 party.sort_custom(func(a,b): return int(State.hero_positions.get(a,1)) > int(State.hero_positions.get(b,1)))
 for id in party:
  if State.run_heroes.get(id,{}).get("dead",false): continue
  var picture := TextureRect.new()
  picture.texture = walk_frames[id][0] if walk_frames.has(id) else load(str(State.hero(id)["art"]))
  picture.set_meta("walker",id)
  picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  picture.stretch_mode = TextureRect.STRETCH_SCALE
  picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
  var height: float = 330.0
  picture.size = Vector2(height * picture.texture.get_width()/picture.texture.get_height(),height)
  picture.position = Vector2(180 + walkers.size()*260,610-height)
  picture.pivot_offset = Vector2(picture.size.x*.5,height)
  var shadow = preload("res://scenes/combat/ground_shadow.gd").new()
  shadow.position = Vector2(picture.position.x + picture.size.x*.5,608)
  stage.add_child(shadow)
  stage.add_child(picture)
  walkers.append(picture)
  bases.append(picture.position)
  picture.set_meta("base_width",picture.size.x)
  var color: String = State.hero_colors.get(id,"original")
  if color != "original":
   var ink := ShaderMaterial.new()
   ink.shader = preload("res://scripts/hero_palette.gdshader")
   ink.set_shader_parameter("accent",{"red":Color("#B93640"),"green":Color("#389B58"),"blue":Color("#438CCD"),"gold":Color("#D5A03A")}.get(color,Color.WHITE))
   ink.set_shader_parameter("source_family",1 if id == "ranger" else 2 if id == "occultist" else 0)
   picture.material = ink
  var hero_name: String = State.hero(id)["name"]
  var hero_class: String = State.HEROES[id]["name"]
  var hero_label: Label = text_at(hero_name if hero_name == hero_class else "%s · %s" % [hero_name,hero_class],Vector2(picture.position.x + picture.size.x*.5 - 170,900),23)
  hero_label.size = Vector2(340,40)
  hero_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 text_at(State.selected_expedition.get("name","Expedition") + " · " + State.floor_title(),Vector2(70,30),32)
 arrival_label = text_at("Through the passage…",Vector2(70,835),28)
 build_destination()
 progress = ProgressBar.new()
 progress.position = Vector2(70,980)
 progress.size = Vector2(1450,10)
 progress.show_percentage = false
 add_child(progress)
 var skip := Button.new()
 skip.name = "SkipTravel"
 skip.text = "SKIP TRAVEL"
 skip.position = Vector2(1590,930)
 skip.size = Vector2(260,70)
 skip.pressed.connect(skip_travel)
 add_child(skip)

func text_at(value: String, where: Vector2, font_size: int) -> Label:
 var label := Label.new()
 label.text = value
 label.position = where
 label.add_theme_font_size_override("font_size",font_size)
 label.add_theme_color_override("font_color",Color("#DDCEB3"))
 label.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(label)
 return label

func _process(delta: float) -> void:
 if complete: return
 elapsed += delta
 scenery.position.x = -100 - minf(elapsed/duration,1.0)*260
 var moving: bool = elapsed < duration
 if encounter != null: encounter.position.x = 1750.0 - minf(elapsed/duration,1.0)*310.0
 for index in range(walkers.size()):
  var picture: TextureRect = walkers[index]
  var id: String = picture.get_meta("walker")
  var stride: float = minf(elapsed,duration)*10.0 + index*1.7
  var texture: Texture2D = walk_frames[id][int(elapsed*7.0 + index*.5)%4] if moving else load(str(State.hero(id)["art"]))
  var height: float = 330.0
  var width: float = height*texture.get_width()/float(maxi(1,texture.get_height()))
  var anchor: Vector2 = bases[index] + Vector2(float(picture.get_meta("base_width"))*0.5,330.0)
  picture.texture = texture
  picture.size = Vector2(width,height)
  picture.pivot_offset = Vector2(width*0.5,height)
  picture.position = anchor-Vector2(width*0.5,height) + (Vector2(sin(stride*.5)*3,-absf(sin(stride))*4) if moving else Vector2.ZERO)
  picture.rotation = sin(stride)*0.009 if moving else 0.0
 if not moving and not arrived:
  arrived = true
  arrival_label.text = str(arrival_label.get_meta("arrival_text"))
  get_node("SkipTravel").text = "CONTINUE"
 progress.value = minf(elapsed/duration,1.0)*100.0
 queue_redraw()
 if elapsed >= duration + arrival_duration: finish()

func skip_travel() -> void:
 if arrived: finish()
 else: elapsed = duration

func build_destination() -> void:
 if not State.run_active: return
 var room: Dictionary = State.floors[State.floor_index][State.room_position]
 var kind: String = str(room.get("kind","entry"))
 var cleared: bool = room.get("cleared",false)
 var corridor: bool = room.get("event_layout","") == "corridor"
 var title: String = "A passage opens into the next room."
 var art: String = "res://assets/ui/encounter_door.svg"
 if not cleared:
  if kind in ["battle","boss"] or room.get("corridor_encounter","") == "roamer":
   var enemies: Array = room.get("enemies",[])
   var id: String = str(enemies[0]) if not enemies.is_empty() else str(room.get("creature",State.selected_expedition.get("creature","ash_raider")))
   var creature: Dictionary = State.CREATURES.get(id,{})
   art = str(creature.get("art",art))
   title = "%s waits ahead." % creature.get("name","A creature")
   if room.get("corridor_encounter","") == "roamer": title = "A lone creature roams the corridor."
  elif kind == "event":
   if room.get("corridor_encounter","") == "gold":
    art = "res://assets/ui/encounter_gold.svg"
    title = "A few coins lie beside the passage."
   else:
    var id: String = str(room.get("event_id","bandit_strongbox"))
    var candidate: String = "res://assets/generated/event_%s.png" % id
    if ResourceLoader.exists(candidate): art = candidate
    var event_name: String = str(State.Events.definition(id).get("name","Something"))
    title = "%s waits in the %s…" % [event_name,"corridor" if corridor else "chamber"]
  elif kind == "camp":
   art = "res://assets/ui/encounter_camp.svg"
   title = "A sheltered fire offers respite."
  elif kind == "stairs": title = "The descent waits beyond this door."
 arrival_label.set_meta("arrival_text",title)
 encounter = TextureRect.new()
 encounter.name = "DestinationProp"
 encounter.texture = load(art)
 encounter.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 encounter.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 encounter.mouse_filter = Control.MOUSE_FILTER_IGNORE
 encounter.size = Vector2(330,350)
 encounter.position = Vector2(1750,260)
 travel_stage.add_child(encounter)

func _draw() -> void:
 # Fog drifts slower than the ground; dark foreground posts move faster.
 for index in range(4):
  var x: float = fposmod(index*650.0-minf(elapsed,duration)*45.0,2500.0)-300.0
  draw_fog_patch(Vector2(x,710),Vector2(370,28),Color(0.36,0.34,0.38,0.055))
 for index in range(3):
  var x: float = fposmod(index*850.0-minf(elapsed,duration)*240.0,2600.0)-150.0
  draw_colored_polygon(PackedVector2Array([Vector2(x,815),Vector2(x+18,700),Vector2(x+34,660),Vector2(x+40,815)]),Color("#0B090D"))

func draw_fog_patch(center: Vector2, radius: Vector2, color: Color) -> void:
 var points := PackedVector2Array()
 for index in range(40):
  var angle: float = TAU*index/40.0
  points.append(center+Vector2(cos(angle),sin(angle))*radius)
 draw_colored_polygon(points,color)

func finish() -> void:
 if complete: return
 complete = true
 finished.emit()
 queue_free()


