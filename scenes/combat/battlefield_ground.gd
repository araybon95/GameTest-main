extends TextureRect
## Stationary painted floor, separate from the camera-controlled scenery.
const SURFACE_Y: float = 430.0
const FEATHER: float = 24.0
var surface_y: float = SURFACE_Y
func configure(source: Texture2D, stage_size: Vector2, surface: float = SURFACE_Y) -> void:
 surface_y = surface
 name = "GroundLayer"
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 stretch_mode = TextureRect.STRETCH_SCALE
 # Sample the existing theme's floor at exactly its original screen position.
 # The short feather hides the join as the independent backdrop camera moves.
 var top: float = maxf(0,surface_y-FEATHER)
 position = Vector2(0,top)
 size = Vector2(stage_size.x,stage_size.y-top)
 var atlas := AtlasTexture.new()
 atlas.atlas = source
 atlas.region = Rect2(0,source.get_height()*top/stage_size.y,source.get_width(),source.get_height()*(stage_size.y-top)/stage_size.y)
 atlas.filter_clip = true
 texture = atlas
 var shader := Shader.new()
 shader.code = "shader_type canvas_item; uniform float feather = 24.0; varying float floor_y; void vertex(){ floor_y = VERTEX.y; } void fragment(){ COLOR.a *= smoothstep(0.0, feather, floor_y); }"
 var floor_material := ShaderMaterial.new()
 floor_material.shader = shader
 floor_material.set_shader_parameter("feather",FEATHER)
 material = floor_material
