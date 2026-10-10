extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://leveling_test.cfg"
 Saves.directory = "user://leveling_test_saves/"
 State.hero_progress.clear()
 State.run_active = false
 assert(State.leveling("warden")["level"] == 1)
 assert(not State.train_hero("warden", "max_hp"))
 assert(State.gain_hero_xp("warden", 105) == 2)
 assert(State.leveling("warden")["level"] == 3 and State.leveling("warden")["points"] == 4)
 assert(State.hero_max_hp("warden") == 59)
 assert(State.train_hero("warden", "max_hp"))
 assert(State.train_hero("warden", "damage_percent"))
 assert(State.train_hero("warden", "block"))
 assert(State.train_hero("warden", "heal"))
 assert(State.hero_max_hp("warden") == 62 and State.hero_bonus("warden", "block") == 1 and State.hero_bonus("warden", "heal") == 1)
 assert(not State.train_hero("warden", "max_hp"))
 assert(not State.train_hero("warden", "unknown"))
 State.gain_hero_xp("warden", 100000)
 assert(State.leveling("warden")["level"] == 10 and State.leveling("warden")["xp"] == 0)
 for i in range(5): assert(State.train_hero("warden", "max_hp"))
 assert(not State.train_hero("warden", "max_hp"))
 assert(State.hero_max_hp("warden") == 91)
 assert(State.train_hero("warden", "debuff_resist"))
 var statuses: Dictionary = {}
 assert(not State.try_hero_status("warden", statuses, "bleed", 1.0, 2.0))
 assert(State.try_hero_status("warden", statuses, "bleed", 1.0, 4.0))
 State.crusader_unlocked = false
 assert(State.gain_hero_xp("crusader", 100) == 0)
 State.hero_progress.clear()
 State.select_expedition("old_road")
 State.start_run(2026)
 assert(not State.train_hero("warden", "max_hp"))
 State.floors[0][State.room_position]["kind"] = "boss"
 State.floors[0][State.room_position]["cleared"] = false
 State.run_heroes["occultist"]["dead"] = true
 var rewards: Dictionary = State.award_victory_xp()
 assert(rewards["warden"]["xp"] == 35 and rewards["ranger"]["xp"] == 35)
 assert(not rewards.has("occultist") and State.leveling("healer")["xp"] == 0)
 assert(State.award_victory_xp().is_empty())
 assert(Saves.save(1))
 State.hero_progress.clear()
 assert(Saves.load_slot(1) and State.leveling("warden")["xp"] == 35)
 assert(State.award_victory_xp().is_empty())
 State.hero_progress.clear()
 State.progress_loaded = false
 State.load_progression()
 assert(State.leveling("warden")["xp"] == 35)
 # Old saves initialize progression rather than importing progress from another slot.
 var cfg := ConfigFile.new()
 assert(cfg.load(Saves.path(1)) == OK)
 var old: Dictionary = cfg.get_value("save", "data")
 old.erase("hero_progress")
 cfg.set_value("save", "data", old)
 cfg.save(Saves.path(2))
 assert(Saves.load_slot(2) and State.leveling("warden")["level"] == 1)
 State.end_run()
 change_scene_to_file("res://scenes/hub/barracks.tscn")
 await process_frame
 await process_frame
 current_scene._show_training("warden")
 assert(is_instance_valid(current_scene.training_panel))
 current_scene.training_panel.queue_free()
 State.hero_progress.clear()
 State.gain_hero_xp("warden", 105)
 assert(State.train_hero("warden", "block"))
 assert(State.train_hero("warden", "block"))
 assert(State.train_hero("warden", "damage_percent"))
 assert(State.train_hero("warden", "damage_percent"))
 State.start_run(89)
 State.floors[0][State.room_position]["kind"] = "battle"
 State.floors[0][State.room_position]["cleared"] = false
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await process_frame
 await process_frame
 var combat = current_scene
 assert(combat.hero_state["warden"]["max_hp"] == 59)
 combat._resolve_card("warden", State.card_stats("wd_guard"))
 assert(combat.hero_state["warden"]["block"] == 8)
 assert(combat._attack_damage("warden", State.card_stats("wd_heavy")) == 14)
 for enemy in combat.enemies: enemy["hp"] = 0
 combat.enemy_hp = 0
 combat._check_battle_over()
 assert(State.leveling("warden")["xp"] == 12)
 combat._check_battle_over()
 assert(State.leveling("warden")["xp"] == 12)
 DirAccess.remove_absolute(State.progress_path)
 DirAccess.remove_absolute(Saves.path(1))
 DirAccess.remove_absolute(Saves.path(2))
 print("PASS: leveling, capped upgrades, resistances, once-only survivor XP, save migration and training UI")
 quit()
