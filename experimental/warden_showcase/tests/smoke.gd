extends SceneTree
func _initialize() -> void:
 if not ResourceLoader.exists("res://showcase.gd"):
  push_error("Warden showcase is missing")
  quit(1)
  return
 var stage = load("res://showcase.gd").new()
 var used: Array = []
 for skill in ["slash","heavy","bash"]:
  var windup: Dictionary = stage.sample(skill,0.1)
  var contact: Dictionary = stage.sample(skill,stage.TIMINGS[skill].impact)
  var recover: Dictionary = stage.sample(skill,stage.TIMINGS[skill].duration-0.01)
  for sample in [windup,contact,recover]:
   if used.has(sample.pose):
    push_error("Every showcased attack phase needs its own painted silhouette")
    quit(1)
    return
   used.append(sample.pose)
  assert(contact.zoom > windup.zoom and contact.target_shift > 0,"Contact must focus the camera and recoil the target")
  assert(contact.ground == 390.0,"Camera and motion must retain the ground anchor")
 var quiet: Dictionary = stage.sample("heavy",0.7,false)
 assert(quiet.zoom == 1.0 and quiet.source_shift == 0.0 and quiet.target_shift == 0.0,"Reduced motion must preserve isolated static staging")
 stage.load_assets()
 assert(stage.poses.size() == 9 and stage.enemy != null,"All showcased assets must load")
 for time in [0.2,0.3,0.47,0.68]:
  var framing: Dictionary = stage.sample("heavy",time)
  assert(stage.fitted_scale(framing.pose,framing.zoom)*stage.poses[framing.pose].get_height() <= 342.01,"Raised mace must fit below the title without vertical clipping")
 var first: Image = stage.render("slash",0.1)
 var impact: Image = stage.render("heavy",0.68)
 assert(first.get_size() == Vector2i(800,540))
 assert(first.get_pixel(15,100) != Color("#100e13"),"Isolated stage must render its dimmed room backdrop")
 assert(first.get_region(Rect2i(0,420,800,120)).get_data() == impact.get_region(Rect2i(0,420,800,120)).get_data(),"Camera must never move or scale the HUD")
 assert(first.get_region(Rect2i(0,0,800,420)).get_data() != impact.get_region(Rect2i(0,0,800,420)).get_data(),"Rendered attacks must have distinct framing and silhouettes")
 stage.free()
 print("PASS: nine distinct attack-phase poses, isolated contact framing, ground anchors and reduced motion")
 quit()
