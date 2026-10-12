extends SceneTree
const Art = preload("res://scripts/local_dungeon_art.gd")
const Catalog = preload("res://assets/art_library/presentation/art_catalog.gd")
const State = preload("res://scripts/game_data.gd")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var rng: int = State.loot_rng.state
	Art.configure("C:/missing-reference-installation/dungeons", true)
	assert(Catalog.TEXTURES.size() == 74)
	for key in Catalog.TEXTURES:
		var texture: Texture2D = Art.texture(str(key))
		assert(texture != null and texture.resource_path == Catalog.TEXTURES[key], "Project assets take precedence without an installed reference")
		assert(Art.texture_size(str(key)) == Vector2i(texture.get_size()))
	for pair in [["bandit", 0], ["keep", 1], ["medical", 0], ["beast", 0], ["beast", 1], ["beast", 2]]:
		var profile = Art.load_profile_files(pair[0], pair[1])
		assert(profile is Dictionary and profile["background"].resource_path.begins_with("res://assets/art_library/presentation/"))
		assert(profile["walls"].size() == profile["floors"].size() and not profile["walls"].is_empty())
	Art.configure("C:/missing-reference-installation/dungeons", true, false)
	assert(Art.load_profile_files("bandit") == null, "The explicitly external-only fallback stays available")
	assert(State.loot_rng.state == rng)
	assert(ProjectSettings.get_setting("display/window/size/initial_screen") == 1)
	assert(ProjectSettings.get_setting("display/window/size/initial_position_type") == 3)
	print("PASS: 74 editable project images, six complete standalone profiles, external-only fallback, monitor 2 preference and unchanged RNG")
	quit()
