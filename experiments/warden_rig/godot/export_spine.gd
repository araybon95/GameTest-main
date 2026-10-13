extends SceneTree
## Export existing pixels and a basic-bone Spine setup. No game state is loaded.
const Rig = preload("res://rig.gd")
const Appearance = preload("res://appearance.gd")
var destination: String
var actor: Node2D
var bones: Array = []
var slots: Array = []
var world: Dictionary = {}
var attachments: Dictionary = {}
var images: Array = []
var geometry: Dictionary = {"bones":{},"attachments":{}}
var failed := false
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1:
		push_error("Usage: --script res://export_spine.gd -- <handoff-directory>")
		quit(2)
		return
	destination = args[0]
	DirAccess.make_dir_recursive_absolute(destination+"/images")
	actor = Rig.new()
	actor.appearance = Appearance.new()
	actor.appearance.helmet = "original"
	actor.mode = "guard"
	root.add_child(actor)
	actor.set_time(0)
	bone("root","",Transform2D.IDENTITY)
	bone("pelvis","root",Transform2D(0,actor.torso.global_position))
	bone("torso","pelvis",actor.torso.global_transform)
	for side in ["far","near"]:
		bone(side+"_thigh","pelvis",axis(actor.joints[side+"_thigh"]),actor.data.lengths.thigh)
		bone(side+"_shin",side+"_thigh",axis(actor.joints[side+"_shin"]),actor.data.lengths.shin)
		bone(side+"_ankle",side+"_shin",actor.joints[side+"_ankle"].global_transform)
		bone(side+"_upper_arm","torso",axis(actor.joints[side+"_arm"]),actor.arm_lengths[side].x)
		bone(side+"_forearm",side+"_upper_arm",axis(actor.joints[side+"_forearm"]),actor.arm_lengths[side].y)
		bone(side+"_hand",side+"_forearm",axis(actor.joints[side+"_hand"]),12)
	var neck: Vector2 = actor.torso.to_global(actor.point(actor.data.sockets.neck))
	bone("head","torso",Transform2D(actor.head.global_rotation,neck))
	# Affine scarf/cape registration lives on bones; regions remain unmodified PNGs.
	for item in [["cape",actor.cape],["scarf",actor.collar]]:
		var transform: Transform2D = item[1].global_transform
		transform.origin = neck
		bone(item[0],"torso",transform)
	bone("weapon","near_hand",Transform2D(actor.weapon.global_rotation,actor.joints.near_hand.global_position),110)
	bone("shield","far_hand",Transform2D(actor.shield.global_rotation,actor.joints.far_hand.global_position),70)
	# Back-to-front order follows the native guard, with gripping hands over the blade.
	slot("cape","cape","ash_grey")
	for side in ["far","near"]:
		for part in ["thigh","shin","boot"]:
			slot(side+"_"+part,side+"_"+("ankle" if part == "boot" else part),side+"_"+part)
		if side == "far": slot("far_upper_arm","far_upper_arm","far_upper_arm")
	slot("torso","torso","torso")
	slot("waist","torso","waist")
	slot("near_upper_arm","near_upper_arm","near_upper_arm")
	slot("scarf","scarf","ash_grey")
	slot("helmet","head","greathelm")
	slot("clasp","torso","gold")
	slot("far_forearm","far_forearm","far_forearm")
	slot("weapon","weapon","sword")
	slot("near_forearm","near_forearm","near_forearm")
	slot("shield","shield",null)
	for side in ["far","near"]:
		for part in ["thigh","shin","boot"]:
			part_image(side+"_"+part,side+"_"+part,find_art(actor.joints[side+"_"+("ankle" if part == "boot" else part)],side+"_"+part))
		part_image(side+"_upper_arm",side+"_arm",actor.segment_art[side+"_arm"])
		part_image(side+"_forearm",side+"_forearm",actor.segment_art[side+"_forearm"])
	for part in ["torso","waist"]: part_image(part,part,find_art(actor.torso,part))
	part_image("shield","shield",actor.shield)
	for id in ["sword","axe","mace"]:
		var spec: Dictionary = actor.data.parts[id]
		var sprite := Sprite2D.new()
		root.add_child(sprite)
		sprite.texture = actor.tile(id)
		sprite.global_transform = Transform2D(actor.weapon.global_rotation,actor.joints.near_hand.global_position)
		sprite.scale *= float(spec.scale)
		sprite.position -= actor.point(spec.anchor).rotated(sprite.rotation)*float(spec.scale)
		image_attachment("weapon",id,"gear/"+id,sprite.global_transform,actor.tile(id).get_image(),spec.sheet,spec.region)
		sprite.queue_free()
	for id in ["original","wolf"]:
		actor.appearance.set_slot("helmet",id)
		var name_value := "greathelm" if id == "original" else "wolf_warhelm"
		var sheet := "components.png" if id == "original" else "corrupted_warhelm.png"
		var size_value: Vector2 = actor.head.texture.get_size()
		image_attachment("helmet",name_value,"cosmetics/"+name_value,actor.head.global_transform,actor.head.texture.get_image(),sheet,[0,0,size_value.x,size_value.y])
	for id in ["original","crown"]:
		actor.appearance.set_slot("cloak",id)
		var name_value := "oxblood" if id == "original" else "ash_grey"
		var suffix := "" if id == "original" else "_crown"
		for item in [["cape",actor.cape,"rear_cloak"],["scarf",actor.collar,"collar"]]:
			var source: String = item[2]+suffix+".png"
			var texture: Texture2D = item[1].texture
			var size_value := texture.get_size()
			image_attachment(item[0],name_value,"cosmetics/"+item[0]+"_"+name_value,item[1].global_transform,texture.get_image(),source,[0,0,size_value.x,size_value.y])
		var clasp_name := "iron" if id == "original" else "gold"
		var region := [1024,0,512,512] if id == "original" else [0,512,512,512]
		image_attachment("clasp",clasp_name,"cosmetics/clasp_"+clasp_name,actor.clasp.global_transform,actor.clasp.texture.get_image(),"components.png",region)
	var idle := {"bones":{
		"torso":{"translate":[{"time":0,"x":0,"y":0},{"time":1.2,"x":0,"y":0.8},{"time":2.4,"x":0,"y":0}]},
		"head":{"rotate":[{"time":0,"value":0},{"time":1.2,"value":-0.4},{"time":2.4,"value":0}]},
		"cape":{"rotate":[{"time":0,"value":0},{"time":1.2,"value":0.5},{"time":2.4,"value":0}]}
	}}
	write_json("warden-import.json",{"skeleton":{"spine":"4.3.00","images":"./images/","fps":30,"x":-160,"y":0,"width":320,"height":360},"bones":bones,"slots":slots,"skins":[{"name":"default","attachments":attachments}],"animations":{"idle_blockout":idle}})
	write_json("attachments.json",{"schema":1,"prototype_only":true,"art_status":"existing replaceable blockout; not an accepted reference match","images":images})
	write_json("setup-geometry.json",geometry)
	write_json("equipment.json",{"schema":1,"prototype_only":true,"slots":{
		"weapon":{"sword":{"weapon":"sword"},"axe":{"weapon":"axe"},"mace":{"weapon":"mace"}},
		"helmet":{"original":{"helmet":"greathelm"},"wolf":{"helmet":"wolf_warhelm"}},
		"cloak":{"original":{"cape":"oxblood","scarf":"oxblood","clasp":"iron"},"crown":{"cape":"ash_grey","scarf":"ash_grey","clasp":"gold"}},
		"offhand":{"none":{"shield":null},"shield":{"shield":"shield"}}
	},"pose_note":"Attachment swaps do not reposition arms. Author matching sword/free, one-hand, and shield pose families in Spine."})
	if failed: quit(1)
	else:
		print("SPINE_HANDOFF_EXPORTED: ",images.size()," original PNG layers; ",bones.size()," basic bones")
		quit()
func axis(node: Node2D) -> Transform2D:
	return Transform2D(node.global_rotation+PI/2.0,node.global_position)
func bone(name_value: String, parent_name: String, transform: Transform2D, length_value: float = 0) -> void:
	world[name_value] = transform
	var local := transform
	if not parent_name.is_empty(): local = world[parent_name].affine_inverse()*transform
	var angle_x: float = local.x.angle()
	var angle_y: float = local.y.angle()
	var item := {"name":name_value,"x":local.origin.x,"y":-local.origin.y,"rotation":-rad_to_deg(angle_x),"scaleX":local.x.length(),"scaleY":local.y.length(),"shearY":-rad_to_deg(wrapf(angle_y-angle_x-PI/2.0,-PI,PI))}
	if not parent_name.is_empty(): item.parent = parent_name
	if length_value > 0: item.length = length_value
	bones.append(item)
	geometry.bones[name_value] = [transform.origin.x,-transform.origin.y]
func slot(name_value: String, bone_name: String, selected) -> void:
	var item := {"name":name_value,"bone":bone_name}
	if selected != null: item.attachment = selected
	slots.append(item)
	attachments[name_value] = {}
func find_art(parent: Node, part: String) -> Sprite2D:
	return parent.get_node(part.capitalize().replace(" ","")+"Art")
func part_image(slot_name: String, part: String, sprite: Sprite2D) -> void:
	var spec: Dictionary = actor.data.parts[part]
	var name_value: String = slot_name if part.ends_with("_arm") else part
	image_attachment(slot_name,name_value,("gear/" if part == "shield" else "body/")+name_value,sprite.global_transform,sprite.texture.get_image(),spec.sheet,spec.region)
func image_attachment(slot_name: String, name_value: String, path_value: String, transform: Transform2D, source: Image, source_file: String, source_region: Array) -> void:
	# Bypass Godot texture import, which fixes RGB at alpha borders.
	var raw := Image.load_from_file(ProjectSettings.globalize_path("res://assets/"+source_file))
	source = raw.get_region(Rect2i(int(source_region[0]),int(source_region[1]),int(source_region[2]),int(source_region[3])))
	var bone_name: String
	for item in slots:
		if item.name == slot_name: bone_name = item.bone; break
	var local: Transform2D = world[bone_name].affine_inverse()*transform
	var size_value := Vector2(source.get_width(),source.get_height())
	var center := local*(size_value*0.5)
	attachments[slot_name][name_value] = {"type":"region","path":path_value,"x":center.x,"y":-center.y,"rotation":-rad_to_deg(local.x.angle()),"scaleX":local.x.length(),"scaleY":local.y.length(),"width":size_value.x,"height":size_value.y}
	var points: Array = []
	for corner in [Vector2.ZERO,Vector2(size_value.x,0),size_value,Vector2(0,size_value.y)]:
		var point_value: Vector2 = transform*corner
		points.append([point_value.x,-point_value.y])
	geometry.attachments[slot_name+"/"+name_value] = points
	var filename := destination+"/images/"+path_value+".png"
	DirAccess.make_dir_recursive_absolute(filename.get_base_dir())
	source.convert(Image.FORMAT_RGBA8)
	if source.save_png(filename) != OK:
		push_error("Failed to save attachment: "+filename)
		failed = true
	var pivot: Vector2 = transform.affine_inverse()*world[bone_name].origin
	images.append({"path":path_value,"width":size_value.x,"height":size_value.y,"pivot_pixels":[pivot.x,pivot.y],"source_file":source_file,"source_region":source_region,"source_sha256":FileAccess.get_sha256("res://assets/"+source_file),"sha256":FileAccess.get_sha256(filename)})
func write_json(filename: String, data: Dictionary) -> void:
	var file := FileAccess.open(destination+"/"+filename,FileAccess.WRITE)
	if file == null:
		push_error("Could not write "+filename)
		failed = true
	else: file.store_string(JSON.stringify(data,"\t",false)+"\n")
