extends SceneTree
## Behavior checks for the isolated lab, without main-game state or saves.
var failures: int = 0
func _initialize() -> void: call_deferred("run")
func check(value: bool, message: String) -> void:
	if not value:
		failures += 1
		push_error(message)
func run() -> void:
	change_scene_to_file("res://lab.tscn")
	for i in range(3): await process_frame
	var lab = current_scene
	lab.set_process(false)
	var actor = lab.actor
	for hero in actor.Catalog.REGIONS:
		actor.select_hero(hero)
		for index in range(4):
			actor.select_pose(index)
			var data: Array = actor.sprite.mesh.surface_get_arrays(0)
			check(data[Mesh.ARRAY_VERTEX].size() == 925,"Dense mesh missing: "+hero)
			check(data[Mesh.ARRAY_INDEX].size() == 5184,"Triangle topology wrong: "+hero)
			var region: Rect2 = actor.Catalog.REGIONS[hero][index]
			var atlas_size: Vector2 = actor.sprite.texture.get_size()
			for uv in data[Mesh.ARRAY_TEX_UV]:
				check(region.has_point(uv*atlas_size),"Atlas sampling escapes measured frame: "+hero)
	actor.style = "animated"
	actor.clock = 0
	actor.gait = 0
	actor.walking = 0
	for i in range(60): actor.advance(1.0/60.0)
	var fine := Vector3(actor.clock,actor.gait,actor.walking)
	actor.clock = 0
	actor.gait = 0
	actor.walking = 0
	for i in range(30): actor.advance(1.0/30.0)
	check(fine.is_equal_approx(Vector3(actor.clock,actor.gait,actor.walking)),"Motion depends on refresh rate")
	check(actor.pose == 1,"Animated mode must preserve one consistent source pose")
	actor.frozen = true
	var held := Vector3(actor.clock,actor.gait,actor.walking)
	actor.advance(0.5)
	check(held.is_equal_approx(Vector3(actor.clock,actor.gait,actor.walking)),"Freeze changed animation")
	actor.frozen = false
	actor.requested_walking = false
	for i in range(120): actor.advance(1.0/60.0)
	check(actor.walking < 0.00001 and is_equal_approx(actor.gait,held.y),"Idle transition must settle and stop the gait")
	lab.get_node("ModeSelection").item_selected.emit(1)
	actor.advance(0)
	check(actor.style == "subtle" and actor.pose == 1,"Subtle selection failed")
	check(actor.surface.get_shader_parameter("animated") == 0.0,"Subtle reference has stride deformation")
	lab.get_node("ModeSelection").item_selected.emit(2)
	actor.requested_walking = true
	for i in range(4):
		actor.gait = i*PI/2.0+0.01
		actor.advance(0)
		check(actor.pose == i,"Original-frame comparison lost a frame")
	lab.get_node("HeroSelection").item_selected.emit(0)
	check(actor.hero == "warden","Hero control failed")
	lab.get_node("Adjust_stride_length").value = 18.0
	check(actor.stride_length == 18.0,"Stride control failed")
	lab.get_node("FaceLeft").button_pressed = true
	lab.get_node("ShowMesh").button_pressed = true
	lab.get_node("FreezeAnimation").button_pressed = true
	actor.advance(0)
	check(actor.reverse and actor.sprite.scale.x == -1 and actor.grid.visible and actor.frozen,"Preview controls failed")
	if failures == 0: print("ANIMATION_LAB_SMOKE_OK: five heroes, 20 frame meshes, refresh-rate independence, idle/freeze, comparison modes, UI controls")
	quit(0 if failures == 0 else 1)
