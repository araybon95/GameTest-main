extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Builds = preload("res://scripts/party_builds.gd")
const Poses = preload("res://scripts/combat_poses.gd")
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> bool:
 if not ok:
  push_error(message)
  quit(1)
 return ok
func run() -> void:
 for id in Builds.HEIGHTS:
  var reference := AtlasTexture.new()
  reference.set_meta("pose_id",id)
  var idle: Texture2D = Builds.idle(reference)
  for state in ["idle","attack","windup","cast","guard","hurt","death"]:
   var frame: AtlasTexture = Builds.pose(idle,state)
   if not check(frame.region.size.x > 0 and frame.region.size.y > 0,"Every approved hero needs every action pose"): return
   if not check(frame.get_meta("idle_pixel_height") == idle.get_height(),"Actions must retain the idle art scale"): return
  for style in ["alternate","equipment"]:
   reference.set_meta("appearance_style",style)
   if not check(Builds.idle(reference) == reference,"Selected outfit must remain unchanged"): return
 State.progress_loaded = true
 State.hero_outfits.clear()
 State.equipment.clear()
 State.party.assign(["warden","ranger","occultist"])
 State.select_expedition("old_road")
 State.start_run(2304)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(4): await process_frame
 battle.presentation.set_process(false)
 var expected = {"warden":285.0,"ranger":260.0,"occultist":255.0}
 for id in expected:
  var art: TextureRect = battle.hero_portraits[id]
  if not check(art.texture.get_meta("party_build","") == id,"Approved build must be used in real combat for "+id): return
  var body: float = art.size.y/art.texture.get_height()*float(art.texture.get_meta("body_height_pixels"))
  if not check(absf(body-expected[id]) < 0.1,"Visible body size must follow melee/ranged profile rather than canvas padding"): return
  var foot: Vector2 = art.get_global_transform()*Vector2(art.size.x/2,art.size.y)
  if not check(absf(foot.y-battle.GROUND_Y)<1,"New builds must stay on the shared ground"): return
  for state in ["attack","windup","cast","guard","hurt","death"]:
   var pose: Texture2D = Poses.state_pose(art.texture,state)
   if not check(pose.get_meta("party_build","") == id and pose.get_meta("idle_pixel_height") == art.texture.get_height(),"Action poses must preserve build and registered scale for "+id+"/"+state): return
 battle.free()
 await process_frame
 print("PASS: default combat builds, body-based proportions, registered action poses and common ground")
 quit()
