extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Passages = preload("res://scripts/passage_events.gd")
func _initialize(): call_deferred("run")
func settle():
 for i in range(5): await process_frame
func run():
 State.progress_loaded = true
 State.progress_path = "user://passage-combat.cfg"
 State.map_travel_mode = true
 State.select_expedition("old_road")
 State.start_run(66)
 State.floors[0] = {Vector2i.ZERO:{"kind":"entry","cleared":true,"seen":true},Vector2i.RIGHT:{"kind":"camp","cleared":false,"seen":true}}
 var key: String = Passages.key(0,Vector2i.ZERO,Vector2i.RIGHT)
 State.journey["passages"] = {key:{"key":key,"kind":"ambush","resolved":false,"room":{"kind":"battle","creature":"ash_raider","enemies":["ash_raider"],"cleared":false,"corridor_surprise":true}}}
 change_scene_to_file("res://scenes/expedition/dungeon.tscn")
 await settle()
 assert(Passages.begin(State,[Vector2i.RIGHT])) # Resume an older saved passage, rather than creating new travel.
 current_scene.resume_map_travel()
 var travel = current_scene.get_node("MapTravel")
 travel.set_process(false)
 travel._process(1.0)
 assert(travel.waiting_event and State.room_position == Vector2i.ZERO)
 travel.enter_battle()
 await settle()
 assert(current_scene.scene_file_path == "res://scenes/combat/combatscene.tscn")
 assert(current_scene.enemies.size() == 1 and current_scene.enemies[0].surprised)
 assert(State.floors[0][Vector2i.RIGHT].kind == "camp" and not State.floors[0][Vector2i.RIGHT].cleared)
 var battle = current_scene
 battle._deal_enemy_damage(999,true)
 battle._check_battle_over()
 await settle()
 if battle.has_node("RelicLootReveal"):
  battle.get_node("RelicLootReveal").dismiss()
  await settle()
 assert(battle.battle_over)
 assert(State.claim_room_loot().is_empty() and State.award_victory_xp().is_empty())
 battle._on_end_turn_button_pressed()
 await settle()
 assert(current_scene.scene_file_path == "res://scenes/expedition/dungeon.tscn")
 assert(State.room_position == Vector2i.ZERO,"Ambush does not arrive or clear destination")
 travel = current_scene.get_node("MapTravel")
 travel.set_process(false)
 travel._process(2.0)
 await settle()
 assert(State.room_position == Vector2i.RIGHT and current_scene.scene_file_path == "res://scenes/expedition/camp.tscn")
 assert(State.journey.passages[key].resolved and not State.journey.has("transit"))
 assert(not State.run_complete and not State.completed_expeditions.has("old_road"))
 print("PASS: actual travel ambush combat/rewards and automatic route resumption into unchanged destination")
 quit()
