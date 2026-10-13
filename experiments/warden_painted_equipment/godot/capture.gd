extends SceneTree
var lab: Control
var elapsed: float = 0.0
var step: int = 0

func _initialize() -> void:
	lab = load("res://lab.tscn").instantiate()
	root.add_child.call_deferred(lab)

func _process(delta: float) -> bool:
	elapsed += delta
	if elapsed > 3.0 and step == 0:
		lab.appearance.set_slot("weapon","axe")
		step = 1
	elif elapsed > 5.0 and step == 1:
		lab.appearance.set_reward_available(true)
		lab.appearance.set_slot("helmet","wolf")
		step = 2
	elif elapsed > 7.0 and step == 2:
		lab.appearance.set_slot("cloak","crown")
		step = 3
	elif elapsed > 9.0 and step == 3:
		lab.appearance.set_slot("helmet","original")
		step = 4
	elif elapsed > 10.0 and step == 4:
		lab.appearance.set_slot("helmet","wolf")
		lab.fighter.attack()
		step = 5
	elif elapsed > 11.3 and step == 5:
		lab.appearance.set_slot("weapon","mace")
		lab.fighter.attack()
		step = 6
	elif elapsed > 12.6 and step == 6:
		lab.walker.set_facing(-1)
		lab.fighter.attack()
		step = 7
	elif elapsed > 14.0 and step == 7:
		lab.walker.set_facing(1)
		lab.appearance.set_reward_available(false)
		step = 8
	return false
