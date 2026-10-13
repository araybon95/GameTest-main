extends "res://complete_actor.gd"
## Same timing and single-image rendering as the approved original outfit.
func _init() -> void:
	sheet = preload("res://assets/ashen_wolf_poses.png")
	ground_values = [380.0,380.0,384.0,384.0,349.0,345.0,348.0,350.0,336.0,337.0,338.0,338.0]
	head_values = [42.0,55.0,47.0,47.0,7.0,9.0,8.0,10.0,5.0,6.0,7.0,6.0]
