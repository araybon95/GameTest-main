extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func image_file(path: String, color: Color, dot: bool = false) -> void:
 var image := Image.create(3,3,false,Image.FORMAT_RGBA8)
 image.fill(Color.TRANSPARENT if dot else color)
 if dot: image.set_pixel(1,1,color)
 assert(image.save_png(path) == OK)
func run() -> void:
 if not ResourceLoader.exists("res://scripts/weapon_visuals.gd"):
  print("FAIL: missing weapon texture compositor")
  quit(1)
  return
 var visual = load("res://scripts/weapon_visuals.gd")
 var manifest = load("res://assets/art_library/weapons/manifest.gd")
 image_file("user://body.png",Color.BLUE)
 image_file("user://weapon.png",Color.GREEN,true)
 image_file("user://hands.png",Color.RED,true)
 var record := {"hero":"warden","style":"original","weapon_profile":"warden_sword","pose":"idle","canvas_size":Vector2i(3,3),"foot":Vector2(1,3),"grips":[Vector2(1,1)],"weapon_axis":PackedVector2Array([Vector2(1,1),Vector2(1,0)]),"metadata":{"pose_id":"warden","party_build":"warden","body_height_pixels":3.0,"idle_pixel_height":3.0,"hit_point":Vector2(1,1),"emitter_point":Vector2(2,1)},"layers":[{"path":"user://body.png","offset":Vector2i.ZERO,"role":"body"},{"path":"user://weapon.png","offset":Vector2i.ZERO,"role":"front_weapon"},{"path":"user://hands.png","offset":Vector2i.ZERO,"role":"hands"}]}
 manifest.frames["warden|original|warden_sword|idle"] = record
 var original_equipment: Dictionary = State.equipment.duplicate(true)
 State.equipment.clear()
 State.equipment_appearance = true
 var texture: Texture2D = visual.frame(State,"warden","original","idle")
 assert(texture != null)
 assert(texture.get_image().get_pixel(0,0) == Color.BLUE)
 assert(texture.get_image().get_pixel(1,1) == Color.RED,"Foreground gauntlet must occlude the weapon")
 assert(texture.get_meta("foot_anchor") == Vector2(1,3) and texture.get_meta("emitter_point") == Vector2(2,1))
 assert(texture.get_meta("body_height_pixels") == 3.0 and texture.get_meta("weapon_id") == "warden_sword")
 assert(visual.frame(State,"warden","original","idle") == texture,"Identical requests reuse a composed texture")
 var legendary: Dictionary = record.duplicate(true)
 legendary.weapon_profile = "warden_legend"
 manifest.frames["warden|original|warden_legend|idle"] = legendary
 var other: Texture2D = visual.frame(State,"warden","original","idle","warden_legend")
 assert(other != texture and other.get_meta("weapon_id") == "warden_legend")
 assert(other.get_meta("foot_anchor") == texture.get_meta("foot_anchor"))
 var alternate: Dictionary = record.duplicate(true)
 alternate.style = "alternate"
 manifest.frames["warden|alternate|warden_sword|idle"] = alternate
 assert(visual.frame(State,"warden","alternate","idle") != texture)
 assert(visual.frame(State,"warden","original","idle","warden_armor") == texture,"Armor preview must not masquerade as a weapon choice")
 State.Items.histories["visual-copy"] = {"base":"warden_legend","name":"A named oath"}
 assert(visual.frame(State,"warden","original","idle","visual-copy") == other)
 State.Items.histories.erase("visual-copy")
 manifest.frames["warden|original|warden_sword|guard"] = record.duplicate(true)
 assert(visual.frame(State,"warden","original","guard") == null,"Manifest identity must match its lookup key")
 assert(visual.coverage_errors("warden","original").any(func(message): return "identity" in message.to_lower()),"Coverage gate must reject a mislabeled pose too")
 var broken: Dictionary = record.duplicate(true)
 broken.pose = "attack"
 broken.layers.pop_back()
 manifest.frames["warden|original|warden_sword|attack"] = broken
 assert(visual.frame(State,"warden","original","attack") == null,"Missing hands cannot silently fall back")
 broken.layers.append({"path":"user://absent-layer.png","offset":Vector2i.ZERO,"role":"hands"})
 assert(visual.frame(State,"warden","original","attack") == null)
 assert(not visual.coverage_errors("warden","original").is_empty())
 manifest.frames.clear()
 visual.clear_cache()
 State.equipment = original_equipment
 print("PASS: weapon composition layer order, fixed registration, metadata, copy resolution, cache isolation and explicit missing-pose rejection")
 quit()
