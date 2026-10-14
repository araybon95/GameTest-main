extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize(): call_deferred("run")
func run():
 assert(ResourceLoader.exists("res://scripts/passage_events.gd"),"Passage ledger is required")
 var events = load("res://scripts/passage_events.gd")
 State.progress_loaded = true
 State.progress_path = "user://passage-events.cfg"
 Saves.directory = "user://passage-events-saves/"
 State.select_expedition("old_road")
 State.start_run(72)
 State.floors[0] = {
  Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true},
  Vector2i.RIGHT:{"kind":"event","event_id":"bandit_strongbox","event_seed":321,"cleared":false,"seen":true},
  Vector2i(2,0):{"kind":"camp","cleared":false,"seen":true}}
 events.prepare_floor(State)
 assert(State.floors[0][Vector2i.RIGHT].kind == "chamber")
 var rng: int = State.loot_rng.state
 var event: Dictionary = events.encounter(State,Vector2i.ZERO,Vector2i.RIGHT)
 assert(event.kind == "curio")
 assert(events.key(0,Vector2i.ZERO,Vector2i.RIGHT) == events.key(0,Vector2i.RIGHT,Vector2i.ZERO))
 var before: int = State.gold
 assert(not events.resolve(State,event,"warden","leave").is_empty())
 assert(events.resolve(State,event,"warden","investigate").is_empty())
 assert(State.gold == before and State.loot_rng.state == rng)
 assert(events.encounter(State,Vector2i.RIGHT,Vector2i.ZERO).resolved)
 assert(not events.begin(State,[Vector2i(2,0)]),"Non-adjacent route cannot start")
 assert(events.begin(State,[Vector2i.RIGHT]))
 assert(events.valid_transit(State))
 assert(Saves.save(1))
 State.journey.clear()
 assert(Saves.load_slot(1))
 assert(events.valid_transit(State))
 assert(events.encounter(State,Vector2i.ZERO,Vector2i.RIGHT).resolved)
 var counts: Dictionary = {}
 for i in range(60):
  var start := Vector2i(i,10)
  var result: Dictionary = events.encounter(State,start,start+Vector2i.RIGHT)
  counts[result.kind] = int(counts.get(result.kind,0))+1
 assert(counts.get("quiet",0) > 25 and counts.get("quiet",0) < 60,"Both quiet passages and events exist")
 State.floors[0][Vector2i(0,1)] = {"kind":"event","event_id":"crusader_coffin","cleared":false,"seen":true}
 events.prepare_floor(State)
 assert(State.floors[0][Vector2i(0,1)].kind == "event","Fixed rescue remains a story room")
 print("PASS: deterministic saved passage ledger, quiet journeys, no rerolls/RNG changes, valid routes and legacy event migration")
 quit()
