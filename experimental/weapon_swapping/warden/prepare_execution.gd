extends SceneTree
## Registers only the generated repair patches; original bodies remain unchanged elsewhere.
const ROOT = "res://experimental/weapon_swapping/warden/assets/"
const GRIPS = [Vector2(225,348),Vector2(145,306),Vector2(220,117),Vector2(336,357),Vector2(217,321)]
const ANGLES = [27.0,32.0,-42.0,35.0,30.0]
const MASKS = [
 [Vector2(185,320),Vector2(247,320),Vector2(386,360),Vector2(386,446),Vector2(278,446),Vector2(185,373)],
 [Vector2(106,279),Vector2(165,279),Vector2(269,320),Vector2(269,400),Vector2(172,400),Vector2(105,333)],
 [Vector2(146,71),Vector2(289,0),Vector2(350,20),Vector2(350,106),Vector2(236,168),Vector2(146,168)],
 [Vector2(305,319),Vector2(372,319),Vector2(512,383),Vector2(512,512),Vector2(400,512),Vector2(305,385)],
 [Vector2(188,291),Vector2(248,291),Vector2(395,353),Vector2(395,466),Vector2(288,466),Vector2(188,353)]
]
func _initialize() -> void: call_deferred("run")
func read_image(path: String) -> Image:
 return load(path).get_image() if ResourceLoader.exists(path) else Image.load_from_file(path)
func transformed(source: Image, pivot: Vector2, grip: Vector2, angle: float, scale_factor: float, canvas: Vector2i) -> Image:
 var result := Image.create(canvas.x,canvas.y,false,Image.FORMAT_RGBA8)
 result.fill(Color.TRANSPARENT)
 var transform := Transform2D(deg_to_rad(angle)+PI/2,Vector2.ONE*scale_factor,0,grip)
 var inverse: Transform2D = transform.affine_inverse()
 for y in range(canvas.y):
  for x in range(canvas.x):
   var point: Vector2 = inverse*Vector2(x+0.5,y+0.5)+pivot
   var sx: int = int(floor(point.x))
   var sy: int = int(floor(point.y))
   if sx >= 0 and sy >= 0 and sx < source.get_width() and sy < source.get_height(): result.set_pixel(x,y,source.get_pixel(sx,sy))
 return result
func save_record(records: Dictionary, id: String, pose: String, body_path: String, body_offset: Vector2i, hands_path: String, hands_offset: Vector2i, weapon_path: String, foot: Vector2, grip: Vector2, axis: Vector2, canvas: Vector2i) -> void:
 records["warden|original|"+id+"|"+pose] = {"hero":"warden","style":"original","weapon_profile":id,"pose":pose,"canvas_size":canvas,"foot":foot,"grips":[grip],"weapon_axis":PackedVector2Array([grip,axis]),"metadata":{"pose_id":"warden","body_height_pixels":479.0,"idle_pixel_height":float(canvas.y),"hit_point":foot+Vector2(0,-290),"emitter_point":grip,"experimental_weapon":true},"layers":[{"path":body_path,"offset":body_offset,"role":"body"},{"path":weapon_path,"offset":Vector2i.ZERO,"role":"front_weapon"},{"path":hands_path,"offset":hands_offset,"role":"hands"}]}
func run() -> void:
 var original: Image = read_image(ROOT+"execution-reference.png")
 var clean: Image = read_image(ROOT+"execution-clean-source.png")
 var alignment: Array = JSON.parse_string(FileAccess.get_file_as_string(ROOT+"execution-registration.json"))
 var offsets: Array = JSON.parse_string(FileAccess.get_file_as_string(ROOT+"execution-offsets.json"))
 var source: Image = read_image(ROOT+"sword-source.png")
 var swords: Array[Image] = [source.get_region(Rect2i(335,10,300,1000)),source.get_region(Rect2i(900,10,305,1000))]
 var pivots := [Vector2(149,825),Vector2(151,825)]
 var ids := ["warden_sword","warden_legend"]
 var records: Dictionary = load("res://experimental/weapon_swapping/warden/frames.gd").RECORDS.duplicate(true)
 var canvas := Vector2i(768,700)
 var foot := Vector2(350,650)
 for i in range(5):
  var cell := Vector2i((i%3)*512,(i/3)*512)
  var body: Image = original.get_region(Rect2i(cell,Vector2i(512,512)))
  var repair: Image = clean.get_region(Rect2i(cell,Vector2i(512,512)))
  var polygon := PackedVector2Array(MASKS[i])
  var transform := Transform2D(0,Vector2.ONE*float(alignment[i].scale),0,Vector2(float(alignment[i].translation[0]),float(alignment[i].translation[1])))
  var inverse: Transform2D = transform.affine_inverse()
  for y in range(512):
   for x in range(512):
    if not Geometry2D.is_point_in_polygon(Vector2(x,y),polygon): continue
    var point: Vector2i = Vector2i(inverse*Vector2(x,y))
    if point.x >= 0 and point.y >= 0 and point.x < 512 and point.y < 512: body.set_pixel(x,y,repair.get_pixelv(point))
  var body_path: String = ROOT+"execution_"+str(i)+"-body.png"
  assert(body.save_png(body_path) == OK)
  var dimensions := Vector2(float(offsets[i][2]),float(offsets[i][3]))
  var sole: Vector2 = dimensions*Vector2(0.5,1.0)
  if i == 2: sole = Vector2(200,458)
  if i == 3: sole = Vector2(177.5,310)
  if i == 4: sole = Vector2(175,374)
  var reference_sole := Vector2(float(offsets[i][0])-cell.x,float(offsets[i][1])-cell.y)+sole
  var body_offset := Vector2i(foot-reference_sole)
  var grip: Vector2 = GRIPS[i]+Vector2(body_offset)
  var hand_area := Rect2i(Vector2i(GRIPS[i])-Vector2i(25,22),Vector2i(50,44))
  var hands_path: String = ROOT+"execution_"+str(i)+"-hands.png"
  assert(body.get_region(hand_area).save_png(hands_path) == OK)
  for w in range(2):
   var path: String = ROOT+"execution_"+str(i)+"-"+ids[w]+".png"
   assert(transformed(swords[w],pivots[w],grip,ANGLES[i],0.22,canvas).save_png(path) == OK)
   save_record(records,ids[w],"execution_"+str(i),body_path,body_offset,hands_path,body_offset+hand_area.position,path,foot,grip,grip+Vector2.RIGHT.rotated(deg_to_rad(ANGLES[i]))*180,canvas)
 var contact: Image = read_image("res://assets/art_library/executions/warden/contact.png")
 var contact_clean: Image = read_image(ROOT+"contact-clean-source.png")
 var shaft_mask := PackedVector2Array([Vector2(652,310),Vector2(791,310),Vector2(1032,380),Vector2(1032,510),Vector2(653,427)])
 for y in range(contact.get_height()):
  for x in range(contact.get_width()):
   if Geometry2D.is_point_in_polygon(Vector2(x,y),shaft_mask) or Vector2(x,y).distance_squared_to(Vector2(1055,445)) < 115.0*115.0: contact.set_pixel(x,y,contact_clean.get_pixel(x,y))
 var contact_path: String = ROOT+"execution-contact-body.png"
 assert(contact.save_png(contact_path) == OK)
 var contact_hand := Rect2i(705,330,90,100)
 var contact_hands: String = ROOT+"execution-contact-hands.png"
 assert(contact.get_region(contact_hand).save_png(contact_hands) == OK)
 for w in range(2):
  var path: String = ROOT+"execution-contact-"+ids[w]+".png"
  assert(transformed(swords[w],pivots[w],Vector2(750,380),11,0.41,contact.get_size()).save_png(path) == OK)
  save_record(records,ids[w],"execution_contact",contact_path,Vector2i.ZERO,contact_hands,contact_hand.position,path,Vector2(492,928),Vector2(750,380),Vector2(1078,444),contact.get_size())
 var output := FileAccess.open("res://experimental/weapon_swapping/warden/frames.gd",FileAccess.WRITE)
 output.store_string("extends RefCounted\n## Generated experimental records; production class gates remain disabled.\nstatic var RECORDS: Dictionary = str_to_var(\"\"\""+var_to_str(records)+"\"\"\")\n")
 print("PASS: prepared five registered execution poses and contact pair for each sword, retaining original body pixels outside weapon masks")
 quit()
