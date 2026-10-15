extends SceneTree
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
 root.size = Vector2i(1280,720)
 root.content_scale_size = Vector2i(1280,720)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 var scene = load("res://experimental/ranger_showcase/showcase.tscn").instantiate()
 root.add_child(scene)
 if scene.source_frames.size() != 6 or scene.target_frames.size() != 5 or scene.bow_frames.size() != 3:
  push_error("Showcase artwork did not initialize")
  quit(1)
  return
 scene.set_process(false)
 var args = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/ranger-showcase"
 DirAccess.make_dir_recursive_absolute(output)
 for mode in [0,1]:
  scene.mode = mode
  for frame in range(84):
   scene.age = frame/30.0-0.25
   scene.queue_redraw()
   await process_frame
   await RenderingServer.frame_post_draw
   assert(root.get_texture().get_image().save_png(output+"/%s-%03d.png" % ["bow" if mode == 0 else "execution",frame]) == OK)
 scene.free()
 print("PASS: captured Ranger bow transitions and rapid two-shot execution, 84 frames each at 30 FPS")
 quit()
