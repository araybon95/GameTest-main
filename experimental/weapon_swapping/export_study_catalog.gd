extends SceneTree
const Visuals = preload("res://scripts/weapon_visuals.gd")
const Builder = preload("res://experimental/weapon_swapping/prepare_class_assets.gd")
class Board extends Node2D:
 var textures: Array = []
 var label: String
 func _draw() -> void:
  draw_rect(Rect2(0,0,1920,1080),Color("#171416"))
  draw_string(ThemeDB.fallback_font,Vector2(20,30),label,HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color("#e4d0a4"))
  for i in range(textures.size()):
   var texture: Texture2D = textures[i]
   var cell := Vector2((i%4)*480,(i/4)*480+70)
   var image: Image = texture.get_image()
   var bounds := image.get_used_rect()
   var factor: float = minf(440.0/bounds.size.x,420.0/bounds.size.y)
   var dimensions := Vector2(bounds.size)*factor
   draw_texture_rect_region(texture,Rect2(cell+Vector2(20,440)-Vector2(0,dimensions.y),dimensions),Rect2(bounds))
   draw_string(ThemeDB.fallback_font,cell+Vector2(20,460),str(texture.get_meta("weapon_id")),HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("#d1c3ae"))
func _initialize() -> void: call_deferred("run")
func run() -> void:
 root.size = Vector2i(1920,1080)
 var output: String = OS.get_cmdline_user_args()[0]
 DirAccess.make_dir_recursive_absolute(output)
 var board := Board.new()
 root.add_child(board)
 for hero in ["ranger","crusader"]:
  var poses: Array = []
  for i in range(6 if hero == "ranger" else 3): poses.append("study_execution_"+str(i))
  if hero == "crusader": poses.append_array(["study_contact_0","study_contact_1"])
  for pose in poses:
   board.textures.clear(); board.label = hero+" / "+pose
   for weapon in Builder.IDS[hero]: board.textures.append(Visuals._frame_for_weapon(hero,"original",pose,weapon))
   board.queue_redraw()
   await process_frame
   await RenderingServer.frame_post_draw
   assert(root.get_texture().get_image().save_png(output+"/"+hero+"-"+pose+".png") == OK)
 board.free(); print("PASS: native study catalog"); quit()
