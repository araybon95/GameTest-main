extends "res://scenes/ui/party_screen.gd"
const Scenery = preload("res://scripts/dungeon_scenery.gd")
const ORB_SCENE: String = "res://scenes/expedition/merchant_orb_room.tscn"
const ORB_ART: String = "res://assets/art_library/generated/merchant_orb_ink.png"
var transitioning: bool = false

# Keep the native Button's keyboard activation while inspecting only painted pixels.
class PaintedOrbButton extends Button:
	var prop: TextureRect
	var silhouette: Image
	func _has_point(point: Vector2) -> bool:
		if not is_instance_valid(prop) or silhouette == null: return false
		var local_point: Vector2 = prop.get_global_transform_with_canvas().affine_inverse() * (get_global_transform_with_canvas() * point)
		if not Rect2(Vector2.ZERO, prop.size).has_point(local_point): return false
		var pixel := Vector2i(local_point / prop.size * Vector2(silhouette.get_size()))
		pixel.x = clampi(pixel.x, 0, silhouette.get_width() - 1)
		pixel.y = clampi(pixel.y, 0, silhouette.get_height() - 1)
		return silhouette.get_pixelv(pixel).a > 0.08

class OrbLight extends Node2D:
	var time: float = 0.0
	var orb_center := Vector2(0, -350)
	var halo_size := Vector2(100, 90)
	func _process(delta: float) -> void:
		time += delta
		queue_redraw()
	func ellipse(center: Vector2, radius: Vector2, tint: Color) -> void:
		var points := PackedVector2Array()
		for index in range(36):
			var angle: float = TAU * index / 36.0
			points.append(center + Vector2(cos(angle), sin(angle)) * radius)
		draw_colored_polygon(points, tint)
	func _draw() -> void:
		var pulse: float = 0.85 + sin(time * 1.1) * 0.15
		for index in range(5):
			ellipse(orb_center, halo_size * (1.0 + index * 0.20), Color(0.22, 0.56, 0.61, 0.012 * pulse))
			ellipse(Vector2(0, -2), Vector2(85 + index * 23, 10 + index * 3), Color(0.20, 0.52, 0.59, 0.016 * pulse))

class IronFrame extends Control:
	func _ready() -> void: mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		var iron := Color("#94806A")
		for corner in [Vector2(10, 10), Vector2(size.x - 10, 10), Vector2(10, size.y - 10), size - Vector2(10, 10)]:
			var direction := Vector2(1 if corner.x < size.x * 0.5 else -1, 1 if corner.y < size.y * 0.5 else -1)
			draw_line(corner, corner + Vector2(24 * direction.x, 0), iron, 3)
			draw_line(corner, corner + Vector2(0, 24 * direction.y), iron, 3)
			draw_circle(corner + direction * 7, 2, Color("#B9A184"))
		for y in [151.0, 388.0, 610.0]:
			draw_line(Vector2(30, y), Vector2(size.x - 30, y), Color("#594E43"), 1)
			draw_line(Vector2(32, y + 2), Vector2(size.x - 32, y + 2), Color(0, 0, 0, 0.6), 1)

func _ready() -> void:
	if not State.merchant_orb_available():
		get_tree().change_scene_to_file.call_deferred("res://scenes/expedition/dungeon.tscn")
		return
	State.ensure_run_heroes()
	refresh()
	add_child(preload("res://scenes/expedition/scene_arrival.gd").new())

func refresh() -> void:
	clear_screen()
	var room: Dictionary = State.floors[State.floor_index][State.room_position]
	var floor_theme: String = Scenery.theme_for(State.selected_expedition, State.floor_index)
	var backdrop := picture(Scenery.stage_path(State.floor_background("combat")), Rect2(0, 0, 1920, 815))
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var ambience = Scenery.new()
	ambience.name = "OrbAtmosphere"
	ambience.size = Vector2(1920, 815)
	ambience.ground_y = 690.0
	ambience.scene_theme = floor_theme
	ambience.show_foreground = false
	add_child(ambience)
	var event_panel := panel(Rect2(35, 60, 600, 700), Color("#151215"))
	event_panel.name = "MerchantOrbLorePanel"
	var iron := StyleBoxFlat.new()
	iron.bg_color = Color(0.06, 0.05, 0.055, 0.96)
	iron.border_color = Color("#635447")
	iron.set_border_width_all(2)
	iron.border_width_top = 3
	iron.shadow_color = Color(0, 0, 0, 0.8)
	iron.shadow_size = 12
	iron.shadow_offset = Vector2(4, 6)
	event_panel.add_theme_stylebox_override("panel", iron)
	var fittings := IronFrame.new()
	fittings.position = event_panel.position
	fittings.size = event_panel.size
	add_child(fittings)
	var category := label_at("ROOM EVENT · FLOOR %d" % (State.floor_index + 1), Vector2(65, 85), 540, 23)
	category.add_theme_color_override("font_color", Color("#AA9780"))
	var title := label_at("Merchant's Orb", Vector2(65, 145), 540, 40)
	title.add_theme_color_override("font_color", Color("#F2DEC1"))
	var lore: String = {
		"bandit": "The brigands guarded more than stolen coin. Beneath their spoils, a blue glass orb burns without heat. Somewhere beyond its surface, a trader is waiting.",
		"keep": "The fallen retainers kept this relic among the keep's plunder. Its cold light survives their oath, opening a passage to a trader beyond the ruined walls.",
		"beast": "The chamber falls silent, but the blue pulse refuses the chorus of the Beast. A merchant's refuge waits beyond the glass, untouched by their worship.",
		"medical": "Among abandoned instruments, an untainted blue light answers. Beyond it lies a trader's refuge, far from the infestation."
	}.get(floor_theme, "A blue orb glimmers in the cleared chamber. A trader's refuge waits beyond its surface.")
	label_at(lore, Vector2(65, 230), 535, 25).size = Vector2(535, 215)
	var safety := label_at("ENEMIES DEFEATED", Vector2(65, 475), 535, 23)
	safety.add_theme_color_override("font_color", Color("#BFD49A"))
	label_at("Touch the orb to enter the Emporium.\nBuy supplies or sell spare items for gold.\nReturn here whenever you are ready.", Vector2(65, 530), 535, 23).size = Vector2(535, 125)
	label_at("This passage remains open while you explore the floor.", Vector2(65, 690), 535, 20)
	for index in range(State.party.size()):
		var hero_id: String = State.party[index]
		var shadow = preload("res://scenes/combat/ground_shadow.gd").new()
		var x: float = 760 + index * 205
		shadow.position = Vector2(x, 690)
		add_child(shadow)
		var figure := picture(str(State.hero(hero_id)["art"]), Rect2(x - 100, 360, 200, 330))
		figure.name = "OrbHero_" + hero_id
		figure.texture = Scenery.grounded_texture(str(State.hero(hero_id)["art"]))
		figure.stretch_mode = TextureRect.STRETCH_SCALE
		figure.size = Vector2(330 * figure.texture.get_width() / float(figure.texture.get_height()), 330)
		figure.position = Vector2(x - figure.size.x * 0.5, 360)
		figure.modulate = Scenery.tint(floor_theme)
		if State.run_heroes[hero_id].get("dead", false): figure.modulate = Color(0.4, 0.4, 0.43, 0.5)
		Scenery.apply_hero_palette(figure, hero_id, str(State.hero_colors.get(hero_id, "original")))
	var object_button := PaintedOrbButton.new()
	object_button.name = "MerchantOrbObject"
	object_button.position = Vector2(1280, 205)
	object_button.size = Vector2(480, 510)
	object_button.pressed.connect(touch_orb)
	add_child(object_button)
	object_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	object_button.tooltip_text = "Enter the Emporium. Buy or sell items, then return to this chamber."
	for state in ["normal", "disabled", "pressed", "hover", "focus"]:
		object_button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	var glow := OrbLight.new()
	glow.name = "MerchantOrbLight"
	glow.position = Vector2(1520, 690)
	add_child(glow)
	var prop_shadow = preload("res://scenes/combat/ground_shadow.gd").new()
	prop_shadow.position = Vector2(1520, 690)
	prop_shadow.scale = Vector2(1.45, 1.35)
	add_child(prop_shadow)
	var prop := picture(ORB_ART, Rect2(1330, 220, 380, 470))
	prop.name = "MerchantOrbProp"
	prop.texture = Scenery.grounded_texture(ORB_ART, 4)
	var prop_height: float = minf(470.0, 380.0 * prop.texture.get_height() / float(prop.texture.get_width()))
	prop.size = Vector2(prop_height * prop.texture.get_width() / float(prop.texture.get_height()), prop_height)
	prop.position = Vector2(1520 - prop.size.x * 0.5, 690 - prop_height)
	prop.stretch_mode = TextureRect.STRETCH_SCALE
	object_button.prop = prop
	object_button.silhouette = prop.texture.get_image()
	glow.orb_center = Vector2(0, -prop_height * 0.76)
	glow.halo_size = Vector2(prop.size.x * 0.30, prop_height * 0.20)
	var highlight := ShaderMaterial.new()
	highlight.shader = preload("res://assets/shaders/curio_highlight.gdshader")
	highlight.set_shader_parameter("glow_color", Color("#9FDDE3"))
	highlight.set_shader_parameter("strength", 0.18)
	prop.material = highlight
	object_button.mouse_entered.connect(func(): highlight.set_shader_parameter("strength", 0.88))
	object_button.mouse_exited.connect(func(): highlight.set_shader_parameter("strength", 0.18))
	object_button.focus_entered.connect(func(): highlight.set_shader_parameter("strength", 0.88))
	object_button.focus_exited.connect(func(): highlight.set_shader_parameter("strength", 0.18))
	var action := label_at("TOUCH THE ORB · ENTER EMPORIUM", Vector2(1250, 725), 570, 24)
	action.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	action.add_theme_color_override("font_color", Color("#BCECF2"))
	party_bar(continue_exploring, "CONTINUE EXPLORING")
	Scenery.decorate(self)

func touch_orb() -> void:
	if transitioning or not State.merchant_orb_available(): return
	transitioning = true
	State.shop_return_scene = ORB_SCENE
	get_tree().change_scene_to_file("res://scenes/hub/item_shop.tscn")

func continue_exploring() -> void:
	if transitioning: return
	transitioning = true
	get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		continue_exploring()
