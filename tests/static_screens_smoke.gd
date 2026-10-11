extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Art = preload("res://scripts/static_screen_art.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.completed_expeditions.assign(["restore_workshop","infested_apothecary","old_road","path_beast"])
 State.party.assign(["warden","ranger","occultist"])
 var rng := State.loot_rng.state
 var gold := State.gold
 var completed := State.completed_expeditions.duplicate()
 var runtime := root.get_node("GameSettings")
 for entry in [["barracks","barracks"],["forge","forge"],["bestiary","chapel"],["apothecary","apothecary"],["customization","workshop"]]:
  var screen = load("res://scenes/hub/%s.tscn" % entry[0]).instantiate()
  root.add_child(screen)
  await process_frame
  await process_frame
  var interior = screen.get_node("StaticInterior")
  assert(interior.kind == entry[1] and interior.restored)
  assert(interior.mouse_filter == Control.MOUSE_FILTER_IGNORE)
  assert(interior.get_node("Attendant").mouse_filter == Control.MOUSE_FILTER_IGNORE)
  assert(interior.get_node("InteriorBackground").texture != null)
  assert(interior.attendant.size.is_equal_approx(interior.npc_rect.size))
  if entry[0] != "apothecary": assert(interior.has_node("EarnedRelic_0"))
  assert(interior.progress_marks().size() >= 2)
  var position: Vector2 = interior.attendant.position
  runtime.ambient_motion = false
  interior._process(0.1)
  position = interior.attendant.position
  interior._process(0.5)
  assert(interior.attendant.position == position,"Reduced motion leaves attendant stationary")
  runtime.ambient_motion = true
  assert(screen.has_meta("static_entrance"))
  if entry[0] == "apothecary":
   screen.refresh()
   assert(not screen.has_node("EntranceCurtain"),"Transactions do not replay entrance")
  screen.queue_free()
  await process_frame
 State.pending_service = "workshop"
 var workshop = load("res://scenes/hub/restoration.tscn").instantiate()
 root.add_child(workshop)
 await process_frame
 assert(workshop.get_node("StaticInterior").restored)
 workshop.queue_free()
 await process_frame
 var region = load("res://scenes/expedition/region_select.tscn").instantiate()
 root.add_child(region)
 await process_frame
 await process_frame
 assert(region.get_node("DungeonDossier").get_meta("floor_count") == 3)
 assert(region.get_node("DungeonDossier/EntrancePlate").size == Vector2(435,150))
 for i in range(3): assert(region.get_node("DungeonDossier/FloorSummary_%d" % i).text.contains(["I","II","III"][i]))
 assert(region.get_node("Expedition_village/LocationHalo").completed)
 region.choose(1,1)
 await process_frame
 assert(region.get_node("Dungeon_path_lament/DungeonSeal").sealed)
 assert(region.get_node("EmbarkButton").disabled)
 assert(region.get_node("Expedition_path/LocationHalo").selected)
 assert(State.gold == gold and State.completed_expeditions == completed and State.loot_rng.state == rng)
 print("PASS: distinct interiors, attendants, earned relics, reduced motion, quiet shop refresh, dossiers/seals and unchanged progression/gold/RNG")
 quit()
