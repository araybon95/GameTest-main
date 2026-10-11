extends SceneTree
## Optional local assets are read-only; synthetic layers exercise every machine.
const Art = preload("res://scripts/local_dungeon_art.gd")
const Layers = preload("res://scripts/local_hallway_layers.gd")
const State = preload("res://scripts/game_data.gd")
var native_profiles_checked: int = 0

func _initialize() -> void:
	call_deferred("run")

func snapshot() -> Dictionary:
	return {"gold": State.gold, "heroes": State.run_heroes.duplicate(true), "position": State.room_position,
		"floor": State.floor_index, "rooms": State.floors.duplicate(true), "journey": State.journey.duplicate(true),
		"inventory": State.inventory.duplicate(true), "equipment": State.equipment.duplicate(true), "rng": State.loot_rng.state}

func synthetic_texture(dimensions: Vector2i, color: Color) -> Texture2D:
	var bitmap := Image.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	bitmap.fill(color)
	return ImageTexture.create_from_image(bitmap)

func synthetic_profile() -> Dictionary:
	var wall_one := synthetic_texture(Vector2i(720, 720), Color(0.2, 0.08, 0.1, 0.6))
	var wall_two := synthetic_texture(Vector2i(720, 720), Color(0.08, 0.2, 0.1, 0.6))
	var walls: Array[Texture2D] = [wall_one, wall_two]
	var floors: Array[Texture2D] = []
	for wall in walls:
		var floor_strip := AtlasTexture.new()
		floor_strip.atlas = wall
		floor_strip.region = Rect2(0, 600, 720, 120)
		floor_strip.filter_clip = true
		floors.append(floor_strip)
	return {"canvas": Vector2(720, 720), "ground_line": 645.0, "floor_region": Rect2(0, 600, 720, 120),
		"background": synthetic_texture(Vector2i(720, 720), Color(0.05, 0.05, 0.05)),
		"mid": synthetic_texture(Vector2i(720, 720), Color(0.1, 0.1, 0.1, 0.5)),
		"walls": walls, "floors": floors,
		"foreground_top": synthetic_texture(Vector2i(720, 293), Color(0, 0, 0, 0.5)),
		"foreground_bottom": synthetic_texture(Vector2i(720, 197), Color(0, 0, 0, 0.5)),
		"background_offset": -80.0, "mid_offset": -20.0}

func layer_state(layer) -> Array:
	var state: Array = []
	for band in layer.bands:
		for tile in band["tiles"]:
			state.append([tile.position, tile.size, tile.texture.get_instance_id()])
	return state

func check_layer_geometry(layer) -> void:
	for band in layer.bands:
		var tiles: Array = band["tiles"]
		assert(tiles.size() >= 3 and tiles[0].position.x <= 0.0)
		assert(tiles.back().position.x + tiles.back().size.x >= layer.size.x, "Repeated layers cover the complete viewport after wrapping")
		for index in range(tiles.size() - 1):
			assert(is_equal_approx(tiles[index].position.x + tiles[index].size.x, tiles[index + 1].position.x), "Wrapped tiles join without gaps or overlap")
			assert(is_equal_approx(tiles[index].position.y, tiles[index + 1].position.y))
		if band["name"] == "Floor":
			var ground_within_strip: float = (645.0 - 600.0) * layer.native_scale
			assert(is_equal_approx(tiles[0].position.y + ground_within_strip, layer.ground_y), "The floor strip aligns with the walking party's feet")
		elif band["name"] == "ForegroundTop":
			assert(is_zero_approx(tiles[0].position.y))
		elif band["name"] == "ForegroundBottom":
			assert(is_equal_approx(tiles[0].position.y + tiles[0].size.y, layer.size.y), "Bottom silhouettes anchor to the stage's lower edge")

func check_native_profile(theme: String, floor: int) -> void:
	var manifest: Dictionary = Art.profiles(theme, floor)
	if not FileAccess.file_exists(Art.DEFAULT_ROOT.path_join(manifest["background_file"])):
		print("SKIP optional installed scenery: %s floor %d" % [theme, floor + 1])
		return
	var loaded = Art.load_profile_files(theme, floor)
	assert(loaded is Dictionary, "An installed profile contains its complete core layers")
	assert(Art.load_profile_files(theme, floor) == loaded, "Profiles are cached")
	for key in ["background", "mid", "door"]:
		assert(loaded[key] != null and loaded[key].get_size() == Vector2(720, 720))
		assert(loaded[key].get_image().get_format() == Image.FORMAT_RGBA8)
	assert(not loaded["walls"].is_empty() and loaded["walls"].size() == loaded["floors"].size())
	for wall in loaded["walls"]:
		assert(wall.get_image().get_format() == Image.FORMAT_RGBA8)
	for floor_texture in loaded["floors"]:
		assert(floor_texture is AtlasTexture and floor_texture.region == Rect2(0, 600, 720, 120))
	var first: Texture2D = Art.texture(manifest["wall_files"][0])
	assert(first == loaded["walls"][0] and Art.texture(manifest["wall_files"][0]) == first)
	assert(Art.texture_size(manifest["wall_files"][0]) == Vector2i(720, 720))
	if theme == "bandit":
		var indexed_foreground: Texture2D = Art.texture(manifest["top_file"])
		assert(indexed_foreground.get_image().get_format() == Image.FORMAT_RGBA8)
		assert(indexed_foreground.get_image().detect_alpha() != Image.ALPHA_NONE, "The paletted foreground retains its transparency")
	native_profiles_checked += 1

func run() -> void:
	root.size = Vector2i(1920, 1080)
	State.progress_loaded = true
	State.progress_path = "user://local_art_smoke_progress.cfg"
	State.party.assign(["warden", "ranger", "occultist"])
	assert(State.select_expedition("old_road"))
	State.start_run(522)
	var before: Dictionary = snapshot()
	Art.texture_cache.clear()
	Art.size_cache.clear()
	Art.configure(Art.DEFAULT_ROOT, false)
	assert(not Art.get_enabled() and Art.load_profile_files("bandit") == null)
	assert(Art.texture("weald/weald.corridor_bg.png") == null, "Disabled local art preserves the original-art fallback")
	Art.configure(ProjectSettings.globalize_path("user://missing-installation/dungeons"), true)
	assert(Art.load_profile_files("bandit") == null and Art.texture("weald/weald.corridor_bg.png") == null)
	assert(Art.texture_size("weald/weald.corridor_bg.png") == Vector2i.ZERO)
	Art.configure("relative/missing-installation", true)
	assert(Art.load_profile_files("beast") == null, "A relative installation root cannot load external art")
	assert(Art.texture("weald/weald.dungeon.json") == null, "The loader accepts PNG artwork only")
	assert(Art.texture_cache.is_empty(), "Unavailable and disabled profiles create no cached textures")
	# A test-created PNG verifies cache and alpha even without the optional game.
	var cache_root: String = ProjectSettings.globalize_path("user://local-art-cache-fixture")
	assert(DirAccess.make_dir_recursive_absolute(cache_root) == OK)
	var cache_bitmap := Image.create(2, 2, false, Image.FORMAT_RGBA8)
	cache_bitmap.fill(Color(0.1, 0.2, 0.3, 0.5))
	cache_bitmap.set_pixel(0, 0, Color(1, 0, 0, 0))
	assert(cache_bitmap.save_png(cache_root.path_join("cache.png")) == OK)
	Art.configure(cache_root, true)
	var cached: Texture2D = Art.texture("cache.png")
	assert(cached != null and cached.get_image().get_format() == Image.FORMAT_RGBA8)
	assert(cached.get_image().get_pixel(0, 0).a == 0.0)
	assert(absf(cached.get_image().get_pixel(1, 1).a - 0.5) < 0.01)
	assert(Art.texture("cache.png") == cached and Art.texture_size("cache.png") == Vector2i(2, 2))
	Art.configure(cache_root, false)
	assert(Art.texture("cache.png") == null, "The enabled flag gates already-cached textures")
	assert(Art.profiles("beast", 0)["folder"] == "darkestdungeon/quest_1")
	assert(Art.profiles("beast", 1)["folder"] == "darkestdungeon/quest_2")
	assert(Art.profiles("beast", 2)["folder"] == "darkestdungeon/quest_3")
	var layer = Layers.new()
	layer.profile = synthetic_profile()
	layer.size = Vector2(1920, 710)
	layer.ground_y = 645.0
	root.add_child(layer)
	await process_frame
	layer.set_process(false)
	assert(layer.bands.size() == 6 and layer.near_layer != null and layer.background != null)
	assert(is_equal_approx(layer.native_scale, 710.0 / 720.0))
	check_layer_geometry(layer)
	var initial: Array = layer_state(layer)
	layer.distance = -50.0
	layer._process(0.0)
	assert(layer_state(layer) == initial, "A negative camera distance stays at the source")
	layer.distance = 2600.0
	layer._process(0.0)
	check_layer_geometry(layer)
	var advanced: Array = layer_state(layer)
	assert(advanced != initial)
	for distance in [720.0, 7200.0, 15000.0, 710.0, 0.0]:
		layer.distance = distance
		layer._process(0.0)
		check_layer_geometry(layer)
	assert(layer_state(layer) == initial, "Reversing to the source restores the original tiles and positions")
	layer.distance = 2600.0
	layer._process(0.0)
	assert(layer_state(layer) == advanced, "A tile sequence depends on distance, not prior movement history")
	# The owner can lift foreground silhouettes above the heroes without leaking them.
	var foreground = layer.near_layer
	layer.remove_child(foreground)
	root.add_child(foreground)
	layer.queue_free()
	await process_frame
	await process_frame
	assert(not is_instance_valid(foreground), "Detached foreground layers retire with their owner")
	Art.configure(Art.DEFAULT_ROOT, true)
	for theme in ["bandit", "keep", "medical"]: check_native_profile(theme, 0)
	for floor in range(3): check_native_profile("beast", floor)
	assert(snapshot() == before, "Scenery configuration, loading and scrolling preserve gameplay and loot RNG")
	Art.configure(Art.DEFAULT_ROOT, false)
	assert(Art.load_profile_files("bandit") == null and Art.texture("weald/weald.corridor_bg.png") == null, "Disabling cached local art takes effect immediately")
	State.end_run()
	DirAccess.remove_absolute(cache_root.path_join("cache.png"))
	DirAccess.remove_absolute(cache_root)
	DirAccess.remove_absolute(State.progress_path)
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: local-art disabled/missing fallback, native profiles %d, RGBA cache/transparency, seamless layer wrapping/reversal, contact plane, foreground lifetime and gameplay/RNG safety" % native_profiles_checked)
	quit()
