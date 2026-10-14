extends Control
## Movement along an agreed passage. Entering its destination commits in dungeon.move_to.
signal finished
signal room_interaction
var room_mode: bool = false
const State = preload("res://scripts/game_data.gd")
const Regions = preload("res://scripts/ink_sprite_regions.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
const TravelAudio = preload("res://scripts/travel_audio.gd")
const LocalArt = preload("res://scripts/local_dungeon_art.gd")
const LocalLayers = preload("res://scripts/local_hallway_layers.gd")
const ActorMotion = preload("res://scripts/hallway_actor_motion.gd")
const QUIET_WALK_POSE: int = 1
const GROUND_Y: float = 430.0
const HERO_HEIGHT: float = 280.0
var duration: float = 5.6
var elapsed: float = 0.0
var complete: bool = false
var auto_walk: bool = false
var manual_walking: bool = false
var manual_direction: int = 0
var left_held: bool = false
var right_held: bool = false
var pointer_direction: int = 0
var facing_left: bool = false
var reached_destination: bool = false
var pointer_walking: bool = false
var moving: bool = false
var animation_clock: float = 0.0
var warden_clock: float = 0.0
var actor_clock: float = 0.0
var actor_walking: float = 0.0
var ambient_clock: float = 0.0
var distance_travelled: float = 0.0
var route_origin := Vector2i.ZERO
var route_steps: Array = []
var scenery: TextureRect
var walkers: Array[TextureRect] = []
var bases: Array[Vector2] = []
var walk_frames: Dictionary = {}
var standing_frames: Dictionary = {}
var wardrobe_looks: Dictionary = {}
var shadows: Array[Node2D] = []
var progress: PassageProgress
var encounter: TextureRect
var arrival_label: Label
var arrived: bool = false
var arrival_duration: float = 0.6 # Compatibility for older previews; arrival now waits for interaction.
var travel_stage: Control
var atmosphere: Control
var scene_theme: String = "bandit"
var footsteps: AudioStreamPlayer
var footstep_clock: float = 0.0
var stride_distance: float = 0.0
const STRIDE: float = 84.0
var footsteps_played: int = 0
var transition_shade: ColorRect
var encounter_end_x: float = 1430.0
var encounter_start_x: float = 2300.0
var encounter_shadow: Node2D
var walk_button: Button
var interact_button: Button
var destination_button: Button
var passage_map: Control
var encounter_glow: ShaderMaterial
var source_door: TextureRect
var source_button: Button
var return_button: Button
var hero_summaries: Dictionary = {}
var gold_counter: Label
var route_clue: Label
var choice_panel: Control
var preparation_button: Button
var discovery_action: String = ""
var investigator: String = ""

class PassageProgress extends Control:
 var value: float = 0.0
 func _ready() -> void:
  mouse_filter = Control.MOUSE_FILTER_IGNORE
 func _draw() -> void:
  draw_rect(Rect2(Vector2.ZERO,size),Color("#251F21"))
  draw_rect(Rect2(Vector2.ZERO,Vector2(size.x*clampf(value/100.0,0,1),size.y)),Color("#BA9C65"))

class PassageMap extends Control:
 var rooms: Dictionary = {}
 var origin := Vector2i.ZERO
 var route: Array = []
 var fraction: float = 0.0
 var positions: Dictionary = {}
 var icon_extent: float = 30.0
 func _ready() -> void:
  mouse_filter = Control.MOUSE_FILTER_IGNORE
  var minimum := Vector2(10000,10000)
  var maximum := Vector2(-10000,-10000)
  for location in rooms:
   if not rooms[location].get("seen",false): continue
   minimum = minimum.min(Vector2(location))
   maximum = maximum.max(Vector2(location))
  var actual_span: Vector2 = maximum-minimum
  var span: Vector2 = actual_span.max(Vector2.ONE)
  var step: float = minf((size.x-36)/span.x,(size.y-36)/span.y)
  icon_extent = clampf(step*0.62,14.0,30.0)
  var offset := (size-actual_span*step)*0.5
  for location in rooms:
   if rooms[location].get("seen",false): positions[location] = offset+(Vector2(location)-minimum)*step
 func _draw() -> void:
  var art = preload("res://scripts/route_map_art.gd")
  art.backing(self)
  for location in positions:
   for direction in [Vector2i.RIGHT,Vector2i.DOWN]:
    var next: Vector2i = location+direction
    if positions.has(next): art.corridor(self,positions[location],positions[next])
  var trail: Array = [origin]
  trail.append_array(route)
  for index in range(trail.size()-1):
   if positions.has(trail[index]) and positions.has(trail[index+1]):
    art.corridor(self,positions[trail[index]],positions[trail[index+1]],true)
  for location in positions:
   var extent := Vector2(icon_extent,icon_extent*0.6) if rooms[location].get("event_layout","") == "corridor" else Vector2.ONE*icon_extent
   art.room(self,Rect2(positions[location]-extent*0.5,extent),rooms[location])
  if trail.is_empty() or not positions.has(trail[0]): return
  var current: Vector2 = positions[trail[0]]
  if trail.size() > 1:
   var leg: float = fraction*(trail.size()-1)
   var index: int = mini(int(leg),trail.size()-2)
   if positions.has(trail[index]) and positions.has(trail[index+1]):
    current = positions[trail[index]].lerp(positions[trail[index+1]],clampf(leg-index,0,1))
  draw_circle(current,5,Color("#FFE4A6"))
  draw_arc(current,10,0,TAU,24,Color("#DDB970"),2,true)

func _ready() -> void:
 name = "HallwayTravel"
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 mouse_filter = Control.MOUSE_FILTER_STOP
 z_index = 0 if room_mode else 100
 var backdrop := ColorRect.new()
 backdrop.color = Color("#08070A")
 backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(backdrop)
 travel_stage = Control.new()
 travel_stage.name = "TravelStage"
 travel_stage.position = Vector2.ZERO
 travel_stage.size = Vector2(1920,600)
 # A closer exploration camera preserves sprite proportions and the shared ground plane.
 travel_stage.scale = Vector2(1.25,1.25)
 travel_stage.position = Vector2(-180,0)
 travel_stage.clip_contents = true
 travel_stage.mouse_filter = Control.MOUSE_FILTER_STOP
 travel_stage.gui_input.connect(stage_input)
 add_child(travel_stage)
 scene_theme = Scenery.theme_for(State.selected_expedition,State.floor_index)
 var local_profile: Variant = LocalArt.load_profile_files(scene_theme,State.floor_index)
 if local_profile is Dictionary:
  atmosphere = LocalLayers.new()
  atmosphere.profile = local_profile
 else:
  atmosphere = load("res://scripts/hallway_scenery.gd").new()
 atmosphere.name = "PassageScenery"
 atmosphere.scene_theme = scene_theme
 atmosphere.ground_y = GROUND_Y
 atmosphere.size = travel_stage.size
 travel_stage.add_child(atmosphere)
 scenery = atmosphere.background
 footsteps = AudioStreamPlayer.new()
 footsteps.name = "Footsteps"
 footsteps.stream = TravelAudio.footstep(scene_theme)
 footsteps.volume_db = -21.0
 footsteps.bus = "Effects" if AudioServer.get_bus_index("Effects") >= 0 else "Master"
 add_child(footsteps)
 build_walkers()
 build_source()
 build_destination()
 if atmosphere.near_layer != null:
  atmosphere.remove_child(atmosphere.near_layer)
  travel_stage.add_child(atmosphere.near_layer)
  atmosphere.near_layer.modulate.a = 0.55
 if room_mode:
  source_button.hide()
  arrived = true
  destination_button.visible = true
  destination_button.disabled = false
  encounter.position.x = encounter_end_x
  destination_button.position = encounter.position-Vector2(12,12)
  encounter_glow.set_shader_parameter("strength",0.32)
 else: build_hud()
 transition_shade = ColorRect.new()
 transition_shade.name = "PassageFade"
 transition_shade.color = Color.BLACK
 transition_shade.size = Vector2(1920,1080)
 transition_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(transition_shade)
 Scenery.decorate(self)
 if not room_mode: update_controls()

func build_walkers() -> void:
 for id in State.HEROES:
  var costume: String = str(State.hero(id).get("equipment_look","original"))
  if id == "warden" and costume in ["original","ashen_wolf"]:
   walk_frames[id] = preload("res://scripts/warden_outfits.gd").walks(costume)
   continue
  if costume == "relic" and preload("res://scripts/equipment_art.gd").available(id):
   var equipped_frames: Array[Texture2D] = []
   for index in range(4,8): equipped_frames.append(preload("res://scripts/equipment_art.gd").frame(id,index))
   walk_frames[id] = equipped_frames
   continue
  if costume == "alternate" and preload("res://scripts/hero_appearance.gd").available(id):
   var variant_frames: Array[Texture2D] = []
   for index in range(4,8): variant_frames.append(preload("res://scripts/hero_appearance.gd").frame(id,index))
   walk_frames[id] = variant_frames
   continue
  var path: String = "res://assets/art_library/generated/hero_%s_walk.png" % id
  if not ResourceLoader.exists(path) or not Regions.WALK.has(id): continue
  var sheet: Texture2D = load(path)
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
  standing_frames[id] = Scenery.grounded_texture(str(State.hero(id)["art"]))
  if id == "warden" and costume_for_warden(id): standing_frames[id] = walk_frames[id][0]
  wardrobe_looks[id] = str(State.hero(id).get("equipment_look","original"))
  picture.texture = walk_frames[id][QUIET_WALK_POSE] if walk_frames.has(id) else standing_frames[id]
  picture.name = "Walker_%s" % id
  picture.set_meta("walker",id)
  picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  picture.stretch_mode = TextureRect.STRETCH_SCALE
  picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
  picture.size = Vector2(HERO_HEIGHT*picture.texture.get_width()/picture.texture.get_height(),HERO_HEIGHT)
  var center_x: float = 315.0+walkers.size()*270.0
  picture.position = Vector2(center_x-picture.size.x*0.5,GROUND_Y-HERO_HEIGHT)
  picture.pivot_offset = Vector2(picture.size.x*0.5,HERO_HEIGHT)
  var shadow = preload("res://scenes/combat/ground_shadow.gd").new()
  shadow.position = Vector2(center_x,GROUND_Y-2)
  travel_stage.add_child(shadow)
  travel_stage.add_child(picture)
  walkers.append(picture)
  shadows.append(shadow)
  bases.append(Vector2(center_x,GROUND_Y))
  Scenery.apply_hero_palette(picture,id,State.hero_colors.get(id,"original"))
  ActorMotion.attach(picture,id)
 update_walkers()

func build_hud() -> void:
 build_exploration_frame()
 text_at("%s · %s" % [State.selected_expedition.get("name","Expedition"),State.floor_title()],Vector2(55,28),28,1540)
 route_clue = text_at("",Vector2(55,695),22,1220)
 route_clue.name = "RouteClue"
 route_clue.add_theme_color_override("font_color",Color("#DCC39A"))
 text_at("ON THE ROAD",Vector2(55,775),17,1000).add_theme_color_override("font_color",Color("#BDA57A"))
 arrival_label = text_at("Hold D / → to set out. Hold A / ← to return to the starting doorway.",Vector2(55,806),21,1040)
 arrival_label.name = "EncounterInspection"
 arrival_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 arrival_label.size.y = 64
 arrival_label.set_meta("arrival_text",destination_description())
 interact_button = action_button("ENTER · W / ENTER",Rect2(1510,990,355,50),interact_destination,"SkipTravel")
 walk_button = action_button("WALK ON",Rect2(1130,990,180,50),toggle_walking,"WalkToggle")
 return_button = action_button("RETURN",Rect2(1320,990,180,50),return_to_origin,"ReturnToOrigin")
 text_at("A / D move · W / Enter interact · Tab inventory · I controls",Vector2(55,1037),17,1040)
 gold_counter = text_at("GOLD  %d" % State.gold,Vector2(55,992),22,260)
 preparation_button = action_button("PREPARE",Rect2(350,990,300,50),open_doorway_choices,"PrepareDoorway")
 for index in range(walkers.size()): build_hero_summary(str(walkers[index].get_meta("walker")),index)
 var map_panel := panel_at(Rect2(1130,775,735,200))
 text_at("ROUTE · FLOOR %d / %d" % [State.floor_index+1,State.floor_count],Vector2(1147,783),20,690)
 passage_map = PassageMap.new()
 passage_map.name = "PassageMap"
 passage_map.rooms = State.floors[State.floor_index] if State.run_active else {}
 passage_map.origin = route_origin
 passage_map.route = route_steps.duplicate()
 if passage_map.route.is_empty(): passage_map.route = [State.room_position]
 passage_map.position = Vector2(10,32)
 passage_map.size = Vector2(715,158)
 map_panel.add_child(passage_map)
 progress = PassageProgress.new()
 progress.name = "PassageProgress"
 progress.position = Vector2(55,754)
 progress.size = Vector2(1810,4)
 add_child(progress)

func build_exploration_frame() -> void:
 var frame := preload("res://scenes/expedition/exploration_frame.gd").new()
 frame.name = "ExplorationFrame"
 frame.scene_theme = scene_theme
 frame.size = Vector2(1920,1080)
 add_child(frame)

func build_hero_summary(id: String, index: int) -> void:
 var left: float = 55.0+index*350.0
 var panel := panel_at(Rect2(left,867,335,105))
 panel.set_meta("hero_id", id)
 var portrait := TextureRect.new()
 portrait.texture = standing_frames[id]
 portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 portrait.position = Vector2(8,8)
 portrait.size = Vector2(65,88)
 portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
 Scenery.apply_hero_palette(portrait,id,State.hero_colors.get(id,"original"))
 panel.add_child(portrait)
 var hero: Dictionary = State.hero(id)
 var hero_name := text_at(str(hero["name"]),Vector2(left+82,873),20,240)
 hero_name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
 text_at(str(State.HEROES[id]["name"]),Vector2(left+82,901),16,240).add_theme_color_override("font_color",Color("#B7AB99"))
 var stats: Dictionary = State.run_heroes.get(id,{})
 var max_hp: int = int(stats.get("max_hp",hero.get("max_hp",1)))
 var hp: int = int(stats.get("hp",max_hp))
 var health := text_at("HP %d / %d" % [hp,max_hp],Vector2(left+82,929),17,125)
 var stress := text_at("STRESS %d" % int(stats.get("stress",0)),Vector2(left+212,930),16,112)
 stress.add_theme_color_override("font_color",Color("#C1B7AC"))
 var bar := ColorRect.new()
 bar.color = Color("#952C36")
 bar.position = Vector2(82,94)
 bar.size = Vector2(224.0*clampf(float(hp)/maxi(1,max_hp),0,1),5)
 bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
 panel.add_child(bar)
 hero_summaries[id] = {"health":health,"stress":stress,"bar":bar}
 var inspect := Button.new()
 inspect.name = "Party_" + id
 inspect.set_meta("hero_id", id)
 inspect.size = panel.size
 inspect.tooltip_text = "Inspect hero · Right-click / C"
 for state in ["normal","hover","pressed","focus"]: inspect.add_theme_stylebox_override(state,StyleBoxEmpty.new())
 inspect.pressed.connect(func():
  var controls := get_node_or_null("/root/GameControls")
  if controls != null: controls.open_hero_sheet(id))
 panel.add_child(inspect)

func panel_at(rect: Rect2) -> Panel:
 var panel := Panel.new()
 panel.position = rect.position
 panel.size = rect.size
 panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
 var box := StyleBoxFlat.new()
 box.bg_color = Color("#141113")
 box.border_color = Color("#5B4D46")
 box.set_border_width_all(1)
 panel.add_theme_stylebox_override("panel",box)
 add_child(panel)
 panel.add_child(preload("res://scenes/combat/iron_frame.gd").new())
 return panel

func text_at(value: String, where: Vector2, font_size: int, width: float = 900) -> Label:
 var label := Label.new()
 label.text = value
 label.position = where
 label.size = Vector2(width,42)
 label.add_theme_font_size_override("font_size",font_size)
 label.add_theme_color_override("font_color",Color("#E3D4BC"))
 label.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(label)
 return label

func action_button(value: String, rect: Rect2, action: Callable, node_name: String) -> Button:
 var button := Button.new()
 button.name = node_name
 button.text = value
 button.position = rect.position
 button.size = rect.size
 button.add_theme_font_size_override("font_size",22)
 for state in ["normal","hover","pressed","focus","disabled"]:
  var box := StyleBoxFlat.new()
  box.bg_color = Color("#34241F") if state in ["hover","pressed"] else Color("#171315")
  box.border_color = Color("#D5BA87") if state in ["hover","focus"] else Color("#675447")
  box.set_border_width_all(2)
  box.set_content_margin_all(8)
  button.add_theme_stylebox_override(state,box)
 button.add_theme_color_override("font_color",Color("#E8D9BE"))
 button.add_theme_color_override("font_disabled_color",Color("#887B6A"))
 button.pressed.connect(action)
 add_child(button)
 return button

func settings_open() -> bool:
 if is_instance_valid(choice_panel): return true
 var controls := get_node_or_null("/root/GameControls")
 if controls != null and controls.input_blocked(): return true
 var settings := get_node_or_null("/root/GameSettings")
 return settings != null and settings.overlay != null

func set_walking(value: bool) -> void:
 if complete or arrived or settings_open(): return
 auto_walk = value
 if not value:
  manual_walking = false
  manual_direction = 0
  left_held = false
  right_held = false
  pointer_walking = false
  moving = false
  if footsteps != null: footsteps.stop()
 update_controls()

func toggle_walking() -> void:
 set_walking(not auto_walk)

func stage_input(event: InputEvent) -> void:
 if room_mode: return
 if settings_open() or complete: return
 if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
  auto_walk = false
  pointer_walking = event.pressed
  pointer_direction = -1 if event.position.x < travel_stage.size.x * 0.5 - 1.0 else 1
  update_controls()
  travel_stage.accept_event()

func _input(event: InputEvent) -> void:
 if room_mode:
  if event is InputEventKey and event.pressed and not event.echo and not event.ctrl_pressed and not event.alt_pressed and not event.meta_pressed and event.keycode in [KEY_W,KEY_ENTER,KEY_KP_ENTER] and not settings_open():
   get_viewport().set_input_as_handled()
   room_interaction.emit()
  return
 # A release outside the stage or after opening Settings must still stop a hold.
 if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
  pointer_walking = false
 if event is InputEventKey and event.pressed and not event.echo and not complete and not settings_open():
  if event.ctrl_pressed or event.alt_pressed or event.meta_pressed:
   if event.keycode in [KEY_A,KEY_LEFT,KEY_D,KEY_RIGHT,KEY_W,KEY_ENTER,KEY_KP_ENTER,KEY_E,KEY_SPACE]: get_viewport().set_input_as_handled()
   return
  # Handle these before GUI buttons so their focus cannot replace a doorway action.
  if event.keycode in [KEY_W,KEY_ENTER,KEY_KP_ENTER,KEY_E]:
   get_viewport().set_input_as_handled()
   if arrived: interact_destination()
   return
  if event.keycode == KEY_SPACE:
   get_viewport().set_input_as_handled()
   toggle_walking()
   return
 if event is InputEventKey and event.keycode in [KEY_A,KEY_LEFT,KEY_D,KEY_RIGHT]:
  if not event.pressed:
   if event.keycode in [KEY_A,KEY_LEFT]: left_held = false
   else: right_held = false
   manual_direction = int(right_held) - int(left_held)
   manual_walking = manual_direction != 0
  elif not event.echo and not event.ctrl_pressed and not event.alt_pressed and not event.meta_pressed and not complete and not settings_open():
   auto_walk = false
   if event.keycode in [KEY_A,KEY_LEFT]: left_held = true
   else: right_held = true
   manual_direction = int(right_held) - int(left_held)
   manual_walking = manual_direction != 0
   get_viewport().set_input_as_handled()
   if manual_direction < 0 and elapsed <= 0.0:
    return_to_origin()
    return
   update_controls()
func _notification(what: int) -> void:
 if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
  left_held = false
  right_held = false
  manual_direction = 0
  manual_walking = false
  pointer_walking = false
  auto_walk = false

func _shortcut_input(event: InputEvent) -> void:
 if room_mode: return
 # Enter on a focused corridor button must still mean entering the reached room.
 if complete or settings_open(): return
 if event is InputEventKey and event.pressed and not event.echo and not event.ctrl_pressed and not event.alt_pressed and not event.meta_pressed and event.keycode in [KEY_W,KEY_ENTER,KEY_KP_ENTER,KEY_E] and arrived:
  get_viewport().set_input_as_handled()
  interact_destination()

func _unhandled_input(event: InputEvent) -> void:
 if room_mode: return
 if complete or settings_open(): return
 if event is InputEventKey and event.pressed and not event.echo and not event.ctrl_pressed and not event.alt_pressed and not event.meta_pressed:
  if arrived and event.keycode in [KEY_W,KEY_ENTER,KEY_KP_ENTER,KEY_E]:
   get_viewport().set_input_as_handled()
   interact_destination()
   return
  elif event.keycode == KEY_SPACE:
   toggle_walking()
  else: return
  get_viewport().set_input_as_handled()

func update_controls() -> void:
 if walk_button == null: return
 walk_button.disabled = arrived
 walk_button.text = "ARRIVED" if arrived else ("PAUSE" if auto_walk else "WALK ON")
 interact_button.disabled = not arrived
 interact_button.text = "INTERACT · W / ENTER" if arrived else "WALK TO THE ENTRANCE"
 return_button.disabled = elapsed > 0.001
 source_button.visible = elapsed <= 0.001
 preparation_button.visible = arrived and not destination_room().get("cleared",false) and (destination_room().get("kind","") in ["battle","boss"] or destination_room().has("event_id") or destination_room().get("corridor_encounter","") == "roamer")
 preparation_button.text = "INVESTIGATE / PASS" if destination_room().has("event_id") else "PREPARE PARTY"

func open_doorway_choices() -> void:
 if not arrived or complete or settings_open(): return
 choice_panel = preload("res://scenes/expedition/doorway_choices.gd").new()
 choice_panel.room = destination_room()
 choice_panel.discovery = destination_room().has("event_id")
 choice_panel.chosen.connect(func(id: String, action: String):
  close_doorway_choices()
  if action == "leave" and destination_room().get("event_id","") == "crusader_coffin":
   finish(false)
   return
  if action != "enter":
   discovery_action = action
   investigator = id
  interact_destination())
 choice_panel.dismissed.connect(close_doorway_choices)
 add_child(choice_panel)

func close_doorway_choices() -> void:
 if is_instance_valid(choice_panel): choice_panel.queue_free()
 choice_panel = null

func _process(delta: float) -> void:
 if room_mode:
  ambient_clock += delta
  atmosphere.clock = ambient_clock
  atmosphere._process(0.0)
  transition_shade.modulate.a = maxf(1.0-ambient_clock/0.25,0.0)
  advance_actor_motion(delta,settings_open())
  update_walkers()
  return
 if complete: return
 update_summaries()
 ambient_clock += delta
 var blocked: bool = settings_open()
 if blocked:
  left_held = false
  right_held = false
  manual_direction = 0
  manual_walking = false
  pointer_walking = false
 var direction: int = manual_direction if manual_walking else pointer_direction if pointer_walking else 1 if auto_walk else 0
 moving = not blocked and direction != 0 and ((direction > 0 and elapsed < duration) or (direction < 0 and elapsed > 0.0))
 if moving:
  elapsed = clampf(elapsed+delta*direction,0.0,duration)
  facing_left = direction < 0
  footstep_clock += delta
  if arrived and elapsed < duration: leave_destination()
 else:
  footstep_clock = 0.0
  footsteps.stop()
 var previous_distance: float = distance_travelled
 var fraction: float = clampf(elapsed/maxf(duration,0.001),0,1)
 route_clue.text = passage_hint() if fraction >= 0.2 and not arrived else ""
 distance_travelled = fraction*(1500.0+minf(maxi(route_steps.size()-1,0),5)*220.0)
 if moving:
  var settings := get_node_or_null("/root/GameSettings")
  if settings == null or settings.ambient_motion: warden_clock += delta
  stride_distance += absf(distance_travelled-previous_distance)
  animation_clock += absf(distance_travelled-previous_distance)/(STRIDE*3.5)
 else:
  stride_distance = 0.0
 atmosphere.distance = distance_travelled
 atmosphere.clock = ambient_clock
 atmosphere._process(0.0)
 if moving and delta > 0.0 and not walkers.is_empty() and stride_distance >= STRIDE:
  stride_distance = fmod(stride_distance,STRIDE)
  footstep_clock = 0.0
  footsteps.pitch_scale = 0.95 if footsteps_played%2 == 0 else 1.06
  footsteps.play()
  footsteps_played += 1
 transition_shade.modulate.a = maxf(1.0-ambient_clock/0.25,0.0)
 advance_actor_motion(delta,blocked)
 update_walkers()
 source_door.position.x = -10.0 - distance_travelled * 0.9
 source_button.position = source_door.position
 if encounter != null:
  var approach: float = smoothstep(0.45,1.0,fraction)
  encounter.position.x = lerpf(encounter_start_x,encounter_end_x,approach)
  encounter_shadow.position.x = encounter.position.x+encounter.size.x*0.5
  destination_button.position = encounter.position-Vector2(12,12)
 if not arrived and elapsed >= duration: arrive()
 if moving and direction < 0 and elapsed <= 0.0:
  return_to_origin()
  return
 update_controls()
 progress.value = fraction*100.0
 progress.queue_redraw()
 passage_map.fraction = fraction
 passage_map.queue_redraw()

func update_summaries() -> void:
 if gold_counter != null: gold_counter.text = "GOLD  %d" % State.gold
 for id in hero_summaries:
  var stats: Dictionary = State.run_heroes.get(id,{})
  var maximum: int = State.hero_max_hp(id)
  var hp: int = int(stats.get("hp",maximum))
  var summary: Dictionary = hero_summaries[id]
  summary["health"].text = "HP %d / %d" % [hp,maximum]
  summary["stress"].text = "STRESS %d" % int(stats.get("stress",0))
  summary["bar"].size.x = 224.0*clampf(float(hp)/maxi(1,maximum),0,1)

func advance_actor_motion(delta: float, blocked: bool) -> void:
 var runtime := get_node_or_null("/root/GameSettings")
 var enabled: bool = runtime != null and runtime.experimental_walking and runtime.ambient_motion
 if not enabled:
  actor_walking = 0.0
 elif not blocked:
  actor_clock += maxf(delta,0.0)
  var target: float = 1.0 if moving and not arrived and not room_mode else 0.0
  actor_walking = lerpf(actor_walking,target,1.0-exp(-8.0*maxf(delta,0.0)))

func update_walkers() -> void:
 var runtime := get_node_or_null("/root/GameSettings")
 var experimental: bool = runtime != null and runtime.experimental_walking
 var enabled: bool = experimental and runtime.ambient_motion
 for index in range(walkers.size()):
  var picture: TextureRect = walkers[index]
  var id: String = picture.get_meta("walker")
  if str(State.hero(id).get("equipment_look","original")) != str(wardrobe_looks.get(id,"original")): refresh_equipment_frames(id)
  var phase: float = animation_clock*7.0+index*0.45
  var texture: Texture2D = standing_frames[id]
  if walk_frames.has(id):
   if id == "warden" and costume_for_warden(id): texture = walk_frames[id][0 if arrived or room_mode else int(warden_clock/0.084)%10]
   elif experimental: texture = walk_frames[id][QUIET_WALK_POSE]
   elif not arrived: texture = walk_frames[id][int(phase)%4]
  var height: float = HERO_HEIGHT*float(texture.get_meta("stride_scale",1.0))
  var width: float = height*texture.get_width()/float(maxi(1,texture.get_height()))
  picture.texture = texture
  picture.flip_h = facing_left
  picture.size = Vector2(width,height)
  picture.pivot_offset = Vector2(width*0.5,height)
  picture.position = bases[index]-Vector2(width*0.5,height)
  picture.rotation = 0.0
  ActorMotion.update(picture,actor_clock,animation_clock*3.5*PI,actor_walking,enabled and not (id == "warden" and costume_for_warden(id)))

func costume_for_warden(id: String) -> bool:
 return id == "warden" and str(State.hero(id).get("equipment_look","original")) in ["original","ashen_wolf"]

func refresh_equipment_frames(id: String) -> void:
 var outfit: String = str(State.hero(id).get("equipment_look","original"))
 var frames: Array[Texture2D] = []
 if id == "warden" and outfit in ["original","ashen_wolf"]:
  frames = preload("res://scripts/warden_outfits.gd").walks(outfit)
 elif outfit == "relic":
  for index in range(4,8): frames.append(preload("res://scripts/equipment_art.gd").frame(id,index))
 elif outfit == "alternate":
  for index in range(4,8): frames.append(preload("res://scripts/hero_appearance.gd").frame(id,index))
 else:
  var path: String = "res://assets/art_library/generated/hero_%s_walk.png" % id
  if ResourceLoader.exists(path) and Regions.WALK.has(id):
   var sheet: Texture2D = load(path)
   for region in Regions.WALK[id]:
    var frame := AtlasTexture.new()
    frame.atlas = sheet
    frame.region = region
    frame.filter_clip = true
    frames.append(frame)
 if frames.is_empty(): walk_frames.erase(id)
 else: walk_frames[id] = frames
 standing_frames[id] = Scenery.grounded_texture(str(State.hero(id).art))
 if costume_for_warden(id): standing_frames[id] = frames[0]
 wardrobe_looks[id] = outfit

func arrive() -> void:
 arrived = true
 moving = false
 auto_walk = false
 manual_walking = false
 manual_direction = 0
 left_held = false
 right_held = false
 pointer_walking = false
 footsteps.stop()
 arrival_label.text = str(arrival_label.get_meta("arrival_text"))
 destination_button.visible = true
 destination_button.disabled = false
 encounter_glow.set_shader_parameter("strength",0.32)
 # Near silhouettes frame a walk but must not obscure the object being inspected.
 atmosphere.near_layer.modulate.a = 0.28
 update_walkers()
 update_controls()

func leave_destination() -> void:
 arrived = false
 destination_button.visible = false
 destination_button.disabled = true
 encounter_glow.set_shader_parameter("strength",0.0)
 atmosphere.near_layer.modulate.a = 0.55
 arrival_label.text = "Retracing the passage. Hold D to turn back toward the destination."

func destination_room() -> Dictionary:
 if not State.run_active or State.floors.is_empty(): return {}
 var destination: Vector2i = route_steps.back() if not route_steps.is_empty() else State.room_position
 return State.floors[State.floor_index].get(destination,{})

func skip_travel() -> void:
 if settings_open() or complete: return
 if arrived: finish()
 else:
  elapsed = duration
  _process(0.0)

func destination_description() -> String:
 if not State.run_active: return "A doorway opens ahead."
 var room: Dictionary = destination_room()
 var kind: String = str(room.get("kind","entry"))
 if room.get("cleared",false): return "The familiar passage is quiet. Continue through the doorway."
 if room.get("corridor_encounter","") == "roamer": return "A lone creature roams ahead, unaware of the party. Confront it."
 if room.get("corridor_encounter","") == "gold": return "A few coins glint beside the passage. Search the scattered gold."
 if kind in ["battle","boss"]:
  var enemies: Array = room.get("enemies",[])
  var id: String = str(enemies[0]) if not enemies.is_empty() else str(room.get("creature",State.selected_expedition.get("creature","ash_raider")))
  return "%s bars the way. Prepare to fight." % State.CREATURES.get(id,{}).get("name","A creature")
 if kind == "event":
  var title: String = State.Events.definition(str(room.get("event_id","bandit_strongbox"))).get("name","A strange object")
  return "%s waits in the %s. Approach to investigate." % [title,"corridor" if room.get("event_layout","") == "corridor" else "chamber"]
 if kind == "camp": return "A sheltered fire offers respite. Enter the campsite."
 if kind == "stairs": return "The descent waits beyond the doorway. Step through."
 if kind == "treasure": return "A hidden cache waits ahead. Search the chamber."
 return "A doorway opens into the next chamber. Step through."

func passage_hint() -> String:
 var room: Dictionary = destination_room()
 if room.get("cleared",false): return "Familiar tracks. This passage has already been cleared."
 if room.get("corridor_encounter","") == "gold": return "A metallic glint catches the light between the floor stones."
 if room.get("corridor_encounter","") == "roamer": return "A single set of footsteps. Its owner has not noticed you."
 match str(room.get("kind","entry")):
  "battle","boss":
   return {"bandit":"Fresh boot prints. Voices carry from the chamber ahead.","keep":"Steel scrapes against stone. Someone holds the next doorway.","beast":"Drag marks cross the stones. A prayer answers from beyond.","medical":"Wing dust clings to the wall. Something stirs inside."}.get(scene_theme,"Something moves in the chamber ahead.")
  "event": return "Something has been left beside the passage. Approach to investigate."
  "camp": return "Warm air and wood smoke drift from a sheltered alcove."
  "treasure": return "A forgotten cache lies beyond the next threshold."
  "stairs": return "The air grows colder. A deeper floor waits below."
 return "The passage opens toward another chamber."

func build_destination() -> void:
 var room: Dictionary = destination_room()
 var kind: String = str(room.get("kind","entry"))
 var cleared: bool = room.get("cleared",false)
 if room_mode and kind == "camp": cleared = false
 var art: String = Scenery.threshold_path(scene_theme)
 if not cleared:
  if kind in ["battle","boss"] or room.get("corridor_encounter","") == "roamer":
   var enemies: Array = room.get("enemies",[])
   var id: String = str(enemies[0]) if not enemies.is_empty() else str(room.get("creature",State.selected_expedition.get("creature","ash_raider")))
   art = str(State.CREATURES.get(id,{}).get("art",art))
  elif kind == "event":
   if room.get("corridor_encounter","") == "gold":
    art = "res://assets/art_library/generated/hallway_gold_cache.png" if ResourceLoader.exists("res://assets/art_library/generated/hallway_gold_cache.png") else "res://assets/ui/encounter_gold.svg"
   else:
    var candidate: String = "res://assets/art_library/generated/event_%s.png" % room.get("event_id","bandit_strongbox")
    if ResourceLoader.exists(candidate): art = candidate
  elif kind == "camp":
   art = "res://assets/art_library/generated/hallway_campfire.png" if ResourceLoader.exists("res://assets/art_library/generated/hallway_campfire.png") else "res://assets/ui/encounter_camp.svg"
  elif kind == "treasure": art = "res://assets/art_library/generated/event_bandit_strongbox.png"
 if room_mode and State.merchant_orb_available(): art = "res://assets/art_library/generated/merchant_orb_ink.png"
 encounter_shadow = preload("res://scenes/combat/ground_shadow.gd").new()
 encounter_shadow.position = Vector2(encounter_start_x,GROUND_Y)
 travel_stage.add_child(encounter_shadow)
 encounter = TextureRect.new()
 encounter.name = "DestinationProp"
 var prop_region: Rect2 = {"hallway_gold_cache.png":Rect2(85,177,1514,594),"hallway_campfire.png":Rect2(189,128,1129,782)}.get(art.get_file(),Rect2())
 if prop_region.has_area():
  # Measured visible alpha bounds exclude faint peripheral flecks; source PNGs stay intact.
  var texture := AtlasTexture.new()
  texture.atlas = load(art)
  texture.region = prop_region
  texture.filter_clip = true
  encounter.texture = texture
 else:
  encounter.texture = Scenery.grounded_texture(art)
 encounter.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 encounter.stretch_mode = TextureRect.STRETCH_SCALE
 encounter.mouse_filter = Control.MOUSE_FILTER_IGNORE
 var threshold: bool = art == Scenery.threshold_path(scene_theme)
 var width_limit: float = 400.0 if threshold else (480.0 if kind == "boss" else 330.0)
 var height_limit: float = 390.0 if threshold else (390.0 if kind == "boss" else 350.0)
 if room.get("corridor_encounter","") == "gold":
  width_limit = 200.0
  height_limit = 110.0
 elif kind == "camp" and not cleared:
  width_limit = 240.0
  height_limit = 170.0
 var height: float = minf(height_limit,width_limit*encounter.texture.get_height()/float(encounter.texture.get_width()))
 encounter.size = Vector2(height*encounter.texture.get_width()/float(encounter.texture.get_height()),height)
 encounter_end_x = 1280.0 if threshold else 1390.0 if kind == "boss" else 1430.0
 var camera_right: float = (1920.0-travel_stage.position.x)/travel_stage.scale.x
 encounter_end_x = minf(encounter_end_x,camera_right-encounter.size.x-28.0)
 encounter.position = Vector2(encounter_start_x,GROUND_Y-height)
 encounter_glow = ShaderMaterial.new()
 encounter_glow.shader = preload("res://assets/shaders/curio_highlight.gdshader")
 encounter_glow.set_shader_parameter("glow_color",Color("#DEC08B"))
 encounter_glow.set_shader_parameter("strength",0.0)
 encounter.material = encounter_glow
 travel_stage.add_child(encounter)
 preload("res://scripts/visual_overlays.gd").stage_edges(travel_stage,Rect2(Vector2.ZERO,travel_stage.size))
 destination_button = Button.new()
 destination_button.name = "DestinationInteract"
 destination_button.position = encounter.position-Vector2(12,12)
 destination_button.size = encounter.size+Vector2(24,24)
 destination_button.visible = false
 destination_button.disabled = true
 destination_button.tooltip_text = "Interact · W / Enter / E"
 for state in ["normal","hover","pressed","focus","disabled"]: destination_button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
 destination_button.pressed.connect(interact_destination)
 destination_button.mouse_entered.connect(func(): encounter_glow.set_shader_parameter("strength",0.85))
 destination_button.mouse_exited.connect(func(): encounter_glow.set_shader_parameter("strength",0.32))
 destination_button.focus_entered.connect(func(): encounter_glow.set_shader_parameter("strength",0.85))
 destination_button.focus_exited.connect(func(): encounter_glow.set_shader_parameter("strength",0.32))
 travel_stage.add_child(destination_button)

func interact_destination() -> void:
 if room_mode:
  if not settings_open(): room_interaction.emit()
  return
 if arrived and not settings_open() and not complete:
  var runtime := get_node_or_null("/root/GameSettings")
  if runtime == null or runtime.ambient_motion:
   complete = true
   reached_destination = true
   footsteps.stop()
   destination_button.disabled = true
   var crossing := create_tween()
   crossing.tween_property(transition_shade,"modulate:a",1.0,0.18)
   await crossing.finished
   finished.emit()
   queue_free()
  else: finish()

func build_source() -> void:
 source_door = TextureRect.new()
 source_door.name = "StartingDoorway"
 source_door.texture = Scenery.grounded_texture(Scenery.threshold_path(scene_theme))
 source_door.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 source_door.stretch_mode = TextureRect.STRETCH_SCALE
 var height: float = minf(390.0,245.0 * source_door.texture.get_height() / float(source_door.texture.get_width()))
 source_door.position = Vector2(-10,GROUND_Y-height)
 source_door.size = Vector2(245,height)
 source_door.modulate = Color(0.72,0.68,0.64)
 source_door.mouse_filter = Control.MOUSE_FILTER_IGNORE
 travel_stage.add_child(source_door)
 source_door.move_to_front()
 source_button = Button.new()
 source_button.name = "StartingDoorwayInteract"
 source_button.position = source_door.position
 source_button.size = source_door.size
 source_button.tooltip_text = "Return to the starting room · A / Left"
 for state in ["normal","hover","pressed","focus"]: source_button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
 source_button.pressed.connect(return_to_origin)
 travel_stage.add_child(source_button)

func return_to_origin() -> void:
 if complete or settings_open() or elapsed > 0.001: return
 finish(false)

func finish(reached: bool = true) -> void:
 if complete: return
 complete = true
 reached_destination = reached
 if footsteps != null: footsteps.stop()
 finished.emit()
 queue_free()

func _exit_tree() -> void:
 if footsteps != null: footsteps.stop()

