extends SceneTree
## Builds modular weapons for fixed-outfit experimental execution studies.
const ROOT = "res://experimental/weapon_swapping/"
const ClassBuilder = preload("res://experimental/weapon_swapping/prepare_class_assets.gd")
const Assembler = preload("res://experimental/weapon_swapping/warden/prepare_assets.gd")
const RANGER = [
 {"grip":Vector2(414,258),"draw":Vector2(249,224),"angle":-90.0},
 {"grip":Vector2(424,254),"draw":Vector2(223,208),"angle":-90.0,"release":true},
 {"grip":Vector2(376,280),"angle":-80.0},
 {"grip":Vector2(414,225),"draw":Vector2(247,215),"angle":-90.0},
 {"grip":Vector2(443,233),"draw":Vector2(223,196),"angle":-90.0,"release":true},
 {"grip":Vector2(330,351),"angle":-50.0}]
const HAMMERS = [
 [Vector2(248,310),Vector2(326,298),Vector2(440,280)],
 [Vector2(338,181),Vector2(265,168),Vector2(178,160)],
 [Vector2(280,383),Vector2(346,405),Vector2(446,445)],
 [Vector2(674,649),Vector2(823,552),Vector2(945,440)],
 [Vector2(662,391),Vector2(746,447),Vector2(1045,600)]]
func _initialize() -> void: call_deferred("run")
func raw(path: String) -> Image:
 var image := Image.new()
 assert(image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) == OK,path)
 return image
func repaired(original: Image, clean: Image, hero: String, index: int, fit: Dictionary) -> Image:
 var result: Image = original.duplicate()
 var scale: Vector2 = Vector2(fit.scale[0],fit.scale[1]) if not fit.is_empty() else Vector2.ONE
 var shift: Vector2 = Vector2(fit.translation[0],fit.translation[1]) if not fit.is_empty() else Vector2.ZERO
 var grips: Array = [RANGER[index].grip] if hero == "ranger" else HAMMERS[index].slice(0,2)
 if hero == "ranger" and RANGER[index].has("draw"): grips.append(RANGER[index].draw)
 for y in range(result.get_height()):
  for x in range(result.get_width()):
   var point := Vector2(x,y)
   var mask: bool
   if hero == "ranger":
    var grip: Vector2 = grips[0]
    mask = Rect2(grip-Vector2(105,190),Vector2(210,380)).has_point(point)
    if RANGER[index].has("draw"): mask = mask or Rect2(210,grips[1].y-20,290,55).has_point(point)
   else:
    var axis: Vector2 = (grips[1]-grips[0]).normalized()
    var end: Vector2 = HAMMERS[index][2]
    mask = point.distance_to(Geometry2D.get_closest_point_to_segment(point,grips[0]-axis*55,end)) < 17 or point.distance_to(end) < (95 if index >= 3 else 64)
   if not mask: continue
   var mapped := Vector2i(((point-shift)/scale).round())
   var color := Color.TRANSPARENT
   if Rect2i(Vector2i.ZERO,clean.get_size()).has_point(mapped): color = clean.get_pixelv(mapped)
   if color.a < 0.85: color = Color.TRANSPARENT
   result.set_pixel(x,y,color)
 # Retain the exact approved gauntlets/fingers; weapon is drawn under them.
 for grip in grips:
  for y in range(maxi(0,int(grip.y)-10),mini(result.get_height(),int(grip.y)+11)):
   for x in range(maxi(0,int(grip.x)-10),mini(result.get_width(),int(grip.x)+11)):
    if Vector2(x,y).distance_to(grip) <= 10: result.set_pixel(x,y,original.get_pixel(x,y))
 return result
func run() -> void:
 var builder = Assembler.new()
 var helper = ClassBuilder.new()
 for hero in ["ranger","crusader"]:
  var dir: String = ROOT+hero+"/"
  var records: Dictionary = load(dir+"frames.gd").RECORDS.duplicate(true)
  for key in records:
   if hero == "ranger" and records[key].pose == "camp" and records[key].style == "original": records[key].metadata.body_height_pixels = 270.0
  var reference := raw(dir+"assets/study-source-reference.png")
  var clean := raw(dir+"assets/study-source-clean.png")
  var fits: Array = JSON.parse_string(FileAccess.get_file_as_string(dir+"study-repair-registration.json"))
  var profiles: Array = []
  var source := raw(dir+"assets/weapon-profiles.png")
  for w in range(4): profiles.append(helper.profile_data(source,w,hero))
  var count: int = 6 if hero == "ranger" else 5
  for i in range(count):
   var contact: bool = hero == "crusader" and i >= 3
   var original: Image
   var cleaned: Image
   var canvas: Vector2i = Vector2i(1536,1024) if contact else Vector2i(1024,700)
   var foot: Vector2 = Vector2(768,1024) if contact else Vector2(512,650)
   var offset := Vector2i.ZERO if contact else Vector2i(256,150)
   var fit: Dictionary = {}
   if contact:
    original = raw(dir+"assets/study-contact-"+str(i-3)+"-reference.png")
    cleaned = raw(dir+"assets/study-contact-"+str(i-3)+"-clean.png")
   else:
    original = reference.get_region(Rect2i((i%3)*512,(i/3)*512,512,512))
    cleaned = clean.get_region(Rect2i((i%3)*512,(i/3)*512,512,1024 if hero == "crusader" else 512))
    fit = fits[i]
   var body := repaired(original,cleaned,hero,i,fit)
   var pose: String = "study_contact_"+str(i-3) if contact else "study_execution_"+str(i)
   var body_path: String = dir+"assets/"+pose+"-body.png"
   assert(body.save_png(body_path) == OK)
   var grips: Array = [RANGER[i].grip] if hero == "ranger" else HAMMERS[i].slice(0,2)
   var hands := Image.create(canvas.x,canvas.y,false,Image.FORMAT_RGBA8)
   for grip in grips:
    var area := Rect2i(Vector2i(grip)-Vector2i(11,11),Vector2i(22,22))
    hands.blit_rect(body,area,area.position+offset)
   if hero == "ranger" and RANGER[i].has("draw"):
    var area := Rect2i(Vector2i(RANGER[i].draw)-Vector2i(11,11),Vector2i(22,22))
    hands.blit_rect(body,area,area.position+offset)
   var hands_path: String = dir+"assets/"+pose+"-hands.png"
   assert(hands.save_png(hands_path) == OK)
   for w in range(4):
    var id: String = ClassBuilder.IDS[hero][w]
    var grip: Vector2 = grips[0]+Vector2(offset)
    var pivot: Vector2 = profiles[w].pivot
    var angle: float = float(RANGER[i].angle) if hero == "ranger" else rad_to_deg((grips[1]-grips[0]).angle())
    var factor: float = 0.37 if hero == "ranger" else grips[0].distance_to(HAMMERS[i][2])/650.0
    var weapon: Image = builder.transformed(profiles[w].image,pivot,grip,angle,factor,canvas)
    var transform := Transform2D(deg_to_rad(angle)+PI/2,Vector2.ONE*factor,0,grip)
    if hero == "ranger":
     var a: Vector2 = transform*(profiles[w].tips[0]-pivot)
     var b: Vector2 = transform*(profiles[w].tips[1]-pivot)
     var nock: Vector2 = (a+b)/2
     var draw: bool = RANGER[i].has("draw") and not RANGER[i].get("release",false)
     if draw: nock = RANGER[i].draw+Vector2(offset)
     helper.line(weapon,a,nock,Color("#b9ad92")); helper.line(weapon,nock,b,Color("#b9ad92"))
     if draw:
      var direction: Vector2 = (grip-nock).normalized()
      var tip: Vector2 = grip+direction*30
      helper.line(weapon,nock-direction*14,tip,Color("#d4bd91"))
      for side in [-1,1]:
       helper.line(weapon,tip,tip-direction*9+direction.orthogonal()*side*4,Color("#ccd1d2"))
       helper.line(weapon,nock-direction*10,nock-direction*20+direction.orthogonal()*side*5,Color("#b1a58b"))
    var weapon_path: String = dir+"assets/"+pose+"-"+id+".png"
    assert(weapon.save_png(weapon_path) == OK)
    var axis := Vector2.RIGHT.rotated(deg_to_rad(angle))
    var registered_grips: Array = []
    for hand in grips: registered_grips.append(hand+Vector2(offset))
    records["|".join([hero,"original",id,pose])] = {"hero":hero,"style":"original","weapon_profile":id,"pose":pose,"canvas_size":canvas,"foot":foot,"grips":registered_grips,"weapon_axis":PackedVector2Array([grip-axis*80,grip+axis*650]),"metadata":{"pose_id":hero,"body_height_pixels":350.4 if hero == "ranger" else 322.7,"idle_pixel_height":float(canvas.y),"hit_point":foot-Vector2(0,220),"emitter_point":grip,"study_source_scale":1.0 if contact else 0.8 if hero == "ranger" else 0.7},"layers":[{"path":body_path,"offset":offset,"role":"body"},{"path":weapon_path,"offset":Vector2i.ZERO,"role":"front_weapon"},{"path":hands_path,"offset":Vector2i.ZERO,"role":"hands"}]}
  var file := FileAccess.open(dir+"frames.gd.tmp",FileAccess.WRITE)
  file.store_string("extends RefCounted\n## Generated registered weapon records.\nstatic var RECORDS: Dictionary = str_to_var(\"\"\""+var_to_str(records)+"\"\"\")\n")
  file.close()
  assert(DirAccess.rename_absolute(dir+"frames.gd.tmp",dir+"frames.gd") == OK)
 builder.free(); helper.free()
 print("PASS: prepared all catalog weapons for fixed-outfit experimental Ranger and Witch Hunter execution studies")
 quit()
