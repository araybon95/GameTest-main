extends SceneTree
const Items = preload("res://scripts/item_data.gd")
func _initialize() -> void:
 var visual = load("res://scripts/weapon_visuals.gd")
 var manifest = load("res://assets/art_library/weapons/manifest.gd")
 for hero in ["ranger","crusader","occultist"]:
  for style in ["original","alternate","relic"]:
   var errors: Array = visual.coverage_errors(hero,style)
   assert(errors.is_empty(),hero+"/"+style+": "+str(errors.slice(0,2)))
   var bodies: Dictionary = {}
   var reference_foot: Vector2
   for weapon in Items.EQUIPMENT:
    var item: Dictionary = Items.EQUIPMENT[weapon]
    if item.get("hero","") != hero or item.get("slot","") != "weapon": continue
    var frame: Texture2D = visual._frame_for_weapon(hero,style,"idle",weapon)
    assert(frame != null and frame.get_meta("weapon_id") == weapon)
    if reference_foot == Vector2.ZERO: reference_foot = frame.get_meta("foot_anchor")
    assert(frame.get_meta("foot_anchor") == reference_foot,"Weapon selection cannot move the body sole")
    for pose in manifest.POSES:
     var entry: Dictionary = manifest.frames["|".join([hero,style,weapon,pose])]
     var body_layers: Array = entry.layers.filter(func(layer): return layer.role == "body" or layer.role == "hands")
     var registration: Array = [body_layers,entry.foot,entry.metadata.body_height_pixels]
     if not bodies.has(pose): bodies[pose] = registration
     assert(bodies[pose] == registration,"Weapon selection must preserve exact body/hand layers and body registration")
     if hero == "crusader" and pose in ["attack","windup","cast"]:
      assert(entry.grips.size() >= 2,"Hammer action frames need two registered hands")
      for grip in entry.grips:
       assert(grip.distance_to(Geometry2D.get_closest_point_to_segment(grip,entry.weapon_axis[0],entry.weapon_axis[1])) < 2,"Both hands must align on the same straight shaft")
 print("PASS: all remaining class catalog/style/context coverage, fixed body registration and two-handed hammer geometry")
 quit()
