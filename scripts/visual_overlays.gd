extends RefCounted
## Presentation only. Repository artwork has an optional installation fallback.
const Art = preload("res://scripts/local_dungeon_art.gd")
const Frame = preload("res://scenes/combat/iron_frame.gd")

class Selection extends Control:
	var hostile: bool = false
	var clock: float = 0.0
	func _ready() -> void:
		name = "SelectionUnderline"
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _process(delta: float) -> void:
		var portrait: Control = get_parent()
		position = Vector2(0,portrait.size.y-3)
		size = Vector2(portrait.size.x,10)
		if not visible: return
		clock += delta
		queue_redraw()
	func _draw() -> void:
		var tint := Color("#E77565") if hostile else Color("#F0CE8D")
		tint.a = 0.82+sin(clock*2.8)*0.12
		var half: float = minf(95,size.x*0.45)
		var center := Vector2(size.x*0.5,4)
		draw_line(center-Vector2(half,0),center+Vector2(half,0),Color("#0A0809"),7,true)
		draw_line(center-Vector2(half,0),center+Vector2(half,0),tint,2,true)
		draw_colored_polygon(PackedVector2Array([center+Vector2(-5,-3),center+Vector2(0,3),center+Vector2(5,-3)]),tint)

class Banner extends Control:
	var texture: Texture2D
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		if texture != null:
			draw_texture_rect(texture,Rect2(Vector2.ZERO,size),false,Color(1.35,1.25,1.15))
		else:
			draw_rect(Rect2(12,14,size.x-24,size.y-28),Color("#321315"))
			for y in [8.0,size.y-8.0]:
				draw_line(Vector2(18,y),Vector2(size.x-18,y),Color("#756450"),2)
				draw_line(Vector2(30,y+3),Vector2(size.x-30,y+3),Color("#292626"),1)

static func frame(panel: Control, hero_id: String = "") -> void:
	if not panel.has_node("InkSurface"):
		var surface = preload("res://scenes/ui/ink_surface.gd").new()
		surface.name = "InkSurface"
		panel.add_child(surface)
		panel.move_child(surface,0)
	panel.get_node("InkSurface").configure(hero_id)
	if not panel.has_node("IronFittings"):
		var new_frame = Frame.new()
		new_frame.name = "IronFittings"
		panel.add_child(new_frame)
	var fittings = panel.get_node("IronFittings")
	fittings.hero_id = hero_id
	fittings.z_index = 2
	fittings.queue_redraw()
	if panel is BaseButton and not panel.has_meta("ornament_signals"):
		panel.set_meta("ornament_signals",true)
		panel.mouse_entered.connect(fittings.queue_redraw)
		panel.mouse_exited.connect(fittings.queue_redraw)
		panel.focus_entered.connect(fittings.queue_redraw)
		panel.focus_exited.connect(fittings.queue_redraw)

static func selection(portrait: TextureRect, selected: bool, hostile: bool = false) -> void:
	var marker: Control = portrait.get_node_or_null("SelectionUnderline")
	if marker == null:
		marker = Selection.new()
		portrait.add_child(marker)
	marker.hostile = hostile
	marker.visible = selected

static func banner(label: Label) -> void:
	if label.has_node("PaintedBanner"): return
	var decoration := Banner.new()
	decoration.name = "PaintedBanner"
	decoration.texture = Art.texture("../overlays/movename_frame.png")
	decoration.position = Vector2(-24,-12)
	decoration.size = label.size+Vector2(48,24)
	decoration.z_index = -1
	label.add_child(decoration)

static func stage_edges(scope: Control, rect: Rect2) -> void:
	if scope.has_node("StageEdgeOverlay"): return
	var overlay := ColorRect.new()
	overlay.name = "StageEdgeOverlay"
	overlay.position = rect.position
	overlay.size = rect.size
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.z_index = 10
	var material := ShaderMaterial.new()
	material.shader = preload("res://assets/shaders/stage_edge_overlay.gdshader")
	overlay.material = material
	scope.add_child(overlay)
