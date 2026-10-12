extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Visual = preload("res://scripts/visual_overlays.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	var rng := State.loot_rng.state
	var settlement = load("res://scenes/hub/settlement.tscn").instantiate()
	root.add_child(settlement)
	await process_frame
	var vista: TextureRect = settlement.get_node("Background")
	var ratio: float = maxf(vista.size.x/vista.texture.get_width(),vista.size.y/vista.texture.get_height())
	var offset := (vista.size-vista.texture.get_size()*ratio)*0.5
	for building in settlement.BUILDINGS:
		var button = settlement.get_node("MapView/"+building.id)
		var highlight: Polygon2D = button.get_node("GlowHover/PaintedHighlight")
		assert(button.silhouette.size() >= 8)
		assert(not button._has_point(Vector2(-1,-1)))
		assert(highlight.texture == vista.texture)
		assert(highlight.uv.size() == highlight.polygon.size())
		for i in highlight.uv.size():
			var registered := highlight.uv[i]*ratio+offset+vista.position
			assert(registered.distance_to(highlight.polygon[i]+button.position) < 0.01,"Painted UVs must coincide with the original vista")
		assert(not button.has_node("CemeteryMarker"))
		button.grab_focus()
		await create_timer(0.3).timeout
		await process_frame
		await process_frame
		assert(button.get_node("GlowHover").modulate.a > 0.95)
		assert(button.get_node("Banner").modulate.a > 0.95)
	var panel := PanelContainer.new()
	panel.position = Vector2(30,50)
	panel.size = Vector2(450,300)
	root.add_child(panel)
	var text := Label.new()
	text.text = "Readable contents"
	panel.add_child(text)
	Visual.frame(panel,"warden")
	Visual.frame(panel,"warden")
	await process_frame
	await process_frame
	var surface: TextureRect = panel.get_node("InkSurface")
	assert(panel.get_child_count() == 3)
	assert(surface.mouse_filter == Control.MOUSE_FILTER_IGNORE)
	assert(surface.material.get_shader_parameter("illustrated"))
	assert(surface.size == panel.size and surface.global_position == panel.global_position)
	assert(panel.get_child(0) == surface)
	assert(State.loot_rng.state == rng)
	print("PASS: nine registered painted hotspots, polygon hit testing, keyboard illumination, input-transparent card material and unaffected RNG")
	settlement.free()
	panel.free()
	quit()
