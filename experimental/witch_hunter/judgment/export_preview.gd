extends SceneTree
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
 root.size = Vector2i(1280,720)
 root.content_scale_size = Vector2i(1280,720)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 var scene = load("res://experimental/witch_hunter/judgment/showcase.tscn").instantiate()
 root.add_child(scene)
 if scene.sources.size() != 3 or scene.contacts.size() != 1 or scene.recoil == null:
  quit(1)
  return
 scene.set_process(false)
 var args = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/witch-judgment"
 if DirAccess.make_dir_recursive_absolute(output) != OK:
  quit(1)
  return
 for frame in range(72):
  scene.age = frame/30.0-0.4
  scene.queue_redraw()
  await process_frame
  await RenderingServer.frame_post_draw
  if root.get_texture().get_image().save_png(output+"/frame-%03d.png" % frame) != OK:
   quit(1)
   return
 scene.free()
 print("PASS: captured Judgment study,72frames at30FPS")
 quit()
