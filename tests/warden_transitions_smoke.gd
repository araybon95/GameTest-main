extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func require(ok: bool, message: String) -> bool:
 if not ok:
  push_error(message)
  quit(1)
 return ok
func run() -> void:
 State.progress_loaded = true
 State.party.assign(["warden","ranger","occultist"])
 State.hero_outfits.clear()
 State.equipment.clear()
 State.select_expedition("old_road")
 State.start_run(2304)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(4): await process_frame
 var cinema = battle.presentation
 cinema.set_process(false)
 for entry in [["wd_slash",0.18,0.31,0.80],["wd_heavy",0.44,0.60,1.16]]:
  cinema.strike(battle.hero_portraits.warden,battle.enemy_views[0].get_node("EnemyArt"),"sword",str(entry[0]),true,{"skill_id":entry[0]})
  if not require(is_equal_approx(cinema.release_time(),entry[1]) and is_equal_approx(cinema.impact_time(),entry[2]) and is_equal_approx(float(cinema.active.duration),entry[3]),"Real default Warden skills must use the approved timing"): return
  var heard: Array = []
  var cue = func(kind: String): heard.append(kind)
  cinema.action_sound.connect(cue)
  cinema.queue_sound("sword")
  cinema.queue_sound("impact")
  var before: Dictionary = battle.hero_state.duplicate(true)
  for time in [0.02,entry[1]-0.001,entry[1],entry[2]-0.001,entry[2],entry[2]+0.02,float(entry[3])-0.01]:
   cinema.age = time
   cinema._process(0)
   var fighter: TextureRect = cinema.fighters[0]
   if not require(is_zero_approx(fighter.rotation),"Upper-body mesh motion must not tip the planted legs"): return
   var foot: Vector2 = fighter.get_global_transform()*Vector2(fighter.size.x/2,fighter.size.y)
   if not require(absf(foot.y-battle.GROUND_Y)<2,"Warden motion must remain on the floor"): return
   if not require(fighter.has_node("WardenMotion") and fighter.self_modulate.a == 0,"Approved mesh presentation must replace the source sprite"): return
   for state in ["idle","windup","attack"]:
    var drawn: Texture2D = preload("res://scenes/combat/warden_motion.gd").textures[preload("res://scenes/combat/warden_motion.gd").cache_key(cinema.active.source,state)]
    var registered: Texture2D = preload("res://scripts/party_builds.gd").pose(cinema.active.source,state)
    if not require(drawn.get_size() == registered.get_size(),"Mesh rasterization must preserve the registered canvas and body anchor"): return
   if time < entry[1] and not require(heard.is_empty(),"No premature release audio"): return
   if time >= entry[1] and time < entry[2] and not require(heard == ["sword"],"Release cue must remain synchronized"): return
  if not require(heard == ["sword","impact"] and battle.hero_state == before,"Presentation applies cues once without mutating gameplay"): return
  cinema.action_sound.disconnect(cue)
  cinema.motion_strength = 0
  cinema._process(0)
  if not require(cinema.fighters[0].self_modulate.a == 1 and not cinema.fighters[0].get_node("WardenMotion").visible,"Reduced motion must disable mesh motion and blends"): return
  cinema.age = 2
  cinema._process(0)
  cinema.motion_strength = 1
 battle.free()
 await process_frame
 print("PASS: integrated Warden timing, grounded mesh, synchronized single cues, reduced motion and unchanged gameplay")
 quit()
