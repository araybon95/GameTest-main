extends SceneTree
func _initialize() -> void:
 var timeline = load("res://experimental/witch_hunter/execution/timeline.gd")
 assert(timeline != null,"Execution timeline must exist")
 assert(timeline.sample(0.0).target == -1)
 assert(timeline.sample(timeline.UPPERCUT-0.001).target == -1)
 assert(timeline.sample(timeline.UPPERCUT).target == 0)
 assert(not timeline.sample(timeline.CRUSH-0.001).dead)
 assert(timeline.sample(timeline.CRUSH).dead and timeline.sample(timeline.CRUSH).target == 1)
 assert(timeline.CRUSH-timeline.UPPERCUT >= 0.4,"Separate impact beats leave time for overhead windup")
 assert(timeline.sample(timeline.FALL_END).target == 2)
 assert(timeline.sample(timeline.DURATION).complete)
 print("PASS: distinct uppercut/crush beats, no early death, buckling then limp corpse, finite execution")
 quit()
