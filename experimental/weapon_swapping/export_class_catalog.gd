extends SceneTree
const Visuals = preload("res://scripts/weapon_visuals.gd")
const IDS = {
 "ranger":["ranger_bow","ranger_epic","ranger_venombow","ranger_legend"],
 "crusader":["crusader_axe","crusader_epic","crusader_unique","crusader_legend"],
 "occultist":["occultist_staff","occultist_epic","occultist_plaguestaff","occultist_legend"]}
class Board extends Node2D:
 var hero: String
 var pose: String
 var ids: Array
 var textures: Array[Texture2D] = []
 func _draw() -> void:
  draw_rect(Rect2(0,0,1920,1080),Color("#171416"))
  var font = ThemeDB.fallback_font
  draw_string(font,Vector2(30,35),("WITCH HUNTER" if hero == "crusader" else hero.to_upper())+" / "+pose.to_upper(),HORIZONTAL_ALIGNMENT_LEFT,-1,25,Color("#e4d0a4"))
  for i in range(textures.size()):
   var col: int = i%4
   var row: int = i/4
   var cell := Vector2(col*480,row*330+65)
   draw_string(font,cell+Vector2(20,16),["original","alternate","relic"][row]+" / "+str(load("res://scripts/item_data.gd").EQUIPMENT[ids[col]].name),HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("#d1c3ae"))
   var texture: Texture2D = textures[i]
   var floor_point := cell+Vector2(225,290)
   var factor: float = 205.0/float(texture.get_meta("body_height_pixels"))
   draw_texture_rect(texture,Rect2(floor_point-texture.get_meta("foot_anchor")*factor,texture.get_size()*factor),false)
   draw_line(cell+Vector2(20,292),cell+Vector2(460,292),Color("#63523b"))
func _initialize() -> void: call_deferred("run")
func run() -> void:
 root.size = Vector2i(1920,1080)
 var args := OS.get_cmdline_user_args()
 var hero: String = args[0]
 var output: String = args[1]
 DirAccess.make_dir_recursive_absolute(output)
 var board := Board.new()
 board.hero = hero
 board.ids = IDS[hero]
 root.add_child(board)
 for pose in ["idle","attack","windup","walk_0","camp","death"]:
  board.pose = pose
  board.textures.clear()
  for style in ["original","alternate","relic"]:
   for id in IDS[hero]:
    var texture: Texture2D = Visuals._frame_for_weapon(hero,style,pose,id)
    assert(texture != null,hero+"/"+style+"/"+pose+"/"+id)
    board.textures.append(texture)
  board.queue_redraw()
  await process_frame
  await RenderingServer.frame_post_draw
  assert(root.get_texture().get_image().save_png(output+"/"+pose+".png") == OK)
 board.free()
 print("PASS: rendered native ",hero," weapon/style/pose catalog")
 quit()
