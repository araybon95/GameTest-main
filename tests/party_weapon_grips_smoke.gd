extends SceneTree
const Model = preload("res://scripts/party_weapon_model.gd")
func _initialize(): call_deferred("run")
func run():
 var model = Model.new()
 root.add_child(model)
 for hero in Model.WEAPONS:
  model.hero_id = hero
  for id in Model.WEAPONS[hero]:
   model.configure("original",id)
   var pixels: Image = model.weapon.texture.get_image()
   var grip: Vector2i = Vector2i(-model.weapon.offset)
   for dy in [-12,0,12]:
    assert(pixels.get_pixelv(grip+Vector2i(0,dy)).a > 0.9,"%s: fingers must wrap around an opaque continuous handle, not empty space or a decoration" % id)
   if hero != "ranger":
    for y in range(350,801,50):
     assert(pixels.get_pixel(grip.x,y).a > 0.9,"%s: one uninterrupted straight shaft axis must connect head mounting, grip and pommel" % id)
   else:
    var spec: Dictionary = model.profiles.ranger.weapons[Model.WEAPONS.ranger.find(id)]
    for anchor in ["top","bottom"]:
     assert(pixels.get_pixelv(Vector2i(model._point(spec[anchor]))).a > 0.9,"%s: bowstring must attach to a solid limb tip" % id)
  if hero == "ranger":
   for outfit in ["original","alternate","relic"]:
    model.configure(outfit,"ranger_bow")
    model.set_pose("attack")
    var shaft: Line2D = model.arrow.get_child(0)
    assert(absf(shaft.points[0].y-shaft.points[1].y) < 0.01,"Nocked arrow must run level above the grip, not through the gripping fingers")
    assert(shaft.points[1].y < model.weapon.position.y-5,"Arrow rests above the hand")
 model.free()
 print("PASS: Twelve opaque grips, straight staff/mace shaft axes and level arrows above holding fingers")
 quit()
