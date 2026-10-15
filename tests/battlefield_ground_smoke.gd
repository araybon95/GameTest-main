extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> bool:
 if not ok:
  push_error(message)
  quit(1)
 return ok
func run() -> void:
 State.progress_loaded = true
 State.party.assign(["warden","ranger","occultist"])
 for context in [["old_road",0],["old_road",1],["path_beast",0],["infested_apothecary",0]]:
  State.select_expedition(context[0])
  State.start_run(24)
  State.floor_index = context[1]
  State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
  var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
  root.add_child(battle)
  for i in range(3): await process_frame
  var layers: Control = battle.get_node("BattlefieldBackdrop/BattlefieldLayers")
  if not check(layers.has_node("GroundLayer"),"Combat needs a dedicated ground layer independent of RoomBackground"): return
  var ground: Control = layers.get_node("GroundLayer")
  if not check(ground.surface_y == battle.GROUND_Y and ground.texture is AtlasTexture and ground.texture.atlas == layers.background.texture,"Each theme floor must share the actor surface and matching artwork"): return
  var rest: Transform2D = ground.get_global_transform()
  var cinema: Control = battle.presentation
  cinema.set_process(false)
  cinema.strike(battle.hero_portraits["warden"],battle.enemy_art,"sword","Heavy Strike",true,{"skill_id":"wd_heavy"})
  cinema.age = cinema.impact_time()+0.01
  cinema._process(0)
  if not check(ground.get_global_transform() == rest and layers.background.scale != Vector2.ONE,"Background camera must move independently of stationary ground"): return
  for fighter in cinema.fighters:
   var foot: Vector2 = fighter.get_global_transform()*Vector2(fighter.size.x*0.5,fighter.size.y)
   if not check(absf(foot.y-battle.GROUND_Y) < 2,"Combat feet must remain on ground during camera movement"): return
  cinema.age = 3
  cinema._process(0)
  if not check(ground.get_global_transform() == rest and layers.background.scale == Vector2.ONE,"Ground and background must restore without drift"): return
  battle.free()
  await process_frame
 print("PASS: dedicated themed ground, independent camera and fixed combat foot anchors")
 quit()
