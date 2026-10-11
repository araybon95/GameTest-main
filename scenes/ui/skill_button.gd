extends Button
## Native disabled actions keep a separate focus target for safe inspection.
const HoverCard = preload("res://scenes/ui/skill_hover_card.gd")
var available: bool = false
var data: Dictionary = {}
var popup_host: Control
var preview: Control
var inspect_focus: Control
var pointer_inside: bool = false
var keyboard_inside: bool = false
var inspecting: bool = false

func configure(details: Dictionary, host: Control) -> void:
	data = details
	popup_host = host
	available = bool(data["availability"]["available"])
	disabled = not available
	focus_mode = Control.FOCUS_ALL if available else Control.FOCUS_NONE
	# Tooltips use this immediate card; avoid a second native delayed tooltip.
	tooltip_text = ""
	inspect_focus = Control.new()
	inspect_focus.name = "InspectFocus"
	inspect_focus.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inspect_focus.focus_mode = Control.FOCUS_NONE if available else Control.FOCUS_ALL
	add_child(inspect_focus)
	inspect_focus.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inspect_focus.focus_entered.connect(_focus_entered)
	inspect_focus.focus_exited.connect(_focus_exited)
	_apply_style()
	preload("res://scripts/visual_overlays.gd").frame(self,str(data.get("hero_id","")))

func _ready() -> void:
	mouse_entered.connect(func(): pointer_inside = true; _sync_inspection())
	mouse_exited.connect(func(): pointer_inside = false; _sync_inspection())
	focus_entered.connect(_focus_entered)
	focus_exited.connect(_focus_exited)

func _focus_entered() -> void:
	keyboard_inside = true
	_sync_inspection()

func _focus_exited() -> void:
	keyboard_inside = false
	_sync_inspection()

func _sync_inspection() -> void:
	inspecting = pointer_inside or keyboard_inside
	_apply_style()
	if inspecting: show_preview()
	elif is_instance_valid(preview): preview.hide()
	queue_redraw()

func show_preview() -> void:
	if not is_instance_valid(popup_host) or not is_inside_tree(): return
	for child in popup_host.get_children():
		if child is Control and child != preview and child.name.begins_with("SkillPreview_"): child.hide()
	if not is_instance_valid(preview):
		preview = HoverCard.new()
		preview.name = "SkillPreview_%s" % name
		preview.configure(data)
		popup_host.add_child(preview)
	preview.place_above(Rect2(get_global_rect().position-popup_host.global_position,get_global_rect().size),popup_host.size)
	preview.show()

func _exit_tree() -> void:
	if is_instance_valid(preview): preview.queue_free()

func _apply_style() -> void:
	var frame := StyleBoxFlat.new()
	frame.bg_color = Color("#1D201B") if available else Color("#21171A")
	frame.border_color = Color("#A49B68") if available else Color("#73524F")
	frame.set_border_width_all(2)
	frame.border_width_top = 3
	frame.shadow_color = Color(0,0,0,0.9)
	frame.shadow_size = 4
	frame.shadow_offset = Vector2(0,4)
	var highlight: StyleBoxFlat = frame.duplicate()
	highlight.bg_color = Color("#2A2B20") if available else Color("#302022")
	highlight.border_color = Color("#EFE4AD") if available else Color("#CC8D82")
	highlight.set_border_width_all(3)
	highlight.shadow_size = 8
	highlight.shadow_color = Color(0.65,0.57,0.31,0.24) if available else Color(0.46,0.16,0.16,0.24)
	add_theme_stylebox_override("normal",frame)
	add_theme_stylebox_override("hover",highlight)
	add_theme_stylebox_override("pressed",highlight)
	add_theme_stylebox_override("disabled",highlight if inspecting else frame)
	var focus: StyleBoxFlat = highlight.duplicate()
	focus.bg_color = Color(0,0,0,0)
	add_theme_stylebox_override("focus",focus)
	if has_node("Contents"):
		get_node("Contents").position.y = -2 if inspecting else 0
		get_node("Contents/Header").add_theme_color_override("font_color",Color("#FFF0CE") if available else Color("#DEC2BC"))
		get_node("Contents/Description").add_theme_color_override("font_color",Color("#F0E6D2") if available else Color("#C8B8B2"))
		get_node("Contents/Effect").add_theme_color_override("font_color",Color("#DDE6B7") if available else Color("#DCA59C"))
		get_node("Contents/ArtFrame/CardArt").modulate = Color(1.12,1.10,1.02) if available else Color(0.83,0.76,0.74)

func _draw() -> void:
	if not inspecting: return
	var tint: Color = Color("#EFE4AD") if available else Color("#CC8D82")
	draw_rect(Rect2(Vector2(2,2),size-Vector2(4,4)),tint,false,2)
	for x in [8.0,size.x-8.0]:
		draw_line(Vector2(x,8),Vector2(x,25),tint,3,true)
