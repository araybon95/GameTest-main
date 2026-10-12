extends SceneTree
var failures: int = 0
func _initialize() -> void: call_deferred("run")
func check(value: bool, message: String) -> void:
	if not value: failures += 1; push_error(message)
func run() -> void:
	change_scene_to_file("res://lab.tscn")
	for i in range(3): await process_frame
	var lab = current_scene
	lab.set_process(false)
	var actor = lab.actor
	check(root.get_node_or_null("GameSettings") == null,"Lab must not load production settings")
	check(actor.parts.size() == 7,"Component set incomplete")
	check(actor.parts.cloth_patch.get_parent() == actor.parts.rear_cloak,"Patch must attach to the cloth layer")
	check(actor.parts.cloth_patch.material == actor.parts.rear_cloak.material,"Patch and cape must deform together")
	for part in actor.parts:
		check(actor.parts[part].texture != null,"Missing component texture: "+part)
		check(actor.parts[part].transform.determinant() > 0,"Invalid component fitting: "+part)
	var head_texture = actor.parts.helmet.texture
	var cape_texture = actor.parts.rear_cloak.texture
	var brooch_texture = actor.parts.insignia.texture
	lab.get_node("Choice_helmet").item_selected.emit(0)
	actor.refresh()
	check(actor.helmet == "original" and actor.parts.helmet.texture.atlas != head_texture.atlas,"Helmet swap failed")
	check(actor.parts.rear_cloak.texture == cape_texture and actor.parts.insignia.texture.region == brooch_texture.region,"Helmet swap changed another slot")
	lab.get_node("PreviewReward").button_pressed = false
	check(not lab.unlocked and actor.helmet == "original" and actor.cloak == "original" and actor.insignia == "iron","Preview lock must reset cosmetics")
	check(lab.selectors.helmet.is_item_disabled(1) and lab.selectors.insignia.is_item_disabled(2),"Locked options remain selectable")
	lab.get_node("Choice_helmet").item_selected.emit(1)
	check(actor.helmet == "original","Locked reward must be rejected")
	lab.get_node("PreviewReward").button_pressed = true
	lab.get_node("Choice_insignia").item_selected.emit(2)
	lab.get_node("Choice_cloak").item_selected.emit(0)
	actor.refresh()
	check(actor.insignia == "patch" and actor.parts.cloth_patch.visible and actor.cloak == "original","Independent patch on original cloth failed")
	lab.get_node("InspectLayer").item_selected.emit(2)
	actor.refresh()
	check(actor.inspection == "cloth_patch" and actor.parts.rear_cloak.visible and actor.parts.rear_cloak.self_modulate.a == 0 and actor.parts.cloth_patch.visible,"Patch-only inspection failed")
	check(not actor.parts.body.visible,"Inspection did not hide unrelated armor")
	lab.get_node("InspectLayer").item_selected.emit(0)
	lab.get_node("ExplodeLayers").button_pressed = true
	actor.refresh()
	var exploded_head: Vector2 = actor.parts.helmet.position
	lab.get_node("ExplodeLayers").button_pressed = false
	actor.refresh()
	check(not actor.parts.helmet.position.is_equal_approx(exploded_head),"Exploded assembly failed")
	lab.get_node("SourceOverlay").button_pressed = true
	actor.refresh()
	check(actor.ghost.visible,"Source alignment overlay failed")
	lab.get_node("HelmetX").value = 11
	lab.get_node("HelmetY").value = -4
	lab.get_node("HelmetScale").value = 0.6
	actor.refresh()
	check(actor.helmet_offset == Vector2(11,-4) and is_equal_approx(actor.helmet_scale,0.6),"Socket fitting controls failed")
	lab.get_node("AnimateModel").button_pressed = true
	lab._process(0.25)
	check(actor.clock > 0 and actor.cloth_material.get_shader_parameter("wind") == 1.0,"Cloth motion failed")
	var clock: float = actor.clock
	lab.get_node("AnimateModel").button_pressed = false
	lab._process(1)
	check(actor.clock == clock and actor.cloth_material.get_shader_parameter("wind") == 0.0,"Static inspection must stop cloth motion")
	lab.get_node("SaveDraft").pressed.emit()
	var draft: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("user://warden_cosmetic_fitting.json"))
	check(draft.prototype_only and draft.pose == "standing" and draft.insignia == "patch" and draft.helmet_socket == [805.0,205.0],"Fitting export failed")
	check(not FileAccess.file_exists("user://expedition_progress.cfg"),"Prototype created real progression data")
	if failures == 0: print("WARDEN_COSMETICS_SMOKE_OK: seven layers, independent swaps, preview locks, attached patch, inspection/explode, socket fitting, cloth motion and prototype-only export")
	quit(0 if failures == 0 else 1)
