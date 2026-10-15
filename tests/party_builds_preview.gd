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
 State.hero_outfits.clear()
 State.select_expedition("old_road")
 State.start_run(2304)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(4): await process_frame
 var cinema: Control = battle.presentation
 cinema.set_process(false)
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/tmp/party-build-idle.png")
 battle._select_hero("ranger")
 battle._select_enemy(0)
 battle._play_card("ranger",battle.hero_state["ranger"]["abilities"].find("rg_quick"))
 assert(not cinema.active.is_empty(),"Ranger shot must actually start")
 var args: PackedStringArray = OS.get_cmdline_user_args()
 var output: String = args[0] if not args.is_empty() else "/tmp/party-build-native"
 DirAccess.make_dir_recursive_absolute(output)
 for i in range(60):
  cinema.age = i/24.0
  cinema._process(0)
  await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/%03d.png" % i)
 print("PASS: captured native party builds and Ranger action")
 battle.free()
 await process_frame
 State.crusader_unlocked = true
 State.party.assign(["warden","crusader","ranger"])
 State.start_run(2304)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(4): await process_frame
 battle.presentation.set_process(false)
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/crusader-lineup.png")
 battle._select_hero("crusader")
 battle._select_enemy(0)
 battle._play_card("crusader",battle.hero_state["crusader"]["abilities"].find("pc_charge"))
 assert(not battle.presentation.active.is_empty(),"Crusader charge must actually start")
 battle.presentation.age = battle.presentation.impact_time()+0.02
 battle.presentation._process(0)
 await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/crusader-charge.png")
 battle.free()
 await process_frame
 quit()
