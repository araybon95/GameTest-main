extends Control
## Native local PNG layers repeat at their canvas scale rather than stretching
## a single tile across the screen. Distance remains presentation-only.
var profile: Dictionary = {}
var scene_theme: String = "bandit"
var ground_y: float = 645.0
var distance: float = 0.0
var clock: float = 0.0
var reduced_motion: bool = false
var background: TextureRect
var near_layer: Control
var far_layer: Control
var bands: Array[Dictionary] = []
var native_scale: float = 1.0
var canvas_origin: float = 0.0

func _ready() -> void:
	name = "LocalHallwayLayers"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if profile.is_empty(): return
	var canvas: Vector2 = profile.get("canvas", Vector2(720, 720))
	native_scale = size.y / maxf(canvas.y, 1.0)
	canvas_origin = ground_y - float(profile.get("ground_line", 645.0)) * native_scale
	far_layer = Control.new()
	far_layer.name = "LocalBackgroundLayers"
	far_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	far_layer.size = size
	add_child(far_layer)
	var rear: Array[Texture2D] = [profile["background"]]
	var middle: Array[Texture2D] = [profile["mid"]]
	var back_band: Dictionary = build_band(far_layer, "Background", rear, 0.20, canvas_origin + float(profile.get("background_offset", 0.0)) * native_scale)
	background = back_band["tiles"][0]
	build_band(far_layer, "Midground", middle, 0.40, canvas_origin + float(profile.get("mid_offset", 0.0)) * native_scale)
	build_band(far_layer, "Wall", profile["walls"], 0.65, canvas_origin)
	var floor_region: Rect2 = profile.get("floor_region", Rect2(0, 600, 720, 120))
	build_band(far_layer, "Floor", profile["floors"], 0.90, canvas_origin + floor_region.position.y * native_scale)
	near_layer = Control.new()
	near_layer.name = "LocalCorridorForeground"
	near_layer.size = size
	near_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	near_layer.z_index = 1
	add_child(near_layer)
	var top: Texture2D = profile.get("foreground_top")
	if top != null:
		var tops: Array[Texture2D] = [top]
		build_band(near_layer, "ForegroundTop", tops, 1.10, 0.0)
	var bottom: Texture2D = profile.get("foreground_bottom")
	if bottom != null:
		var bottoms: Array[Texture2D] = [bottom]
		build_band(near_layer, "ForegroundBottom", bottoms, 1.10, size.y - bottom.get_height() * native_scale)
	_process(0.0)

func build_band(parent: Control, layer_name: String, textures: Array, ratio: float, y: float) -> Dictionary:
	var band: Dictionary = {"name":layer_name,"textures":textures,"ratio":ratio,"y":y,"tiles":[],"tile_width":0.0}
	if textures.is_empty(): return band
	var width: float = textures[0].get_width() * native_scale
	band["tile_width"] = width
	var count: int = int(ceil(size.x / maxf(width, 1.0))) + 3
	for index in range(count):
		var tile := TextureRect.new()
		tile.name = "%s_%d" % [layer_name, index]
		tile.texture = textures[index % textures.size()]
		tile.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tile.stretch_mode = TextureRect.STRETCH_SCALE
		tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tile.size = Vector2(width, tile.texture.get_height() * native_scale)
		parent.add_child(tile)
		band["tiles"].append(tile)
	bands.append(band)
	return band

func _process(_delta: float) -> void:
	for band in bands:
		var width: float = band["tile_width"]
		var travelled: float = maxf(0.0, distance) * float(band["ratio"])
		var first: int = int(floor(travelled / width)) - 1
		var start: float = -fposmod(travelled, width) - width
		var textures: Array = band["textures"]
		for index in range(band["tiles"].size()):
			var tile: TextureRect = band["tiles"][index]
			tile.texture = textures[posmod(first + index, textures.size())]
			tile.position = Vector2(start + index * width, band["y"])

func _exit_tree() -> void:
	# The travel owner may place the foreground above the walking party.
	# Free it only if it has actually left this component's subtree.
	if is_instance_valid(near_layer) and near_layer.get_parent() != self:
		near_layer.queue_free()
