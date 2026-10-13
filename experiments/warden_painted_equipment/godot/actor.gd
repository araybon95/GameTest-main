extends Node2D
## A painted flipbook body with independent equipment, not articulated limbs.
const BODY = preload("res://assets/body_poses.png")
const GEAR = preload("res://assets/gear_parts.png")
const COMPONENTS = preload("res://assets/components.png")
const WOLF = preload("res://assets/corrupted_warhelm.png")
const BREATH = preload("res://breath.gdshader")
const CLOTH = preload("res://cloth.gdshader")
const FRAME_SECONDS := 0.084
const ATTACK_SECONDS := 0.62
const GROUNDS := [366.0, 366.0, 368.0, 368.0, 335.0, 340.0, 343.0, 343.0, 336.0, 336.0, 337.0, 334.0]
const NECKS := [Vector2(200,57), Vector2(196,77), Vector2(200,73), Vector2(200,71), Vector2(203,36), Vector2(211,35), Vector2(209,40), Vector2(210,39), Vector2(203,20), Vector2(209,19), Vector2(211,23), Vector2(207,25)]
const HANDS := [Vector2(143,194), Vector2(119,24), Vector2(151,210), Vector2(151,207), Vector2(151,166), Vector2(164,170), Vector2(161,171), Vector2(162,171), Vector2(151,156), Vector2(161,155), Vector2(162,160), Vector2(161,160)]
const GEAR_SPECS := {
	"mace": {"region": Rect2(627,627,627,627), "anchor": Vector2(313.5,508.212890625), "scale": 0.205},
	"axe": {"region": Rect2(0,627,627,627), "anchor": Vector2(352.6875,489.84375), "scale": 0.195},
}

var appearance: Resource
var mode: String = "idle"
var clock: float = 0.0
var attack_elapsed: float = 0.0
var current_frame: int = 0
var breath_offset: float = 0.0
var visual: Node2D
var body: Sprite2D
var cape: MeshInstance2D
var collar: Sprite2D
var helmet: Sprite2D
var grip: Node2D
var weapon: Sprite2D
var gauntlet: Sprite2D
var body_material: ShaderMaterial
var cloth_material: ShaderMaterial
var body_frames: Array[AtlasTexture] = []
var hand_frames: Array[AtlasTexture] = []
var equipment_cache: Dictionary = {}

func region(index: int) -> Rect2:
	var row: int = index / 4
	var tops := [0.0,380.0,740.0]
	var bottoms := [380.0,740.0,1086.0]
	return Rect2((index % 4) * 362.0, tops[row], 362.0, bottoms[row] - tops[row])

func tile(sheet: Texture2D, rectangle: Rect2) -> AtlasTexture:
	var texture := AtlasTexture.new()
	texture.atlas = sheet
	texture.region = rectangle
	texture.filter_clip = true
	return texture

func sprite(title: String, z: int, parent: Node = null) -> Sprite2D:
	var result := Sprite2D.new()
	result.name = title
	result.centered = false
	result.z_index = z
	(parent if parent != null else visual).add_child(result)
	return result

func _ready() -> void:
	if appearance == null:
		appearance = preload("res://appearance.gd").new()
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	visual = Node2D.new()
	visual.name = "EquippedVisual"
	# Rear equipment is behind the body, but above the room background.
	visual.z_index = 20
	add_child(visual)
	cape = MeshInstance2D.new()
	cape.name = "RearCloak"
	cape.z_index = -10
	cape.mesh = cape_mesh()
	visual.add_child(cape)
	cloth_material = ShaderMaterial.new()
	cloth_material.shader = CLOTH
	cape.material = cloth_material
	body = sprite("PaintedBody",0)
	body_material = ShaderMaterial.new()
	body_material.shader = BREATH
	body.material = body_material
	collar = sprite("NeckWrap",2)
	helmet = sprite("Helmet",3)
	grip = Node2D.new()
	grip.name = "HandSocket"
	grip.z_index = 4
	visual.add_child(grip)
	weapon = sprite("Weapon",0,grip)
	gauntlet = sprite("GrippingGauntlet",5)
	for index in range(12):
		var frame: Rect2 = region(index)
		body_frames.append(tile(BODY,frame))
		var hand_region := Rect2(frame.position + HANDS[index] - Vector2(14,13),Vector2(28,26))
		hand_frames.append(tile(BODY,hand_region))
	for id in GEAR_SPECS:
		equipment_cache[id] = tile(GEAR,GEAR_SPECS[id].region)
	equipment_cache.original = tile(COMPONENTS,Rect2(0,0,512,512))
	equipment_cache.wolf = WOLF
	appearance.appearance_changed.connect(apply_appearance)
	apply_appearance()

func cape_mesh() -> ArrayMesh:
	var vertices := PackedVector3Array()
	var uv := PackedVector2Array()
	var indices := PackedInt32Array()
	for y in range(17):
		for x in range(17):
			var n := Vector2(x/16.0,y/16.0)
			vertices.append(Vector3(n.x*1247,n.y*1261,0))
			uv.append(n)
			var i: int = y*17+x
			if x < 16 and y < 16:
				indices.append_array(PackedInt32Array([i,i+17,i+1,i+1,i+17,i+18]))
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uv
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
	return mesh

func apply_appearance() -> void:
	if body == null:
		return
	weapon.texture = equipment_cache[appearance.weapon]
	helmet.texture = equipment_cache[appearance.helmet]
	cape.texture = load("res://assets/rear_cloak" + ("_crown" if appearance.cloak == "crown" else "") + ".png")
	collar.texture = load("res://assets/collar" + ("_crown" if appearance.cloak == "crown" else "") + ".png")
	refresh()

func set_motion(value: String) -> void:
	if value not in ["idle","walk"]:
		return
	mode = value
	refresh()

func set_facing(direction: int) -> void:
	visual.scale.x = -1 if direction < 0 else 1

func attack() -> void:
	mode = "attack"
	attack_elapsed = 0.0
	refresh()

func set_time(value: float) -> void:
	clock = maxf(0,value)
	refresh()

func advance(delta: float) -> void:
	clock += maxf(0,delta)
	if mode == "attack":
		attack_elapsed += maxf(0,delta)
		if attack_elapsed >= ATTACK_SECONDS:
			mode = "idle"
	refresh()

func refresh() -> void:
	if body == null:
		return
	current_frame = 2 + int(clock/FRAME_SECONDS) % 10 if mode == "walk" else 1 if mode == "attack" else 0
	breath_offset = (1.0-cos(clock*TAU/3.6))*0.85 if mode == "idle" else 0.0
	var ground: float = GROUNDS[current_frame]
	var origin := Vector2(-190,-ground)
	var frame: Rect2 = region(current_frame)
	body.texture = body_frames[current_frame]
	body.position = origin
	body_material.set_shader_parameter("frame_uv",Vector4(frame.position.x/BODY.get_width(),frame.position.y/BODY.get_height(),frame.size.x/BODY.get_width(),frame.size.y/BODY.get_height()))
	body_material.set_shader_parameter("breath_pixels",breath_offset)
	var neck: Vector2 = origin + NECKS[current_frame] - Vector2(0,breath_offset)
	cape.scale = Vector2(0.255,0.29)
	cape.position = neck - Vector2(794,209)*cape.scale
	cloth_material.set_shader_parameter("clock",clock)
	cloth_material.set_shader_parameter("wind",0.75)
	collar.scale = Vector2.ONE*0.285
	collar.position = neck - Vector2(842,288)*collar.scale
	var head_factor: float = 0.18*512.0/helmet.texture.get_width()
	helmet.scale = Vector2.ONE*head_factor
	helmet.position = neck - Vector2(280,470)*0.18
	var hand: Vector2 = HANDS[current_frame]
	var relative: float = hand.y/frame.size.y
	var blend: float = smoothstep(0.38,0.67,relative)
	grip.position = origin + hand - Vector2(0,breath_offset*(1.0-blend))
	grip.rotation = 0.9 if mode == "attack" else 1.95
	var spec: Dictionary = GEAR_SPECS[appearance.weapon]
	weapon.scale = Vector2.ONE*float(spec.scale)
	weapon.position = -Vector2(spec.anchor)*float(spec.scale)
	gauntlet.texture = hand_frames[current_frame]
	gauntlet.position = grip.position - Vector2(14,13)
	visual.position.x = 14.0*minf(attack_elapsed/0.1,1.0)*clampf((ATTACK_SECONDS-attack_elapsed)/0.16,0,1)*visual.scale.x if mode == "attack" else 0.0

func weapon_grip_error() -> float:
	var spec: Dictionary = GEAR_SPECS[appearance.weapon]
	return weapon.to_global(Vector2(spec.anchor)).distance_to(grip.global_position)
