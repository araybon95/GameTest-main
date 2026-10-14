extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
 root.size = Vector2i(1920,1080)
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 State.progress_loaded = true
 State.party.assign(["warden","ranger","occultist"])
 State.equipment.clear()
 State.select_expedition("old_road")
 State.start_run(2304)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(4): await process_frame
 var cinema: Control = battle.presentation
 cinema.set_process(false)
 battle.enemy_hp = 1
 battle._store_enemy()
 battle._play_card("warden",battle.hero_state["warden"]["abilities"].find("wd_heavy"))
 var args: PackedStringArray = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/warden-integrated-preview"
 DirAccess.make_dir_recursive_absolute(output)
 for i in range(72):
  cinema.age = i/24.0
  cinema._process(0)
  await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/%03d.png" % i)
 print("PASS: captured 72 production execution frames, including unlocked victory aftermath")
 battle.free()
 await process_frame
 quit()
