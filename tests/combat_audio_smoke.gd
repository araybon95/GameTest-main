extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.select_expedition("old_road")
 State.start_run(20)
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await process_frame
 for hero in ["warden", "ranger", "occultist"]:
  battle._attack_with_equipment(hero, {"damage": 1})
  assert(battle.combat_audio.last_sound == {"warden":"sword","ranger":"bow","occultist":"spell"}[hero])
 battle.enemy_block = 100
 assert(battle._deal_enemy_damage(5) == 0)
 assert(battle.combat_audio.last_sound == "block")
 battle._play_attack_sound("sword")
 battle._deal_enemy_damage(0)
 assert(battle.combat_audio.last_sound == "sword")
 battle.hero_state["warden"]["block"] = 100
 assert(battle._apply_damage("warden", 5) == 0)
 assert(battle.combat_audio.last_sound == "block")
 for index in range(20): battle._play_attack_sound("spell")
 assert(battle.combat_audio.voices.size() <= 8)
 for stream in battle.combat_audio.SOUNDS.values(): assert(stream.get_length() > 0.1)
 battle.queue_free()
 await process_frame
 await process_frame
 print("PASS: attack categories, fully blocked impacts, zero damage silence and bounded audio voices")
 quit()
