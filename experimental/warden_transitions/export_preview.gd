extends SceneTree
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
 root.size = Vector2i(1440,640)
 root.content_scale_size = Vector2i(1440,640)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 var view = load("res://experimental/warden_transitions/showcase.tscn").instantiate()
 root.add_child(view)
 view.set_process(false)
 var args = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/warden-transitions"
 DirAccess.make_dir_recursive_absolute(output)
 for index in range(156):
  view.elapsed = index/30.0
  view.queue_redraw()
  await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/%03d.png" % index)
 view.free()
 print("PASS: captured slash and heavy transition comparison, 156 frames at 30 FPS")
 quit()
