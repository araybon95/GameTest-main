extends Node2D
## Full-canvas layers share one reference frame; head/badge have socket anchors.
const CANVAS = Vector2(1247,1261)
const ORDER = ["rear_cloak","cloth_patch","body","arms_gear","collar","helmet","insignia"]
const HEAD_SOCKET = Vector2(794,209)
const CLASP_SOCKET = Vector2(736,248)
const HEAD_JOINT = Vector2(280,470)
const EXPLODE = {"rear_cloak":Vector2(-145,0),"cloth_patch":Vector2(160,70),"body":Vector2.ZERO,"arms_gear":Vector2(160,25),"collar":Vector2(-25,-130),"helmet":Vector2(0,-165),"insignia":Vector2(180,-65)}
var parts: Dictionary = {}
var cloth_material: ShaderMaterial
var ghost: Sprite2D
var helmet: String = "crown"
var cloak: String = "crown"
var insignia: String = "crown"
var inspection: String = "all"
var exploded: bool = false
var source_overlay: bool = false
var animate: bool = false
var clock: float = 0
var helmet_offset := Vector2.ZERO
var helmet_scale: float = 0.55
var cloth_texture: Texture2D
var cloth_variant: String = ""
var base_transforms: Dictionary = {}
var tiles: Dictionary = {}
func _ready() -> void:
	var alignment: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/alignment.json"))
	for part in alignment.layers:
		var m: Array = alignment.layers[part].matrix
		base_transforms[part] = Transform2D(Vector2(m[0][0],m[1][0]),Vector2(m[0][1],m[1][1]),Vector2(m[0][2],m[1][2]))
	for part in ORDER:
		if part == "cloth_patch": continue
		var layer: Node2D
		if part == "rear_cloak":
			var mesh := MeshInstance2D.new()
			mesh.mesh = cloth_mesh()
			cloth_material = ShaderMaterial.new()
			cloth_material.shader = preload("res://cloth.gdshader")
			mesh.material = cloth_material
			layer = mesh
		else:
			var sprite := Sprite2D.new()
			sprite.centered = false
			layer = sprite
		layer.name = part.capitalize().replace(" ","")
		parts[part] = layer
		add_child(layer)
	var patch := MeshInstance2D.new()
	patch.name = "EmbroideredPatch"
	patch.mesh = patch_mesh()
	patch.texture = preload("res://assets/components.png")
	patch.material = cloth_material
	parts.rear_cloak.add_child(patch)
	parts.cloth_patch = patch
	for part in ["body","arms_gear","collar"]:
		var sprite: Sprite2D = parts[part]
		sprite.texture = load("res://assets/"+part+".png")
		sprite.transform = base_transforms[part]
	ghost = Sprite2D.new()
	ghost.name = "SourceOverlay"
	ghost.texture = preload("res://assets/original.png")
	ghost.centered = false
	ghost.modulate.a = 0.23
	add_child(ghost)
	refresh()
func tile(index: int) -> AtlasTexture:
	if tiles.has(index): return tiles[index]
	var texture := AtlasTexture.new()
	texture.atlas = preload("res://assets/components.png")
	var cell := texture.atlas.get_size()/Vector2(3,2)
	texture.region = Rect2(Vector2(index%3,int(index/3))*cell,cell)
	if index == 1:
		texture.atlas = preload("res://assets/corrupted_warhelm.png")
		texture.region = Rect2(Vector2.ZERO,texture.atlas.get_size())
	texture.filter_clip = true
	tiles[index] = texture
	return texture
func refresh() -> void:
	if parts.is_empty(): return
	if cloth_variant != cloak:
		cloth_texture = load("res://assets/rear_cloak"+("_crown" if cloak == "crown" else "")+".png")
		parts.rear_cloak.texture = cloth_texture
		cloth_variant = cloak
	var head: Sprite2D = parts.helmet
	head.texture = tile(1 if helmet == "crown" else 0)
	# Normalize each helmet to 512 px; its neck joint is (280,470).
	head.scale = Vector2.ONE*helmet_scale*512.0/head.texture.get_width()
	head.position = HEAD_SOCKET+helmet_offset-HEAD_JOINT*helmet_scale
	var clasp: Sprite2D = parts.insignia
	clasp.texture = tile(3 if insignia == "crown" else 2)
	clasp.scale = Vector2.ONE*0.17*512.0/clasp.texture.get_width()
	clasp.position = CLASP_SOCKET-Vector2(256,256)*0.17
	for part in ORDER:
		var layer: Node2D = parts[part]
		if part not in ["helmet","insignia"]: layer.transform = base_transforms.get(part,Transform2D.IDENTITY)
		if exploded: layer.position += EXPLODE[part]
		layer.visible = inspection == "all" or inspection == part
	parts.rear_cloak.visible = inspection in ["all","rear_cloak","cloth_patch"]
	parts.rear_cloak.self_modulate.a = 0.0 if inspection == "cloth_patch" else 1.0
	parts.cloth_patch.visible = (insignia == "patch" and inspection in ["all","rear_cloak"]) or inspection == "cloth_patch"
	ghost.visible = source_overlay
	cloth_material.set_shader_parameter("clock",clock)
	cloth_material.set_shader_parameter("wind",1.0 if animate else 0.0)
func advance(delta: float) -> void:
	if animate: clock += maxf(0,delta)
	refresh()
func cloth_mesh() -> ArrayMesh:
	var vertices := PackedVector3Array()
	var uv := PackedVector2Array()
	var indices := PackedInt32Array()
	const COLS: int = 24
	const ROWS: int = 24
	for y in range(ROWS+1):
		for x in range(COLS+1):
			var n := Vector2(float(x)/COLS,float(y)/ROWS)
			vertices.append(Vector3(n.x*CANVAS.x,n.y*CANVAS.y,0))
			uv.append(n)
			var i: int = y*(COLS+1)+x
			if x < COLS and y < ROWS: indices.append_array(PackedInt32Array([i,i+COLS+1,i+1,i+1,i+COLS+1,i+COLS+2]))
	var data: Array = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_TEX_UV] = uv
	data[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	return mesh
func patch_mesh() -> ArrayMesh:
	# The patch uses the cape's source-space coordinates and the SAME deformation
	# material/parent transform, so embroidery follows fabric instead of sliding.
	var vertices := PackedVector3Array()
	var uv := PackedVector2Array()
	var indices := PackedInt32Array()
	var sheet: Texture2D = preload("res://assets/components.png")
	var region := Rect2(Vector2(sheet.get_width()/3.0,sheet.get_height()/2.0),sheet.get_size()/Vector2(3,2))
	for y in range(9):
		for x in range(9):
			var n := Vector2(float(x)/8,float(y)/8)
			var point := Vector2(344,590)+n*Vector2(210,210)
			vertices.append(Vector3(point.x,point.y,0))
			uv.append((region.position+Vector2(0.5,0.5)+n*(region.size-Vector2.ONE))/sheet.get_size())
			var i: int = y*9+x
			if x < 8 and y < 8: indices.append_array(PackedInt32Array([i,i+9,i+1,i+1,i+9,i+10]))
	var data: Array = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_TEX_UV] = uv
	data[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	return mesh
