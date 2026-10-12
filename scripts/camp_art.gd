extends RefCounted
const ROOT = "res://assets/art_library/camp/"
static func path_for(id: String) -> String:
	for extension in ["png","tres"]:
		var path: String = ROOT+id+"."+extension
		if ResourceLoader.exists(path): return path
	return ""
static func texture_for(id: String) -> Texture2D:
	var path := path_for(id)
	return load(path) if not path.is_empty() else null
