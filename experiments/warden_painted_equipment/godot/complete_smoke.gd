extends SceneTree
var failures: int = 0
func check(value: bool, message: String) -> void:
	if not value:
		failures += 1
		push_error(message)
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	if not ResourceLoader.exists("res://complete_actor.gd"):
		check(false,"Complete painted actor is missing")
		quit(1)
		return
	var actor = load("res://complete_actor.gd").new()
	root.add_child(actor)
	check(actor.get_child_count() == 1,"Character has one image node, without separate helmet/cloak/gear layers")
	actor.set_motion("walk")
	var frames: Dictionary = {}
	for i in range(10):
		actor.set_time(i*0.084+0.00001)
		frames[actor.current_frame] = true
		check(actor.current_frame >= 2,"Travel uses only the unarmed walking poses")
		check(absf(actor.art.position.y+actor.GROUNDS[actor.current_frame]*actor.art.scale.y) < 0.001,"Whole image stays grounded")
	check(frames.size() == 10,"Ten painted walking poses are retained")
	actor.set_time(0.84001)
	check(actor.current_frame == 2,"Stride retains its accepted timing")
	actor.set_facing(-1)
	check(actor.scale.x < 0,"Facing mirrors the complete image")
	actor.set_motion("idle")
	check(actor.current_frame == 0,"Combat switches to the armed full-body idle image")
	actor.attack()
	check(actor.current_frame == 1,"Attack switches to the armed full-body attack image")
	actor.advance(0.7)
	check(actor.current_frame == 0 and actor.mode == "idle","Attack returns to combat idle")
	actor.set_motion("walk")
	check(actor.current_frame >= 2,"Travel restores the gear-free whole image")
	actor.queue_free()
	await process_frame
	print("Complete painted stride checks: %d failures" % failures)
	quit(1 if failures else 0)
