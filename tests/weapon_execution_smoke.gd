extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var visuals = load("res://scripts/weapon_visuals.gd")
 # Explicit selection must not read current live equipment during the animation.
 for style in ["original","alternate","relic","ashen_wolf"]:
  for weapon in ["warden_sword","warden_epic","warden_frostblade","warden_legend"]:
   for phase in ["execution_0","execution_1","execution_2","execution_3","execution_4","execution_contact"]:
    var frame: Texture2D = visuals.execution_frame(State,"warden",style,phase,weapon)
    assert(frame != null and frame.get_meta("weapon_id") == weapon and frame.get_meta("weapon_style") == style)
 State.progress_loaded = true
 State.progress_path = "user://weapon-execution.cfg"
 State.equipment.clear()
 State.hero_outfits.clear()
 State.legacy_weapon_costumes.clear()
 State.equipment_appearance = true
 State.party.assign(["warden","ranger","occultist"])
 State.select_expedition("old_road")
 State.start_run(935)
 State.add_item("warden_legend")
 assert(State.equip_item("warden","warden_legend"))
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(3): await process_frame
 var cinema = battle.presentation
 cinema.set_process(false)
 var target: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
 assert(cinema.strike(battle.hero_portraits.warden,target,"sword","Oathkeeper",true,{"skill_id":"wd_heavy"}))
 assert(cinema.execute_warden(target))
 assert(cinema.active.source_weapon_id == "warden_legend" and cinema.active.source_style == "original")
 State.unequip_item("warden","weapon")
 for time in [0.02,0.2,0.6,0.96,1.3,1.8]:
  cinema.age = time
  cinema._process(0)
  assert(cinema.execution_visual.source_weapon_id == "warden_legend","Queued source identity must survive live-state changes")
  assert(cinema.execution_visual.source_frames.size() == 5)
  for frame in cinema.execution_visual.source_frames: assert(frame.get_meta("weapon_id") == "warden_legend")
 battle.free()
 await process_frame
 print("PASS: every Warden execution weapon/outfit phase and immutable queued weapon identity")
 quit()
