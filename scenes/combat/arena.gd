extends Control
## Provides a quiet battlefield beneath the combatants.

const MOTE_TEXTURE_PATH: String = "res://assets/generated/mote.png"


func _ready() -> void:
	var particles: CPUParticles2D = $Dust
	if ResourceLoader.exists(MOTE_TEXTURE_PATH):
		particles.texture = load(MOTE_TEXTURE_PATH) as Texture2D
