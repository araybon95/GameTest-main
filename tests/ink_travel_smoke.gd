extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.select_expedition("old_road")
 State.start_run(20)
 var gold: int = State.gold
 var hp: int = State.run_heroes["warden"]["hp"]
 var passage = preload("res://scenes/expedition/hallway_travel.gd").new()
 passage.duration = 10
 root.add_child(passage)
 await process_frame
 assert(passage.walkers.size() == 3 and passage.walk_frames.size() == 5)
 for id in State.HEROES:
  assert(passage.walk_frames[id].size() == 2)
  for frame in passage.walk_frames[id]: assert(frame.get_width() > 0 and frame.get_height() > 0)
 var start: float = passage.scenery.position.x
 await create_timer(0.25).timeout
 assert(passage.scenery.position.x < start)
 assert(State.gold == gold and State.run_heroes["warden"]["hp"] == hp,"Travel presentation does not change gameplay")
 var completions: Array = []
 passage.finished.connect(func(): completions.append(true))
 passage.finish()
 passage.finish()
 assert(completions.size() == 1,"Skip and timer cannot resolve travel twice")
 await process_frame
 State.run_heroes["ranger"]["dead"] = true
 var next = preload("res://scenes/expedition/hallway_travel.gd").new()
 root.add_child(next)
 await process_frame
 assert(next.walkers.size() == 2,"Fallen heroes do not walk")
 next.finish()
 await process_frame
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print("PASS: hallway scrolling, walk frames, safe skip and surviving party")
 quit()
