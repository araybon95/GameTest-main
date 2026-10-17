extends SceneTree
const ROOT = "res://experimental/weapon_swapping/warden/assets/"
const Builder = preload("res://experimental/weapon_swapping/warden/prepare_execution.gd")
const IDS = ["warden_sword","warden_legend","warden_epic","warden_frostblade"]
const GRIPS = {
 "alternate":[Vector2(222,348),Vector2(144,305),Vector2(297,67),Vector2(335,338),Vector2(219,300)],
 "relic":[Vector2(195,335),Vector2(133,294),Vector2(236,99),Vector2(345,297),Vector2(210,271)],
 "ashen_wolf":[Vector2(211,334),Vector2(126,287),Vector2(230,77),Vector2(359,323),Vector2(222,267)]
}
func _initialize() -> void: call_deferred("run")
func raw(path: String) -> Image:
 var image := Image.new()
 assert(image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) == OK)
 return image
func sole(image: Image) -> Vector2:
 var bottom: int = -1
 for y in range(image.get_height()-1,-1,-1):
  for x in range(image.get_width()):
   if image.get_pixel(x,y).a > 0.75: bottom = y; break
  if bottom >= 0: break
 assert(bottom >= 0)
 var left: int = image.get_width()
 var right: int = 0
 for y in range(maxi(0,bottom-10),bottom+1):
  for x in range(image.get_width()):
   if image.get_pixel(x,y).a > 0.75: left = mini(left,x); right = maxi(right,x)
 return Vector2((left+right)/2.0,bottom+1)
func run() -> void:
 var builder = Builder.new()
 var records: Dictionary = load("res://experimental/weapon_swapping/warden/frames.gd").RECORDS.duplicate(true)
 var source := raw(ROOT+"sword-source.png")
 var extra := raw(ROOT+"catalog-sword-source.png")
 var swords: Array[Image] = [source.get_region(Rect2i(335,10,300,1000)),source.get_region(Rect2i(900,10,305,1000)),extra.get_region(Rect2i(335,10,300,1000)),extra.get_region(Rect2i(900,10,305,1000))]
 var canvas := Vector2i(768,700)
 var foot := Vector2(350,650)
 var registration: Dictionary = {}
 for style in ["alternate","relic","ashen_wolf"]:
  var sheet := raw(ROOT+style+"-execution-source.png")
  assert(sheet.get_size() == Vector2i(1536,1024))
  registration[style] = []
  for i in range(5):
   var body := sheet.get_region(Rect2i((i%3)*512,(i/3)*512,512,512))
   var local_foot := sole(body)
   var offset := Vector2i(foot-local_foot)
   var grip: Vector2 = GRIPS[style][i]+Vector2(offset)
   registration[style].append({"foot":[local_foot.x,local_foot.y],"grip":[GRIPS[style][i].x,GRIPS[style][i].y]})
   var body_path: String = ROOT+style+"-execution_"+str(i)+"-body.png"
   assert(body.save_png(body_path) == OK)
   var hand_area := Rect2i(Vector2i(GRIPS[style][i])-Vector2i(20,18),Vector2i(40,36))
   var hands_path: String = ROOT+style+"-execution_"+str(i)+"-hands.png"
   assert(body.get_region(hand_area).save_png(hands_path) == OK)
   for w in range(4):
    var pose: String = "execution_"+str(i)
    var path: String = ROOT+style+"-"+pose+"-"+IDS[w]+".png"
    var angle: float = [27.0,32.0,-42.0,35.0,30.0][i]
    assert(builder.transformed(swords[w],Vector2(151 if w%2 else 149,825),grip,angle,0.22,canvas).save_png(path) == OK)
    var temp: Dictionary = {}
    builder.save_record(temp,IDS[w],pose,body_path,offset,hands_path,offset+hand_area.position,path,foot,grip,grip+Vector2.RIGHT.rotated(deg_to_rad(angle))*180,canvas)
    var entry: Dictionary = temp.values()[0]
    entry.style = style
    entry.metadata["warden_outfit"] = style
    records["warden|"+style+"|"+IDS[w]+"|"+pose] = entry
  var contact := raw(ROOT+style+"-contact-source.png")
  var original := raw(ROOT+"execution-contact-body.png")
  # Use the established transparent silhouette to exclude generated backdrop haze
  # and retain exact original sole/cloth/shield registration.
  for y in range(contact.get_height()):
   for x in range(880):
    var color: Color = contact.get_pixel(x,y)
    color.a *= original.get_pixel(x,y).a
    contact.set_pixel(x,y,color)
  # Keep the original victim and impact artwork pixel-for-pixel.
  contact.blit_rect(original,Rect2i(880,0,656,1024),Vector2i(880,0))
  var body_path: String = ROOT+style+"-execution-contact-body.png"
  assert(contact.save_png(body_path) == OK)
  var hands_path: String = ROOT+style+"-execution-contact-hands.png"
  assert(contact.get_region(Rect2i(720,340,65,65)).save_png(hands_path) == OK)
  for w in range(4):
   var path: String = ROOT+style+"-execution-contact-"+IDS[w]+".png"
   assert(builder.transformed(swords[w],Vector2(151 if w%2 else 149,825),Vector2(750,380),11,0.41,contact.get_size()).save_png(path) == OK)
   var temp: Dictionary = {}
   builder.save_record(temp,IDS[w],"execution_contact",body_path,Vector2i.ZERO,hands_path,Vector2i(720,340),path,Vector2(492,928),Vector2(750,380),Vector2(1078,444),contact.get_size())
   var entry: Dictionary = temp.values()[0]
   entry.style = style
   entry.metadata["warden_outfit"] = style
   records["warden|"+style+"|"+IDS[w]+"|execution_contact"] = entry
 var output := FileAccess.open("res://experimental/weapon_swapping/warden/frames.gd",FileAccess.WRITE)
 output.store_string("extends RefCounted\n## Registered Warden catalog records; publication remains gated.\nstatic var RECORDS: Dictionary = str_to_var(\"\"\""+var_to_str(records)+"\"\"\")\n")
 var reg := FileAccess.open(ROOT+"style-execution-registration.json",FileAccess.WRITE)
 reg.store_string(JSON.stringify(registration,"  ")+"\n")
 builder.free()
 print("PASS: assembled all Warden outfit execution and contact layers with retained original target artwork")
 quit()
