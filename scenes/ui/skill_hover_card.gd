extends Panel
## A noninteractive, viewport-clamped inspection card for the current skill.
const READY = Color("#DDE6B7")
const LOCKED = Color("#DCA59C")

func label(value: String, rect: Rect2, font_size: int, tint: Color) -> Label:
	var result := Label.new()
	result.text = value
	result.position = rect.position
	result.size = rect.size
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result.add_theme_font_size_override("font_size",font_size)
	result.add_theme_color_override("font_color",tint)
	add_child(result)
	return result

func configure(data: Dictionary) -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	focus_mode = Control.FOCUS_NONE
	size = Vector2(472,372)
	z_index = 70
	var available: bool = data["availability"]["available"]
	var frame := StyleBoxFlat.new()
	frame.bg_color = Color("#151216")
	frame.border_color = Color("#C8AD70") if available else Color("#A46059")
	frame.set_border_width_all(2)
	frame.border_width_top = 4
	frame.shadow_color = Color(0,0,0,0.85)
	frame.shadow_size = 12
	frame.shadow_offset = Vector2(0,5)
	add_theme_stylebox_override("panel",frame)
	preload("res://scripts/visual_overlays.gd").frame(self,str(data.get("hero_id","")))
	label(str(data["name"]),Rect2(20,15,432,38),24,Color("#FFF0CE"))
	label("%s · %s" % [data["hero_name"],data["class_name"]],Rect2(20,53,432,28),15,Color("#CBBCA5"))
	var icon := TextureRect.new()
	icon.name = "SkillIcon"
	icon.position = Vector2(22,91)
	icon.size = Vector2(74,90)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.texture = data.get("icon")
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.modulate = Color(1.12,1.10,1.04) if available else Color(0.88,0.84,0.82)
	add_child(icon)
	label(str(data["description"]),Rect2(114,88,335,112),18,Color("#F1E6D2")).name = "Effects"
	label(str(data["availability"]["reason"]),Rect2(20,207,432,50),17,READY if available else LOCKED).name = "Availability"
	label("Cost %d AP · Current %d AP\nCooldown %d turn(s) · %d remaining" % [data["cost"],data["current_ap"],data.get("base_cooldown",0),data["cooldown"]],Rect2(20,259,432,47),15,Color("#D6C7AF")).name = "Resources"
	label(str(data["rank"]),Rect2(20,313,432,22),14,Color("#D6C7AF")).name = "Rank"
	label(str(data.get("note","")),Rect2(20,337,432,28),12,Color("#BFAF98")).name = "PreviewNote"

func place_above(anchor: Rect2, viewport_size: Vector2) -> void:
	position = Vector2(clampf(anchor.get_center().x-size.x*0.5,12,maxf(12,viewport_size.x-size.x-12)),clampf(anchor.position.y-size.y-10,12,maxf(12,viewport_size.y-size.y-12)))
