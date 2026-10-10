extends Control
## Original layered corridor scenery. Distance is presentation only; navigation stays in the dungeon.
const State = preload("res://scripts/game_data.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")

var scene_theme: String = "bandit"
var ground_y: float = 645.0
var distance: float = 0.0
var clock: float = 0.0
var reduced_motion: bool = false
var panorama_path: String = ""
var background: TextureRect
var near_layer: Control
var far_layer: Control
var background_origin := Vector2.ZERO

class FarLayer extends Control:
	var scenery: Control

	func _draw() -> void:
		if is_instance_valid(scenery):
			scenery.paint_far(self)

class NearLayer extends Control:
	var scenery: Control

	func _draw() -> void:
		if is_instance_valid(scenery):
			scenery.paint_near(self)

func _ready() -> void:
	name = "HallwayScenery"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	background = TextureRect.new()
	background.name = "CorridorPanorama"
	var illustrated: String = "res://assets/generated/hallway_%s_panorama.png" % scene_theme
	var path: String = panorama_path
	if path.is_empty():
		path = illustrated if ResourceLoader.exists(illustrated) else Scenery.stage_path(State.floor_background("combat"))
	if not ResourceLoader.exists(path):
		path = Scenery.stage_path(State.floor_background("combat"))
	background.texture = load(path)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Feet sit forward of the rear wall's floor seam. Preserve the panorama's aspect ratio.
	# Cover the longest accepted route without exposing an empty right edge.
	var width: float = maxf(3400.0, size.x + 1480.0)
	var height: float = width * background.texture.get_height() / float(maxi(1, background.texture.get_width()))
	background.size = Vector2(width, height)
	background_origin = Vector2(-60.0, ground_y - height * 0.82)
	background.position = background_origin
	background.modulate = Color(0.83, 0.81, 0.83)
	add_child(background)
	move_child(background, 0)
	far_layer = FarLayer.new()
	far_layer.name = "CorridorAtmosphere"
	far_layer.scenery = self
	far_layer.size = size
	far_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(far_layer)
	near_layer = NearLayer.new()
	near_layer.name = "CorridorForeground"
	near_layer.scenery = self
	near_layer.size = size
	near_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(near_layer)
	# The owner can reparent near_layer above the walkers. This node remains behind them.
	near_layer.z_index = 1

func _process(_delta: float) -> void:
	if background != null:
		background.position.x = background_origin.x - maxf(0.0, distance) * 0.45
	queue_redraw()
	if is_instance_valid(far_layer):
		far_layer.queue_redraw()
	if is_instance_valid(near_layer):
		near_layer.queue_redraw()

func paint_far(canvas: Control) -> void:
	var ambient: float = 0.0 if reduced_motion else clock
	var slow_distance: float = maxf(0.0, distance) * (0.45 if reduced_motion else 0.17)
	var fog: Color = {"bandit": Color(0.54, 0.43, 0.36, 0.045), "keep": Color(0.42, 0.47, 0.56, 0.045), "beast": Color(0.57, 0.24, 0.29, 0.045), "medical": Color(0.34, 0.47, 0.36, 0.04)}.get(scene_theme, Color(0.44, 0.42, 0.48, 0.04))
	for index in range(6):
		var x: float = fposmod(index * 470.0 - slow_distance - ambient * 8.0, 2820.0) - 340.0
		ellipse(canvas, Vector2(x, ground_y - 14.0 + sin(ambient * 0.4 + index) * 5.0), Vector2(330.0, 24.0), fog)
	# Infrequent wall lamps and drifting dust keep a stopped passage alive.
	for index in range(4):
		var x: float = fposmod(index * 760.0 - distance * 0.48, 3040.0) - 120.0
		paint_lantern(canvas, Vector2(x, 132.0), ambient, index)
	for index in range(18):
		var drift: float = ambient * (9.0 + (index % 4) * 2.0)
		var x: float = fposmod(index * 137.0 - slow_distance + sin(ambient * 0.28 + index) * 9.0, 2260.0) - 100.0
		var y: float = ground_y - 32.0 - fposmod(index * 41.0 + drift, 420.0)
		var particle: Color = Color(0.74, 0.57, 0.40, 0.15)
		if scene_theme == "beast": particle = Color(0.66, 0.22, 0.25, 0.16)
		elif scene_theme == "medical": particle = Color(0.57, 0.68, 0.45, 0.14)
		elif scene_theme == "keep": particle = Color(0.55, 0.62, 0.73, 0.12)
		canvas.draw_circle(Vector2(x, y), 1.15 if index % 3 else 1.7, particle)
	# A quiet contact band joins the art floor and the walkers without covering their feet.
	canvas.draw_rect(Rect2(0.0, ground_y + 25.0, size.x, maxf(0.0, size.y - ground_y - 25.0)), Color(0.025, 0.018, 0.025, 0.35))

func paint_lantern(canvas: Control, position: Vector2, ambient: float, index: int) -> void:
	var flicker: float = 0.88 + sin(ambient * 3.1 + index * 1.7) * 0.08 + sin(ambient * 5.7 + index) * 0.04
	var flame: Color = Color(0.85, 0.46, 0.18)
	if scene_theme == "beast": flame = Color(0.67, 0.18, 0.20)
	elif scene_theme == "medical": flame = Color(0.49, 0.59, 0.32)
	elif scene_theme == "keep": flame = Color(0.76, 0.63, 0.41)
	for ring in range(4):
		var glow: Color = flame
		glow.a = 0.014 * flicker
		ellipse(canvas, position, Vector2(22.0 + ring * 11.0, 34.0 + ring * 12.0), glow)
	canvas.draw_line(position - Vector2(0.0, 115.0), position - Vector2(0.0, 25.0), Color("#19171A"), 3.0, true)
	canvas.draw_colored_polygon(PackedVector2Array([position + Vector2(-13, -25), position + Vector2(10, -27), position + Vector2(16, 24), position + Vector2(-15, 22)]), Color("#161216"))
	flame.a = 0.45 * flicker
	canvas.draw_line(position + Vector2(1, -10), position + Vector2(-2, 12), flame, 4.0, true)
	canvas.draw_line(position + Vector2(-16, 23), position + Vector2(17, 24), Color("#292025"), 4.0, true)

func paint_near(canvas: Control) -> void:
	var scroll: float = maxf(0.0, distance) * (0.45 if reduced_motion else 1.1)
	var ink := Color("#100C10")
	var edge := Color("#261B22")
	if scene_theme == "keep":
		ink = Color("#101116")
		edge = Color("#25252C")
	elif scene_theme == "medical":
		ink = Color("#0C100D")
		edge = Color("#20271E")
	for index in range(4):
		var x: float = fposmod(index * 835.0 - scroll, 3340.0) - 185.0
		if scene_theme == "beast":
			paint_rib(canvas, x, index, ink, edge)
		elif scene_theme == "keep":
			paint_column(canvas, x, index, ink, edge)
		elif scene_theme == "medical":
			paint_shelf(canvas, x, index, ink, edge)
		else:
			paint_tree(canvas, x, index, ink, edge)
	# Scattered foreground rubble occupies the strip beneath the contact plane.
	for index in range(11):
		var x: float = fposmod(index * 229.0 - scroll, 2519.0) - 150.0
		var y: float = ground_y + 40.0 + (index % 3) * 8.0
		canvas.draw_colored_polygon(PackedVector2Array([Vector2(x - 19, y + 17), Vector2(x - 11, y - 3), Vector2(x + 7, y - 8), Vector2(x + 23, y + 6), Vector2(x + 20, y + 20)]), ink)

func paint_tree(canvas: Control, x: float, index: int, ink: Color, edge: Color) -> void:
	canvas.draw_colored_polygon(PackedVector2Array([Vector2(x - 32, ground_y + 50), Vector2(x - 13, 210), Vector2(x - 27, 66), Vector2(x + 2, 7), Vector2(x + 25, 196), Vector2(x + 17, 387), Vector2(x + 38, ground_y + 50)]), ink)
	canvas.draw_polyline(PackedVector2Array([Vector2(x + 13, 472), Vector2(x + 1, 267), Vector2(x - 5, 128)]), edge, 3.0, true)
	var direction: float = -1.0 if index % 2 else 1.0
	canvas.draw_colored_polygon(PackedVector2Array([Vector2(x, 177), Vector2(x + direction * 63, 144), Vector2(x + direction * 118, 34), Vector2(x + direction * 140, 28), Vector2(x + direction * 84, 163), Vector2(x + direction * 7, 224)]), ink)
	if index % 2 == 0:
		# A broken gallows beam and slack rope sit above the party, never across faces.
		canvas.draw_colored_polygon(PackedVector2Array([Vector2(x - 32, 98), Vector2(x + 146, 83), Vector2(x + 160, 100), Vector2(x - 27, 119)]), ink)
		canvas.draw_line(Vector2(x + 120, 105), Vector2(x + 125, 194), edge, 3.0, true)
		canvas.draw_arc(Vector2(x + 125, 207), 13.0, -0.4, TAU - 0.6, 14, edge, 3.0, true)

func paint_column(canvas: Control, x: float, index: int, ink: Color, edge: Color) -> void:
	canvas.draw_colored_polygon(PackedVector2Array([Vector2(x - 31, ground_y + 48), Vector2(x - 20, 77), Vector2(x - 12, 35), Vector2(x + 29, 35), Vector2(x + 23, 166), Vector2(x + 34, ground_y + 48)]), ink)
	canvas.draw_colored_polygon(PackedVector2Array([Vector2(x - 50, 18), Vector2(x + 60, 18), Vector2(x + 51, 70), Vector2(x - 41, 75)]), ink)
	canvas.draw_polyline(PackedVector2Array([Vector2(x + 10, 81), Vector2(x + 7, 249), Vector2(x + 16, 310), Vector2(x + 12, 576)]), edge, 3.0, true)
	for joint in range(4):
		var y: float = 134.0 + joint * 119.0
		canvas.draw_line(Vector2(x - 15, y), Vector2(x + 22, y + (5 if joint % 2 else -3)), edge, 2.0, true)
	if index % 2:
		for link in range(7):
			canvas.draw_arc(Vector2(x + 57, 52 + link * 25), 8.0, 0.0, TAU, 10, edge, 2.0, true)
	else:
		canvas.draw_colored_polygon(PackedVector2Array([Vector2(x + 8, 66), Vector2(x + 87, 20), Vector2(x + 172, 0), Vector2(x + 236, 0), Vector2(x + 97, 48), Vector2(x + 19, 98)]), ink)

func paint_rib(canvas: Control, x: float, index: int, ink: Color, edge: Color) -> void:
	canvas.draw_colored_polygon(PackedVector2Array([Vector2(x - 43, ground_y + 57), Vector2(x - 22, 444), Vector2(x - 33, 323), Vector2(x - 12, 181), Vector2(x + 15, 112), Vector2(x + 36, 120), Vector2(x + 9, 261), Vector2(x + 18, 419), Vector2(x + 34, ground_y + 57)]), ink)
	var direction: float = -1.0 if index % 2 else 1.0
	canvas.draw_colored_polygon(PackedVector2Array([Vector2(x - 9, 213), Vector2(x + direction * 28, 112), Vector2(x + direction * 87, 56), Vector2(x + direction * 167, 21), Vector2(x + direction * 234, 18), Vector2(x + direction * 218, 42), Vector2(x + direction * 121, 58), Vector2(x + direction * 62, 103), Vector2(x + direction * 17, 232)]), ink)
	canvas.draw_polyline(PackedVector2Array([Vector2(x + direction * 193, 35), Vector2(x + direction * 97, 72), Vector2(x + direction * 27, 145)]), edge, 3.0, true)
	for scar in range(3):
		var y: float = 304.0 + scar * 84.0
		canvas.draw_line(Vector2(x - 16, y), Vector2(x + 6, y + 9), edge, 2.0, true)
	# Small votive barbs make these ribs read as worship furniture rather than clean bones.
	for barb in range(3):
		var y: float = 155.0 + barb * 19.0
		canvas.draw_colored_polygon(PackedVector2Array([Vector2(x + 12, y + 18), Vector2(x + 42, y - 4), Vector2(x + 19, y + 3)]), ink)

func paint_shelf(canvas: Control, x: float, index: int, ink: Color, edge: Color) -> void:
	canvas.draw_colored_polygon(PackedVector2Array([Vector2(x - 22, ground_y + 47), Vector2(x - 17, 44), Vector2(x + 9, 38), Vector2(x + 23, ground_y + 47)]), ink)
	canvas.draw_line(Vector2(x + 7, 75), Vector2(x + 11, 569), edge, 2.0, true)
	var direction: float = -1.0 if index % 2 else 1.0
	for shelf in range(2):
		var y: float = 111.0 + shelf * 103.0
		canvas.draw_colored_polygon(PackedVector2Array([Vector2(x, y), Vector2(x + direction * 117, y - 3), Vector2(x + direction * 126, y + 10), Vector2(x, y + 16)]), ink)
		for bottle in range(3):
			var center := Vector2(x + direction * (31.0 + bottle * 27.0), y - 19.0)
			canvas.draw_colored_polygon(PackedVector2Array([center + Vector2(-8, 17), center + Vector2(-7, -7), center + Vector2(-3, -10), center + Vector2(-3, -19), center + Vector2(3, -19), center + Vector2(3, -10), center + Vector2(8, -7), center + Vector2(8, 17)]), ink)
			canvas.draw_line(center + Vector2(4, -4), center + Vector2(4, 9), edge, 2.0, true)
	# Hanging surgical cloth stays high and narrow, leaving the traveling formation clear.
	if index % 2:
		canvas.draw_colored_polygon(PackedVector2Array([Vector2(x + 32, 52), Vector2(x + 69, 48), Vector2(x + 61, 174), Vector2(x + 53, 167), Vector2(x + 47, 189), Vector2(x + 38, 166)]), ink)

func ellipse(canvas: Control, center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(32):
		var angle: float = TAU * index / 32.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	canvas.draw_colored_polygon(points, color)
