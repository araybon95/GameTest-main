extends SceneTree
const State = preload("res://scripts/game_data.gd")
var output: String
func _initialize() -> void: call_deferred("run")
func snap(name: String) -> void:
 await process_frame
 await RenderingServer.frame_post_draw
 assert(root.get_texture().get_image().save_png(output+"/"+name+".png") == OK)
func run() -> void:
 output = OS.get_cmdline_user_args()[0]
 DirAccess.make_dir_recursive_absolute(output)
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 root.size = Vector2i(1920,1080)
 State.progress_loaded = true
 State.progress_path = "user://warden-runtime-review.cfg"
 State.equipment.clear()
 State.inventory.clear()
 State.hero_outfits.clear()
 State.legacy_weapon_costumes.clear()
 State.equipment_appearance = true
 State.party.assign(["warden","ranger","occultist"])
 State.select_expedition("old_road")
 State.start_run(2304)
 State.add_item("warden_sword")
 State.add_item("warden_legend")
 State.equip_item("warden","warden_sword")
 var sheet = load("res://scenes/ui/hero_sheet.gd").new()
 sheet.hero_id = "warden"
 sheet.inventory_mode = true
 root.add_child(sheet)
 await process_frame
 sheet.choose_item("warden_legend")
 await snap("equipment-1920")
 root.size = Vector2i(1280,720)
 await snap("equipment-1280")
 sheet.free()
 root.size = Vector2i(1920,1080)
 State.equip_item("warden","warden_legend")
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(4): await process_frame
 battle.presentation.set_process(false)
 await snap("battle-idle-1920")
 root.size = Vector2i(1280,720)
 await snap("battle-idle-1280")
 battle._attack_with_equipment("warden",{"name":"Heavy Strike","damage":999,"skill_id":"wd_heavy"})
 for time in [0.6,0.96,1.3]:
  battle.presentation.age = time
  battle.presentation._process(0)
  await snap("execution-"+str(time))
 battle.free()
 await process_frame
 print("PASS: native equipment comparison, grounded battlefield and selected-weapon execution captures at both viewport sizes")
 quit()
