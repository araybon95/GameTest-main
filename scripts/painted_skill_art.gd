extends RefCounted
static func path_for(id: String) -> String:
 var relics: Dictionary = {"relic_warden":"warden_legend","relic_ranger":"ranger_legend","relic_occultist":"occultist_legend","relic_healer":"healer_legend","relic_crusader":"crusader_legend"}
 if relics.has(id): return preload("res://scripts/item_data.gd").icon_path(relics[id])
 for extension in ["png","tres","svg"]:
  var path: String = "res://assets/ui/skills/%s.%s" % [id,extension]
  if ResourceLoader.exists(path): return path
 return "res://assets/ui/skills/%s.svg" % id
