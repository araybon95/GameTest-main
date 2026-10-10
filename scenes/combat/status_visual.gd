extends Control
## Per-combatant cosmetic effects. This node never modifies gameplay state.
const SHADER = preload("res://assets/shaders/combat_status.gdshader")
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
	portrait.rotation = deg_to_rad(-3.0 if injured else 0.0) + sin(elapsed * 65.0) * impact * 0.075
	portrait.scale = Vector2(0.97, 0.94) if injured else Vector2.ONE
	if not statuses.is_empty() or injured or impact > 0.0:
		queue_redraw()

func _draw() -> void:
	if dead:
		return
	var center := size * 0.5
	if statuses.has("burn"):
		for index in range(7):
			var x: float = size.x * (0.22 + index * 0.09)
			var height: float = 20.0 + 10.0 * sin(elapsed * 7.0 + index * 1.8)
			var foot := Vector2(x, size.y * 0.88)
			draw_colored_polygon(PackedVector2Array([foot + Vector2(-9, 0), foot + Vector2(-6, -height * 0.45), foot + Vector2(4 * sin(elapsed * 5 + index), -height), foot + Vector2(8, 0)]), Color(1.0, 0.35, 0.03, 0.7))
			draw_circle(foot + Vector2(0, -height * 0.23), 4, Color(1.0, 0.83, 0.25, 0.8))
			var rise: float = fposmod(elapsed * 30.0 + index * 19, size.y * 0.6)
			draw_circle(Vector2(x + sin(index + elapsed) * 6, size.y * 0.85 - rise), 1.8, Color(1.0, 0.65, 0.18, 0.85))
	if statuses.has("bleed"):
		for index in range(5):
			var fall: float = fposmod(elapsed * 35.0 + index * 27.0, size.y * 0.42)
			var point := Vector2(size.x * (0.31 + index * 0.085), size.y * 0.4 + fall)
			draw_line(point - Vector2(0, 6), point, Color("#A8243F"), 3)
			draw_circle(point, 2.5, Color("#DF3A51"))
	if statuses.has("poison"):
		for index in range(6):
			var rise: float = fposmod(elapsed * 17 + index * 29, size.y * 0.75)
			var point := Vector2(size.x * (0.22 + index * 0.11) + sin(elapsed * 2 + index) * 7, size.y * 0.87 - rise)
			draw_circle(point, 3.5 + sin(elapsed + index), Color(0.49, 0.85, 0.25, 0.65), false, 1.5)
	if statuses.has("chill"):
		for index in range(6):
			var angle: float = index * TAU / 6.0
			var point := center + Vector2(cos(angle) * size.x * 0.33, sin(angle) * size.y * 0.37)
			var length: float = 7.0 + sin(elapsed * 2.0 + index) * 2.0
			draw_line(point - Vector2(length, 0), point + Vector2(length, 0), COLORS["chill"], 1.5)
			draw_line(point - Vector2(0, length), point + Vector2(0, length), COLORS["chill"], 1.5)
	if statuses.has("weaken") or statuses.has("affliction"):
		draw_arc(center, minf(size.x, size.y) * 0.38, elapsed * 0.6, elapsed * 0.6 + PI * 1.4, 24, Color(0.69, 0.48, 0.8, 0.6), 2)
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
