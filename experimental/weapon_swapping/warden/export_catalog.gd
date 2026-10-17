extends SceneTree
const Visuals = preload("res://scripts/weapon_visuals.gd")
const IDS = ["warden_sword","warden_epic","warden_frostblade","warden_legend"]
const STYLES = ["original","alternate","relic","ashen_wolf"]
class Board extends Node2D:
 var pose: String
 var textures: Array[Texture2D] = []
 func _draw() -> void:
  draw_rect(Rect2(0,0,1920,1080),Color("#171416"))
  var font = ThemeDB.fallback_font
  draw_string(font,Vector2(30,32),"WARDEN CATALOG / "+pose.to_upper(),HORIZONTAL_ALIGNMENT_LEFT,-1,23,Color("#e4d0a4"))
  for i in range(textures.size()):
   var texture: Texture2D = textures[i]
   var col: int = i%4
   var row: int = i/4
   var cell := Vector2(col*480,row*250+65)
   draw_string(font,cell+Vector2(20,16),STYLES[row]+" / "+IDS[col].trim_prefix("warden_"),HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("#d1c3ae"))
   var floor_point := cell+Vector2(225,222)
   var scale_factor: float = 170.0/float(texture.get_meta("body_height_pixels"))
   if pose == "execution_contact": scale_factor = 0.25
   draw_texture_rect(texture,Rect2(floor_point-texture.get_meta("foot_anchor")*scale_factor,texture.get_size()*scale_factor),false)
   draw_line(cell+Vector2(20,224),cell+Vector2(460,224),Color("#63523b"))
func _initialize() -> void: call_deferred("run")
func run() -> void:
 root.size = Vector2i(1920,1080)
 var board := Board.new()
 root.add_child(board)
 var output: String = OS.get_cmdline_user_args()[0]
 DirAccess.make_dir_recursive_absolute(output)
 for pose in ["idle","windup","walk_0","camp","execution_2","execution_contact"]:
  board.pose = pose
  board.textures.clear()
  for style in STYLES:
   for id in IDS:
    var frame: Texture2D = Visuals._frame_for_weapon("warden",style,pose,id)
    assert(frame != null)
    board.textures.append(frame)
  board.queue_redraw()
  await process_frame
  await RenderingServer.frame_post_draw
  assert(root.get_texture().get_image().save_png(output+"/"+pose+".png") == OK)
 board.free()
 print("PASS: rendered all Warden weapon/outfit catalog comparisons")
 quit()
