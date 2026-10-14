extends SceneTree
## Requires a native renderer: dummy headless ViewportTextures contain no pixels.
const Model = preload("res://scripts/party_weapon_model.gd")
func _initialize(): call_deferred("run")
func run():
 var renderer = load("res://scripts/warden_combat_art.gd").new()
 root.add_child(renderer)
 for hero in Model.WEAPONS:
  renderer.hero_id = hero
  for outfit in ["original","alternate","relic"]:
   for id in Model.WEAPONS[hero]:
    for pose in ["idle","attack"]:
     var texture: Texture2D = renderer.frame(outfit,id,pose)
     var viewport: SubViewport
     for child in renderer.get_children():
      if child.get_texture() == texture: viewport = child
     var model = viewport.get_child(0)
     model.motion_enabled = false
     for i in range(3): await process_frame
     await RenderingServer.frame_post_draw
     var pixels: Image = texture.get_image()
     var bounds: Rect2i = pixels.get_used_rect()
     assert(bounds.size.x > 100 and bounds.size.y > 300,"A complete body and equipped weapon must render")
     assert(bounds.position.x > 0 and bounds.end.x < viewport.size.x,"Cape and weapon must fit inside the composite: %s/%s/%s %s %s" % [hero,outfit,id,pose,bounds])
     assert(bounds.position.y > 0,"Weapon head and wisps must not be clipped at the top")
     assert(bounds.end.y >= 508,"Every outfit/pose must stay grounded")
     var grip: Vector2 = model.body.position+model._point(model.profile.grip)*model.body.scale
     assert(model.weapon.position.distance_to(grip) < 0.01,"Handle and painted grip remain attached")
     assert(model.hand.texture == model.body.texture and model.hand.uv == model.hand.polygon,"Foreground hand uses matching source pixels")
 renderer.free()
 print("PASS: 72 native weapon/outfit/pose renders, full silhouettes, unclipped heads, grounded feet and attached grips")
 quit()
