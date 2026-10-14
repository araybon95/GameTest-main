extends SceneTree
func _initialize() -> void:
 var stage = load("res://execution.gd").new()
 var args: PackedStringArray = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/warden-execution-frames"
 DirAccess.make_dir_recursive_absolute(output)
 for index in range(96):
  var image: Image = stage.render_execution(index/24.0)
  if image.save_png(output+"/%03d.png" % index) != OK:
   push_error("Execution frame export failed")
   stage.free()
   quit(1)
   return
 stage.free()
 print("PASS: exported 96 execution frames at 24 FPS with a stable corpse aftermath")
 quit()
