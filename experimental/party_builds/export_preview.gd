extends SceneTree
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
 root.size = Vector2i(1600,1000)
 var stage = load("res://showcase.gd").new()
 root.add_child(stage)
 stage.set_process(false)
 var args: PackedStringArray = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/party-build-preview"
 DirAccess.make_dir_recursive_absolute(output)
 for i in range(3): await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/party-comparison.png")
 stage.bow_view = true
 for i in range(96):
  stage.elapsed = i/30.0
  stage.queue_redraw()
  await process_frame
  await RenderingServer.frame_post_draw
  var frame: Image = root.get_texture().get_image()
  if frame.save_png(output+"/%03d.png" % i) != OK:
   push_error("Cannot save preview frame")
   quit(1)
   return
 print("PASS: comparison and 96 complete-pose bow frames exported")
 stage.free()
 await process_frame
 quit()
