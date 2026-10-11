extends RefCounted
## Optional, read-only scenery from the player's installed local game.
## No files are copied into this project and no imported resource is required.
const DEFAULT_ROOT = "C:/Program Files (x86)/Steam/steamapps/common/DarkestDungeon/dungeons"
const CONFIG_PATH = "user://local_art.cfg"
static var root_path: String = DEFAULT_ROOT
static var enabled: bool = true
static var configured: bool = false
static var texture_cache: Dictionary = {}
static var size_cache: Dictionary = {}
static var profile_cache: Dictionary = {}

static func configure(source_root: String = DEFAULT_ROOT, is_enabled: bool = true) -> void:
	root_path = source_root.replace("\\", "/").trim_suffix("/")
	enabled = is_enabled
	configured = true
	profile_cache.clear()

static func read_configuration() -> void:
	if configured: return
	var configuration := ConfigFile.new()
	if configuration.load(CONFIG_PATH) == OK:
		configure(str(configuration.get_value("art", "root", DEFAULT_ROOT)), bool(configuration.get_value("art", "enabled", true)))
	else:
		configure()

static func get_enabled() -> bool:
	read_configuration()
	return enabled

static func get_root() -> String:
	read_configuration()
	return root_path

static func profiles(scene_theme: String, floor_index: int = 0) -> Dictionary:
	var beast_folder: String = "darkestdungeon/quest_%d" % (clampi(floor_index, 0, 2) + 1)
	var folder: String = {"bandit":"weald", "keep":"crypts", "beast":beast_folder, "medical":"warrens"}.get(scene_theme, "weald")
	var stem: String = "darkestdungeon" if scene_theme == "beast" else folder
	var maximum: int = {"bandit":10, "keep":6, "beast":5, "medical":7}.get(scene_theme, 10)
	var wall_files: Array[String] = []
	for index in range(1, maximum + 1):
		wall_files.append("%s/%s.corridor_wall.%02d.png" % [folder, stem, index])
	return {
		"theme":scene_theme, "folder":folder, "stem":stem,
		"canvas":Vector2(720, 720), "ground_line":645.0,
		"background_file":"%s/%s.corridor_bg.png" % [folder, stem],
		"mid_file":"%s/%s.corridor_mid.png" % [folder, stem],
		"wall_files":wall_files,
		"top_file":"%s/%s.foreground_top.01.png" % [folder, stem],
		"bottom_file":"%s/%s.foreground_bottom.01.png" % [folder, stem],
		"door_file":"%s/%s.corridor_door.basic.png" % [folder, stem],
		"background_offset":-80.0 if scene_theme == "beast" and floor_index < 2 else 0.0,
		"mid_offset":-20.0 if scene_theme == "beast" and floor_index < 2 else 0.0,
		"floor_region":Rect2(0, 600, 720, 120)
	}

static func load_texture(absolute_path: String) -> Texture2D:
	if texture_cache.has(absolute_path): return texture_cache[absolute_path]
	if not absolute_path.is_absolute_path() or not FileAccess.file_exists(absolute_path): return null
	var image := Image.load_from_file(absolute_path)
	if image == null or image.is_empty(): return null
	# Paletted PNGs and layers with colored RGB in transparent pixels must retain
	# normal alpha blending. Image conversion handles all source PNG formats.
	image.convert(Image.FORMAT_RGBA8)
	size_cache[absolute_path] = image.get_size()
	var texture := ImageTexture.create_from_image(image)
	texture.set_meta("local_art_path", absolute_path)
	texture_cache[absolute_path] = texture
	return texture

static func texture(relative_path: String) -> Texture2D:
	read_configuration()
	if not enabled or not root_path.is_absolute_path() or relative_path.get_extension().to_lower() != "png": return null
	return load_texture(root_path.path_join(relative_path))

static func texture_size(relative_path: String) -> Vector2i:
	read_configuration()
	var absolute_path: String = root_path.path_join(relative_path)
	if not size_cache.has(absolute_path): texture(relative_path)
	return size_cache.get(absolute_path, Vector2i.ZERO)

static func load_profile_files(scene_theme: String, floor_index: int = 0) -> Variant:
	read_configuration()
	if not enabled or not root_path.is_absolute_path(): return null
	var cache_key: String = "%s:%s:%d" % [root_path, scene_theme, floor_index]
	if profile_cache.has(cache_key): return profile_cache[cache_key]
	var profile: Dictionary = profiles(scene_theme, floor_index)
	var background: Texture2D = load_texture(root_path.path_join(profile["background_file"]))
	var mid: Texture2D = load_texture(root_path.path_join(profile["mid_file"]))
	var walls: Array[Texture2D] = []
	for relative_file in profile["wall_files"]:
		var texture: Texture2D = load_texture(root_path.path_join(relative_file))
		if texture != null: walls.append(texture)
	# The first wall provides the common floor strip. Reject incomplete profiles
	# as a whole so original project art remains the coherent fallback.
	var first_wall: Texture2D = load_texture(root_path.path_join(profile["wall_files"][0]))
	if background == null or mid == null or first_wall == null or walls.is_empty(): return null
	var region: Rect2 = profile["floor_region"]
	if first_wall.get_width() < region.end.x or first_wall.get_height() < region.end.y: return null
	var floors: Array[Texture2D] = []
	for wall in walls:
		if wall.get_width() < region.end.x or wall.get_height() < region.end.y: continue
		var strip := AtlasTexture.new()
		strip.atlas = wall
		strip.region = region
		strip.filter_clip = true
		floors.append(strip)
	profile["background"] = background
	profile["mid"] = mid
	profile["walls"] = walls
	profile["floors"] = floors
	profile["foreground_top"] = load_texture(root_path.path_join(profile["top_file"]))
	profile["foreground_bottom"] = load_texture(root_path.path_join(profile["bottom_file"]))
	profile["door"] = load_texture(root_path.path_join(profile["door_file"]))
	profile["source_root"] = root_path
	profile_cache[cache_key] = profile
	return profile
