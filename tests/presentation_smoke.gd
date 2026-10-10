extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.party = ["warden","ranger","occultist"]
 State.select_expedition("old_road")
 State.start_run(20)
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await process_frame
 battle.enemy_block = 100
 var hp: int = battle.enemy_hp
 battle._attack_with_equipment("warden",{"damage":1,"name":"Blocked strike"})
 assert(battle.presentation.active["kind"] == "block")
 assert(battle.enemy_hp == hp)
 battle._attack_with_equipment("ranger",{"damage":1,"name":"Arrow"})
 battle._attack_with_equipment("occultist",{"damage":1,"name":"Spell"})
 var hp_after: int = battle.enemy_hp
 await create_timer(2.3).timeout
 assert(battle.presentation.active.is_empty())
 assert(not battle.presentation.visible)
 assert(battle.enemy_hp == hp_after, "Presentation must never apply extra damage")
 assert(battle.enemy_views[0].position.x > battle.hero_buttons["occultist"].global_position.x)
 battle.queue_free()
 await process_frame
 await process_frame
 print("PASS: side staging, blocked strike, queued arrow/spell recovery, and damage unaffected by animation")
 quit()
