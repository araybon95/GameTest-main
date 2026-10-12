extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_library/manifest.json"))
	assert(manifest.schema == 1 and manifest.assets.size() >= 557)
	for asset in manifest.assets:
		assert(ResourceLoader.exists(asset.resource),"Moved artwork must remain loadable: "+str(asset.resource))
		var texture: Texture2D = load(asset.resource)
		assert(texture != null and texture.get_width() > 0 and texture.get_height() > 0)
		if str(asset.file).ends_with(".png"):
			assert(texture.get_size() == Vector2(asset.dimensions[0],asset.dimensions[1]))
		if asset.has("atlas"):
			assert(texture is AtlasTexture and texture.atlas != null)
			assert(texture.atlas.resource_path == "res://assets/art_library/"+str(asset.atlas))
	print("PASS: all ",manifest.assets.size()," library images/resources load, PNG dimensions match and atlas references resolve")
	quit()
