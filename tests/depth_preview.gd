extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func shot(path: String) -> void:
 await process_frame
 await process_frame
 await create_timer(0.7).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://depth_preview.cfg"
 State.gold = 30
 State.select_expedition("old_road")
 change_scene_to_file("res://scenes/expedition/preparation.tscn")
 await shot("C:/GAME/Ashen/depth-preparation.png")
 State.start_run(20)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout","ash_raider"],"cleared":false,"seen":true}
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await shot("C:/GAME/Ashen/depth-combat.png")
 current_scene._select_hero("ranger")
 current_scene.hero_state["ranger"]["resolve_type"] = "affliction"
 current_scene.hero_state["ranger"]["resolve_tag"] = "Fearful"
 current_scene.stress_behavior("ranger",0.0)
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("C:/GAME/Ashen/depth-stress.png")
 State.floors[0][Vector2i.ZERO] = {"kind":"camp","cleared":false,"seen":true}
 change_scene_to_file("res://scenes/expedition/camp.tscn")
 await process_frame
 await process_frame
 current_scene.rest_party()
 current_scene.prepare("watch")
 await shot("C:/GAME/Ashen/depth-camp.png")
 State.journey["kills"] = 6
 State.journey["steps"] = 12
 State.journey["xp"] = {"warden":64,"ranger":64,"occultist":64}
 State.add_item("warden_sword")
 State.add_deed("warden","damage",43)
 State.end_run()
 change_scene_to_file("res://scenes/expedition/aftermath.tscn")
 await shot("C:/GAME/Ashen/depth-aftermath.png")
 DirAccess.remove_absolute(State.progress_path)
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 quit()
