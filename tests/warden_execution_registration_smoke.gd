extends SceneTree
const Execution = preload("res://scenes/combat/warden_execution.gd")
func _initialize() -> void: call_deferred("run")
func mapped(rect: Rect2, texture: Texture2D, point: Vector2) -> Vector2:
 return rect.position+point*rect.size/texture.get_size()
func run() -> void:
 var actor := Execution.new()
 root.add_child(actor)
 for motion in [true,false]:
  var before: Dictionary = actor.frame_layout(0.94,motion)
  var contact: Dictionary = actor.frame_layout(1.079,motion)
  var after: Dictionary = actor.frame_layout(1.08,motion)
  # Manual source landmarks: tolerance covers the native painted sole edges,
  # not a generic motion score. The old jump was 130–199 display pixels.
  for pair in [[Vector2(149,926),Vector2(55,310)],[Vector2(789,916),Vector2(300,307)]]:
   var a := mapped(contact.pair,Execution.contact,pair[0])
   var b := mapped(after.body,Execution.bodies[3],pair[1])
   assert(a.distance_to(b)*1.15 < 8.0,"Both soles must stay registered across contact/follow-through")
  var windup := mapped(before.body,Execution.bodies[2],Execution.WINDUP_SOLES)
  var impact := mapped(contact.pair,Execution.contact,Execution.CONTACT_SOLES)
  assert(windup.distance_to(impact) < 0.1,"Windup must reach the shared impact stance before the strike")
  assert(before.weapon_transform.is_equal_approx(contact.weapon_transform),"The dropped cleaver cannot teleport at contact")
  for endpoints in [[Execution.KNEEL_BLADE,Execution.CRUSHED_BLADE],[Execution.KNEEL_HANDLE,Execution.CRUSHED_HANDLE]]:
   var prop_point: Vector2 = contact.weapon_transform*(endpoints[0]-Vector2(Execution.WEAPON_REGION.position))
   var painted_point := mapped(after.target,Execution.targets[3],endpoints[1])
   assert(prop_point.distance_to(painted_point) < 0.1,"Both blade and handle must meet the actually drawn follow-through weapon")
  assert(contact.paired and not after.paired,"Keep the approved 0.13 second contact hold")
  for tick in range(144):
   var frame: Dictionary = actor.frame_layout(float(tick)/60.0,motion)
   for key in ["body","target","pair"]:
    var rect: Rect2 = frame[key]
    assert(rect.position.y >= 0 and rect.end.y < 420,"Execution artwork must remain above the HUD")
 var prop: Image = Execution.dropped_weapon.get_image()
 assert(prop.get_size() == Execution.WEAPON_REGION.size)
 assert(prop.get_pixel(130,20).a > 0.1,"The persistent floor prop must include the cleaver handle")
 assert(prop.get_pixel(144,0).a == 0.0,"Finger pixels stay attached to the hand, not the dropped weapon")
 assert(Execution.targets[2].get_image().get_pixel(130,274).a == 0.0,"Kneeling body must not duplicate the separate weapon")
 actor.free()
 await process_frame
 print("PASS: registered impact/follow-through soles, stable complete dropped cleaver, both motion modes and battlefield bounds")
 quit()
