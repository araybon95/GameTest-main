extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Events = preload("res://scripts/passage_events.gd")
func _initialize(): call_deferred("run")
func run():
 assert(ResourceLoader.exists("res://scenes/expedition/map_travel.gd"),"Automatic travel scene is required")
 State.progress_loaded = true
 State.progress_path = "user://map-travel.cfg"
 State.select_expedition("old_road")
 State.start_run(33)
 State.floors[0] = {Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true},Vector2i.RIGHT:{"kind":"chamber","cleared":false,"seen":true},Vector2i(2,0):{"kind":"camp","cleared":false,"seen":false}}
 var key: String = Events.key(0,Vector2i.ZERO,Vector2i.RIGHT)
 State.journey["passages"] = {key:{"key":key,"kind":"quiet","resolved":false}}
 assert(Events.begin(State,[Vector2i.RIGHT]))
 var travel = load("res://scenes/expedition/map_travel.gd").new()
 root.add_child(travel)
 travel.set_process(false)
 assert(travel.get_node("TravelParty").get_child_count() == 3)
 travel._process(0.15)
 await process_frame
 await process_frame
 assert(travel.party_art[0].scale.y > 1.0,"Warden shares the stationary party breathing")
 var completed: Array = []
 travel.finished.connect(func(): completed.append(true))
 travel._process(0.8)
 assert(State.room_position == Vector2i.ZERO)
 travel._process(1.0)
 assert(State.room_position == Vector2i.RIGHT and completed.size() == 1,"Quiet travel arrives automatically")
 travel._process(2.0)
 assert(completed.size() == 1)
 travel.free()
 State.floors[0][Vector2i.RIGHT].cleared = true
 State.room_position = Vector2i.ZERO
 State.journey.erase("transit")
 State.journey.passages[key] = {"key":key,"kind":"curio","resolved":false,"room":{"kind":"event","event_id":"bandit_strongbox","event_seed":4,"event_resolved":false,"cleared":false}}
 assert(Events.begin(State,[Vector2i.RIGHT]))
 travel = load("res://scenes/expedition/map_travel.gd").new()
 root.add_child(travel)
 travel.set_process(false)
 travel._process(1.0)
 assert(travel.waiting_event and State.room_position == Vector2i.ZERO,"Event interrupts before arrival")
 assert(travel.has_node("PassageEvent/ClassInvestigation"),"Class-specific curio choices remain available")
 travel.skip_travel()
 assert(State.room_position == Vector2i.ZERO,"Skip cannot bypass a pending event")
 var settings = root.get_node("GameSettings")
 settings.open_settings()
 var age: float = travel.elapsed
 travel._process(10.0)
 assert(travel.elapsed == age,"Settings pause the transition")
 settings.close_settings()
 travel.choose_event("leave")
 travel.continue_travel()
 travel._process(2.0)
 assert(State.room_position == Vector2i.RIGHT)
 travel.free()
 State.journey.erase("transit")
 State.floors[0][Vector2i(2,0)].seen = false
 var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
 root.add_child(dungeon)
 await process_frame
 assert(dungeon.has_node("RouteMap"),"Map is the primary exploration view")
 current_scene = dungeon
 assert(not str(root.get_node("GameControls").guide_sections()).contains("Walk forward"),"Room-travel guide does not instruct manual walking")
 dungeon.preview_route(Vector2i.ZERO)
 assert(dungeon.get_node("RouteMap").preview_route.size() == 1)
 assert(dungeon.get_node("RouteDetails").size.x <= 520,"Destination text fits the side panel")
 assert(not dungeon.has_node("Room_2_0"),"Unseen rooms cannot be clicked")
 dungeon.free()
 print("PASS: automatic stationary travel, event and skip guards, settings pause, clickable map previews and fog")
 quit()
