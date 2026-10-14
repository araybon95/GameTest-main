extends SceneTree
const State = preload("res://scripts/game_data.gd")
var Events = load("res://scripts/passage_events.gd")
func _initialize(): call_deferred("run")
func run():
 State.progress_loaded = true
 State.progress_path = "user://passage-regressions.cfg"
 State.select_expedition("old_road")
 State.start_run(2)
 State.floors[0] = {Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true},Vector2i.RIGHT:{"kind":"event","event_layout":"corridor","corridor_encounter":"gold","small_gold":3,"event_id":"bandit_strongbox","event_seed":1,"cleared":false,"seen":true},Vector2i(1,1):{"kind":"camp","cleared":true,"seen":true}}
 Events.prepare_floor(State)
 var cancelled: Dictionary = Events.encounter(State,Vector2i.ZERO,Vector2i.RIGHT)
 var alternate: Dictionary = Events.encounter(State,Vector2i(1,1),Vector2i.RIGHT)
 var before: int = State.gold
 Events.resolve(State,alternate,"warden","investigate")
 Events.resolve(State,Events.encounter(State,Vector2i.ZERO,Vector2i.RIGHT),"warden","investigate")
 assert(State.gold == before+3,"A discovery can only be collected once across different inbound edges")
 State.floors[0][Vector2i.RIGHT] = {"kind":"event","event_layout":"room","event_id":"bandit_strongbox","event_seed":10,"cleared":false,"seen":true}
 Events.prepare_floor(State)
 Events.restore_floor(State)
 assert(State.floors[0][Vector2i.RIGHT].kind == "event" and State.floors[0][Vector2i.RIGHT].event_layout == "room","Manual walking restores unresolved events")
 var key: String = Events.key(0,Vector2i.ZERO,Vector2i.RIGHT)
 State.journey.passages[key] = {"key":key,"kind":"ambush","resolved":false,"room":{"kind":"battle","enemies":["ash_raider"],"cleared":false}}
 State.journey["passage_watch"] = true
 var protected: Dictionary = Events.encounter(State,Vector2i.ZERO,Vector2i.RIGHT)
 assert(protected.kind == "quiet" and not State.journey.passage_watch,"Watch protects against cached ambushes")
 print("PASS: shared discovery resolution, reversible walking-mode migration and cached-ambush Watch protection")
 quit()
