extends SceneTree
var failures: int = 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var actor = load("res://actor.gd").new()
	root.add_child(actor)
	actor.set_motion("walk")
	var neck_x: Array[float] = []
	var neck_y: Array[float] = []
	for i in range(10):
		actor.set_time(i*0.084+0.00001)
		check(not actor.weapon.visible, "Walking holsters the weapon in every pose")
		check(not actor.gauntlet.visible, "Walking does not overlay a gripping-hand patch")
		var joint: Vector2 = actor.helmet.position + Vector2(280,470)*0.18
		neck_x.append(joint.x)
		neck_y.append(joint.y)
		var frame_ground: Vector2 = actor.body.position + Vector2(0,actor.GROUNDS[actor.current_frame])*actor.body.scale
		check(absf(frame_ground.y) < 0.001, "Registration keeps the boot baseline planted")
	check(neck_x.max()-neck_x.min() < 0.01, "Walking no longer shifts the upper body sideways between drawings")
	check(neck_y.max()-neck_y.min() < 2.5, "Walking has a restrained controlled bob instead of atlas jitter")
	actor.appearance.set_slot("weapon","axe")
	check(not actor.weapon.visible, "Swapping a holstered weapon does not reveal it during travel")
	actor.set_time(0.84+0.00001)
	check(actor.current_frame == 2, "The approved ten-pose stride keeps its original duration")
	actor.set_motion("idle")
	check(actor.weapon.visible and actor.gauntlet.visible, "Combat stance reveals the equipped weapon and grip")
	actor.attack()
	check(actor.weapon.visible and actor.current_frame == 1, "Attack uses the equipped weapon")
	actor.advance(0.7)
	check(actor.weapon.visible and actor.mode == "idle", "Attack returns to an armed breathing stance")
	actor.set_motion("walk")
	actor.set_facing(-1)
	check(not actor.weapon.visible and actor.visual.scale.x < 0, "Leftward travel remains weapon free")
	actor.queue_free()
	await process_frame
	print("Weapon-free stride checks: %d failures" % failures)
	quit(1 if failures else 0)
