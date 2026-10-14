extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Passages = preload("res://scripts/passage_events.gd")
func _initialize(): call_deferred("run")
func run():
 assert(ResourceLoader.exists("res://scripts/discovery_presentation.gd"),"Discovery presentation is required")
 var discovery = load("res://scripts/discovery_presentation.gd")
 State.progress_loaded = true
 State.progress_path = "user://discovery-polish.cfg"
 State.select_expedition("old_road")
 State.start_run(42)
 State.floors[0] = {Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true},Vector2i.RIGHT:{"kind":"chamber","cleared":false,"seen":true},Vector2i(2,0):{"kind":"camp","cleared":false,"seen":false}}
 var key: String = Passages.key(0,Vector2i.ZERO,Vector2i.RIGHT)
 State.journey["passages"] = {key:{"key":key,"kind":"curio","resolved":false,"room":{"kind":"event","event_id":"bandit_strongbox","event_seed":4,"cleared":false}}}
 var before: Dictionary = State.journey.duplicate(true)
 var rng: int = State.loot_rng.state
 assert(discovery.knowledge(State,Vector2i.ZERO,Vector2i.RIGHT).state == "unknown","Cached but unseen discoveries do not leak")
 State.floors[0][Vector2i.RIGHT].scouted = true
 var clue: Dictionary = discovery.knowledge(State,Vector2i.ZERO,Vector2i.RIGHT)
 assert(clue.state == "scouted" and clue.kind == "curio" and clue.clue != "")
 assert(State.journey == before and State.loot_rng.state == rng,"Scouting presentation cannot roll, collect or consume protection")
 assert(discovery.knowledge(State,Vector2i.RIGHT,Vector2i(2,0)).state == "unknown")
 assert(Passages.begin(State,[Vector2i.RIGHT]))
 var travel = load("res://scenes/expedition/map_travel.gd").new()
 root.add_child(travel)
 travel.set_process(false)
 travel._process(1.0)
 assert(travel.current_event.discovered)
 assert(travel.has_node("PassageEvent/DiscoveryProp"),"Curio reveal shows its painted object")
 root.get_node("GameSettings").ambient_motion = false
 travel.select_investigator("ranger")
 assert(travel.event_panel.modulate.a == 1.0,"Reduced motion displays discovery immediately")
 travel.choose_event("leave")
 travel.continue_travel()
 travel._process(2.0)
 assert(State.journey.passages[key].traversed)
 assert(discovery.knowledge(State,Vector2i.RIGHT,Vector2i.ZERO).state == "travelled","Trail history works both directions")
 assert(State.journey.get("recent_discoveries",[]).has(Vector2i(2,0)))
 travel.free()
 State.floors[0][Vector2i.RIGHT].cleared = true
 var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
 root.add_child(dungeon)
 await process_frame
 assert(dungeon.get_node("RouteMap").new_rooms.has(Vector2i(2,0)))
 dungeon.preview_route(Vector2i.ZERO)
 assert(dungeon.get_node("RouteDetails").text.contains("travelled"))
 dungeon.free()
 print("PASS: discovery clues without leaks/RNG changes, object reveal, reduced motion, travelled trails and new-room highlights")
 quit()
