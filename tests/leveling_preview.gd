extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://leveling_preview.cfg"
 State.gain_hero_xp("warden", 150)
 change_scene_to_file("res://scenes/hub/barracks.tscn")
 await process_frame
 await process_frame
 current_scene._show_training("warden")
 await create_timer(0.8).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("C:/GAME/Ashen/leveling-preview.png")
 DirAccess.remove_absolute(State.progress_path)
 quit()
