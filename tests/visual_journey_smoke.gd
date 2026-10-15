extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Poses = preload("res://scripts/combat_poses.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 for frame in range(3): await process_frame
func run() -> void:
 State.map_travel_mode = false # Legacy illustrated room fixture.
 State.progress_loaded = true
 State.crusader_unlocked = true
 State.party.assign(["crusader","ranger","occultist"])
 State.select_expedition("old_road")
 State.start_run(42)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout"],"seen":true,"cleared":false}
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await settle()
 var cinema: Control = battle.presentation
 cinema.set_process(false)
 var hero: TextureRect = battle.hero_portraits["crusader"]
 var seen: Array = []
 for state in ["attack","windup","guard","hurt","death"]:
  var pose: Texture2D = Poses.state_pose(hero.texture,state)
  assert(pose is AtlasTexture and not seen.has(pose.region))
  assert(pose.region.end.x <= pose.atlas.get_width() and pose.region.end.y <= pose.atlas.get_height())
  seen.append(pose.region)
 var rng: int = State.loot_rng.state
 var hp: int = battle.enemy_hp
 var target: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
 cinema.strike(hero,target,"sword","Sunder",true,{"skill_id":"pc_charge"})
 cinema.age = 0.12
 cinema._process(0)
 assert(cinema.has_node("AttackTell"))
 assert(cinema.fighters[0].texture == Poses.state_pose(hero.texture,"windup"))
 assert(absf(cinema.fighters[0].position.y+cinema.fighters[0].size.y-Travel.GROUND_Y)<2)
 cinema.age = 2
 cinema._process(0)
 battle._select_hero("crusader")
 battle.quick_select_skill(0)
 assert(battle.get_node("TargetHint").text.contains("TARGET"))
 assert(State.loot_rng.state == rng and battle.enemy_hp == hp)
 battle.queue_free()
 await settle()
 State.floors[0][Vector2i.ZERO] = {"kind":"event","event_id":"bandit_strongbox","event_seed":42,"event_layout":"corridor","cleared":false,"seen":true}
 var event = load("res://scenes/expedition/event_room.tscn").instantiate()
 root.add_child(event)
 await settle()
 assert(event.has_node("InvestigatorMarker") and event.has_node("InvestigatorEffects"))
 event.investigate()
 assert(event.has_node("EventOutcome") and event.has_node("EventOutcomeDetails"))
 var gold: int = State.gold
 event.investigate()
 assert(State.gold == gold,"A result reveal cannot award a second reward")
 event.queue_free()
 await settle()
 State.floors[0][Vector2i(1,0)] = {"kind":"entry","cleared":true,"seen":true}
 var travel := Travel.new()
 travel.route_steps = [Vector2i(1,0)]
 travel.duration = 10
 root.add_child(travel)
 await settle()
 travel.set_process(false)
 travel.set_walking(true)
 travel._process(0.1)
 assert(travel.footsteps_played == 0,"A partial stride is silent")
 travel._process(0.5)
 assert(travel.footsteps_played == 1,"A completed stride has one footfall")
 travel.skip_travel()
 var commits: Array = []
 travel.finished.connect(func(): commits.append(true))
 travel.interact_destination()
 travel.interact_destination()
 assert(travel.complete and commits.is_empty(),"Room commit waits for the doorway fade")
 await create_timer(0.25).timeout
 assert(commits.size() == 1 and not is_instance_valid(travel))
 print("PASS: Witch Hunter poses and planted Sunder, readable tells/target, one-shot event reveal, distance footfalls and one doorway commit")
 quit()
