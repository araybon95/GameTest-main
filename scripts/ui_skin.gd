extends RefCounted
## Shared visual tokens. No scene routing or gameplay state.
const INK = Color("#101012")
const PAPER = Color("#EDE1CE")
const MUTED = Color("#B5A694")
const BRASS = Color("#B89C71")
const EDGE = Color("#665B4E")
static func refine(source: StyleBoxFlat, state: String = "panel") -> StyleBoxFlat:
	var box: StyleBoxFlat = source.duplicate()
	box.set_corner_radius_all(2)
	box.shadow_color = Color(0,0,0,0.65)
	box.shadow_size = 7 if state == "panel" else 4
	box.shadow_offset = Vector2(0,4)
	if state == "focus":
		box.draw_center = false
		box.border_color = BRASS.lightened(0.2)
		box.set_border_width_all(2)
	else:
		box.border_color = box.border_color.lerp(EDGE,0.45)
		box.set_border_width_all(1)
	return box
static func frame(fill: Color, border: Color, state: String = "panel") -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_content_margin_all(12)
	return refine(box,state)
