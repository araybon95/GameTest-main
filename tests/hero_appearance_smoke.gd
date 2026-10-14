extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
const Art = preload("res://scripts/hero_appearance.gd")
const Poses = preload("res://scripts/combat_poses.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 for i in range(3): await process_frame
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://appearance-test.cfg"
 Saves.directory = "user://appearance-saves/"
 State.hero_outfits.clear()
 State.hero_portraits.clear()
 State.completed_expeditions.clear()
 assert(not State.customize_hero("warden","Alden","green","alternate","bust"))
 State.completed_expeditions.append("restore_workshop")
 State.crusader_unlocked = true
 var rng: int = State.loot_rng.state
 for id in State.HEROES:
  assert(Art.available(id))
  assert(State.customize_hero(id,"","original","alternate","bust"))
  var hero: Dictionary = State.hero(id)
  assert(hero.max_hp == State.HEROES[id].max_hp and hero.abilities == State.HEROES[id].abilities)
  var idle: Texture2D = load(hero.art)
  assert(idle.get_meta("appearance_style","") == "alternate")
  for pose in ["attack","hurt","guard","cast","windup","death"]:
   var texture: AtlasTexture = Poses.state_pose(idle,pose)
   assert(texture.atlas.resource_path.ends_with("hero_"+id+"_outfit.png"))
   assert(texture.region.size.x > 100 and texture.region.size.y > 100)
  for index in range(4,8): assert(Art.frame(id,index).get_meta("pose_id") == id)
  assert(load(hero.camp_art).get_meta("appearance_style") == "alternate")
  assert(load(hero.portrait_art).get_meta("portrait_view"))
  assert(Poses.pose(load(hero.portrait_art),true) == load(hero.portrait_art),"HUD portraits cannot turn into a full-body attack")
 assert(State.loot_rng.state == rng)
 assert(Saves.save(1))
 State.hero_outfits.clear()
 State.hero_portraits.clear()
 assert(Saves.load_slot(1))
 assert(State.hero_outfits.warden == "alternate" and State.hero_portraits.warden == "bust")
 var screen = load("res://scenes/hub/customization.tscn").instantiate()
 root.add_child(screen)
 current_scene = screen
 await settle()
 screen.name_edit.text = "Alden"
 screen.change_color("blue")
 screen.change_outfit("original")
 assert(screen.name_edit.text == "Alden" and State.hero_outfits.warden == "alternate", "Draft previews preserve typed names and saved appearance")
 screen.save_appearance()
 assert(State.hero_outfits.warden == "original" and State.hero_names.warden == "Alden")
 State.select_expedition("old_road")
 State.start_run(43)
 var travel = preload("res://scenes/expedition/hallway_travel.gd").new()
 root.add_child(travel)
 await settle()
 assert(travel.walk_frames.ranger[0].atlas.resource_path.contains("appearance"))
 assert(travel.walk_frames.warden[0].get_meta("appearance_style") == "warden_complete","Original and alternate outfits may mix in one party")
 travel.queue_free()
 screen.queue_free()
 await settle()
 print("PASS: workshop gate, five consistent outfit/pose/camp/portrait sets, unchanged stats/RNG, persistent choices, noncommitting live preview and mixed-party walking")
 quit()
