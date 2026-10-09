extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 await process_frame
 await process_frame
func shot(path: String) -> void:
 if DisplayServer.get_name() == "headless": return
 await create_timer(0.65).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://graveyard_test.cfg"
 Saves.directory = "user://graveyard_test_saves/"
 State.graves.clear()
 State.hero_names["warden"] = "Alden"
 State.select_expedition("old_road")
 State.start_run(30)
 State.add_deed("warden","battles",2)
 State.add_deed("warden","damage",31)
 State.add_deed("warden","healing",7)
 assert(Saves.save(1))
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await settle()
 current_scene.hero_state["warden"]["hp"] = 0
 current_scene.hero_state["warden"]["deaths_door"] = true
 current_scene._apply_damage("warden",1,true,"Bleed")
 assert(State.graves.size() == 1)
 var grave: Dictionary = State.graves[0]
 assert(grave["name"] == "Alden" and grave["class"] == "Warden" and grave["deeds"]["damage"] == 31 and grave["cause"] == "Bleed")
 State.record_death("warden","Bleed")
 assert(State.graves.size() == 1)
 assert(Saves.load_slot(1))
 assert(State.graves.size() == 1, "Loading an earlier save retains historical memorials")
 State.graves.clear()
 State.progress_loaded = false
 State.load_progression()
 assert(State.graves.size() == 1, "Memorial survives a fresh progress load")
 State.end_run()
 change_scene_to_file("res://scenes/hub/graveyard.tscn")
 await settle()
 await shot("C:/GAME/Ashen/graveyard-preview.png")
 change_scene_to_file("res://scenes/hub/settlement.tscn")
 await settle()
 assert(current_scene.has_node("MapView/graveyard"))
 await shot("C:/GAME/Ashen/settlement-graveyard-preview.png")
 print("PASS: death memorial names/deeds, duplicate prevention, persistence across older saves and settlement graveyard navigation")
 quit()
