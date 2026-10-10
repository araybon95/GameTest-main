extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 await process_frame
 await process_frame
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://depth_tactics_test.cfg"
 State.hero_positions.clear()
 State.formation.clear()
 State.select_expedition("old_road")
 State.start_run(99)
 assert(State.Depth.position_of(State,"warden") == 1)
 assert(State.Depth.position_of(State,"occultist") == 3)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout","ash_raider"],"cleared":false,"seen":true}
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await settle()
 var battle = current_scene
 battle._select_hero("warden")
 battle._select_enemy(2)
 var hp: int = battle.enemies[2]["hp"]
 battle._play_card("warden",0)
 assert(battle.hero_state["warden"]["ap"] == 2 and battle.enemies[2]["hp"] == hp,"Out-of-reach skills spend neither AP nor HP")
 battle._select_enemy(0)
 battle._play_card("warden",2)
 assert(battle.enemy_position(0) == 2,"Shield bash pushes a surviving enemy")
 battle._select_hero("ranger")
 battle.move_position(-1)
 assert(State.Depth.position_of(State,"ranger") == 1 and State.Depth.position_of(State,"warden") == 2)
 assert(battle.hero_state["ranger"]["ap"] == 1)
 battle._play_card("ranger",0)
 assert(battle.hero_state["ranger"]["ap"] == 1,"Bow skills require a rear position")
 assert(battle._enemy_move(1)["effect"] == "reposition","A marksman displaced to the front seeks distance")
 battle.round_number = 5
 battle.hero_state["ranger"]["resolve_type"] = "affliction"
 battle.hero_state["ranger"]["resolve_tag"] = "Fearful"
 battle.hero_state["ranger"]["ap"] = 2
 battle.stress_behavior("ranger",0.0)
 assert(battle.hero_state["ranger"]["ap"] == 1)
 battle.stress_behavior("ranger",0.0)
 assert(battle.hero_state["ranger"]["ap"] == 1,"Stress reactions are bounded to one per turn")
 battle.hero_state["occultist"]["resolve_type"] = "affliction"
 battle.hero_state["occultist"]["resolve_tag"] = "Paranoid"
 assert(battle.refuses_healing("occultist",0.0))
 assert(not battle.refuses_healing("occultist",0.0))
 battle.hero_state["warden"]["resolve_type"] = "virtue"
 battle.hero_state["warden"]["stress"] = 12
 battle.hero_state["warden"]["block"] = 0
 battle.stress_behavior("warden",0.0)
 assert(battle.hero_state["warden"]["stress"] == 9 and battle.hero_state["warden"]["block"] == 2)
 assert(battle.hero_state["ranger"]["block"] >= 2)
 DirAccess.remove_absolute(State.progress_path)
 print("PASS: positional skill validation, AP swaps, forced movement, enemy roles and bounded stress reactions")
 quit()
