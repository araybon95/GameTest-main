extends Node
## Subtle whole-image breathing; no independently moving equipment layers.
var clock: float = 0.0
static func attach(target: TextureRect) -> void:
	if target.has_node("WardenIdleMotion"): return
	var motion = load("res://scripts/warden_idle_motion.gd").new()
	motion.name = "WardenIdleMotion"
	target.add_child(motion)
func _process(delta: float) -> void:
	var target: TextureRect = get_parent()
	var settings := get_node_or_null("/root/GameSettings")
	var enabled: bool = settings == null or settings.ambient_motion
	if enabled: clock += delta
	var texture: Texture2D = target.texture
	var idle: bool = texture != null and texture.get_meta("appearance_style","") == "warden_complete" and not texture.get_meta("travel_unarmed",false) and texture.get_meta("combat_state","idle") == "idle"
	target.pivot_offset = Vector2(target.size.x/2,target.size.y)
	target.scale.y = 1.0 + sin(clock*TAU/3.6)*0.003 if enabled and idle else 1.0
