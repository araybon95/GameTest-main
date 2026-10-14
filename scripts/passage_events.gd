extends RefCounted
## Saved undirected hallway outcomes. Uses a separate deterministic RNG.
static func key(floor: int, a: Vector2i, b: Vector2i) -> String:
 if a.x > b.x or (a.x == b.x and a.y > b.y):
  var swap: Vector2i = a; a = b; b = swap
 return "%d:%d,%d:%d,%d" % [floor,a.x,a.y,b.x,b.y]
static func prepare_floor(state) -> void:
 for room in state.floors[state.floor_index].values():
  if room.get("kind","") != "event" or room.get("cleared",false) or room.get("event_id","") == "crusader_coffin": continue
  room["travel_discovery"] = room.duplicate(true)
  room["kind"] = "chamber"
  room.erase("event_layout")
static func restore_floor(state) -> void:
 for room in state.floors[state.floor_index].values():
  if room.get("kind","") != "chamber" or not room.has("travel_discovery") or room.get("travel_discovery_resolved",false): continue
  var original: Dictionary = room.travel_discovery
  room["kind"] = "event"
  room["event_layout"] = original.get("event_layout","room")
  room.erase("travel_discovery")
static func activate(state, event: Dictionary) -> Dictionary:
 if event.get("resolved",false): return event
 if event.has("destination") and state.floors[state.floor_index].get(event.destination,{}).get("travel_discovery_resolved",false):
  event["kind"] = "quiet"
  event["resolved"] = true
 if event.kind == "ambush" and state.journey.get("passage_watch",false):
  event["kind"] = "quiet"
  state.journey["passage_watch"] = false
  mark_discovery(state,event)
 return event
static func encounter(state, a: Vector2i, b: Vector2i) -> Dictionary:
 var id: String = key(state.floor_index,a,b)
 if not state.journey.has("passages"): state.journey["passages"] = {}
 var ledger: Dictionary = state.journey.passages
 if ledger.has(id): return activate(state,ledger[id])
 var rng := RandomNumberGenerator.new()
 rng.seed = state.run_seed*1009+int(id.hash())
 var destination: Dictionary = state.floors[state.floor_index].get(b,{})
 var event: Dictionary = {"key":id,"kind":"quiet","resolved":false,"seed":rng.randi()}
 if destination.has("travel_discovery") and not destination.get("travel_discovery_resolved",false):
  var old: Dictionary = destination.travel_discovery.duplicate(true)
  event["destination"] = b
  event["kind"] = {"gold":"gold","roamer":"ambush"}.get(old.get("corridor_encounter","object"),"curio")
  event["amount"] = int(old.get("small_gold",3))
  event["room"] = old
 elif not destination.get("cleared",false):
  var roll: float = rng.randf()
  event["kind"] = "quiet" if roll < 0.70 else "curio" if roll < 0.85 else "gold" if roll < 0.95 else "ambush"
  event["amount"] = rng.randi_range(1,4)
 if event.kind == "curio" and not event.has("room"):
  var pool: Array = state.Events.pool(str(state.selected_expedition.get("faction","")))
  event["room"] = {"kind":"event","event_id":pool[rng.randi_range(0,pool.size()-1)],"event_seed":event.seed,"event_resolved":false,"cleared":false}
 if event.kind == "ambush":
  var enemy: String = str(destination.get("creature",state.floor_enemy_pool(state.floor_index)[0]))
  event["room"] = {"kind":"battle","creature":enemy,"enemies":[enemy],"cleared":false,"corridor_surprise":true,"travel_text":"AMBUSH IN THE PASSAGE — defeat the prowler to continue your journey."}
 ledger[id] = event
 return activate(state,event)
static func resolve(state, event: Dictionary, hero: String, action: String) -> Dictionary:
 activate(state,event)
 if event.get("resolved",false): return {}
 var result: Dictionary = {}
 match str(event.get("kind","quiet")):
  "quiet": result = {"text":"The passage is quiet."}
  "gold":
   state.gold += int(event.get("amount",0))
   result = {"text":"Recovered %d Gold along the passage." % event.get("amount",0),"gold":event.get("amount",0)}
  "curio": result = state.Events.resolve_room(state,event.room,hero,action == "leave",action)
  "ambush": return {}
 if result.is_empty(): return {}
 event["resolved"] = true
 event["result"] = result
 mark_discovery(state,event)
 return result
static func mark_discovery(state, event: Dictionary) -> void:
 if event.has("destination") and state.floors[state.floor_index].has(event.destination):
  state.floors[state.floor_index][event.destination]["travel_discovery_resolved"] = true
static func begin(state, route: Array) -> bool:
 if not state.run_active or state.run_complete or route.is_empty(): return false
 var rooms: Dictionary = state.floors[state.floor_index]
 var previous: Vector2i = state.room_position
 if not rooms.has(previous) or not rooms[previous].get("cleared",false): return false
 for i in range(route.size()):
  var step: Variant = route[i]
  if not step is Vector2i or not rooms.has(step) or not rooms[step].get("seen",false) or abs(step.x-previous.x)+abs(step.y-previous.y) != 1: return false
  if i < route.size()-1 and not rooms[step].get("cleared",false): return false
  previous = step
 state.journey["transit"] = {"run_id":state.run_id,"floor":state.floor_index,"origin":state.room_position,"route":route.duplicate(),"index":0,"stage":"travel","event_key":"","event_done":false}
 return true
static func valid_transit(state) -> bool:
 var transit: Dictionary = state.journey.get("transit",{})
 if transit.is_empty() or not state.run_active or state.run_complete or transit.get("run_id","") != state.run_id or transit.get("floor",-1) != state.floor_index: return false
 var route: Array = transit.get("route",[])
 var index: int = int(transit.get("index",-1))
 if index < 0 or index >= route.size(): return false
 var expected: Vector2i = transit.origin if index == 0 else route[index-1]
 if state.room_position != expected: return false
 var rooms: Dictionary = state.floors[state.floor_index]
 if not rooms.has(expected) or not rooms[expected].get("cleared",false): return false
 for i in range(index,route.size()):
  if not route[i] is Vector2i or not rooms.has(route[i]) or not rooms[route[i]].get("seen",false) or abs(route[i].x-expected.x)+abs(route[i].y-expected.y) != 1: return false
  if i < route.size()-1 and not rooms[route[i]].get("cleared",false): return false
  expected = route[i]
 return true
static func battle_room(state) -> Dictionary:
 var transit: Dictionary = state.journey.get("transit",{})
 if not valid_transit(state) or transit.get("stage","") != "battle": return {}
 return state.journey.get("passages",{}).get(transit.get("event_key",""),{}).get("room",{})
