extends SceneTree
const ImpactMotion = preload("res://scenes/combat/impact_animation.gd")
const Art = preload("res://scripts/local_dungeon_art.gd")
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void:
	var rng: int = State.loot_rng.state
	assert(ImpactMotion.pose(0.279).is_empty())
	assert(ImpactMotion.pose(0.62).is_empty())
	var contact: Dictionary = ImpactMotion.pose(0.28)
	var sweep: Dictionary = ImpactMotion.pose(0.35)
	var recovery: Dictionary = ImpactMotion.pose(0.57)
	assert(contact["sweep"] == 0 and contact["alpha"] == 1)
	assert(sweep["sweep"] == 1 and sweep["scale"] > contact["scale"])
	assert(recovery["alpha"] < sweep["alpha"] and recovery["fall"] > sweep["fall"])
	Art.configure(Art.DEFAULT_ROOT,false)
	assert(ImpactMotion.blood_texture() == null)
	Art.configure(Art.DEFAULT_ROOT,true)
	if FileAccess.file_exists(Art.DEFAULT_ROOT.path_join("../fx/blood_splatter/blood_splatter.sprite.png")):
		assert(ImpactMotion.blood_texture().region == Rect2(2,2,309,282))
	assert(State.loot_rng.state == rng)
	print("PASS: impact anticipation, fast sweep, held contact, fade/fall, optional splatter and unchanged loot RNG")
	quit()

