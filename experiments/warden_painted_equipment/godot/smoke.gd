extends SceneTree
var failures: int = 0

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	if not ResourceLoader.exists("res://actor.gd"):
		check(false, "Modular painted Warden renderer is missing")
		quit(1)
		return
	var look = load("res://appearance.gd").new()
	var actor = load("res://actor.gd").new()
	actor.appearance = look
	root.add_child(actor)
	check(look.weapon == "mace" and look.helmet == "original", "Trial begins with stock equipment")
	check(not look.set_slot("helmet", "wolf"), "Reward helmet is locked before the simulated unlock")
	check(not look.set_slot("cloak", "crown"), "Reward cloak is locked before the simulated unlock")
	actor.set_motion("walk")
	actor.advance(0.23)
	var phase: float = actor.clock
	var frame: int = actor.current_frame
	var body_before: Texture2D = actor.body.texture
	var mace_before: Texture2D = actor.weapon.texture
	check(look.set_slot("weapon", "axe"), "Mace can be swapped for axe")
	check(actor.weapon.texture != mace_before, "Weapon swap changes the rendered weapon texture")
	check(actor.body.texture == body_before, "Weapon swap retains the painted body pose")
	check(actor.current_frame == frame and is_equal_approx(actor.clock, phase), "Equipment swap preserves stride phase")
	look.set_reward_available(true)
	var helmet_before: Texture2D = actor.helmet.texture
	var cloak_before: Texture2D = actor.cape.texture
	check(look.set_slot("helmet", "wolf"), "Simulated unlock permits wolf helmet")
	check(actor.helmet.texture != helmet_before, "Wolf helmet changes its own texture")
	check(look.set_slot("cloak", "crown"), "Simulated unlock permits reward cloak")
	check(actor.cape.texture != cloak_before, "Reward cloak changes its own texture")
	check(actor.current_frame == frame and is_equal_approx(actor.clock, phase), "Cosmetic swaps preserve stride phase")
	var visited: Dictionary = {}
	for i in range(10):
		actor.set_time(i * 0.084 + 0.00001)
		visited[actor.current_frame] = true
		for weapon in ["mace", "axe"]:
			look.set_slot("weapon", weapon)
			check(actor.weapon_grip_error() < 0.001, "Weapon remains at the hand socket in every walking pose")
	check(visited.size() == 10, "Walk visits ten distinct painted frames")
	actor.attack()
	actor.advance(0.2)
	check(actor.current_frame == 1, "Combat uses the distinct overhead attack pose")
	look.set_slot("weapon", "mace")
	check(actor.current_frame == 1 and actor.weapon_grip_error() < 0.001, "Weapon can swap during the held attack without losing the grip")
	actor.advance(0.5)
	check(actor.mode == "idle" and actor.current_frame == 0, "Attack returns to breathing idle")
	actor.advance(0.8)
	var breath: float = actor.breath_offset
	actor.advance(0.4)
	check(maxf(absf(breath), absf(actor.breath_offset)) > 0.01, "Equipped actor breathes in idle")
	var safe: Dictionary = look.to_dict()
	check(not look.set_slot("weapon", "invalid"), "Unknown weapon IDs are rejected")
	check(look.to_dict() == safe, "Rejected selection leaves the current outfit intact")
	look.set_reward_available(false)
	check(look.helmet == "original" and look.cloak == "original", "Disabling simulated rewards restores stock cosmetics")
	check(actor.mode == "idle", "Changing reward availability does not restart motion")
	actor.set_facing(-1)
	check(actor.visual.scale.x < 0, "Left facing mirrors the complete equipped actor")
	actor.queue_free()
	await process_frame
	print("Painted equipment checks: %d failures" % failures)
	quit(1 if failures else 0)
