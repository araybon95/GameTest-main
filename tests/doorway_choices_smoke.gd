extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 for i in range(4): await process_frame
func fixture(kind: String, event_id: String = "") -> void:
 State.select_expedition("old_road")
 State.start_run(92)
 State.floors[0] = {
  Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true,"travel_counted":true},
  Vector2i.RIGHT:{"kind":kind,"cleared":false,"seen":true,"enemies":["ash_raider"],"event_seed":42}
 }
 if not event_id.is_empty(): State.floors[0][Vector2i.RIGHT]["event_id"] = event_id
 change_scene_to_file("res://scenes/expedition/dungeon.tscn")
 await settle()
func passage() -> Control:
 current_scene.move_to(Vector2i.RIGHT)
 await settle()
 var travel = current_scene.get_node("HallwayTravel")
 travel.set_process(false)
 travel.skip_travel()
 assert(travel.arrived)
 return travel
func press(panel: Control, value: String) -> void:
 for button in panel.find_children("*","Button",true,false):
  if button.text == value:
   assert(not button.disabled)
   button.pressed.emit()
   return
 assert(false,"Missing action: "+value)
func run() -> void:
 root.size = Vector2i(1920,1080)
 root.content_scale_size = root.size
 State.map_travel_mode = false # Explicit legacy-walking fixture.
 State.progress_loaded = true
 State.party.assign(["warden","ranger","occultist"])
 root.get_node("GameSettings").ambient_motion = false
 await fixture("event","bandit_strongbox")
 var travel = await passage()
 var rng: int = State.loot_rng.state
 travel.open_doorway_choices()
 var panel = travel.choice_panel
 press(panel,State.hero("ranger")["name"])
 assert(panel.selected_hero == "ranger")
 assert(State.room_position == Vector2i.ZERO and not State.floors[0][Vector2i.RIGHT].get("event_resolved",false))
 var key := InputEventKey.new()
 key.keycode = KEY_D
 key.pressed = true
 root.push_input(key,true)
 var elapsed: float = travel.elapsed
 travel._process(0.2)
 assert(travel.elapsed == elapsed,"Discovery decisions pause movement")
 press(panel,"INVESTIGATE")
 await settle()
 var event: Dictionary = State.floors[0][Vector2i.RIGHT]
 assert(event.event_resolved and event.event_result.hero == "ranger")
 assert(current_scene.selected_hero == "ranger","Outcome scene shows the investigator")
 var gold: int = State.gold
 var inventory: Dictionary = State.inventory.duplicate()
 assert(State.Events.resolve(State,"ranger").is_empty())
 assert(State.gold == gold and State.inventory == inventory and State.loot_rng.state == rng)
 await fixture("event","bandit_supplies")
 travel = await passage()
 gold = State.gold
 inventory = State.inventory.duplicate()
 travel.open_doorway_choices()
 press(travel.choice_panel,"LEAVE UNTOUCHED")
 await settle()
 assert(State.room_position == Vector2i.RIGHT and State.floors[0][Vector2i.RIGHT].event_result.left)
 assert(State.gold == gold and State.inventory == inventory)
 await fixture("event","crusader_coffin")
 travel = await passage()
 travel.open_doorway_choices()
 press(travel.choice_panel,"LEAVE UNTOUCHED")
 await settle()
 assert(State.room_position == Vector2i.ZERO and not State.floors[0][Vector2i.RIGHT].get("event_resolved",false),"Coffin can be revisited")
 await fixture("battle")
 travel = await passage()
 rng = State.loot_rng.state
 travel.open_doorway_choices()
 panel = travel.choice_panel
 var before: int = State.Depth.position_of(State,"warden")
 press(panel,"CHANGE RANK")
 assert(State.Depth.position_of(State,"warden") != before)
 State.run_heroes.warden.hp = 12
 State.add_item("healing_potion")
 press(panel,"SUPPLIES / INVENTORY")
 var controls = root.get_node("GameControls")
 assert(controls.hero_sheet.inventory_mode)
 controls.hero_sheet.choose_item("healing_potion")
 assert(State.run_heroes.warden.hp > 12)
 controls.close_hero_sheet()
 await settle()
 assert(is_instance_valid(travel) and current_scene.traveling,"Using supplies does not rebuild away the passage")
 press(panel,"ENTER ENCOUNTER")
 await settle()
 assert(current_scene.has_method("_play_card") and State.room_position == Vector2i.RIGHT)
 assert(State.loot_rng.state == rng,"Preparation does not roll encounter loot")
 print("PASS: investigator choice, paused decisions, once-only discovery, passing without loot, revisitable coffin, rank changes and precombat potion use")
 quit()
