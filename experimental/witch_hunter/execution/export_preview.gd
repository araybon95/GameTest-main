extends SceneTree
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
 root.size = Vector2i(1280,720)
 root.content_scale_size = Vector2i(1280,720)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 var scene = load("res://experimental/witch_hunter/execution/showcase.tscn").instantiate()
 root.add_child(scene)
 if scene.sources.size() != 3 or scene.targets.size() != 3 or scene.contacts.size() != 2:
  quit(1)
  return
 scene.set_process(false)
 var args = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/witch-execution"
 var directory_result: int = DirAccess.make_dir_recursive_absolute(output)
 if directory_result != OK:
  push_error("Cannot create capture directory: "+output)
  quit(1)
  return
 for frame in range(96):
  scene.age = frame/30.0-0.35
  scene.queue_redraw()
  await process_frame
  await RenderingServer.frame_post_draw
  var result: int = root.get_texture().get_image().save_png(output+"/frame-%03d.png" % frame)
  if result != OK:
   push_error("Cannot save execution frame %d: error %d" % [frame,result])
   quit(1)
   return
 scene.free()
 print("PASS: captured Witch Hunter execution, 96 frames at 30 FPS")
 quit()
