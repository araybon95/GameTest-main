extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://depth_supplies_test.cfg"
 State.select_expedition("old_road")
 State.start_run(5)
 State.inventory.clear()
 var room: Dictionary = {"kind":"event","event_id":"bandit_strongbox","event_seed":5,"cleared":false,"seen":true}
 State.floors[0][Vector2i.ZERO] = room
 assert(State.Events.resolve(State,"warden",false,"supply").is_empty())
 State.add_item("lock_tools")
 var result: Dictionary = State.Events.resolve(State,"warden",false,"supply")
 assert(not result.is_empty() and result["status"] == "")
 assert(result["gold"] > 0 or not result["item"].is_empty())
 assert(not State.inventory.has("lock_tools") and State.Events.resolve(State,"warden",false,"supply").is_empty())
 State.floors[0][Vector2i.ZERO] = {"kind":"event","event_id":"crusader_coffin","event_seed":5,"cleared":false,"seen":true}
 State.crusader_unlocked = false
 State.add_item("bandage")
 var before: int = State.run_heroes["warden"]["hp"]
 result = State.Events.resolve(State,"warden",false,"supply")
 assert(State.crusader_unlocked and result["damage"] == 1 and State.run_heroes["warden"]["hp"] == before - 1)
 assert(not State.inventory.has("bandage"))
 State.gold = 10
 assert(State.purchase_item("trail_food") and State.gold == 8)
 assert(not State.apply_potion("warden","trail_food",State.run_heroes))
 change_scene_to_file("res://scenes/expedition/preparation.tscn")
 await process_frame
 await process_frame
 assert(current_scene.get_child_count() > 20)
 DirAccess.remove_absolute(State.progress_path)
 print("PASS: provision buying, safe guaranteed event outcomes, coffin bandaging and preparation UI")
 quit()
