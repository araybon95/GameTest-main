extends RefCounted
## Presentation-only portrait motion. Boots and contact shadows stay stationary.
const PALETTE_SHADER = preload("res://scripts/hero_palette.gdshader")
const PROFILES = {
	"warden":Vector3(0.75,0.65,0.0), "ranger":Vector3(0.95,0.85,1.37),
	"occultist":Vector3(1.0,0.8,2.74), "healer":Vector3(0.9,0.75,4.11),
	"crusader":Vector3(0.8,0.65,5.48)
}
static func attach(picture: TextureRect, id: String) -> void:
	var ink: ShaderMaterial
	if picture.material is ShaderMaterial and picture.material.shader == PALETTE_SHADER:
		ink = picture.material.duplicate()
		if ink.get_shader_parameter("recolor") == null: ink.set_shader_parameter("recolor",true)
	else:
		ink = ShaderMaterial.new()
		ink.shader = PALETTE_SHADER
		ink.set_shader_parameter("recolor",false)
	ink.set_shader_parameter("actor_profile",PROFILES.get(id,Vector3(0.8,0.7,0)))
	picture.material = ink
static func update(picture: TextureRect, clock: float, stride: float, weight: float, enabled: bool) -> void:
	for layer in [picture,picture.get_node_or_null("EquipmentAccents")]:
		if layer == null: continue
		var ink: ShaderMaterial = layer.material
		ink.set_shader_parameter("actor_motion",enabled)
		ink.set_shader_parameter("actor_size",picture.size)
		ink.set_shader_parameter("actor_clock",clock)
		ink.set_shader_parameter("actor_stride",stride)
		ink.set_shader_parameter("actor_walking",weight)
		ink.set_shader_parameter("actor_profile",picture.material.get_shader_parameter("actor_profile"))
