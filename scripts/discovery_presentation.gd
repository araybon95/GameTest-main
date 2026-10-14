extends RefCounted
## Knowledge only: never creates ledger entries, claims rewards or activates Watch.
const Passages = preload("res://scripts/passage_events.gd")
const CLUES = {"quiet":"No obvious disturbance along this passage.","gold":"A glint of coins in the dust.","curio":"An abandoned object catches the torchlight.","ambush":"Fresh tracks lead into the shadows. Someone may be waiting."}
static func knowledge(state, a: Vector2i, b: Vector2i) -> Dictionary:
 var unknown: Dictionary = {"state":"unknown","kind":"unknown","clue":"The passage is unscouted. Its discoveries remain unknown."}
 var rooms: Dictionary = state.floors[state.floor_index]
 if not rooms.get(a,{}).get("seen",false) or not rooms.get(b,{}).get("seen",false): return unknown
 var event: Dictionary = state.journey.get("passages",{}).get(Passages.key(state.floor_index,a,b),{})
 if event.get("traversed",false): return {"state":"travelled","kind":event.kind,"clue":"Already travelled. The passage has been searched."}
 if event.get("discovered",false) or event.get("resolved",false):
  var text: String = "Discovery resolved." if event.get("resolved",false) else "A discovery awaits your decision."
  if event.get("result",{}).get("left",false): text = "The object was left untouched."
  return {"state":"known","kind":event.kind,"clue":text}
 if not rooms[a].get("cleared",false) and rooms[b].get("cleared",false):
  var swap: Vector2i = a; a = b; b = swap
 if not rooms[a].get("cleared",false) or not rooms[b].get("scouted",false): return unknown
 if event.is_empty(): event = Passages.generate(state,a,b)
 return {"state":"scouted","kind":event.kind,"clue":str(CLUES.get(event.kind,CLUES.quiet))}
static func route_hint(state, origin: Vector2i, route: Array) -> String:
 var previous: Vector2i = origin
 var travelled: int = 0
 var clue: String = ""
 for step in route:
  var info: Dictionary = knowledge(state,previous,step)
  if info.state == "travelled": travelled += 1
  elif clue == "" and info.state in ["known","scouted"]: clue = info.clue
  previous = step
 if clue != "": return "PASSAGE CLUE · "+clue
 if travelled == route.size() and not route.is_empty(): return "A familiar route · all passages already travelled."
 return "%d passage%s already travelled · the rest remains unscouted." % [travelled,"" if travelled == 1 else "s"]
