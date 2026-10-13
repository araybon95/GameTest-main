extends Node2D
const Motion = preload("res://motion.gd")
var appearance: Resource
var mode: String = "walk"
var clock: float = 0.0
var walk_blend: float = 1.0
var paused: bool = false
var reverse: bool = false
var show_joints: bool = false
var contact_error: float = 0.0
var weapon_id: String = ""
var visual: Node2D
var torso: Node2D
var head: Sprite2D
var collar: Sprite2D
var clasp: Sprite2D
var cape: MeshInstance2D
var weapon: Sprite2D
var shield: Sprite2D
var joints: Dictionary = {}
var data: Dictionary
var atlas_cache: Dictionary = {}
var cloth: ShaderMaterial
var joint_overlay: Node2D
func _ready() -> void:
	walk_blend = 1.0 if mode == "walk" else 0.0
	data = JSON.parse_string(FileAccess.get_file_as_string("res://assets/attachments.json"))
	visual = joint(self,"Visual",Vector2.ZERO)
	# Keep every negative-offset body layer above the stage background.
	visual.z_index = 50
	for side in ["far","near"]:
		var thigh := joint(visual,side+"_thigh",Vector2.ZERO)
		var shin := joint(thigh,side+"_shin",Vector2(0,100))
		var sole := joint(shin,side+"_sole",Vector2(0,112))
		thigh.z_index = -20 if side == "far" else -10
		joints[side+"_thigh"] = thigh
		joints[side+"_shin"] = shin
		joints[side+"_sole"] = sole
		attach(thigh,side+"_thigh",100)
		attach(shin,side+"_shin",112)
	torso = joint(visual,"Torso",Vector2(0,-204))
	build_cloth()
	for side in ["far","near"]:
		var arm := joint(torso,side+"_arm",point(data.sockets[side+"_shoulder"]))
		var forearm := joint(arm,side+"_forearm",Vector2(0,65))
		var hand := joint(forearm,side+"_hand",Vector2(0,70))
		arm.z_index = -4 if side == "far" else 4
		joints[side+"_arm"] = arm
		joints[side+"_forearm"] = forearm
		joints[side+"_hand"] = hand
		attach(arm,side+"_arm",65)
		attach(forearm,side+"_forearm",70)
	attach(torso,"torso")
	var waist := attach(torso,"waist")
	waist.z_index = 2
	shield = attach(joints.far_hand,"shield")
	shield.z_index = 8
	weapon = Sprite2D.new()
	weapon.name = "WeaponAttachment"
	weapon.centered = false
	weapon.z_index = -1
	joints.near_hand.add_child(weapon)
	head = Sprite2D.new()
	head.name = "HelmetAttachment"
	head.centered = false
	head.z_index = 7
	torso.add_child(head)
	collar = Sprite2D.new()
	collar.name = "NeckWrap"
	collar.centered = false
	collar.z_index = 6
	torso.add_child(collar)
	clasp = Sprite2D.new()
	clasp.centered = false
	clasp.z_index = 8
	torso.add_child(clasp)
	joint_overlay = Node2D.new()
	joint_overlay.name = "JointOverlay"
	joint_overlay.z_index = 300
	add_child(joint_overlay)
	joint_overlay.draw.connect(draw_joint_overlay)
	appearance.appearance_changed.connect(apply_appearance)
	apply_appearance()
	refresh()
func joint(parent: Node, title: String, origin: Vector2) -> Node2D:
	var result := Node2D.new()
	result.name = title
	result.position = origin
	parent.add_child(result)
	return result
func point(values: Array) -> Vector2: return Vector2(values[0],values[1])
func tile(part: String) -> AtlasTexture:
	if atlas_cache.has(part): return atlas_cache[part]
	var spec: Dictionary = data.parts[part]
	var texture := AtlasTexture.new()
	texture.atlas = load("res://assets/"+spec.sheet)
	var grid := point(spec.grid)
	var cell: Vector2 = texture.atlas.get_size()/grid
	texture.region = Rect2(Vector2(int(spec.cell)%int(grid.x),int(int(spec.cell)/int(grid.x)))*cell,cell)
	texture.filter_clip = true
	atlas_cache[part] = texture
	return texture
func fit(sprite: Sprite2D, part: String, length: float = 0) -> void:
	var spec: Dictionary = data.parts[part]
	sprite.texture = tile(part)
	var anchor := point(spec.anchor)
	var factor: float = spec.get("scale",0.3)
	var turn: float = 0.0
	if length > 0:
		var axis: Vector2 = point(spec.end)-anchor
		factor = length/axis.length()
		turn = PI/2.0-axis.angle()
	sprite.scale = Vector2.ONE*factor*512.0/sprite.texture.get_width()
	sprite.rotation = turn
	sprite.position = (-anchor*factor).rotated(turn)
func attach(parent: Node, part: String, length: float = 0) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = part.capitalize().replace(" ","")+"Art"
	sprite.centered = false
	parent.add_child(sprite)
	fit(sprite,part,length)
	return sprite
func turn_attachment(sprite: Sprite2D, part: String, angle: float) -> void:
	var spec: Dictionary = data.parts[part]
	sprite.rotation = angle
	sprite.position = (-point(spec.anchor)*float(spec.scale)).rotated(angle)
func registered(part: String) -> Transform2D:
	var alignment: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/alignment.json"))
	var m: Array = alignment.layers[part].matrix
	return Transform2D(Vector2(m[0][0],m[1][0])*0.34,Vector2(m[0][1],m[1][1])*0.34,(Vector2(m[0][2],m[1][2])-Vector2(794,570))*0.34)
func build_cloth() -> void:
	cape = MeshInstance2D.new()
	cape.name = "CapeAttachment"
	cape.z_index = -30
	cape.transform = registered("rear_cloak")
	cloth = ShaderMaterial.new()
	cloth.shader = preload("res://cloth.gdshader")
	cape.material = cloth
	var vertices := PackedVector3Array()
	var uv := PackedVector2Array()
	var indices := PackedInt32Array()
	for y in range(25):
		for x in range(25):
			var n := Vector2(x/24.0,y/24.0)
			vertices.append(Vector3(n.x*1247,n.y*1261,0))
			uv.append(n)
			var i: int = y*25+x
			if x < 24 and y < 24: indices.append_array(PackedInt32Array([i,i+25,i+1,i+1,i+25,i+26]))
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uv
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
	cape.mesh = mesh
	torso.add_child(cape)
func apply_appearance() -> void:
	weapon_id = appearance.weapon
	fit(weapon,weapon_id)
	var texture := AtlasTexture.new()
	if appearance.helmet == "wolf":
		texture.atlas = preload("res://assets/corrupted_warhelm.png")
		texture.region = Rect2(Vector2.ZERO,texture.atlas.get_size())
	else:
		texture.atlas = preload("res://assets/components.png")
		texture.region = Rect2(0,0,512,512)
	texture.filter_clip = true
	head.texture = texture
	head.scale = Vector2.ONE*0.24*512.0/texture.get_width()
	head.position = point(data.sockets.neck)-Vector2(280,470)*0.24
	cape.texture = load("res://assets/rear_cloak"+("_crown" if appearance.cloak == "crown" else "")+".png")
	collar.texture = load("res://assets/collar"+("_crown" if appearance.cloak == "crown" else "")+".png")
	collar.transform = registered("collar")
	var badge := AtlasTexture.new()
	badge.atlas = preload("res://assets/components.png")
	badge.region = Rect2(0,512,512,512) if appearance.cloak == "crown" else Rect2(1024,0,512,512)
	badge.filter_clip = true
	clasp.texture = badge
	clasp.scale = Vector2.ONE*0.075
	clasp.position = point(data.sockets.brooch)-Vector2(256,256)*0.075
	refresh()
func advance(delta: float) -> void:
	if not paused:
		clock += maxf(delta,0)
		walk_blend = lerpf(walk_blend,1.0 if mode == "walk" else 0.0,1.0-exp(-8.0*maxf(delta,0)))
	refresh()
func set_time(seconds: float) -> void:
	clock = maxf(seconds,0)
	walk_blend = 1.0 if mode == "walk" else 0.0
	refresh()
func limb(side: String, target: Vector2, hip: Vector2) -> void:
	var thigh: Node2D = joints[side+"_thigh"]
	var shin: Node2D = joints[side+"_shin"]
	thigh.position = hip
	var angles := Motion.solve(hip,target,100,112)
	thigh.rotation = angles.x
	shin.rotation = angles.y
	var endpoint := hip+Vector2.DOWN.rotated(angles.x)*100+Vector2.DOWN.rotated(angles.x+angles.y)*112
	contact_error = maxf(contact_error,endpoint.distance_to(target))
func arm(side: String, target: Vector2) -> void:
	var upper: Node2D = joints[side+"_arm"]
	var lower: Node2D = joints[side+"_forearm"]
	var angles := Motion.solve(upper.position,target,65,70,1 if side == "near" else -1)
	upper.rotation = angles.x
	lower.rotation = angles.y
func refresh() -> void:
	if visual == null: return
	visual.scale.x = -1 if reverse else 1
	var phase: float = clock/Motion.PERIOD*TAU
	var bob: float = lerpf(sin(clock*1.5)*0.45,cos(phase*2)*0.8,walk_blend)
	torso.position = Vector2(sin(phase)*0.6*walk_blend,-204+bob)
	torso.rotation = sin(phase)*0.009*walk_blend
	contact_error = 0
	limb("near",Vector2(-18,0)+Vector2(-8,0).lerp(Motion.foot(clock,0),walk_blend),Vector2(-16,-204+bob))
	limb("far",Vector2(20,0)+Vector2(10,0).lerp(Motion.foot(clock,0.5),walk_blend),Vector2(18,-204+bob))
	var hand := Vector2(-70,-20)
	var angle: float = 2.55
	if mode != "combat":
		hand += Vector2(sin(phase)*3,cos(phase)*2)*walk_blend
		angle += sin(phase-0.4)*0.035*walk_blend
	else:
		var cycle: float = fposmod(clock,3.0)
		var windup: float = smoothstep(0.3,1.05,cycle)
		var strike: float = smoothstep(1.05,1.4,cycle)
		var recover: float = smoothstep(1.55,2.5,cycle)
		hand = hand.lerp(Vector2(-75,-115),windup).lerp(Vector2(78,-64),strike).lerp(Vector2(-70,-20),recover)
		angle = lerpf(lerpf(lerpf(2.55,-0.65,windup),2.0,strike),2.55,recover)
		torso.rotation = lerpf(lerpf(-0.06*windup,0.075,strike),0,recover)
	arm("near",hand)
	arm("far",Vector2(66,-40)+Vector2(sin(phase+0.7)*1.5,0)*walk_blend)
	turn_attachment(weapon,weapon_id,angle-joints.near_arm.rotation-joints.near_forearm.rotation)
	turn_attachment(shield,"shield",-joints.far_arm.rotation-joints.far_forearm.rotation+sin(clock*1.8)*0.012)
	head.rotation = -torso.rotation*0.7
	head.position = point(data.sockets.neck)-(Vector2(280,470)*0.24).rotated(head.rotation)
	cloth.set_shader_parameter("clock",clock)
	cloth.set_shader_parameter("wind",lerpf(0.35,0.8,walk_blend))
	joint_overlay.queue_redraw()
func draw_joint_overlay() -> void:
	if not show_joints or visual == null: return
	var cyan := Color(0.25,0.88,0.88,0.8)
	for side in ["near","far"]:
		for chain in [["_thigh","_shin","_sole"],["_arm","_forearm","_hand"]]:
			for i in range(3):
				var p: Vector2 = joint_overlay.to_local(joints[side+chain[i]].global_position)
				joint_overlay.draw_circle(p,3.0,cyan)
				if i < 2: joint_overlay.draw_line(p,joint_overlay.to_local(joints[side+chain[i+1]].global_position),cyan,1.5)
