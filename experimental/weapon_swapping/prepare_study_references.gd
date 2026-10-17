extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
 for hero in ["ranger","crusader"]:
  var path: String = "res://experimental/ranger_showcase/showcase.gd" if hero == "ranger" else "res://experimental/witch_hunter/execution/showcase.gd"
  var study = load(path).new()
  study.reference_only = true
  root.add_child(study)
  study.set_process(false)
  study.hide()
  var textures: Array = study.source_frames if hero == "ranger" else study.sources
  var factor: float = 0.8 if hero == "ranger" else 0.7
  var sheet := Image.create(1536,1024,false,Image.FORMAT_RGBA8)
  sheet.fill(Color.TRANSPARENT)
  var metadata: Array = []
  for i in range(textures.size()):
   var image: Image = textures[i].get_image()
   if hero == "ranger" and i in [3,4]: image.fill_rect(Rect2i(0,0,image.get_width(),8 if i == 3 else 7),Color.TRANSPARENT)
   var old_size: Vector2i = image.get_size()
   image.resize(roundi(old_size.x*factor),roundi(old_size.y*factor),Image.INTERPOLATE_LANCZOS)
   var cell := Vector2i((i%3)*512,(i/3)*512)
   var offset := cell+Vector2i(256-image.get_width()/2,500-image.get_height())
   sheet.blit_rect(image,Rect2i(Vector2i.ZERO,image.get_size()),offset)
   metadata.append({"scale":factor,"original_size":[old_size.x,old_size.y]})
  var dir: String = "res://experimental/weapon_swapping/"+hero+"/assets/"
  assert(sheet.save_png(dir+"study-source-reference.png") == OK)
  if hero == "crusader":
   for i in range(2):
    var image: Image = study.contacts[i].get_image()
    var pair := Image.create(1536,1024,false,Image.FORMAT_RGBA8)
    pair.fill(Color.TRANSPARENT)
    pair.blit_rect(image,Rect2i(Vector2i.ZERO,image.get_size()),Vector2i((1536-image.get_width())/2,1024-image.get_height()))
    assert(pair.save_png(dir+"study-contact-"+str(i)+"-reference.png") == OK)
  var file := FileAccess.open("res://experimental/weapon_swapping/"+hero+"/study-registration.json",FileAccess.WRITE)
  file.store_string(JSON.stringify(metadata,"  ")+"\n")
  study.free()
 print("PASS: extracted original standalone execution source/contact geometry, leaving victim/timeline assets untouched")
 quit()
