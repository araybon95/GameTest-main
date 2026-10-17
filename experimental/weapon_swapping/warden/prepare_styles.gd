extends SceneTree
## Builds outfit-preserving registered layers from approved atlases and surgical repairs.
const ROOT = "res://experimental/weapon_swapping/warden/assets/"
const Assembler = preload("res://experimental/weapon_swapping/warden/prepare_assets.gd")
const Outfits = preload("res://scripts/warden_outfits.gd")
const IDS = ["warden_sword","warden_legend","warden_epic","warden_frostblade"]
const GRIPS = {
 "alternate":[Vector2(136,201),Vector2(620,139),Vector2(945,224),Vector2(1300,38),Vector2(145,527),Vector2(560,526),Vector2(940,522),Vector2(1315,532),Vector2(293,812),Vector2.ZERO,Vector2(844,706),Vector2(1295,802)],
 "relic":[Vector2(128,195),Vector2(610,137),Vector2(943,220),Vector2(1287,35),Vector2(143,527),Vector2(558,526),Vector2(932,526),Vector2(1300,533),Vector2(290,813),Vector2.ZERO,Vector2(836,710),Vector2(1288,806)]
}
const ANCHORS = {
 "alternate":[203.0,580.0,1016.0,1371.0,201.0,603.5,996.5,1360.0,260.0,573.0,946.0,1318.0],
 "relic":[202.0,580.0,1015.0,1371.0,201.0,603.5,996.5,1360.0,260.0,573.0,946.0,1318.0]
}
var records: Dictionary
var swords: Array[Image] = []
var assembler
func _initialize() -> void: call_deferred("run")
func raw(path: String) -> Image:
 var im := Image.new()
 assert(im.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) == OK)
 return im
func write_frame(style: String, pose: String, body: Image, local_foot: Vector2, local_grip: Vector2, angle: float, body_height: float, scale_factor: float = 0.2, weapon_visible: bool = true) -> void:
 var canvas := Vector2i(768,700)
 var foot := Vector2(350,650)
 var offset := Vector2i(foot-local_foot)
 var body_path: String = ROOT+style+"-"+pose+"-body.png"
 assert(body.save_png(body_path) == OK)
 var hand_area := Rect2i(Vector2i(local_grip)-Vector2i(19,20),Vector2i(38,40)).intersection(Rect2i(Vector2i.ZERO,body.get_size()))
 var hand_path: String = ROOT+style+"-"+pose+"-hands.png"
 if weapon_visible: assert(body.get_region(hand_area).save_png(hand_path) == OK)
 for w in range(4):
  var weapon_id: String = IDS[w]
  var grip: Vector2 = local_grip+Vector2(offset)
  var path: String = ROOT+style+"-"+pose+"-"+weapon_id+".png"
  var layers: Array = []
  if weapon_visible:
   var pivot := Vector2(151 if w%2 else 149,825)
   assert(assembler.transformed(swords[w],pivot,grip,angle,scale_factor,canvas).save_png(path) == OK)
   layers = [{"path":body_path,"offset":offset,"role":"body"},{"path":path,"offset":Vector2i.ZERO,"role":"front_weapon"},{"path":hand_path,"offset":offset+hand_area.position,"role":"hands"}]
  else:
   # Genuine bust portraits contain no weapon; keep the approved portrait crop.
   layers = [{"path":body_path,"offset":offset,"role":"full_frame"}]
  var metadata := {"pose_id":"warden","appearance_style":"weapon_layers","warden_outfit":style,"idle_pixel_height":700.0,"body_height_pixels":body_height,"hit_point":foot+Vector2(0,-body_height*0.62),"emitter_point":grip,"weapon_visible":weapon_visible}
  if pose.begins_with("walk_"):
   metadata["stride_anchor"] = foot.x/768.0
   metadata["stride_scale"] = 1.0
  if pose == "portrait": metadata["portrait_view"] = true
  records["warden|"+style+"|"+weapon_id+"|"+pose] = {"hero":"warden","style":style,"weapon_profile":weapon_id,"pose":pose,"canvas_size":canvas,"foot":foot,"grips":[grip],"weapon_axis":PackedVector2Array([grip,grip+Vector2.RIGHT.rotated(deg_to_rad(angle))*180]),"metadata":metadata,"layers":layers}
func template(style: String, index: int, sheet: Image, clean: Image) -> Dictionary:
 var regions = preload("res://assets/art_library/appearance/regions.gd").REGIONS if style == "alternate" else preload("res://assets/art_library/equipment/regions.gd").REGIONS
 var region := Rect2i(regions.warden[index])
 var body := sheet.get_region(region)
 var grip: Vector2 = GRIPS[style][index]
 var angle: float = (83.0 if style == "alternate" else 81.0) if index == 8 else 14.0 if index == 10 else 22.0
 # Cover the entire original sword, including pommel. Empty portrait is unchanged.
 if index != 9:
  var axis := Vector2.RIGHT.rotated(deg_to_rad(angle))
  var end: Vector2 = grip+axis*(280 if index == 10 else 200 if index != 8 else 175)
  for y in range(region.size.y):
   for x in range(region.size.x):
    var point := Vector2(region.position+Vector2i(x,y))
    var nearest := Geometry2D.get_closest_point_to_segment(point,grip-axis*36,end)
    if point.distance_to(nearest) <= 27: body.set_pixel(x,y,clean.get_pixelv(Vector2i(point)))
 if index == 8:
  # The seated hand wraps the pommel: retain the original closed gauntlet,
  # excluding the old blade, guard and exposed handle above/below it.
  for y in range(region.size.y):
   for x in range(region.size.x):
    var absolute := Vector2(region.position+Vector2i(x,y))
    if absolute.distance_to(grip) <= 17: body.set_pixel(x,y,sheet.get_pixelv(Vector2i(absolute)))
 return {"body":body,"foot":Vector2(ANCHORS[style][index]-region.position.x,region.size.y),"grip":grip-Vector2(region.position),"angle":angle}
func clone_pose(style: String, source: String, dest: String) -> void:
 for id in IDS:
  var entry: Dictionary = records["warden|"+style+"|"+id+"|"+source].duplicate(true)
  entry.pose = dest
  records["warden|"+style+"|"+id+"|"+dest] = entry
func run() -> void:
 assembler = Assembler.new()
 var source := raw(ROOT+"sword-source.png")
 var extra := raw(ROOT+"catalog-sword-source.png")
 swords = [source.get_region(Rect2i(335,10,300,1000)),source.get_region(Rect2i(900,10,305,1000)),extra.get_region(Rect2i(335,10,300,1000)),extra.get_region(Rect2i(900,10,305,1000))]
 records = load("res://experimental/weapon_swapping/warden/frames.gd").RECORDS.duplicate(true)
 for style in ["alternate","relic"]:
  var path: String = "res://assets/art_library/appearance/hero_warden_outfit.png" if style == "alternate" else "res://assets/art_library/equipment/hero_warden_relic.png"
  var sheet := raw(path)
  var clean := raw(ROOT+style+"-clean-source.png")
  assert(sheet.get_size() == clean.get_size())
  var index_poses := {0:["idle","guard"],1:["attack"],2:["hurt","death"],8:["camp"],9:["portrait"],10:["windup","cast"]}
  for i in index_poses:
   var t := template(style,i,sheet,clean)
   for pose in index_poses[i]: write_frame(style,pose,t.body,t.foot,t.grip,t.angle,325.0,0.2,i != 9)
  for i in range(4,8):
   var t := template(style,i,sheet,clean)
   write_frame(style,"walk_"+str(i-4),t.body,t.foot,t.grip,t.angle,325.0)
 for style in ["original","ashen_wolf"]:
  var sheet := raw("res://assets/art_library/warden_outfits/"+style+".png")
  var clean: Image = raw(ROOT+style+"-clean-source.png") if style != "original" else null
  # Keep all ten existing strides; the four common poses are a minimum contract.
  for i in range(12):
   if style == "original" and i < 2: continue
   var region := Rect2i((i%4)*362,[0,389,741][i/4],366 if i%4 != 3 else 362,Outfits.GROUNDS[style][i]+1)
   var body := sheet.get_region(region)
   var local_grip: Vector2
   var angle: float = 30.0
   var anchor: float
   if i >= 2:
    local_grip = Outfits.WALK_HANDS[style][i-2]
    anchor = Outfits.WALK_ANCHORS[style][i-2]
   else:
    local_grip = Vector2(141,224) if i == 0 else Vector2(118,65)
    anchor = 215.0
    angle = 15.0 if i == 0 else -30.0
    var absolute_grip: Vector2 = local_grip+Vector2(region.position)
    var direction := Vector2.RIGHT.rotated(deg_to_rad(angle))
    for y in range(region.size.y):
     for x in range(region.size.x):
      var absolute := Vector2(region.position+Vector2i(x,y))
      if absolute.distance_to(Geometry2D.get_closest_point_to_segment(absolute,absolute_grip-direction*45,absolute_grip+direction*130)) < 42:
       body.set_pixel(x,y,clean.get_pixelv(Vector2i(absolute)))
   var pose: String = "idle" if i == 0 else "attack" if i == 1 else "walk_"+str(i-2)
   write_frame(style,pose,body,Vector2(anchor,region.size.y),local_grip,angle,340.0)
  if style == "ashen_wolf":
   for pose in ["guard","hurt","death"]: clone_pose(style,"idle",pose)
   for pose in ["windup","cast"]: clone_pose(style,"attack",pose)
  else: clone_pose(style,"guard","cast")
  clone_pose(style,"walk_0","camp")
  clone_pose(style,"camp","portrait")
 # Store ordinary coverage first; cinematic layers are assembled separately.
 var output := FileAccess.open("res://experimental/weapon_swapping/warden/frames.gd",FileAccess.WRITE)
 output.store_string("extends RefCounted\n## Registered Warden catalog records; publication remains gated.\nstatic var RECORDS: Dictionary = str_to_var(\"\"\""+var_to_str(records)+"\"\"\")\n")
 assembler.free()
 print("PASS: assembled Warden weapon layers across four approved outfit atlases, including all travel strides and camp")
 quit()
