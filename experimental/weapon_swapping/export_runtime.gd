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
 root.size = Vector2i(1280,720)
 State.progress_loaded = true
 State.progress_path = "user://class-runtime-review.cfg"
 State.crusader_unlocked = true
 State.equipment_appearance = true
 for hero in ["ranger","crusader","occultist"]:
  State.equipment.clear(); State.inventory.clear(); State.hero_outfits.clear(); State.legacy_weapon_costumes.clear()
  State.party.assign(["warden",hero,"healer"])
  State.select_expedition("old_road"); State.start_run(2304)
  var starter: String = preload("res://assets/art_library/weapons/manifest.gd").STARTERS[hero]
  State.add_item(starter); State.add_item(hero+"_legend")
  assert(State.equip_item(hero,starter))
  var sheet = load("res://scenes/ui/hero_sheet.gd").new()
  sheet.hero_id = hero; sheet.inventory_mode = true
  root.add_child(sheet)
  sheet.choose_item(hero+"_legend")
  await snap(hero+"-equipment")
  sheet.free()
  if OS.get_cmdline_user_args().size() > 1: continue
  State.equip_item(hero,hero+"_legend")
  State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
  var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
  root.add_child(battle)
  for i in range(4): await process_frame
  battle.presentation.set_process(false)
  await snap(hero+"-battle")
  battle._attack_with_equipment(hero,{"name":"Weapon review","damage":1,"skill_id":"rg_shot" if hero == "ranger" else "pc_smite" if hero == "crusader" else "oc_bolt"})
  for i in range(36):
   battle.presentation.age = i/30.0
   battle.presentation._process(0)
   await snap(hero+"-attack-%03d" % i)
  battle.free()
  await process_frame
 print("PASS: native remaining-class equipment, grounded battle and selected-weapon attack sequences")
 quit()
