extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var viewport := SubViewport.new()
 viewport.size = Vector2i(800,600)
 viewport.transparent_bg = true
 viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
 root.add_child(viewport)
 var source := Image.create(800,600,false,Image.FORMAT_RGBA8)
 source.fill(Color.WHITE)
 var ground = preload("res://scenes/combat/battlefield_ground.gd").new()
 viewport.add_child(ground)
 ground.configure(ImageTexture.create_from_image(source),Vector2(800,600))
 for i in range(3): await process_frame
 await RenderingServer.frame_post_draw
 var pixels: Image = viewport.get_texture().get_image()
 if not (pixels.get_pixel(400,407).a < 0.1 and pixels.get_pixel(400,418).a > 0.3 and pixels.get_pixel(400,418).a < 0.7 and pixels.get_pixel(400,431).a > 0.99):
  push_error("Floor must feather from transparent to opaque over its 24px top edge, including atlas UVs")
  quit(1)
  return
 print("PASS: GPU-rendered atlas floor feather and opaque shared ground surface")
 viewport.free()
 quit()
