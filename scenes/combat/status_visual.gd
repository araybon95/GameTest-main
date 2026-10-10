extends Control
## Per-combatant cosmetic effects. This node never modifies gameplay state.
const SHADER = preload("res://assets/shaders/combat_status.gdshader")
const Marks = preload("res://scenes/combat/strike_effects.gd")
const COLORS: Dictionary = {"burn": Color("#FF9A40"), "bleed": Color("#F45B66"), "poison": Color("#96CF63"), "chill": Color("#94DCFF"), "weaken": Color("#C5A7DD"), "affliction": Color("#D793C7")}
var portrait: TextureRect
var effect_material: ShaderMaterial
var statuses: Dictionary = {}
var health_ratio: float = 1.0
var dead: bool = false
var impact_remaining: float = 0.0
var elapsed: float = 0.0
var show_badges: bool = true
var badge_styles: Dictionary = {}

func attach_to(target: TextureRect) -> void:
	portrait = target
	name = "StatusVisual"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	effect_material = ShaderMaterial.new()
	effect_material.shader = SHADER
	portrait.material = effect_material
	portrait.add_child(self)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func sync(active_statuses: Dictionary, hp: int, max_hp: int, is_dead: bool = false, weak_turns: int = 0, afflicted: bool = false) -> void:
	statuses = active_statuses.duplicate(true)
	if weak_turns > 0:
		statuses["weaken"] = {"turns": weak_turns}
	if afflicted:
		statuses["affliction"] = {"turns": 0}
	health_ratio = clampf(float(hp) / maxi(1, max_hp), 0.0, 1.0)
	dead = is_dead
	for effect in ["burn", "bleed", "poison", "chill"]:
		effect_material.set_shader_parameter(effect, 1.0 if statuses.has(effect) and not dead else 0.0)
	effect_material.set_shader_parameter("wounded", 0.0 if dead else clampf((0.65 - health_ratio) / 0.65, 0.0, 1.0))
	effect_material.set_shader_parameter("slain", 1.0 if dead else 0.0)
	queue_redraw()

func hurt() -> void:
	impact_remaining = 0.45

func _process(delta: float) -> void:
	elapsed += delta
	impact_remaining = maxf(0.0, impact_remaining - delta)
	if not is_instance_valid(portrait):
		return
	var impact: float = impact_remaining / 0.45
	effect_material.set_shader_parameter("impact", impact)
	portrait.pivot_offset = Vector2(portrait.size.x * 0.5, portrait.size.y)
	var injured: bool = health_ratio <= 0.35 and not dead
	portrait.rotation = deg_to_rad(-16.0 if dead else -3.0 if injured else 0.0) + sin(elapsed * 65.0) * impact * 0.075
	var breath: float = sin(elapsed * 2.2) * 0.006 if not dead else 0.0
	portrait.scale = Vector2(0.88,0.76) if dead else Vector2(0.97,0.94 + breath) if injured else Vector2(1.0,1.0 + breath)
	if not statuses.is_empty() or injured or impact > 0.0:
		queue_redraw()

func _draw() -> void:
	if dead:
		return
	for effect in statuses:
		for mark in effect_marks(str(effect),size,elapsed):
			if mark["filled"]:
				draw_colored_polygon(mark["points"],mark["color"])
			else:
				draw_polyline(mark["points"],mark["color"],mark["width"],true)
	if show_badges:
		var index: int = 0
		for effect in statuses:
			var color: Color = COLORS.get(effect, Color.WHITE)
			var columns: int = 2
			var rect := Rect2(Vector2((index % columns) * size.x * 0.5, (index / columns) * 22), Vector2(size.x * 0.5 - 3, 20))
			draw_style_box(_badge(color), rect)
			var turns: int = int(statuses[effect].get("turns", 0))
			var value: String = str(effect).capitalize() + (" %d" % turns if turns > 0 else "")
			draw_string(ThemeDB.fallback_font, rect.position + Vector2(5, 15), value, HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 8, 14, color)
			index += 1
	if health_ratio <= 0.35:
		var rect := Rect2(Vector2(14, size.y - 20), Vector2(size.x - 28, 19))
		draw_style_box(_badge(Color("#F45B66")), rect)
		draw_string(ThemeDB.fallback_font, rect.position + Vector2(6, 14), "HURT", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x - 12, 12, Color("#F45B66"))

static func effect_marks(effect: String, dimensions: Vector2, time: float) -> Array[Dictionary]:
	# Geometry is deterministic and bounded to this portrait. No floor pools or HUD residue.
	var result: Array[Dictionary] = []
	var scale_factor: float = clampf(minf(dimensions.x/240.0,dimensions.y/250.0),0.25,1.4)
	match effect:
		"burn":
			for index in range(7):
				var rise: float = fposmod(time*0.075+index*0.093,0.6)
				var point := dimensions*Vector2(0.23+index*0.085+sin(time*1.4+index)*0.015,0.8-rise)
				var smoke: PackedVector2Array = Marks.ragged_outline(point,Vector2(14,20)*scale_factor,index+45)
				_add_mark(result,smoke,Color(0.055,0.047,0.055,0.42),true,dimensions)
				_add_mark(result,PackedVector2Array([smoke[5],smoke[6],smoke[7],smoke[8]]),Color(0.24,0.20,0.19,0.34),false,dimensions,0.8*scale_factor)
				var ember := point+Vector2(3,9)*scale_factor
				var ember_points := PackedVector2Array([ember,ember+Vector2(-1,-4)*scale_factor,ember+Vector2(1,-7)*scale_factor])
				_add_mark(result,ember_points,Color(0.83,0.44,0.20,0.84),false,dimensions,1.7*scale_factor)
			for index in range(3):
				var coal := dimensions*Vector2(0.34+index*0.15,0.69+sin(time*5+index)*0.015)
				var flicker: float = 7+sin(time*7+index)*3
				_add_mark(result,PackedVector2Array([coal+Vector2(-3,3)*scale_factor,coal+Vector2(-2,-2)*scale_factor,coal+Vector2(0,-flicker)*scale_factor,coal+Vector2(2,-2)*scale_factor,coal+Vector2(4,3)*scale_factor]),Color(0.57,0.23,0.11,0.7),true,dimensions)
		"bleed":
			for index in range(5):
				var fall: float = fposmod(time*0.09+index*0.063,0.34)
				var point := dimensions*Vector2(0.31+index*0.085,0.4+fall)
				_add_mark(result,PackedVector2Array([point+Vector2(-2,-8)*scale_factor,point+Vector2(1,-4)*scale_factor,point+Vector2(0,1)*scale_factor]),Color(0.27,0.055,0.085,0.85),false,dimensions,2.4*scale_factor)
				_add_mark(result,PackedVector2Array([point+Vector2(0,-1)*scale_factor,point+Vector2(2,4)*scale_factor,point+Vector2(0,7)*scale_factor,point+Vector2(-1.5,3)*scale_factor]),Color(0.48,0.10,0.15,0.83),true,dimensions)
		"poison":
			for index in range(6):
				var rise: float = fposmod(time*0.045+index*0.097,0.57)
				var point := dimensions*Vector2(0.25+index*0.095+sin(time+index)*0.015,0.79-rise)
				_add_mark(result,Marks.ragged_outline(point,Vector2(9,15)*scale_factor,index+63),Color(0.16,0.20,0.11,0.26),true,dimensions)
				var wisp := PackedVector2Array([point+Vector2(1,8)*scale_factor,point+Vector2(-4,1)*scale_factor,point+Vector2(3,-5)*scale_factor,point+Vector2(0,-12)*scale_factor])
				_add_mark(result,wisp,Color(0.42,0.49,0.27,0.58),false,dimensions,1.6*scale_factor)
		"chill":
			for index in range(6):
				var point := dimensions*Vector2(0.26+index%3*0.24,0.28+floor(index/3.0)*0.36)
				var length: float = 13+sin(time*1.5+index)*2
				var vein := PackedVector2Array([point+Vector2(-5,length)*scale_factor,point+Vector2(2,3)*scale_factor,point+Vector2(-2,-3)*scale_factor,point+Vector2(4,-length)*scale_factor])
				_add_mark(result,vein,Color(0.08,0.13,0.16,0.8),false,dimensions,3.3*scale_factor)
				_add_mark(result,vein,Color(0.58,0.72,0.76,0.8),false,dimensions,1.2*scale_factor)
				_add_mark(result,PackedVector2Array([point+Vector2(2,3)*scale_factor,point+Vector2(9,0)*scale_factor,point+Vector2(11,-5)*scale_factor]),Color(0.58,0.72,0.76,0.67),false,dimensions,1.1*scale_factor)
		"weaken", "affliction":
			for index in range(4):
				var point := dimensions*Vector2(0.24+index*0.17,0.25+sin(time*0.9+index)*0.07)
				_add_mark(result,PackedVector2Array([point+Vector2(-5,7)*scale_factor,point+Vector2(-2,-2)*scale_factor,point+Vector2(4,-8)*scale_factor]),Color(0.40,0.30,0.46,0.55),false,dimensions,1.5*scale_factor)
	return result

static func _add_mark(result: Array[Dictionary], points: PackedVector2Array, color: Color, filled: bool, dimensions: Vector2, width: float = 1.0) -> void:
	var bounded := PackedVector2Array()
	var margin: Vector2 = Vector2.ONE*minf(4,maxf(0,minf(dimensions.x,dimensions.y)*0.1))
	for point in points:
		bounded.append(point.clamp(margin,dimensions-margin))
	result.append({"points":bounded,"color":color,"filled":filled,"width":maxf(0.5,width)})

func _badge(color: Color) -> StyleBoxFlat:
	var key: String = color.to_html()
	if badge_styles.has(key):
		return badge_styles[key]
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0.055, 0.03, 0.045, 0.92)
	box.border_color = color.darkened(0.3)
	box.set_border_width_all(1)
	box.set_corner_radius_all(3)
	badge_styles[key] = box
	return box
