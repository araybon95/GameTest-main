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
 State.progress_path = "user://polish_preview.cfg"
 State.hero_names["warden"] = "Alden"
 State.hero_colors["warden"] = "green"
 State.select_expedition("old_road")
 State.start_run(30)
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await shot("C:/GAME/Ashen/named-combat-preview.png")
 State.end_run()
 State.discovered.append("undying_lord")
 change_scene_to_file("res://scenes/hub/bestiary.tscn")
 await process_frame
 await process_frame
 current_scene.open_volume("old_road")
 current_scene.turn_page(7)
 await shot("C:/GAME/Ashen/lore-book-preview.png")
 change_scene_to_file("res://scenes/ui/title_screen.tscn")
 await shot("C:/GAME/Ashen/title-continue-preview.png")
 quit()
