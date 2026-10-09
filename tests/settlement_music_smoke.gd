extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Music = preload("res://scripts/settlement_music.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 await process_frame
 await process_frame
func run() -> void:
 State.progress_loaded = true
 change_scene_to_file("res://scenes/hub/settlement.tscn")
 await settle()
 var music = Music.player()
 assert(music != null and music.playing)
 for path in ["res://scenes/hub/barracks.tscn", "res://scenes/hub/bestiary.tscn", "res://scenes/hub/apothecary.tscn", "res://scenes/expedition/region_select.tscn", "res://scenes/expedition/preparation.tscn", "res://scenes/hub/settlement.tscn"]:
  change_scene_to_file(path)
  await settle()
  assert(Music.player() == music and music.playing)
 State.start_run(20)
 assert(not music.playing)
 State.end_run()
 Music.play()
 assert(music.playing)
 change_scene_to_file("res://scenes/ui/title_screen.tscn")
 await settle()
 assert(not music.playing)
 music.queue_free()
 await settle()
 print("PASS: same music player through buildings and preparation, stops on expedition/title, restarts on return")
 quit()
