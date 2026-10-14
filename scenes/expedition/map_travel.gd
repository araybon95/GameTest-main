extends "res://scenes/ui/party_screen.gd"
## Stationary party, automatic passage, decisions before arrival.
const Passages = preload("res://scripts/passage_events.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
signal finished
var bound_transit: Dictionary = {}
var elapsed: float = 0.0
var duration: float = 1.4
var waiting_event: bool = false
var complete: bool = false
var reached_destination: bool = false
var investigator: String = ""
var current_event: Dictionary = {}
var event_panel: Control
var progress: ProgressBar
var heading: Label
var party_art: Array[TextureRect] = []
var breath_clock: float = 0.0
func _ready() -> void:
 name = "MapTravel"
 z_index = 100
 mouse_filter = Control.MOUSE_FILTER_STOP
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 if not Passages.valid_transit(State): cancel_travel(); return
 var transit: Dictionary = State.journey.transit
 bound_transit = transit
 if transit.get("stage","") == "battle":
  var battle: Dictionary = Passages.battle_room(State)
  if not battle.get("cleared",false): get_tree().change_scene_to_file("res://scenes/combat/combatscene.tscn"); return
  transit["stage"] = "travel"
  transit["event_done"] = true
 var backdrop := picture(Scenery.stage_path(State.floor_background("combat")),Rect2(0,0,1920,1080))
 backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 backdrop.modulate = Color(0.55,0.55,0.6)
 var ambience = Scenery.new()
 ambience.size = Vector2(1920,800)
 ambience.ground_y = 710
 ambience.show_foreground = false
 ambience.scene_theme = Scenery.theme_for(State.selected_expedition,State.floor_index)
 add_child(ambience)
 panel(Rect2(55,45,1810,120),Color(0.06,0.05,0.06,0.9))
 heading = label_at("THROUGH THE DARK",Vector2(90,65),1500,34)
 label_at("The party moves between chambers. Listen to the passage.",Vector2(90,112),1500,20)
 var party := Control.new()
 party.name = "TravelParty"
 add_child(party)
 for id in State.party:
  if State.run_heroes.get(id,{}).get("dead",false): continue
  if investigator.is_empty() and int(State.run_heroes.get(id,{}).get("hp",0)) > 0: investigator = id
  var image = preload("res://scripts/standing_party.gd").create(id,Vector2(390+party_art.size()*410,710),380)
  image.name = "Traveler_"+id
  image.set_process(false)
  party.add_child(image)
  party_art.append(image)
 panel(Rect2(55,800,1810,220),Color(0.06,0.05,0.06,0.94))
 label_at("TRAVELLING · FLOOR %d" % [State.floor_index+1],Vector2(90,830),1300,25)
 label_at("Some passages are quiet. Others hide a choice—or an enemy.",Vector2(90,875),1300,21)
 progress = ProgressBar.new()
 progress.position = Vector2(90,935)
 progress.size = Vector2(1300,18)
 progress.show_percentage = false
 add_child(progress)
 button_at("SKIP TRANSITION",Rect2(1450,850,350,55),skip_travel).name = "SkipTransition"
 button_at("RETURN TO MAP",Rect2(1450,925,350,55),cancel_travel).name = "CancelTravel"
 load_edge()
func load_edge() -> void:
 elapsed = 0.0
 var transit: Dictionary = State.journey.transit
 var destination: Vector2i = transit.route[transit.index]
 current_event = Passages.encounter(State,State.room_position,destination)
 transit["event_key"] = current_event.key
 heading.text = "THROUGH THE DARK · %d / %d PASSAGES" % [transit.index+1,transit.route.size()]
 if current_event.get("resolved",false): transit["event_done"] = true
func modal_open() -> bool:
 var settings = get_node_or_null("/root/GameSettings")
 var controls = get_node_or_null("/root/GameControls")
 return (settings != null and is_instance_valid(settings.overlay)) or (controls != null and controls.is_modal_open())
func _process(delta: float) -> void:
 if complete or modal_open(): return
 if not is_same(State.journey.get("transit",{}),bound_transit):
  complete = true
  finished.emit()
  queue_free()
  return
 if not Passages.valid_transit(State):
  waiting_event = false
  cancel_travel()
  return
 var settings = get_node_or_null("/root/GameSettings")
 var animate: bool = settings == null or settings.ambient_motion
 if animate: breath_clock += delta
 for index in range(party_art.size()):
  party_art[index].update_motion(delta)
 if waiting_event: return
 elapsed += delta
 progress.value = minf(elapsed/duration,1.0)*100
 var transit: Dictionary = State.journey.transit
 if elapsed >= duration*0.45 and not transit.event_done:
  if current_event.kind == "quiet":
   Passages.resolve(State,current_event,investigator,"leave")
   transit["event_done"] = true
  else: show_event(); return
 if elapsed >= duration: cross_threshold()
func show_event() -> void:
 waiting_event = true
 get_node("SkipTransition").disabled = true
 get_node("CancelTravel").disabled = true
 event_panel = Control.new()
 event_panel.name = "PassageEvent"
 add_child(event_panel)
 var existing: Array = get_children()
 var box := panel(Rect2(935,190,890,580),Color(0.065,0.045,0.06,0.97))
 box.name = "PassageEventFrame"
 label_at("IN THE PASSAGE",Vector2(975,220),790,21).add_theme_color_override("font_color",Color("#D7B578"))
 var kind: String = str(current_event.kind)
 var definition: Dictionary = State.Events.definition(current_event.get("room",{}).get("event_id",""))
 label_at(str(definition.get("name","A Prowler in the Dark" if kind == "ambush" else "Coins in the Dust")),Vector2(975,265),790,34)
 label_at(str(definition.get("description","A lone enemy blocks the hallway. Your destination waits beyond." if kind == "ambush" else "Scattered coins catch the torchlight along the passage.")),Vector2(975,335),790,22).size.y = 110
 label_at(str(definition.get("risk","Defeat the prowler, then continue the same route." if kind == "ambush" else "Recover %d Gold. This find can only be claimed once." % current_event.get("amount",0))),Vector2(975,455),790,19).size.y = 85
 if kind == "curio":
  for index in range(State.party.size()):
   var id: String = State.party[index]
   var option := button_at(("• " if id == investigator else "")+str(State.hero(id).name),Rect2(975+index*260,555,250,50),select_investigator.bind(id))
   option.disabled = State.run_heroes.get(id,{}).get("dead",false) or int(State.run_heroes.get(id,{}).get("hp",0)) <= 0
  var class_option: Dictionary = State.Mechanics.event_option(current_event.room.event_id,investigator)
  if not class_option.is_empty():
   var special := button_at(str(class_option.name).to_upper()+" · "+str(class_option.risk),Rect2(975,610,765,45),choose_event.bind("class"))
   special.name = "ClassInvestigation"
   special.add_theme_font_size_override("font_size",17)
   special.disabled = int(State.run_heroes.get(investigator,{}).get("hp",0)) <= int(class_option.cost)
  button_at("INVESTIGATE",Rect2(975,665,370,55),choose_event.bind("investigate"))
  button_at("LEAVE UNTOUCHED",Rect2(1370,665,370,55),choose_event.bind("leave"))
  var supply: String = str(State.Depth.EVENT_SUPPLIES.get(current_event.room.event_id,""))
  if supply != "":
   var use := button_at("USE "+str(State.Items.item(supply).name),Rect2(975,728,765,40),choose_event.bind("supply"))
   use.add_theme_font_size_override("font_size",17)
   use.disabled = int(State.inventory.get(supply,0)) <= 0
 elif kind == "ambush": button_at("DEFEND THE PASSAGE",Rect2(975,630,765,65),enter_battle)
 else: button_at("COLLECT & CONTINUE",Rect2(975,630,765,65),choose_event.bind("investigate"))
 for child in get_children():
  if child != event_panel and not existing.has(child): child.reparent(event_panel)
func select_investigator(id: String) -> void:
 investigator = id
 event_panel.free()
 show_event()
func choose_event(action: String) -> void:
 if complete or not Passages.valid_transit(State) or current_event.get("resolved",false): return
 var result: Dictionary = Passages.resolve(State,current_event,investigator,action)
 if result.is_empty(): return
 State.journey.transit["event_done"] = true
 event_panel.free()
 event_panel = Control.new()
 event_panel.name = "PassageOutcome"
 add_child(event_panel)
 var existing: Array = get_children()
 panel(Rect2(935,260,890,440),Color(0.065,0.045,0.06,0.97))
 label_at("THE PASSAGE YIELDS",Vector2(975,300),790,30)
 label_at(str(result.get("text","")),Vector2(975,380),790,24).size.y = 160
 button_at("CONTINUE THE JOURNEY",Rect2(975,580,765,65),continue_travel)
 for child in get_children():
  if child != event_panel and not existing.has(child): child.reparent(event_panel)
func continue_travel() -> void:
 if not current_event.get("resolved",false): return
 if is_instance_valid(event_panel): event_panel.free()
 waiting_event = false
 get_node("SkipTransition").disabled = false
 get_node("CancelTravel").disabled = false
func enter_battle() -> void:
 if not Passages.valid_transit(State): return
 State.journey.transit["stage"] = "battle"
 get_tree().change_scene_to_file("res://scenes/combat/combatscene.tscn")
func cross_threshold() -> void:
 if complete or waiting_event or not Passages.valid_transit(State): return
 var transit: Dictionary = State.journey.transit
 if not transit.event_done: return
 if not State.commit_move(transit.route[transit.index]): cancel_travel(); return
 transit["index"] += 1
 if transit.index >= transit.route.size():
  reached_destination = true
  complete = true
  State.journey.erase("transit")
  finished.emit()
  queue_free()
 else:
  transit["event_done"] = false
  load_edge()
func skip_travel() -> void:
 if waiting_event or complete or modal_open(): return
 _process(duration)
func finish() -> void: skip_travel()
func cancel_travel() -> void:
 if complete or waiting_event: return
 complete = true
 State.journey.erase("transit")
 finished.emit()
 queue_free()
func refresh_equipment_frames(_id: String) -> void:
 for image in party_art:
  var id: String = str(image.name).trim_prefix("Traveler_")
  image.refresh_art()
