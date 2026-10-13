extends SceneTree
var lab: Control
var elapsed: float = 0.0
var step: int = 0

func _initialize() -> void:
	lab = load("res://stride_lab.tscn").instantiate()
	root.add_child.call_deferred(lab)

func _process(delta: float) -> bool:
	elapsed += delta
	if elapsed > 6.0 and step == 0:
		lab.choose("left")
		step = 1
	elif elapsed > 10.0 and step == 1:
		lab.choose("idle")
		step = 2
	elif elapsed > 11.2 and step == 2:
		lab.choose("attack")
		step = 3
	elif elapsed > 12.5 and step == 3:
		lab.choose("right")
		step = 4
	return false
