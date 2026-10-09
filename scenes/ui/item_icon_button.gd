extends Button

const Items = preload("res://scripts/item_data.gd")
var item_id: String = ""

func configure(id: String, amount: int = 1) -> void:
	item_id = id
	custom_minimum_size = Vector2(80, 80)
	focus_mode = Control.FOCUS_ALL
	var entry: Dictionary = Items.item(id)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#080B12")
	style.border_color = Color(str(Items.RARITY_COLORS.get(entry.get("rarity", ""), "#54454C")))
	style.set_border_width_all(3)
	style.shadow_color = Color(style.border_color, 0.45)
	style.shadow_size = 5
	style.set_corner_radius_all(3)
	add_theme_stylebox_override("normal", style)
	add_theme_stylebox_override("disabled", style)
	var hover: StyleBoxFlat = style.duplicate()
	hover.bg_color = Color("#382732")
	hover.set_border_width_all(3)
	add_theme_stylebox_override("hover", hover)
	add_theme_stylebox_override("focus", hover)
	tooltip_text = Items.tooltip(id)
	if entry.is_empty():
		text = "—"
		return
	var picture := TextureRect.new()
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	picture.texture = load(Items.icon_path(id))
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(picture)
	picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	picture.modulate = Color(1.3, 1.3, 1.3)
	picture.offset_left = 6
	picture.offset_top = 6
	picture.offset_right = -6
	picture.offset_bottom = -6
	var quantity := Label.new()
	quantity.text = str(amount) if amount > 1 or entry.get("kind", "") in ["scroll", "potion"] else ""
	quantity.mouse_filter = Control.MOUSE_FILTER_IGNORE
	quantity.add_theme_font_size_override("font_size", 18)
	quantity.add_theme_color_override("font_color", Color("#F4E9DD"))
	quantity.add_theme_color_override("font_outline_color", Color.BLACK)
	quantity.add_theme_constant_override("outline_size", 4)
	add_child(quantity)
	quantity.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	quantity.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	quantity.offset_right = -5
	quantity.offset_bottom = -3

func _make_custom_tooltip(for_text: String) -> Object:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#161017")
	style.border_color = Color(str(Items.RARITY_COLORS.get(Items.item(item_id).get("rarity", ""), "#8F4546")))
	style.set_border_width_all(2)
	style.set_content_margin_all(16)
	panel.add_theme_stylebox_override("panel", style)
	var label := Label.new()
	label.text = for_text
	label.custom_minimum_size = Vector2(380, 0)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", Color("#EADDD0"))
	panel.add_child(label)
	return panel
