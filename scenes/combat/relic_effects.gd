extends RefCounted
## Signature shapes use deterministic geometry and never consume gameplay RNG.
static func identity(active: Dictionary) -> String:
	return str(active.get("relic_fx","")) if not str(active.get("relic_fx","")).is_empty() else str(active.get("skill_id",""))
static func draw(canvas: Node2D, data: Dictionary, active: Dictionary) -> void:
	var id: String = identity(active)
	var start: Vector2 = data.start
	var aim: Vector2 = data.aim
	var flight: float = data.progress
	var power: float = data.impact
	var ink := Color("#100B10")
	var tint := Color("#B6C66D")
	if id in ["relic_ranger","relic_volley"] and data.clock >= 0.13 and data.clock < 0.38:
		var normal: Vector2 = (aim-start).normalized().orthogonal()
		for offset in [-1,0,1]:
			var tip: Vector2 = start.lerp(aim,flight)+normal*offset*12*sin(flight*PI)
			var tail: Vector2 = tip-(aim-start).normalized()*35
			canvas.draw_line(tail,tip,ink,6,true)
			canvas.draw_line(tail,tip,tint,2,true)
			canvas.draw_colored_polygon(PackedVector2Array([tip,tip-(aim-start).normalized()*13+normal*5,tip-(aim-start).normalized()*13-normal*5]),tint)
	if id in ["relic_occultist","relic_drain","drain_return"]:
		if id != "drain_return" and not data.harmful: return
		var origin: Vector2 = aim if id != "drain_return" else start
		var end: Vector2 = start if id != "drain_return" else aim
		var strength: float = power
		if id == "drain_return": strength = sin(flight*PI)
		if strength > 0:
			var path := PackedVector2Array()
			for i in range(15):
				var t: float = i/14.0
				path.append(origin.lerp(end,t)+Vector2(0,sin(t*PI*3+data.clock*8)*16*sin(t*PI)))
			canvas.draw_polyline(path,Color(0.04,0.02,0.06,strength),8,true)
			canvas.draw_polyline(path,Color(0.66,0.39,0.72,strength),3,true)
			for i in range(5): canvas.draw_circle(origin.lerp(end,fposmod(flight+i*0.19,1)),3,Color(0.85,0.76,0.71,strength))
	if id in ["relic_healer","relic_cleanse","relic_warden","relic_guard"] and power > 0:
		var gold := Color(0.90,0.78,0.52,power)
		for i in range(3): canvas.draw_arc(aim,30+power*65+i*17,0,TAU,48,gold,2,true)
		for i in range(8):
			var ray: Vector2 = Vector2.from_angle(i*TAU/8)
			canvas.draw_line(aim+ray*25,aim+ray*(50+power*55),gold,2,true)
	if id in ["relic_crusader","relic_charge"] and data.harmful and power > 0:
		for i in range(7):
			var ray: Vector2 = Vector2.from_angle(-1.1+i*0.35)
			var p: Vector2 = aim+ray*(30+power*70)
			canvas.draw_line(aim,p,Color(0.39,0.05,0.10,power),5,true)
			canvas.draw_colored_polygon(PackedVector2Array([p,p-ray*20+ray.orthogonal()*6,p-ray*20-ray.orthogonal()*6]),Color(0.78,0.68,0.52,power))
