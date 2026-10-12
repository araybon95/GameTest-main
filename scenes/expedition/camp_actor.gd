extends Node
## Foot-anchored breathing and firelight, with no gameplay randomness.
var portrait: TextureRect
var base_tint: Color
var clock: float = 0.0
var spent: bool = false
var alive: bool = true
func _ready() -> void:
 name = "CampActor"
 portrait = get_parent()
 portrait.pivot_offset = Vector2(portrait.size.x*0.5,portrait.size.y)
 base_tint = portrait.modulate
 if portrait.material == null:
  var material := ShaderMaterial.new()
  material.shader = preload("res://scripts/hero_palette.gdshader")
  material.set_shader_parameter("recolor",false)
  portrait.material = material
func _process(delta: float) -> void:
 var runtime := get_node_or_null("/root/GameSettings")
 var moving: bool = alive and (runtime == null or runtime.ambient_motion)
 if moving: clock += delta
 portrait.scale = Vector2(1.0,1.0+sin(clock*1.6)*0.003 if moving else 1.0)
 if portrait.material is ShaderMaterial:
  portrait.material.set_shader_parameter("firelight",(0.32 if spent else 0.65)*(0.92+0.08*sin(clock*3.4)) if alive else 0.0)
