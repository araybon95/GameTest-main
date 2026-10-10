extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Poses = preload("res://scripts/combat_poses.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 for id in ["ranger","occultist","healer"]:
  var idle: Texture2D = load(State.HEROES[id]["art"])
  var seen: Array = []
  for state in ["attack","cast","guard","hurt"]:
   var pose: Texture2D = Poses.state_pose(idle,state)
   assert(pose != idle and not seen.has(pose.region),"Every new hero has a distinct combat state")
   assert(pose.atlas.get_image().get_format() == Image.FORMAT_RGBA8)
   assert(pose.region.end.x <= pose.atlas.get_width() and pose.region.end.y <= pose.atlas.get_height())
   seen.append(pose.region)
 for id in ["gallows_scout","ash_chieftain"]:
  var idle: Texture2D = load(State.CREATURES[id]["art"])
  assert(Poses.state_pose(idle,"attack") != Poses.state_pose(idle,"hurt"))
 State.select_expedition("old_road")
 State.start_run(20)
 var gold: int = State.gold
 var hp: int = State.run_heroes["warden"]["hp"]
 for kind in ["battle","event","camp","stairs"]:
  State.floors[0][Vector2i.ZERO] = {"kind":kind,"enemies":["gallows_scout"],"event_id":"bandit_strongbox","cleared":false,"seen":true}
  var passage = Travel.new()
  passage.duration = 20.0
  passage.arrival_duration = 20.0
  root.add_child(passage)
  await process_frame
  assert(passage.encounter != null and passage.encounter.texture != null)
  passage.skip_travel()
  await process_frame
  assert(passage.arrived and not passage.complete,"Skip pauses at the encounter before entering")
  assert(passage.encounter.position.x < 1500.0)
  var stopped: Vector2 = passage.walkers[0].position
  await create_timer(0.08).timeout
  assert(passage.walkers[0].position == stopped,"Walkers stop at the doorway")
  assert(State.gold == gold and State.run_heroes["warden"]["hp"] == hp)
  passage.skip_travel()
  await process_frame
 var strip = preload("res://scenes/combat/status_strip.gd").new()
 root.add_child(strip)
 var statuses: Dictionary = {"burn":{"turns":2,"stacks":3,"damage":9},"chill":{"turns":1,"damage":0}}
 strip.sync(statuses,2,1)
 assert(strip.get_child_count() == 4)
 assert(strip.get_child(0).tooltip_text.contains("3 stacks") and strip.get_child(0).tooltip_text.contains("9 damage"))
 assert(strip.get_child(0).get_child(1).text == "2t")
 strip.sync({})
 assert(strip.get_child_count() == 0 and statuses.size() == 2)
 strip.queue_free()
 for id in State.CARDS: assert(ResourceLoader.exists("res://assets/ui/skills/%s.svg" % id))
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print("PASS: separate combat states, transparent atlases, encounter arrival stop, safe continuation, readable effects and all skill glyphs")
 quit()
