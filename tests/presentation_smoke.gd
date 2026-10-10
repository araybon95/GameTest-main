extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Poses = preload("res://scripts/combat_poses.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 for key in Poses.POSES:
  var original: Texture2D = load("res://assets/generated/" + key)
  for hurt in [false,true]:
   var pose: Texture2D = Poses.pose(original,hurt)
   assert(pose != original and pose.get_width() > 0 and pose.get_height() > 0,"Every shipped character pose loads")
 var fallback: Texture2D = load("res://assets/generated/enemy_howling_head.png")
 assert(Poses.pose(fallback,true) == fallback,"Unmapped models keep their original art")
 State.progress_loaded = true
 State.party = ["warden","ranger","occultist"]
 State.select_expedition("old_road")
 State.start_run(20)
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await process_frame
 await process_frame
 var source: TextureRect = battle.hero_portraits["warden"]
 var target: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
 assert(absf(source.get_global_rect().end.y - 430.0) < 2.0)
 assert(absf(target.get_global_rect().end.y - 430.0) < 2.0)
 battle.enemy_block = 100
 var hp: int = battle.enemy_hp
 battle._attack_with_equipment("warden",{"damage":1,"name":"Blocked strike"})
 assert(battle.presentation.active["kind"] == "block")
 assert(battle.enemy_hp == hp)
 assert(not source.visible and not target.visible)
 assert(battle.hero_portraits["ranger"].visible)
 await create_timer(0.34).timeout
 assert(battle.presentation.fighters[0].texture != source.texture,"Attack uses a dedicated pose")
 assert(battle.presentation.fighters[1].texture != target.texture,"Target uses a hurt pose")
 assert(absf(battle.presentation.fighters[0].get_global_rect().end.y - 430.0) < 30.0)
 battle._attack_with_equipment("ranger",{"damage":1,"name":"Arrow"})
 battle._attack_with_equipment("occultist",{"damage":1,"name":"Spell"})
 var hp_after: int = battle.enemy_hp
 await create_timer(2.3).timeout
 assert(battle.presentation.active.is_empty())
 assert(not battle.presentation.visible)
 assert(source.visible and target.visible,"Original sprites restore after the spotlight")
 assert(battle.enemy_hp == hp_after, "Presentation must never apply extra damage")
 assert(battle.enemy_views[0].position.x > battle.hero_buttons["occultist"].global_position.x)
 battle.presentation.strike(source,source,"heal","Self recovery")
 assert(not battle.presentation.fighters[1].visible)
 await create_timer(0.8).timeout
 assert(source.visible,"Self-target skills restore the source")
 battle.queue_free()
 await process_frame
 await process_frame
 print("PASS: grounded staging, two-person spotlight, attack/hurt poses, blocked strike, queue/self recovery, and unchanged damage")
 quit()
