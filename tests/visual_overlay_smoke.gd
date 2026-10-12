extends SceneTree
const Art = preload("res://scripts/local_dungeon_art.gd")
const Overlays = preload("res://scripts/visual_overlays.gd")
const Sheet = preload("res://scenes/ui/hero_sheet.gd")
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void: call_deferred("run")

func run() -> void:
	var rng: int = State.loot_rng.state
	Art.configure(Art.DEFAULT_ROOT,false)
	var host := Control.new()
	root.add_child(host)
	var panel := Panel.new()
	panel.size = Vector2(450,300)
	host.add_child(panel)
	Overlays.frame(panel)
	Overlays.frame(panel)
	assert(panel.get_child_count() == 2 and panel.get_node("IronFittings").mouse_filter == Control.MOUSE_FILTER_IGNORE)
	assert(panel.get_node("IronFittings").painted_frame == null)
	var label := Label.new()
	label.size = Vector2(920,60)
	host.add_child(label)
	Overlays.banner(label)
	assert(label.get_node("PaintedBanner").texture == null and label.get_node("PaintedBanner").mouse_filter == Control.MOUSE_FILTER_IGNORE)
	Overlays.stage_edges(host,Rect2(0,0,1920,600))
	assert(host.get_node("StageEdgeOverlay").size.y == 600 and host.get_node("StageEdgeOverlay").mouse_filter == Control.MOUSE_FILTER_IGNORE)
	var portrait := TextureRect.new()
	portrait.size = Vector2(180,280)
	host.add_child(portrait)
	Overlays.selection(portrait,true)
	await process_frame
	assert(portrait.get_node("SelectionUnderline").visible)
	Overlays.selection(portrait,false)
	assert(not portrait.get_node("SelectionUnderline").visible)
	var paths: Array[String] = []
	for id in ["warden","ranger","occultist","healer","crusader"]:
		var path: String = Sheet.hero_backdrop_path(id)
		assert(ResourceLoader.exists(path) and not path.contains("camp"))
		assert(not paths.has(path), "Each current class has a distinct setting")
		paths.append(path)
	Art.configure(Art.DEFAULT_ROOT,true)
	var native: Texture2D = Art.texture("../panels/panel_inventory.png")
	if native != null:
		assert(native.get_width() >= 668 and native.get_height() >= 360)
	assert(State.loot_rng.state == rng, "Decoration never consumes gameplay randomness")
	print("PASS: optional native frames, drawn fallback, input-transparent stage/banner/selection overlays, five class settings and unchanged RNG")
	quit()
