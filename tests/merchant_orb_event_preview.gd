extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func move_pointer(position: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = position
	motion.global_position = position
	root.push_input(motion, true)
	for frame in range(3): await process_frame
func capture(path: String) -> void:
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(path) == OK)
func painted_hover_point(prop: TextureRect) -> Vector2:
	var image: Image = prop.texture.get_image()
	var desired := Vector2(image.get_width() * 0.5, image.get_height() * 0.22)
	var nearest := Vector2.ZERO
	var distance: float = INF
	for y in range(0, image.get_height(), 4):
		for x in range(0, image.get_width(), 4):
			var pixel := Vector2(x, y)
			if image.get_pixel(x, y).a > 0.5 and pixel.distance_squared_to(desired) < distance:
				nearest = pixel
				distance = pixel.distance_squared_to(desired)
	assert(distance < INF)
	return prop.global_position + (nearest + Vector2(0.5, 0.5)) / Vector2(image.get_size()) * prop.size
func check_silhouette_hit_testing(object: Button, prop: TextureRect) -> void:
	var image: Image = prop.texture.get_image()
	var transparent: int = 0
	var painted: int = 0
	for y in range(0, image.get_height(), 20):
		for x in range(0, image.get_width(), 20):
			var canvas: Vector2 = prop.global_position + (Vector2(x, y) + Vector2(0.5, 0.5)) / Vector2(image.get_size()) * prop.size
			var opaque: bool = image.get_pixel(x, y).a > 0.08
			assert(object._has_point(canvas - object.global_position) == opaque)
			if opaque: painted += 1
			else: transparent += 1
	assert(painted > 0 and transparent > 0)
func run() -> void:
	root.size = Vector2i(1920, 1080)
	root.content_scale_size = Vector2i(1920, 1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.party.assign(["warden", "ranger", "occultist"])
	for settings in [["old_road", 0, "bandit"], ["old_road", 1, "keep"], ["path_beast", 0, "beast"]]:
		State.select_expedition(settings[0])
		State.start_run(42)
		State.floor_index = int(settings[1])
		for location in State.floors[State.floor_index]:
			if State.floors[State.floor_index][location].get("merchant_orb", false): State.room_position = location
		State.finish_encounter()
		change_scene_to_file("res://scenes/expedition/merchant_orb_room.tscn")
		await create_timer(0.9).timeout
		var prop: TextureRect = current_scene.get_node("MerchantOrbProp")
		var object: Button = current_scene.get_node("MerchantOrbObject")
		assert(prop.texture is AtlasTexture and prop.texture.atlas.resource_path == "res://assets/generated/merchant_orb_ink.png")
		assert(prop.size.x <= 380.01 and prop.size.y <= 470.01 and is_equal_approx(prop.position.y + prop.size.y, 690.0))
		check_silhouette_hit_testing(object, prop)
		await move_pointer(Vector2(1860, 710))
		assert(not object.is_hovered())
		await capture("C:/GAME/Ashen/orb-event-%s-rest.png" % settings[2])
		await move_pointer(painted_hover_point(prop))
		assert(object.is_hovered() and is_equal_approx(float(prop.material.get_shader_parameter("strength")), 0.88))
		await capture("C:/GAME/Ashen/orb-event-%s.png" % settings[2])
	current_scene.queue_free()
	await process_frame
	print("PASS: 3 themed painted orb rooms, natural ground sizing, alpha silhouette hit testing and actual hover; 6 previews captured at 1920 × 1080")
	quit()
