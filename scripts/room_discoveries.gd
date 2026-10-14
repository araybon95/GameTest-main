extends RefCounted
## Restore room-owned discoveries from the earlier passage prototype.
static func prepare_floor(state) -> void:
 var rooms: Dictionary = state.floors[state.floor_index]
 for room in rooms.values():
  if room.get("kind","") == "chamber" and room.has("travel_discovery"):
   if room.get("travel_discovery_resolved",false):
    room["cleared"] = true
   else:
    var original: Dictionary = room.travel_discovery.duplicate(true)
    original["seen"] = room.get("seen",false)
    original["scouted"] = room.get("scouted",false)
    room.merge(original,true)
   room.erase("travel_discovery")
  if room.get("kind","") == "event": room["event_layout"] = "room"
static func move(state, route: Array) -> bool:
 if route.is_empty() or not state.run_active or state.run_complete: return false
 if not state.journey.get("transit",{}).is_empty(): return false
 var rooms: Dictionary = state.floors[state.floor_index]
 var previous: Vector2i = state.room_position
 if not rooms.get(previous,{}).get("cleared",false): return false
 for i in range(route.size()):
  var step: Variant = route[i]
  if not step is Vector2i or not rooms.has(step) or not rooms[step].get("seen",false) or abs(step.x-previous.x)+abs(step.y-previous.y) != 1: return false
  if i < route.size()-1 and not rooms[step].get("cleared",false): return false
  previous = step
 if not state.authorize_move("local",route[0]): return false
 var seen: Array = []
 for point in rooms:
  if rooms[point].get("seen",false): seen.append(point)
 for step in route:
  if not state.commit_move(step): return false
 if not state.journey.has("recent_discoveries"): state.journey["recent_discoveries"] = []
 for point in rooms:
  if rooms[point].get("seen",false) and not seen.has(point) and not state.journey.recent_discoveries.has(point): state.journey.recent_discoveries.append(point)
 return true
