extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize(): call_deferred("run")
func run():
 State.progress_loaded = true
 State.progress_path = "user://dungeon-entrance.cfg"
 State.map_travel_mode = true
 State.select_expedition("old_road")
 State.start_run(42)
 var dungeon = load("res://scenes/expedition/dungeon.tscn").instantiate()
 root.add_child(dungeon)
 await process_frame
 assert(dungeon.has_node("EntranceGate"),"New journeys begin in an interactive entrance chamber")
 assert(not dungeon.has_node("RouteMap"))
 var before: Dictionary = {"position":State.room_position,"gold":State.gold,"rations":State.journey.rations,"rng":State.loot_rng.state}
 for id in State.party:
  var image: TextureRect = dungeon.get_node("Party_"+id)
  assert(image.texture.get_meta("standing_pose",false))
 dungeon.get_node("EntranceGate").pressed.emit()
 assert(dungeon.has_node("RouteMap") and not dungeon.has_node("EntranceGate"))
 assert(before.position == State.room_position and before.gold == State.gold and before.rations == State.journey.rations and before.rng == State.loot_rng.state,"Opening map does not travel or spend resources")
 dungeon.show_entrance()
 assert(dungeon.has_node("EntranceGate"))
 dungeon.open_route_map()
 for id in State.party: assert(dungeon.get_node("Party_"+id).texture.get_meta("standing_pose",false))
 State.room_position = Vector2i.RIGHT
 State.floors[0][Vector2i.RIGHT] = {"kind":"chamber","cleared":true,"seen":true}
 dungeon.show_entrance()
 assert(dungeon.has_node("RouteMap"),"Entrance is not shown in unrelated rooms")
 dungeon.free()
 print("PASS: interactive grimdark entrance, standing party, map access without movement and entry-only routing")
 quit()
