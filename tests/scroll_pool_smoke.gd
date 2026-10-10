extends SceneTree
const Items = preload("res://scripts/item_data.gd")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 713
	var counts: Dictionary = {}
	for trial in range(20000):
		var id: String = Items.roll_scroll(rng)
		assert(Items.SCROLLS.has(id), "Every scroll roll produces a known scroll")
		counts[id] = int(counts.get(id, 0)) + 1
	# Both rare scroll designs must be lootable; dictionary order cannot exclude one.
	assert(int(counts.get("healing_scroll", 0)) > 1800)
	assert(int(counts.get("lightning_bolt_scroll", 0)) > 1800)
	var rare_total: int = int(counts["healing_scroll"]) + int(counts["lightning_bolt_scroll"])
	assert(abs(rare_total - 5000) < 400, "Sharing a tier preserves its combined rarity weight")
	assert(abs(int(counts["healing_scroll"]) - int(counts["lightning_bolt_scroll"])) < 400)
	assert(int(counts.get("fire_bolt_scroll", 0)) > 11000)
	assert(int(counts.get("storm_lance_scroll", 0)) > 1500)
	assert(int(counts.get("sunfire_scroll", 0)) > 650)
	var saved_rng: int = rng.state
	var sequence: Array[String] = []
	for trial in range(100):
		sequence.append(Items.roll_scroll(rng))
	rng.state = saved_rng
	for expected in sequence:
		assert(Items.roll_scroll(rng) == expected, "Pool selection resumes deterministically from saved RNG state")
	print("PASS: every scroll is lootable, shared rare pool preserves rarity weight and saved RNG sequence")
	quit()
