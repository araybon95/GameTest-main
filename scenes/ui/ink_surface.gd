extends TextureRect
## Textured underlay stays beneath labels and portraits, above the backing style.
const BACKDROPS = {"warden":"keep_hall.png","ranger":"hallway_bandit_panorama.png","occultist":"beast_sanctuary.png","healer":"apothecary_reclaimed.png","crusader":"bg_crypt.png"}
func _ready() -> void:
	name = "InkSurface"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ensure_material()
	if get_parent() is Container:
		set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		set_as_top_level(true)
		_sync_bounds()
	set_process(get_parent() is Container)
	resized.connect(refresh_material)
	var owner := get_parent()
	if owner is BaseButton:
		owner.mouse_entered.connect(refresh_material)
		owner.mouse_exited.connect(refresh_material)
		owner.focus_entered.connect(refresh_material)
		owner.focus_exited.connect(refresh_material)
func _sync_bounds() -> void:
	global_position = get_parent().global_position
	size = get_parent().size
func _process(_delta: float) -> void:
	_sync_bounds()
func ensure_material() -> void:
	if material != null: return
	var ink := ShaderMaterial.new()
	ink.shader = preload("res://assets/shaders/ink_surface.gdshader")
	material = ink
func configure(hero_id: String) -> void:
	ensure_material()
	set_meta("hero_id",hero_id)
	var owner: Control = get_parent()
	var extent: Vector2 = owner.size.max(owner.custom_minimum_size)
	var illustrated: bool = BACKDROPS.has(hero_id) and extent.y >= 180 and extent.y <= 650 and extent.x <= 800
	if illustrated:
		texture = load("res://assets/art_library/generated/"+BACKDROPS[hero_id])
	else:
		var flat := GradientTexture2D.new()
		flat.width = 2; flat.height = 2
		texture = flat
	material.set_shader_parameter("illustrated",illustrated)
	material.set_shader_parameter("accent",preload("res://scenes/combat/iron_frame.gd").class_color(hero_id))
	refresh_material()
func refresh_material() -> void:
	if material == null: return
	material.set_shader_parameter("surface_size",size.max(Vector2.ONE))
	var owner := get_parent()
	material.set_shader_parameter("active",1.0 if owner is BaseButton and not owner.disabled and (owner.is_hovered() or owner.has_focus()) else 0.0)
