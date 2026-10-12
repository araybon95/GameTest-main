extends RefCounted
## Editable repository artwork first; optional local installation as fallback.
const Catalog = preload("res://assets/art_library/presentation/art_catalog.gd")
const DEFAULT_ROOT = "C:/Program Files (x86)/Steam/steamapps/common/DarkestDungeon/dungeons"
const CONFIG_PATH = "user://local_art.cfg"
static var root_path: String = DEFAULT_ROOT
static var enabled: bool = true
static var configured: bool = false
static var include_project_art: bool = true
static var texture_cache: Dictionary = {}
static var size_cache: Dictionary = {}
static var profile_cache: Dictionary = {}

static func configure(source_root: String = DEFAULT_ROOT, is_enabled: bool = true, use_project_art: bool = true) -> void:
	root_path = source_root.replace("\\", "/").trim_suffix("/")
	enabled = is_enabled
	include_project_art = use_project_art
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
	if absolute_path.begins_with("res://"):
		if not ResourceLoader.exists(absolute_path): return null
		var project_texture: Texture2D = load(absolute_path)
		project_texture.set_meta("project_art_path",absolute_path)
		texture_cache[absolute_path] = project_texture
		size_cache[absolute_path] = Vector2i(project_texture.get_size())
		return project_texture
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
	var path: String = texture_path(relative_path)
	return load_texture(path) if not path.is_empty() else null

static func texture_path(relative_path: String) -> String:
	if not enabled or relative_path.get_extension().to_lower() != "png": return ""
	var project_path: String = str(Catalog.TEXTURES.get(relative_path,""))
	if include_project_art and not project_path.is_empty() and ResourceLoader.exists(project_path): return project_path
	return root_path.path_join(relative_path) if root_path.is_absolute_path() else ""

static func texture_size(relative_path: String) -> Vector2i:
	read_configuration()
	var absolute_path: String = texture_path(relative_path)
	if not size_cache.has(absolute_path): texture(relative_path)
	return size_cache.get(absolute_path, Vector2i.ZERO)

static func load_profile_files(scene_theme: String, floor_index: int = 0) -> Variant:
	read_configuration()
	if not enabled: return null
	var cache_key: String = "%s:%s:%d" % [root_path, scene_theme, floor_index]
	if profile_cache.has(cache_key): return profile_cache[cache_key]
	var profile: Dictionary = profiles(scene_theme, floor_index)
	var background: Texture2D = texture(profile["background_file"])
	var mid: Texture2D = texture(profile["mid_file"])
	var walls: Array[Texture2D] = []
	for relative_file in profile["wall_files"]:
		var wall_texture: Texture2D = texture(relative_file)
		if wall_texture != null: walls.append(wall_texture)
	# The first wall provides the common floor strip. Reject incomplete profiles
	# as a whole so original project art remains the coherent fallback.
	var first_wall: Texture2D = texture(profile["wall_files"][0])
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
	profile["foreground_top"] = texture(profile["top_file"])
	profile["foreground_bottom"] = texture(profile["bottom_file"])
	profile["door"] = texture(profile["door_file"])
	profile["source_root"] = root_path
	profile_cache[cache_key] = profile
	return profile
