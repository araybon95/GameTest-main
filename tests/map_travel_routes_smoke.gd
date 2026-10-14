extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Events = preload("res://scripts/passage_events.gd")
func _initialize(): call_deferred("run")
func fixture():
 State.progress_loaded = true
 State.progress_path = "user://map-route-test.cfg"
 State.select_expedition("old_road")
 State.start_run(41)
 State.floors[0] = {Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true},Vector2i.RIGHT:{"kind":"chamber","cleared":true,"seen":true},Vector2i(2,0):{"kind":"chamber","cleared":false,"seen":true}}
 State.journey["passages"] = {}
 for i in range(2):
  var key: String = Events.key(0,Vector2i(i,0),Vector2i(i+1,0))
  State.journey.passages[key] = {"key":key,"kind":"quiet","resolved":false}
func run():
 fixture()
 assert(Events.begin(State,[Vector2i.RIGHT,Vector2i(2,0)]))
 var travel = load("res://scenes/expedition/map_travel.gd").new()
 root.add_child(travel)
 travel.set_process(false)
 root.get_node("GameSettings").ambient_motion = false
 travel._process(2.0)
 assert(State.room_position == Vector2i.RIGHT and State.journey.transit.index == 1)
 travel._process(2.0)
 assert(State.room_position == Vector2i(2,0) and travel.complete)
 assert(travel.party_art[0].scale.y == 1.0,"Reduced motion still permits travel")
 travel.free()
 fixture()
 assert(Events.begin(State,[Vector2i.RIGHT]))
 travel = load("res://scenes/expedition/map_travel.gd").new()
 root.add_child(travel)
 travel.set_process(false)
 fixture() # A loaded/new run invalidates the old scene.
 assert(Events.begin(State,[Vector2i.RIGHT,Vector2i(2,0)]))
 var fresh: Dictionary = State.journey.transit.duplicate(true)
 travel._process(2.0)
 assert(State.room_position == Vector2i.ZERO and State.journey.transit == fresh,"Stale transition cannot advance or erase a newer journey")
 travel.free()
 print("PASS: multi-passage commit, reduced motion and stale travel isolation")
 quit()
