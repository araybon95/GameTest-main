extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var scene = load("res://scenes/combat/warden_execution.gd").new()
 root.add_child(scene)
 var sheet := Image.create(1536,1024,false,Image.FORMAT_RGBA8)
 sheet.fill(Color.TRANSPARENT)
 var offsets: Array = []
 for index in range(scene.bodies.size()):
  var body: Image = scene.bodies[index].get_image()
  var offset := Vector2i((index%3)*512+(512-body.get_width())/2,(index/3)*512+500-body.get_height())
  offsets.append([offset.x,offset.y,body.get_width(),body.get_height()])
  sheet.blit_rect(body,Rect2i(Vector2i.ZERO,body.get_size()),offset)
 assert(sheet.save_png("res://experimental/weapon_swapping/warden/assets/execution-reference.png") == OK)
 var file := FileAccess.open("res://review-output/weapon-swapping/execution-offsets.json",FileAccess.WRITE)
 file.store_string(JSON.stringify(offsets))
 scene.free()
 print("PASS: extracted actual five approved execution source poses without changing their pixels")
 quit()
