extends SceneTree
## Publication contract: every selectable Warden body retains every catalog weapon.
func _initialize() -> void:
 var visual = load("res://scripts/weapon_visuals.gd")
 var failures: Array[String] = []
 for style in ["original","alternate","relic","ashen_wolf"]:
  failures.append_array(visual.coverage_errors("warden",style))
 if not failures.is_empty():
  print("FAIL: Warden pack has ",failures.size()," missing or invalid records; first: ",failures[0])
  quit(1)
  return
 print("PASS: complete Warden catalog/style/pose publication coverage")
 quit()
