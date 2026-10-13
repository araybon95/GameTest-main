extends SceneTree
var failures: Array[String] = []
func check(value: bool, message: String) -> void:
	if not value: failures.append(message)
func _initialize() -> void: call_deferred("run")
func run() -> void:
	if not ResourceLoader.exists("res://appearance.gd"):
		print("WARDEN_RIG_FAIL: shared appearance profile is missing")
		quit(1)
		return
	var profile = load("res://appearance.gd").new()
	check(profile.set_slot("weapon","axe"),"Valid axe selection rejected")
	check(profile.set_slot("offhand","none"),"Reference stance cannot remove the shield")
	check(not profile.set_slot("weapon","unknown"),"Unknown equipment accepted")
	check(profile.weapon == "axe","Rejected selection changed weapon")
	var before: Dictionary = profile.to_dict()
	var legacy: Dictionary = before.duplicate()
	legacy.erase("offhand")
	check(profile.apply_data(legacy) and profile.offhand == "shield","Legacy lab look lost its implicit shield")
	profile.apply_data(before)
	var invalid: Dictionary = before.duplicate()
	invalid.weapon = "sword"
	invalid.cloak = "missing"
	check(not profile.apply_data(invalid) and profile.to_dict() == before,"Invalid later slot caused partial import")
	check(not profile.apply_data({"schema":9,"prototype_only":true,"weapon":"sword"}),"Future schema accepted")
	check(profile.to_dict() == before,"Failed import changed profile")
	for pair in [["schema","1"],["schema",true],["prototype_only",1],["hero",[]],["weapon",{}],["cloak",2],["offhand",true]]:
		var malformed: Dictionary = before.duplicate()
		malformed[pair[0]] = pair[1]
		var accepted = profile.apply_data(malformed)
		check(typeof(accepted) == TYPE_BOOL and accepted == false and profile.to_dict() == before,"Malformed field type was not cleanly rejected: "+pair[0])
	if not ResourceLoader.exists("res://lab.tscn"):
		print("WARDEN_RIG_FAIL: synchronized rig scene is missing")
		quit(1)
		return
	change_scene_to_file("res://lab.tscn")
	await process_frame
	await process_frame
	var lab = current_scene
	lab.set_process(false)
	check(get_root().get_node_or_null("State") == null,"Game state loaded into prototype")
	check(lab.actors.size() == 3,"Walking, combat and card instances missing")
	lab.set_slot("weapon","axe")
	for actor in lab.actors:
		check(actor.appearance == lab.appearance,"Appearance profile not shared")
		check(actor.weapon_id == "axe","Weapon change failed to reach a view")
		check(actor.weapon.get_parent() == actor.joints.near_hand,"Weapon is not bound to the hand socket")
	for id in ["sword","axe","mace"]:
		var held_phase: float = lab.actors[1].clock
		lab.set_slot("weapon",id)
		check(is_equal_approx(lab.actors[1].clock,held_phase),"Swap restarted the attack phase")
		for actor in lab.actors:
			actor.set_time(1.3)
			var spec: Dictionary = actor.data.parts[id]
			var grip: Vector2 = Vector2(spec.anchor[0],spec.anchor[1])
			check(actor.weapon.to_global(grip).distance_to(actor.joints.near_hand.global_position) < 0.05,"Weapon grip detached during motion: "+id)
	lab.set_slot("weapon","axe")
	for offset in [-0.1,lab.scenery[0].width*0.9]:
		lab.travel = offset
		lab._process(0)
		var right: float = -INF
		var left: float = INF
		for tile in lab.scenery:
			right = maxf(right,tile.node.position.x+tile.width)
			left = minf(left,tile.node.position.x)
		check(left <= 0 and right >= lab.scenery[0].node.get_parent().size.x,"Reversed or wrapped corridor exposes an empty edge")
	lab.travel = 0
	var actor = lab.actors[0]
	if not actor.joints.has("near_ankle"):
		push_error("Boots need independent ankle pivots, not rotation baked into shins")
		quit(1)
		return
	actor.mode = "idle"
	actor.set_time(0)
	var chest_height: float = actor.torso.global_position.distance_to(actor.head.to_global(Vector2(280,470)*actor.head.texture.get_width()/512.0))/actor.scale.y
	check(float(actor.data.hip_height)/chest_height < 1.6,"Leg silhouette is too elongated relative to the chest")
	for side in ["near","far"]:
		check(actor.joints[side+"_shin"].global_position.x > actor.joints[side+"_thigh"].global_position.x,"Standing knees bend away from the forward-facing reference: "+side)
	check(chest_height < 125,"Torso-to-neck proportion remains too long")
	check(actor.joints.near_sole.global_position.distance_to(actor.joints.far_sole.global_position)/actor.scale.y > 65,"Standing feet do not form a stable stance")
	actor.mode = "walk"
	actor.set_time(0.1)
	var first: Vector2 = actor.joints.near_shin.global_position
	actor.set_time(0.5)
	check(not first.is_equal_approx(actor.joints.near_shin.global_position),"Knee did not articulate")
	for i in range(130):
		actor.set_time(float(i)/100)
		check(actor.contact_error < 0.05,"Foot endpoint does not reach its target")
		check(absf(actor.joints.near_ankle.global_rotation) < 0.1,"Walking boot rotates with its shin")
	actor.set_time(0)
	var seam_start: Vector2 = actor.joints.near_shin.global_position
	actor.set_time(1.3)
	check(seam_start.distance_to(actor.joints.near_shin.global_position) < 0.05,"Walk loop seam discontinuity")
	var motion = load("res://motion.gd")
	var epsilon: float = 0.00001
	var outgoing: Vector2 = (motion.foot(0,0)-motion.foot(-epsilon,0))/epsilon
	var incoming: Vector2 = (motion.foot(epsilon,0)-motion.foot(0,0))/epsilon
	check(outgoing.distance_to(incoming) < 0.1,"Foot velocity jumps at the loop boundary")
	actor.set_time(0)
	for i in range(60): actor.advance(1.0/60)
	var fine_pose: Vector2 = actor.joints.near_shin.global_position
	actor.set_time(0)
	for i in range(15): actor.advance(1.0/15)
	check(fine_pose.distance_to(actor.joints.near_shin.global_position) < 0.05,"Motion depends on refresh rate")
	actor.set_time(0.34)
	var before_idle: Vector2 = actor.joints.near_shin.global_position
	actor.mode = "idle"
	actor.advance(0.01)
	check(before_idle.distance_to(actor.joints.near_shin.global_position) < 3.0,"Walk-to-idle snapped the knee")
	actor.advance(2.0)
	actor.mode = "walk"
	actor.set_time(0.34)
	lab.get_node("Pause").button_pressed = true
	var held_travel: float = lab.travel
	lab._process(0.5)
	check(lab.travel == held_travel,"Pause moved the corridor")
	actor.paused = true
	var held: float = actor.clock
	actor.advance(1.0)
	check(actor.clock == held,"Pause changed motion time")
	actor.reverse = true
	actor.refresh()
	check(actor.visual.scale.x < 0,"Facing did not mirror the rig")
	lab.set_slot("cloak","original")
	check(lab.actors[0].cape.texture == lab.actors[1].cape.texture,"Cape differs between views")
	lab.set_slot("weapon","sword")
	lab.set_slot("offhand","none")
	for view in lab.actors:
		check(not view.shield.visible,"Free offhand left a shield visible")
		for pose_name in ["walk","guard","windup","strike","combat"]:
			view.mode = pose_name
			for sample in range(61):
				view.set_time(sample/20.0)
				var spec: Dictionary = view.data.parts.sword
				var second_grip := Vector2(spec.anchor[0],spec.anchor[1])+Vector2.DOWN*18.0/float(spec.scale)
				check(view.weapon.to_global(second_grip).distance_to(view.joints.far_hand.global_position) < 0.05,"Second hand leaves the sword grip: "+pose_name+" at "+str(sample/20.0)+"s error="+str(view.weapon.to_global(second_grip).distance_to(view.joints.far_hand.global_position)))
				check(view.contact_error < 0.05,"Pose foot target is unreachable: "+pose_name)
	var combat_actor = lab.actors[1]
	combat_actor.mode = "combat"
	combat_actor.set_time(0)
	var previous_elbow: Vector2 = combat_actor.joints.far_forearm.global_position
	for frame_index in range(1,91):
		combat_actor.set_time(frame_index/30.0)
		var elbow: Vector2 = combat_actor.joints.far_forearm.global_position
		check(elbow.distance_to(previous_elbow)/combat_actor.scale.y < 18.0,"Sword recovery elbow turns sharply near its shoulder")
		previous_elbow = elbow
	lab.set_slot("offhand","shield")
	for view in lab.actors: check(view.shield.visible,"Shield selection not shared")
	lab.set_slot("weapon","axe")
	lab.save_profile()
	lab.set_slot("weapon","sword")
	lab.load_profile()
	check(lab.appearance.weapon == "axe","Prototype profile did not round-trip")
	var f = FileAccess.open("user://warden_rig_profile.json",FileAccess.READ)
	check(f != null,"Profile export missing")
	if f != null:
		var saved = JSON.parse_string(f.get_as_text())
		check(saved.prototype_only and saved.schema == 1,"Export can be mistaken for gameplay data")
	if failures.is_empty(): print("WARDEN_RIG_SMOKE_OK: shared appearance, articulated limbs, foot targets, loop, pause, facing and isolated profile export")
	else:
		for failure in failures: push_error(failure)
	quit(0 if failures.is_empty() else 1)
