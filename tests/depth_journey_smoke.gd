extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 await process_frame
 await process_frame
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://depth_journey_test.cfg"
 Saves.directory = "user://depth_journey_saves/"
 State.select_expedition("old_road")
 State.start_run(93)
 State.run_heroes["warden"]["hp"] = 10
 for i in range(6): State.Depth.explore(State,{})
 assert(State.journey["rations"] == 2 and State.run_heroes["warden"]["hp"] == 13)
 var room: Dictionary = {}
 State.Depth.explore(State,room)
 var steps: int = State.journey["steps"]
 State.Depth.explore(State,room)
 assert(State.journey["steps"] == steps)
 State.journey["steps"] = 5
 State.journey["rations"] = 0
 State.add_item("trail_food",1)
 State.Depth.explore(State,{})
 assert(not State.inventory.has("trail_food"))
 State.journey["steps"] = 5
 State.Depth.explore(State,{})
 assert(State.run_heroes["warden"]["stress"] == 6)
 State.floors[0][Vector2i.ZERO] = {"kind":"camp","cleared":false,"seen":true}
 assert(not State.Depth.prepare_camp(State,"watch"))
 assert(State.rest_at_camp())
 assert(State.Depth.prepare_camp(State,"ward") and State.Depth.prepare_camp(State,"sharpen"))
 assert(not State.Depth.prepare_camp(State,"watch") and not State.Depth.prepare_camp(State,"ward"))
 assert(State.Depth.prepare_camp(State,"scout"))
 assert(State.floors[0][Vector2i.ZERO]["camp_points"] == 0)
 assert(State.journey["boons"]["ward"] and State.journey["boons"]["sharpen"])
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","cleared":false,"seen":true,"enemies":["ash_raider"]}
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await settle()
 assert(current_scene.hero_state["warden"]["camp_ward"] and current_scene.hero_state["warden"]["camp_might"])
 assert(State.journey["boons"].is_empty())
 assert(current_scene._attack_damage("warden",{"damage":20}) == 22)
 var statuses: Dictionary = {}
 assert(not State.try_hero_status("warden",statuses,"bleed",1.0,14.0,15))
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await settle()
 assert(not current_scene.hero_state["warden"]["camp_ward"] and not current_scene.hero_state["warden"]["camp_might"])
 # Watch is guaranteed protection; every ambush seed is deterministic and one-use.
 State.floors[0][Vector2i.ZERO] = {"kind":"camp","cleared":true,"camp_used":true,"camp_choices":["watch"]}
 assert(not State.Depth.camp_ambush(State))
 var found: bool = false
 for value in range(100):
  State.run_seed = value
  State.floors[0][Vector2i.ZERO] = {"kind":"camp","cleared":true,"camp_used":true}
  if State.Depth.camp_ambush(State):
   found = true
   assert(State.floors[0][Vector2i.ZERO]["enemies"].size() == 1)
   assert(not State.Depth.camp_ambush(State))
   break
 assert(found)
 State.hero_positions = {"warden":2,"ranger":1,"occultist":3}
 assert(Saves.save(1))
 State.journey.clear()
 State.hero_positions.clear()
 assert(Saves.load_slot(1))
 assert(State.journey["steps"] > 0 and State.hero_positions["ranger"] == 1)
 var cfg := ConfigFile.new()
 assert(cfg.load(Saves.path(1)) == OK)
 var legacy: Dictionary = cfg.get_value("save","data")
 for key in ["hero_positions","journey","last_report"]: legacy.erase(key)
 cfg.set_value("save","data",legacy)
 cfg.save(Saves.path(2))
 assert(Saves.load_slot(2))
 assert(State.journey["rations"] == 3 and State.hero_positions.size() == 3,"Older active saves receive safe journey defaults")
 State.run_heroes["occultist"]["dead"] = true
 State.journey["kills"] = 4
 State.add_deed("warden","damage",31)
 State.gold += 7
 State.end_run()
 assert(State.last_report["survivors"].size() == 2 and State.last_report["fallen"].size() == 1)
 assert(State.last_report["kills"] == 4 and State.last_report["gold"] == 7)
 assert(State.last_report["survivors"][0]["deeds"]["damage"] == 31)
 change_scene_to_file("res://scenes/expedition/aftermath.tscn")
 await settle()
 assert(current_scene.has_method("return_home"))
 assert(preload("res://scripts/settlement_music.gd").player().playing)
 DirAccess.remove_absolute(State.progress_path)
 DirAccess.remove_absolute(Saves.path(1))
 DirAccess.remove_absolute(Saves.path(2))
 print("PASS: rations, hunger, camp points/boons, deterministic ambushes, save continuity and aftermath")
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 quit()
