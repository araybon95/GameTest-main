extends Control
## Original foreground shapes connect the party and props to the same floor.
var scene_theme: String = "bandit"
var ground_y: float = 680.0
var time: float = 0.0
var scrolling: float = 0.0
var fire_position := Vector2(-1000, -1000)
var fire_spent: bool = false
var show_foreground: bool = true

static func theme_for(expedition: Dictionary, floor: int) -> String:
	if expedition.get("faction", "") == "remade": return "beast"
	if expedition.get("faction", "") == "moth": return "medical"
	if expedition.get("id", "") == "old_road" and floor > 0: return "keep"
	return "bandit"

static func stage_path(path: String) -> String:
	var stages: Dictionary = {"bandit_combat.png":"bandit_battle_stage.png", "keep_hall.png":"keep_battle_stage.png", "beast_sanctuary.png":"beast_battle_stage.png", "apothecary_interior.png":"apothecary_battle_stage.png"}
	return "res://assets/generated/" + str(stages[path.get_file()]) if stages.has(path.get_file()) else path

static func threshold_path(kind: String) -> String:
	var illustrated: String = "res://assets/generated/threshold_%s.tres" % kind
	return illustrated if ResourceLoader.exists(illustrated) else "res://assets/ui/threshold_%s.svg" % kind

static func tint(kind: String) -> Color:
	return {"bandit":Color("#E6C6A8"), "keep":Color("#CED8E8"), "beast":Color("#DFB5B2"), "medical":Color("#C8D9BE")}.get(kind, Color.WHITE)

static func grounded_texture(path: String, padding: int = 0) -> Texture2D:
	var original: Texture2D = load(path)
	var image: Image = original.get_image()
	var bounds: Rect2i = image.get_used_rect()
	if bounds.size.x <= 0 or bounds.size.y <= 0: return original
	if padding > 0: bounds = bounds.grow(padding).intersection(Rect2i(Vector2i.ZERO,image.get_size()))
	var atlas := AtlasTexture.new()
	atlas.atlas = original
	atlas.region = bounds
	atlas.filter_clip = true
	return atlas

static func apply_hero_palette(picture: TextureRect, id: String, chosen_color: String) -> void:
	if chosen_color == "original": return
	var material := ShaderMaterial.new()
	material.shader = preload("res://scripts/hero_palette.gdshader")
	material.set_shader_parameter("accent", {"red":Color("#B93640"),"green":Color("#389B58"),"blue":Color("#438CCD"),"gold":Color("#D5A03A")}.get(chosen_color,Color.WHITE))
	material.set_shader_parameter("source_family",1 if id == "ranger" else 2 if id == "occultist" else 0)
	picture.material = material

static func decorate(scope: Node) -> void:
	# These screens rebuild after choices; apply the iron skin to each rebuilt view.
	var presentation: Node = scope.get_node_or_null("/root/GothicPresentation")
	if presentation != null: presentation.decorate(scope)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	time += delta
	queue_redraw()

func _draw() -> void:
	# The darkest shapes remain at the edges; the playable ground stays clear.
	draw_rect(Rect2(0, ground_y + 32, size.x, maxf(0, size.y-ground_y-32)), Color(0.025,0.018,0.025,0.65))
	for index in range(5):
		var x: float = fposmod(index * 525.0 - scrolling, 2625.0) - 350.0
		var fog := Color(0.42,0.35,0.33,0.045) if scene_theme == "bandit" else Color(0.43,0.47,0.52,0.045)
		if scene_theme == "beast": fog = Color(0.55,0.20,0.25,0.04)
		if scene_theme == "medical": fog = Color(0.30,0.50,0.32,0.045)
		ellipse(Vector2(x,ground_y-15), Vector2(320,25), fog)
	if not show_foreground:
		if fire_position.x > 0: draw_fire()
		return
	for side in [0,1]:
		var x: float = 50.0 if side == 0 else size.x-65.0
		var direction: float = 1.0 if side == 0 else -1.0
		if scene_theme == "beast":
			draw_colored_polygon(PackedVector2Array([Vector2(x-direction*90,70),Vector2(x-direction*20,70),Vector2(x+direction*12,ground_y+40),Vector2(x-direction*100,ground_y+40)]),Color("#0D0910"))
			for index in range(4):
				var y: float = 120.0+index*125.0
				draw_colored_polygon(PackedVector2Array([Vector2(x-direction*15,y+130),Vector2(x+direction*20,y+95),Vector2(x+direction*60,y+35),Vector2(x+direction*130,y),Vector2(x+direction*105,y+20),Vector2(x+direction*51,y+65),Vector2(x+direction*9,y+137)]),Color("#0D0910"))
		elif scene_theme == "medical":
			draw_rect(Rect2(x-10,180,25,ground_y-180),Color("#0B100D"))
			for index in range(3):
				var y: float = 245.0+index*110.0
				draw_line(Vector2(x-direction*10,y),Vector2(x+direction*105,y),Color("#0C100D"),10)
				for bottle in range(3):
					var pos := Vector2(x+direction*(22+bottle*28),y-30)
					draw_rect(Rect2(pos-Vector2(8,0),Vector2(16,24)),Color("#0F1512"))
		else:
			draw_colored_polygon(PackedVector2Array([Vector2(x-25,ground_y+35),Vector2(x-9,80),Vector2(x+20,80),Vector2(x+32,ground_y+35)]),Color("#101015"))
			if scene_theme == "keep":
				draw_line(Vector2(x+direction*35,85),Vector2(x+direction*35,275),Color("#404348"),4)
				for index in range(6):
					draw_arc(Vector2(x+direction*35,95+index*30),8,0,TAU,8,Color("#303239"),2,true)
	if fire_position.x > 0: draw_fire()

func ellipse(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(40):
		var angle: float = TAU*index/40.0
		points.append(center+Vector2(cos(angle),sin(angle))*radius)
	draw_colored_polygon(points,color)

func draw_fire() -> void:
	var glow := Color(1.0,0.30,0.08,0.035)
	if scene_theme == "beast": glow = Color(0.9,0.08,0.17,0.035)
	if fire_spent: glow.a *= 0.45
	for index in range(6):
		ellipse(fire_position-Vector2(0,17),Vector2(80+index*24,35+index*12),glow)
	for index in range(4):
		var drift: float = fposmod(time*24+index*27,120)
		draw_circle(fire_position+Vector2(sin(time+index)*28,-drift),1.8,Color(0.9,0.5,0.25,(1-drift/120)*.45))
