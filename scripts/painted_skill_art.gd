extends RefCounted
static func path_for(id: String) -> String:
 for extension in ["png","tres","svg"]:
  var path: String = "res://assets/ui/skills/%s.%s" % [id,extension]
  if ResourceLoader.exists(path): return path
 return "res://assets/ui/skills/%s.svg" % id
