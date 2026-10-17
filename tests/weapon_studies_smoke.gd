extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var victims: Dictionary = {}
 for hero in ["ranger","crusader"]:
  var script = load("res://experimental/ranger_showcase/showcase.gd" if hero == "ranger" else "res://experimental/witch_hunter/execution/showcase.gd")
  var ids: Array = ["ranger_bow","ranger_epic","ranger_venombow","ranger_legend"] if hero == "ranger" else ["crusader_axe","crusader_epic","crusader_unique","crusader_legend"]
  for id in ids:
   var study = script.new()
   study.source_weapon_id = id
   root.add_child(study)
   study.set_process(false)
   var sources: Array = study.source_frames if hero == "ranger" else study.sources
   assert(sources.size() == (6 if hero == "ranger" else 3))
   for frame in sources: assert(frame.get_meta("weapon_id","") == id,"Study source phases must match the configured weapon")
   var targets: Array = study.target_frames if hero == "ranger" else study.targets
   var hashes: Array = []
   for target in targets: hashes.append(hash(target.get_image().get_data()))
   hashes.append(hash(study.cleaver.get_image().get_data()))
   if not victims.has(hero): victims[hero] = hashes
   assert(hashes == victims[hero],"Weapon selection cannot change target-collapse frames or the dropped cleaver")
   if hero == "crusader":
    for contact in study.contacts: assert(contact.get_meta("weapon_id","") == id)
   else:
    for frame in study.bow_frames.values(): assert(frame.get_meta("weapon_id","") == id)
   study.source_weapon_id = ids[0] if id != ids[0] else ids[3]
   assert(study.locked_weapon_id == id,"A running study freezes its configured weapon")
   for frame in sources: assert(frame.get_meta("weapon_id") == id)
   study.free()
   await process_frame
 print("PASS: original-outfit Ranger/Witch Hunter studies accept every class weapon with frozen source identity and unchanged victim/cleaver data")
 quit()
