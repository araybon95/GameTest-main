extends SceneTree
## Registered source composition; generated weapon art stays separate from bodies.
const ROOT = "res://experimental/weapon_swapping/"
const Assembler = preload("res://experimental/weapon_swapping/warden/prepare_assets.gd")
const POSES = ["idle","attack","hurt","guard","walk_0","walk_1","walk_2","walk_3","camp","death","windup","cast"]
const IDS = {
 "ranger":["ranger_bow","ranger_epic","ranger_venombow","ranger_legend"],
 "crusader":["crusader_axe","crusader_epic","crusader_unique","crusader_legend"],
 "occultist":["occultist_staff","occultist_epic","occultist_plaguestaff","occultist_legend"]
}
func _initialize() -> void: call_deferred("run")
func raw(path: String) -> Image:
 var image := Image.new()
 assert(image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) == OK,path)
 return image
func vector(value: Array) -> Vector2: return Vector2(float(value[0]),float(value[1]))
func opaque_bounds(image: Image) -> Rect2i:
 var left: int = image.get_width()
 var top: int = image.get_height()
 var right: int = -1
 var bottom: int = -1
 for y in range(image.get_height()):
  for x in range(image.get_width()):
   if image.get_pixel(x,y).a > 0.75:
    left = mini(left,x); top = mini(top,y); right = maxi(right,x); bottom = maxi(bottom,y)
 assert(right >= left)
 return Rect2i(left,top,right-left+1,bottom-top+1)
func line(image: Image, start: Vector2, finish: Vector2, color: Color) -> void:
 var steps: int = maxi(1,ceili(start.distance_to(finish)*2))
 for i in range(steps+1):
  var point := Vector2i(start.lerp(finish,float(i)/steps).round())
  if Rect2i(Vector2i.ZERO,image.get_size()).has_point(point): image.set_pixelv(point,color)
func profile_data(source: Image, index: int, hero: String) -> Dictionary:
 var area := Rect2i(index*384,0,384,1024)
 if hero == "crusader": area = [Rect2i(40,0,380,1024),Rect2i(420,0,345,1024),Rect2i(765,0,360,1024),Rect2i(1125,0,390,1024)][index]
 var image := source.get_region(area)
 var y: int = 800 if hero == "crusader" else 500 if hero == "ranger" else 400
 var total: float = 0
 var count: int = 0
 for row in range(y-5,y+6):
  for x in range(image.get_width()):
   if image.get_pixel(x,row).a > 0.75: total += x; count += 1
 assert(count > 0)
 var data := {"image":image,"pivot":Vector2(total/count,y)}
 if hero == "ranger":
  var bounds := opaque_bounds(image)
  var tips: Array[Vector2] = []
  for row in [bounds.position.y+5,bounds.end.y-6]:
   total = 0; count = 0
   for x in range(image.get_width()):
    if image.get_pixel(x,row).a > 0.75: total += x; count += 1
   assert(count > 0)
   tips.append(Vector2(total/count,row))
  data["tips"] = tips
 return data
func weapon_mask(point: Vector2, hero: String, index: int, data: Dictionary) -> bool:
 var grip := vector(data.grip)
 if hero == "ranger":
  if index == 8:
   return Rect2(35,10,115,325).has_point(point) if index == 8 and data.angle != 180 else Rect2(10,250,355,90).has_point(point)
  if index == 9 and data.angle == 180: return Rect2(5,275,365,70).has_point(point)
  if data.get("overhead",false): return Rect2(65,0,280,170).has_point(point)
  var bow := Rect2(grip-Vector2(85,165),Vector2(165,325))
  if bow.has_point(point): return true
  if data.has("draw_hand"):
   var draw := vector(data.draw_hand)
   return Rect2(Vector2(draw.x-15,draw.y-15),Vector2(390-draw.x,32)).has_point(point)
  return false
 var direction := Vector2.RIGHT.rotated(deg_to_rad(float(data.angle)))
 var nearest := Geometry2D.get_closest_point_to_segment(point,grip-direction*300,grip+direction*300)
 return point.distance_to(nearest) <= 48 or point.distance_to(grip+direction*(100 if index == 8 else 80)) <= 47
func repaired_body(hero: String, index: int, original: Image, clean: Image, data: Dictionary) -> Image:
 var body := original.duplicate()
 var grip := vector(data.grip)
 var direction := Vector2.RIGHT.rotated(deg_to_rad(float(data.get("angle",0))))
 for y in range(body.get_height()):
  for x in range(body.get_width()):
   var point := Vector2(x,y)
   if weapon_mask(point,hero,index,data):
    var color: Color = clean.get_pixel(x,y)
    # The staff crown cannot become a spare fist after a reference cleanup.
    # Beyond the real held grip it is entirely modular weapon/negative space.
    if hero == "occultist" and (point-grip).dot(direction) > 15: color = Color.TRANSPARENT
    body.set_pixel(x,y,color)
 # Preserve the original fingers around the real grip, excluding old pommels.
 if data.get("hands",true):
  var hands: Array = [grip]
  if data.has("draw_hand"): hands.append(vector(data.draw_hand))
  for hand in hands:
   for y in range(maxi(0,int(hand.y)-9),mini(body.get_height(),int(hand.y)+10)):
    for x in range(maxi(0,int(hand.x)-9),mini(body.get_width(),int(hand.x)+10)):
     if Vector2(x,y).distance_to(hand) <= 9: body.set_pixel(x,y,original.get_pixel(x,y))
 return body
func run() -> void:
 var args := OS.get_cmdline_user_args()
 var hero: String = args[0]
 var only_pose: int = int(args[1]) if args.size() > 1 else -1
 assert(IDS.has(hero))
 var dir: String = ROOT+hero+"/"
 var config: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(ROOT+"class-registration.json"))[hero]
 var registrations: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(dir+"registration.json"))
 var source := raw(dir+"assets/weapon-profiles.png")
 var profiles: Array[Dictionary] = []
 for w in range(4): profiles.append(profile_data(source,w,hero))
 var builder = Assembler.new()
 var records: Dictionary = load(dir+"frames.gd").RECORDS.duplicate(true) if only_pose >= 0 else {}
 var canvas := Vector2i(768,700)
 var foot := Vector2(350,650)
 for style in ["original","alternate","relic"]:
  var reference := raw(dir+"assets/"+style+"-reference.png")
  var clean := raw(dir+"assets/"+style+"-clean.png")
  assert(reference.get_size() == clean.get_size())
  var pose_repair: Image = raw(dir+"assets/"+style+"-pose-repair.png") if hero == "occultist" and style != "original" else null
  var idle_height: float = 270.0
  for i in range(12):
   if only_pose >= 0 and i != only_pose: continue
   var cell := Vector2i((i%4)*384,(i/4)*341)
   var height: int = mini(353 if hero == "crusader" else 341,clean.get_height()-cell.y)
   var area := Rect2i(cell,Vector2i(384,height))
   var local: Dictionary = config[style][i]
   var body: Image = clean.get_region(area) if hero == "crusader" or (hero == "ranger" and i == 8) else repaired_body(hero,i,reference.get_region(area),clean.get_region(area),local)
   var repaired_pose: bool = pose_repair != null and i in [8,9,10,11]
   if repaired_pose:
    body = pose_repair.get_region(Rect2i(cell,Vector2i(384,341)))
    for y in range(body.get_height()):
     for x in range(body.get_width()):
      if body.get_pixel(x,y).a < 0.87: body.set_pixel(x,y,Color.TRANSPARENT)
   if not (hero == "crusader" and i == 9):
    body.fill_rect(Rect2i(0,0,6,body.get_height()),Color.TRANSPARENT)
    body.fill_rect(Rect2i(body.get_width()-6,0,6,body.get_height()),Color.TRANSPARENT)
   if i >= 4: body.fill_rect(Rect2i(0,0,body.get_width(),12),Color.TRANSPARENT)
   var local_foot := Vector2(192,333)
   if hero == "crusader":
    var bounds := opaque_bounds(body)
    local_foot.y = bounds.end.y
    if i == 0: idle_height = 278.0
   else:
    idle_height = float(registrations[style][i].body_height)
    if i == 8 and style == "original": idle_height = 270.0
    if pose_is_walk(i): idle_height = roundf(float(registrations[style][i].source_size[1])*float(registrations[style][i].scale))
   if repaired_pose:
    local_foot.y = opaque_bounds(body).end.y
    idle_height = 270.0
   var offset := Vector2i(foot-local_foot)
   var grips: Array[Vector2] = [vector(local.grip)+Vector2(offset)]
   var angle: float = float(local.get("angle",0))
   if local.has("second_hand"):
    grips.append(vector(local.second_hand)+Vector2(offset))
    angle = rad_to_deg((grips[1]-grips[0]).angle())
   var pose: String = POSES[i]
   var body_path: String = dir+"assets/"+style+"-"+pose+"-body.png"
   assert(body.save_png(body_path) == OK)
   var hands_image := Image.create(canvas.x,canvas.y,false,Image.FORMAT_RGBA8)
   hands_image.fill(Color.TRANSPARENT)
   var hand_centers: Array = [vector(local.grip)]
   if local.has("second_hand"): hand_centers.append(vector(local.second_hand))
   if local.has("draw_hand"): hand_centers.append(vector(local.draw_hand))
   if local.get("hands",true):
    for hand in hand_centers:
     var hand_area := Rect2i(Vector2i(hand)-Vector2i(15,15),Vector2i(30,30)).intersection(Rect2i(Vector2i.ZERO,body.get_size()))
     hands_image.blit_rect(body,hand_area,offset+hand_area.position)
   if hero == "occultist" and style == "original":
    var books: Array[Rect2i] = [Rect2i(150,130,70,80),Rect2i(130,190,75,60),Rect2i(150,135,75,70),Rect2i(185,150,70,80),Rect2i(120,95,105,90),Rect2i(120,95,105,90),Rect2i(120,95,105,90),Rect2i(120,95,105,90),Rect2i(115,220,120,100),Rect2i(210,290,95,45),Rect2i(230,150,135,115),Rect2i(230,150,135,115)]
    var book: Rect2i = books[i].intersection(Rect2i(Vector2i.ZERO,body.get_size()))
    hands_image.blit_rect(body,book,offset+book.position)
   var hands_path: String = dir+"assets/"+style+"-"+pose+"-hands.png"
   assert(hands_image.save_png(hands_path) == OK)
   for w in range(4):
    var id: String = IDS[hero][w]
    var pivot: Vector2 = profiles[w].pivot
    pivot.y = float(local.get("pivot_y",pivot.y))
    var factor: float = float(local.scale)
    if pose_is_walk(i) and hero != "crusader": factor *= idle_height/270.0
    var weapon: Image = builder.transformed(profiles[w].image,pivot,grips[0],angle,factor,canvas)
    if hero == "occultist":
     var overflow: float = weapon.get_used_rect().end.y-foot.y
     var vertical: float = cos(deg_to_rad(angle)+PI/2)
     if overflow > 0 and vertical > 0.2:
      # Slide the hand along a fixed-length staff rather than burying its base.
      pivot.y += overflow/(factor*vertical)
      weapon = builder.transformed(profiles[w].image,pivot,grips[0],angle,factor,canvas)
    var transform := Transform2D(deg_to_rad(angle)+PI/2,Vector2.ONE*factor,0,grips[0])
    if hero == "ranger":
     var tip_a: Vector2 = transform*(profiles[w].tips[0]-pivot)
     var tip_b: Vector2 = transform*(profiles[w].tips[1]-pivot)
     var nock: Vector2 = transform*((profiles[w].tips[0]+profiles[w].tips[1])/2-pivot)
     if local.has("draw_hand") and i != 1: nock = vector(local.draw_hand)+Vector2(offset)
     line(weapon,tip_a,nock,Color("#b9ad92"))
     line(weapon,nock,tip_b,Color("#b9ad92"))
     if local.has("draw_hand") and i != 1:
      var direction: Vector2 = (grips[0]-nock).normalized()
      var tip: Vector2 = grips[0]+direction*28
      line(weapon,nock-direction*12,tip,Color("#d4bd91"))
      line(weapon,tip,tip-direction.rotated(0.45)*9,Color("#ccd1d2"))
      line(weapon,tip,tip-direction.rotated(-0.45)*9,Color("#ccd1d2"))
      line(weapon,nock-direction*10,nock-direction*17+direction.orthogonal()*4,Color("#a69e8d"))
      line(weapon,nock-direction*10,nock-direction*17-direction.orthogonal()*4,Color("#a69e8d"))
    var weapon_path: String = dir+"assets/"+style+"-"+pose+"-"+id+".png"
    assert(weapon.save_png(weapon_path) == OK)
    var weapon_layer := {"path":weapon_path,"offset":Vector2i.ZERO,"role":"front_weapon"}
    var body_layer := {"path":body_path,"offset":offset,"role":"body"}
    var layers: Array = [body_layer,weapon_layer]
    layers.append({"path":hands_path,"offset":Vector2i.ZERO,"role":"hands"})
    var direction := Vector2.RIGHT.rotated(deg_to_rad(angle))
    var metadata := {"pose_id":hero,"party_build":hero,"appearance_style":"equipment" if style == "relic" else "alternate" if style == "alternate" else "weapon_layers","idle_pixel_height":700.0,"body_height_pixels":idle_height,"hit_point":foot+Vector2(0,-idle_height*0.62),"emitter_point":grips[0]+Vector2(25,0),"weapon_resting":not local.get("hands",true)}
    if hero in ["occultist","crusader"]: metadata["emitter_point"] = transform*(Vector2(pivot.x,137 if hero == "occultist" else 150)-pivot)
    records["|".join([hero,style,id,pose])] = {"hero":hero,"style":style,"weapon_profile":id,"pose":pose,"canvas_size":canvas,"foot":foot,"grips":grips,"weapon_axis":PackedVector2Array([grips[0]-direction*80,grips[0]+direction*350]),"metadata":metadata,"layers":layers}
  for id in IDS[hero]:
   var entry: Dictionary = records["|".join([hero,style,id,"idle"])].duplicate(true)
   entry.pose = "portrait"
   records["|".join([hero,style,id,"portrait"])] = entry
 var file := FileAccess.open(dir+"frames.gd.tmp",FileAccess.WRITE)
 file.store_string("extends RefCounted\n## Generated registered class weapon records.\nstatic var RECORDS: Dictionary = str_to_var(\"\"\""+var_to_str(records)+"\"\"\")\n")
 file.close()
 assert(DirAccess.rename_absolute(dir+"frames.gd.tmp",dir+"frames.gd") == OK)
 builder.free()
 print("PASS: prepared ",hero," across all catalog weapons, three armor styles and thirteen gameplay contexts")
 quit()

func pose_is_walk(index: int) -> bool: return index >= 4 and index <= 7
