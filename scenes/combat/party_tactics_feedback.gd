extends Control
## Read-only guard links and formation equipment feedback.
var combat: Control
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	set_process(true)
func links() -> Array:
	var result: Array = []
	if not is_instance_valid(combat): return result
	for hero in combat._standing_heroes():
		var target: String = combat.hero_state[hero].get("oath_target","")
		if not target.is_empty() and combat._is_standing(target):
			result.append({"source":hero,"target":target,"return_ready":not combat.hero_state[hero].get("oath_retaliated",true)})
	return result
func movement_text(hero: String) -> String:
	var state: Script = load("res://scripts/game_data.gd")
	if state.equipment_bonus(hero,"free_move") > 0:
		return "SCOUTING · FREE MOVE USED · RESETS NEXT TURN" if combat.hero_state[hero].get("free_move_used",false) else "SCOUTING · FIRST FORMATION MOVE FREE"
	if combat.formation_move_cost(hero) > 1: return "HEAVY PLATE · FORMATION MOVE COSTS 2 AP"
	return "FORMATION MOVE · 1 AP"
func _process(_delta: float) -> void: queue_redraw()
func _draw() -> void:
	if not is_instance_valid(combat) or combat.battle_over: return
	if combat.presentation != null and combat.presentation.visible: return
	var tint := Color("#E0C77E")
	for link in links():
		var a: Vector2 = combat.hero_portraits[link.source].get_global_rect().get_center()
		var b: Vector2 = combat.hero_portraits[link.target].get_global_rect().get_center()
		a = get_global_transform().affine_inverse()*a
		b = get_global_transform().affine_inverse()*b
		a.y = 563
		b.y = 563
		var points := PackedVector2Array([a+Vector2(0,-9),a,b,b+Vector2(0,-9)])
		draw_polyline(points,Color("#100C10"),7,true)
		draw_polyline(points,tint,2,true)
		for point in [a,b]: draw_circle(point,4,tint)
		var caption: String = "OATH · %s → %s · UNTIL NEXT TURN · %s" % [combat._name_of(link.source).left(14),combat._name_of(link.target).left(14),"RETURN READY" if link.return_ready else "RETURN SPENT"]
		draw_string(ThemeDB.fallback_font,Vector2(minf(a.x,b.x)-35,592),caption,HORIZONTAL_ALIGNMENT_LEFT,800,16,tint)
