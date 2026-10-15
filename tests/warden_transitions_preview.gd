extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
 root.size = Vector2i(1920,1080)
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 State.progress_loaded = true
 State.party.assign(["warden","ranger","occultist"])
 State.hero_outfits.clear()
 State.equipment.clear()
 var args = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/warden-transitions-integrated"
 DirAccess.make_dir_recursive_absolute(output)
 var index: int = 0
 for skill in ["wd_slash","wd_heavy"]:
  State.select_expedition("old_road")
  State.start_run(2304)
  State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
  var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
  root.add_child(battle)
  for i in range(4): await process_frame
  var cinema = battle.presentation
  cinema.set_process(false)
  battle._select_hero("warden")
  battle._select_enemy(0)
  battle._play_card("warden",battle.hero_state.warden.abilities.find(skill))
  assert(cinema.active.get("warden_motion",false))
  for frame in range(48):
   if not cinema.active.is_empty():
    cinema.age = frame/30.0
    cinema._process(0)
   await process_frame
   await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png(output+"/%03d.png" % index)
   index += 1
  battle.free()
  await process_frame
 print("PASS: captured integrated Slash and Heavy Strike, 96 frames")
 quit()
