extends SceneTree
func _initialize(): call_deferred("run")
func settle():
 for i in range(5): await process_frame
 await RenderingServer.frame_post_draw
func run():
 root.size = Vector2i(1920,1080)
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 change_scene_to_file("res://experiments/weapon_showcase.tscn")
 await settle()
 for f in current_scene.figures:
  f.motion_enabled = false
  f.elapsed = 2.4
 var figure = current_scene.figures[0]
 figure.configure("original","warden_frostblade")
 for element in ["bleed","poison","burn","chill"]:
  figure.smoke.material.set_shader_parameter("tint",figure.COLOURS[element])
  figure.wisps.visible = false
  await settle()
  var plain: Image = root.get_texture().get_image()
  figure.wisps.visible = true
  await settle()
  var smoky: Image = root.get_texture().get_image()
  var origin: Vector2i = Vector2i(figure.smoke.global_position)
  var peak: float = 0
  var count: int = 0
  for y in range(int(figure.smoke.size.y)):
   for x in range(int(figure.smoke.size.x)):
    var a: Color = plain.get_pixelv(origin+Vector2i(x,y))
    var b: Color = smoky.get_pixelv(origin+Vector2i(x,y))
    var difference: float = maxf(absf(a.r-b.r),maxf(absf(a.g-b.g),absf(a.b-b.b)))*255
    peak = maxf(peak,difference)
    if difference >= 15: count += 1
  print("Native ",element," wisp contrast: peak ",peak,"; pixels with visible contrast ",count)
  if peak < 50 or count < 160:
   print("FAIL: wisps remain too faint/narrow against the dungeon")
   quit(1)
   return
 print("PASS: all four soft wisp colours remain visible against the dungeon")
 quit()
