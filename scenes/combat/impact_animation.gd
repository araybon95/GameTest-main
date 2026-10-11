extends RefCounted
## Recreated impact motion; optional painted splatter is read from the local installation.
const Art = preload("res://scripts/local_dungeon_art.gd")
static var splatter: AtlasTexture

static func pose(time: float) -> Dictionary:
	var age: float = time - 0.28
	if time < 0.28 or time >= 0.62: return {}
	var fraction: float = age / 0.34
	return {"sweep":clampf(age / 0.065,0,1), "scale":lerpf(0.38,1.12,1.0-pow(1.0-fraction,3)),
		"alpha":1.0-smoothstep(0.10,0.34,age), "fall":fraction*fraction*20.0,"age":age}

static func blood_texture() -> Texture2D:
	var source: Texture2D = Art.texture("../fx/blood_splatter/blood_splatter.sprite.png")
	if source == null: return null
	if splatter == null or splatter.atlas != source:
		splatter = AtlasTexture.new()
		splatter.atlas = source
		splatter.region = Rect2(2,2,309,282)
		splatter.filter_clip = true
	return splatter

static func draw(canvas: Node2D, point: Vector2, time: float, direction: float, kind: String, fire: bool, heavy: bool) -> void:
	var frame: Dictionary = pose(time)
	if frame.is_empty(): return
	var opacity: float = frame["alpha"]
	var extent: float = 155.0 if heavy else 115.0
	if kind in ["sword","bow","arrow"]:
		var texture: Texture2D = blood_texture()
		if texture != null:
			var dimensions := Vector2(175,160)*float(frame["scale"])*(1.25 if heavy else 1.0)
			canvas.draw_set_transform(point+Vector2(direction*12,frame["fall"]),0,Vector2(direction,1))
			canvas.draw_texture_rect(texture,Rect2(-dimensions*0.5,dimensions),false,Color(0.78,0.64,0.64,opacity*0.85))
			canvas.draw_set_transform(Vector2.ZERO)
	if kind == "sword" and frame["age"] < 0.15:
		var tip: float = float(frame["sweep"])
		var tail: float = maxf(0,tip-0.65)
		var a: Vector2 = point+Vector2(direction*extent*(tail-0.5),extent*(tail-0.5))
		var b: Vector2 = point+Vector2(direction*extent*(tip-0.5),extent*(tip-0.5))
		var normal := Vector2(-direction,1).normalized()
		canvas.draw_colored_polygon(PackedVector2Array([a,b+normal*9,b-normal*4]),Color(0.06,0.04,0.05,opacity))
		canvas.draw_line(a,b,Color(0.88,0.81,0.65,opacity),2.5,true)
	if fire:
		for index in range(7):
			var phase: float = float(frame["age"])*18+index*1.9
			var base: Vector2 = point+Vector2((index-3)*13,35-float(frame["age"])*70)
			var tip: Vector2 = base+Vector2(sin(phase)*12,-(25+sin(phase+0.7)*11)*float(frame["scale"]))
			canvas.draw_colored_polygon(PackedVector2Array([base+Vector2(-9,0),tip,base+Vector2(8,0)]),Color(0.58,0.16,0.06,opacity*0.8))
			canvas.draw_line(base,tip,Color(0.9,0.53,0.23,opacity*0.85),2,true)
