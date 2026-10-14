extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize(): call_deferred("run")
func run():
 State.progress_loaded = true
 State.progress_path = "user://room-discoveries.cfg"
 State.select_expedition("old_road")
 State.start_run(42)
 State.floors[0] = {Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true},Vector2i.RIGHT:{"kind":"event","event_id":"bandit_strongbox","event_seed":4,"event_layout":"corridor","cleared":false,"seen":true},Vector2i(2,0):{"kind":"camp","cleared":false,"seen":false}}
 var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
 root.add_child(dungeon)
 await process_frame
 assert(State.floors[0][Vector2i.RIGHT].kind == "event","Room discoveries remain in rooms, not passages")
 assert(State.floors[0][Vector2i.RIGHT].event_layout == "room")
 dungeon.move_to(Vector2i.RIGHT)
 assert(State.room_position == Vector2i.RIGHT,"Selecting a room arrives immediately")
 assert(State.journey.get("transit",{}).is_empty(),"No hallway travel scene or random encounter")
 await process_frame
 await process_frame
 var screen = current_scene
 assert(screen.has_node("StoryArt") and screen.has_node("StoryChoices"))
 State.inventory["lock_tools"] = 0
 var gold: int = State.gold
 screen.investigate_with_supply() # Unavailable supply must not resolve or award anything.
 assert(not State.floors[0][Vector2i.RIGHT].get("event_resolved",false) and State.gold == gold)
 screen.investigate()
 assert(State.floors[0][Vector2i.RIGHT].event_resolved)
 assert(screen.has_node("StoryChoices/StoryContinue"))
 var snapshot: Dictionary = {"gold":State.gold,"inventory":State.inventory.duplicate(true),"heroes":State.run_heroes.duplicate(true)}
 screen.investigate()
 screen.leave_untouched()
 assert(snapshot.gold == State.gold and snapshot.inventory == State.inventory and snapshot.heroes == State.run_heroes,"Resolved room cannot repeat rewards or apply consequences")
 var saved: Dictionary = State.floors[0][Vector2i.RIGHT].event_result.duplicate(true)
 assert(load("res://scripts/save_files.gd").load_slot(0))
 assert(State.floors[0][Vector2i.RIGHT].event_result == saved)
 var restore = load("res://scripts/room_discoveries.gd")
 State.floors[0][Vector2i(2,0)] = {"kind":"chamber","cleared":false,"seen":true,"travel_discovery":{"kind":"event","event_id":"bandit_supplies","event_seed":19,"cleared":false}}
 restore.prepare_floor(State)
 assert(State.floors[0][Vector2i(2,0)].kind == "event")
 var position_before: Vector2i = State.room_position
 assert(not restore.move(State,[Vector2i(2,0),Vector2i(3,0)]))
 assert(State.room_position == position_before,"Invalid route must not partially commit")
 State.floors[0][Vector2i(2,0)] = {"kind":"chamber","cleared":false,"seen":true,"travel_discovery_resolved":true,"travel_discovery":{"kind":"event","event_id":"bandit_supplies","event_seed":19}}
 restore.prepare_floor(State)
 assert(State.floors[0][Vector2i(2,0)].cleared,"Resolved discoveries stay resolved after migrating")
 State.floors[0][Vector2i(2,0)] = {"kind":"event","event_id":"bandit_supplies","event_seed":19,"event_layout":"room","cleared":false,"seen":true}
 State.journey["transit"] = {"run_id":"expired","floor":0,"origin":State.room_position,"route":[Vector2i(2,0)],"index":0}
 var recovery = load("res://scenes/expedition/dungeon.tscn").instantiate()
 root.add_child(recovery)
 await process_frame
 await process_frame
 assert(State.journey.get("transit",{}).is_empty())
 assert(State.floors[0][Vector2i(2,0)].kind == "event","Invalid older passage must restore unresolved room discoveries")
 recovery.free()
 assert(load("res://scripts/passage_events.gd").begin(State,[Vector2i(2,0)]))
 recovery = load("res://scenes/expedition/dungeon.tscn").instantiate()
 root.add_child(recovery)
 await process_frame
 await process_frame
 var old_travel = recovery.get_node("MapTravel")
 old_travel.set_process(false)
 old_travel.cancel_travel()
 await process_frame
 assert(State.journey.get("transit",{}).is_empty())
 assert(State.floors[0][Vector2i(2,0)].kind == "event","Cancelled older passage must restore unresolved discoveries")
 recovery.free()
 var ambush_seen: bool = false
 for seed_value in range(100):
  State.run_seed = seed_value
  State.floors[0][State.room_position] = {"kind":"camp","cleared":true,"seen":true,"camp_used":true,"camp_choices":["watch"]}
  assert(not State.Depth.camp_ambush(State),"Watch prevents a camp-room ambush")
  State.floors[0][State.room_position] = {"kind":"camp","cleared":true,"seen":true,"camp_used":true,"camp_choices":[]}
  if State.Depth.camp_ambush(State): ambush_seen = true
 assert(ambush_seen,"Room mode retains the existing unguarded camp risk")
 print("PASS: instant room arrival, full-screen story choices, saved result and repeat-reward prevention")
 quit()
