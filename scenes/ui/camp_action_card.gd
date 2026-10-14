extends Button
## Illustrated camp actions share one component with read-only character records.
const Art = preload("res://scripts/camp_art.gd")
const Visual = preload("res://scripts/visual_overlays.gd")
const SkinTokens = preload("res://scripts/ui_skin.gd")
const ACCENTS = {"watch":Color("#B7A783"),"ward":Color("#9ABFD0"),"sharpen":Color("#C98B6B"),"scout":Color("#A9B589")}
const EFFECTS = {"watch":"Prevent the ambush","ward":"+15% debuff resistance","sharpen":"+10% skill damage","scout":"Reveal nearby rooms"}
func configure(id: String, entry: Dictionary, rested: bool = false, points: int = 3, applied: bool = false, compact: bool = false) -> void:
	if id == "watch" and preload("res://scripts/game_data.gd").map_travel_mode:
		entry = entry.duplicate()
		entry["description"] = "Prevent the next travel ambush."
	name = "CampSkill_"+id
	text = ""
	tooltip_text = str(entry.name)+"\n"+str(entry.description)+"\n"+("Prepare at camp after resting." if compact else "Applied at this camp." if applied else "Rest first to unlock preparation." if not rested else "Not enough camp points." if points < int(entry.cost) else "Prepare this camp skill.")
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if not compact else Control.CURSOR_HELP
	focus_mode = Control.FOCUS_ALL if not compact else Control.FOCUS_NONE
	disabled = compact or not rested or applied or points < int(entry.cost)
	var tint: Color = ACCENTS[id]
	for state in ["normal","hover","pressed","disabled","focus"]:
		var style := SkinTokens.frame(Color("#151517"),tint,state)
		if state == "hover": style.bg_color = Color("#302822")
		if state == "pressed": style.bg_color = Color("#3C2D22")
		if state == "disabled": style.bg_color = Color("#111113")
		add_theme_stylebox_override(state,style)
	Visual.frame(self)
	var icon := TextureRect.new()
	icon.name = "CampIcon"
	icon.texture = Art.texture_for(id)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.position = Vector2(8,5) if compact else Vector2(10,12)
	icon.size = Vector2(43,43) if compact else Vector2(85,88)
	icon.modulate = Color(0.85,0.85,0.85) if disabled and not compact and not applied else Color.WHITE
	add_child(icon)
	var x: float = 58 if compact else 108
	_label(str(entry.name),Vector2(x,6 if compact else 12),size.x-x-12,17 if compact else 22,SkinTokens.PAPER)
	if not compact:
		_label("Prevent next travel ambush" if id == "watch" and preload("res://scripts/game_data.gd").map_travel_mode else str(EFFECTS[id]),Vector2(x,44),size.x-x-12,17,tint)
	var status: String = "%d %s" % [int(entry.cost),"POINT" if int(entry.cost) == 1 else "POINTS"]
	if not compact: status += " · "+("PREPARED" if applied else "REST FIRST" if not rested else "READY" if not disabled else "INSUFFICIENT")
	_label(status,Vector2(x,29 if compact else 94),size.x-x-12,13 if compact else 14,Color("#CBB68A") if applied else SkinTokens.MUTED)
func _label(value: String, pos: Vector2, width: float, font_size: int, tint: Color) -> void:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = Vector2(width,0)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",tint)
	label.add_theme_color_override("font_shadow_color",Color.BLACK)
	label.add_theme_constant_override("shadow_offset_y",1)
	add_child(label)
