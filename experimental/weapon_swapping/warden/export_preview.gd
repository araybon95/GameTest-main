extends SceneTree
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
 root.size = Vector2i(1280,720)
 root.content_scale_size = Vector2i(1280,720)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 var view = load("res://experimental/weapon_swapping/warden/showcase.tscn").instantiate()
 root.add_child(view)
 view.set_process(false)
 var args = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/warden-weapons"
 DirAccess.make_dir_recursive_absolute(output)
 for mode in [0,1]:
  view.mode = mode
  for frame in range(60 if mode == 0 else 64):
   view.elapsed = frame/(10.0 if mode == 0 else 20.0)
   view.update_movies()
   view.queue_redraw()
   await process_frame
   await RenderingServer.frame_post_draw
   assert(root.get_texture().get_image().save_png(output+"/%s-%03d.png" % ["poses" if mode == 0 else "execution",frame]) == OK)
 view.free()
 print("PASS: captured Warden poses and executions with two matching weapons and fixed registration")
 quit()
