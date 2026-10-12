extends Node2D
const Catalog = preload("res://actor_catalog.gd")
const COLUMNS: int = 24
const ROWS: int = 36
var hero: String = "warden"
var style: String = "animated"
var height: float = 350.0
var size := Vector2.ZERO
var clock: float = 0.0
var gait: float = 0.0
var walking: float = 0.0
var requested_walking: bool = true
var frozen: bool = false
var reverse: bool = false
var cadence: float = 2.6
var stride_length: float = 12.0
var foot_lift: float = 5.0
var cloth_sway: float = 2.0
var body_bob: float = 0.8
var show_grid: bool = false
var pose: int = -1
var sprite: MeshInstance2D
var grid: MeshInstance2D
var surface: ShaderMaterial
var wire: ShaderMaterial
var mesh_cache: Dictionary = {}
func _ready() -> void:
	sprite = MeshInstance2D.new()
	grid = MeshInstance2D.new()
	add_child(sprite)
	add_child(grid)
	surface = ShaderMaterial.new()
	surface.shader = preload("res://stride.gdshader")
	wire = ShaderMaterial.new()
	wire.shader = preload("res://grid.gdshader")
	sprite.material = surface
	grid.material = wire
	select_hero(hero)
func select_hero(id: String) -> void:
	hero = id
	pose = -1
	select_pose(1)
	update_materials()
func select_pose(index: int) -> void:
	if pose == index: return
	pose = index
	var atlas: Texture2D = load("res://assets/characters/hero_"+hero+"_walk.png")
	var region: Rect2 = Catalog.REGIONS[hero][index]
	size = Vector2(height*region.size.x/region.size.y,height)
	var key: String = hero+":"+str(index)
	if not mesh_cache.has(key): mesh_cache[key] = build_meshes(region,atlas.get_size())
	sprite.texture = atlas
	sprite.mesh = mesh_cache[key][0]
	grid.mesh = mesh_cache[key][1]
	update_materials()
func build_meshes(region: Rect2, atlas_size: Vector2) -> Array[ArrayMesh]:
	var vertices := PackedVector3Array()
	var uvs := PackedVector2Array()
	var triangles := PackedInt32Array()
	var lines := PackedInt32Array()
	for row in range(ROWS+1):
		for col in range(COLUMNS+1):
			var n := Vector2(float(col)/COLUMNS,float(row)/ROWS)
			vertices.append(Vector3(n.x*size.x,n.y*size.y,0))
			uvs.append((region.position+Vector2(0.5,0.5)+n*(region.size-Vector2.ONE))/atlas_size)
			var i: int = row*(COLUMNS+1)+col
			if col < COLUMNS: lines.append_array(PackedInt32Array([i,i+1]))
			if row < ROWS: lines.append_array(PackedInt32Array([i,i+COLUMNS+1]))
			if row < ROWS and col < COLUMNS:
				triangles.append_array(PackedInt32Array([i,i+COLUMNS+1,i+1,i+1,i+COLUMNS+1,i+COLUMNS+2]))
	var data: Array = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_TEX_UV] = uvs
	data[Mesh.ARRAY_INDEX] = triangles
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	data[Mesh.ARRAY_INDEX] = lines
	var wire_mesh := ArrayMesh.new()
	wire_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES,data)
	return [mesh,wire_mesh]
func advance(delta: float) -> void:
	if not frozen:
		clock += maxf(delta,0)
		if requested_walking: gait += maxf(delta,0)*cadence*PI
		walking = lerpf(walking,1.0 if requested_walking else 0.0,1.0-exp(-8.0*maxf(delta,0)))
	var index: int = int(gait*2.0/PI)%4 if style == "classic" and requested_walking else 1
	select_pose(index)
	update_materials()
func update_materials() -> void:
	if surface == null: return
	for material in [surface,wire]:
		material.set_shader_parameter("actor_size",size)
		material.set_shader_parameter("leg_profile",Catalog.LEGS[hero])
		material.set_shader_parameter("clock",clock if style != "classic" else 0.0)
		material.set_shader_parameter("gait",gait)
		material.set_shader_parameter("phase",Catalog.PHASES[hero] if style != "classic" else 0.0)
		material.set_shader_parameter("walking",walking if style != "classic" else 0.0)
		material.set_shader_parameter("animated",1.0 if style == "animated" else 0.0)
		for setting in ["stride_length","foot_lift","cloth_sway","body_bob"]: material.set_shader_parameter(setting,get(setting))
	for layer in [sprite,grid]:
		layer.position = Vector2(size.x*0.5 if reverse else -size.x*0.5,-height)
		layer.scale = Vector2(-1,1) if reverse else Vector2.ONE
	grid.visible = show_grid
