extends SceneTree
func _initialize() -> void:
 var stage = load("res://showcase.gd").new()
 var args: PackedStringArray = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/warden-showcase-frames"
 DirAccess.make_dir_recursive_absolute(output)
 for index in range(180):
  var skill: String = stage.ORDER[index/60]
  var time: float = (index%60)/20.0
  var image: Image = stage.render(skill,time)
  var error: int = image.save_png(output+"/%03d.png" % index)
  if error != OK:
   push_error("Preview frame export failed")
   quit(1)
   return
 stage.free()
 print("PASS: exported 180 Warden showcase frames at 20 FPS")
 quit()
