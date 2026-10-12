extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://stories-progress.cfg"
 Saves.directory = "user://stories-saves/"
 State.hero_journals.clear()
 State.graves.clear()
 State.party.assign(["warden","ranger","occultist"])
 State.hero_names = {"warden":"Alden","ranger":"Mara","occultist":"Iris"}
 State.select_expedition("old_road")
 State.start_run(43)
 State.floors[0][State.room_position] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(combat)
 current_scene = combat
 await process_frame
 await process_frame
 var rng: int = State.loot_rng.state
 var voice: String = State.Stories.personality(State,"ranger").name
 combat.hero_state.ranger.hp = 0
 combat.hero_state.ranger.deaths_door = true
 combat._heal_hero("ranger",5,"occultist")
 State.run_heroes = combat.hero_state.duplicate(true)
 State.Stories.remember(State,"ranger","boss:giant","Stood against the Harrowed Slave Giant.")
 State.Stories.remember(State,"ranger","boss:giant","Duplicate should not appear.")
 assert(State.hero_journals.ranger.memories.size() == 3)
 assert(State.Stories.biography(State,"ranger").contains("Iris brought me back"))
 assert(Saves.save(1))
 State.hero_journals.clear()
 assert(Saves.load_slot(1))
 assert(State.Stories.personality(State,"ranger").name == voice and State.hero_journals.ranger.memories.size() == 3)
 combat._apply_damage("ranger",999,true,"A bandit's blade")
 combat._apply_damage("ranger",1,true,"A bandit's blade")
 assert(State.graves.size() == 1 and State.graves[0].speaker == "occultist")
 assert(State.graves[0].story.memories.size() == 3 and State.graves[0].personality == voice)
 assert(not State.hero_journals.has("ranger") and not State.hero_journals.occultist.ties.has("ranger"))
 var quote: String = State.graves[0].tribute
 State.record_death("ranger","Duplicate")
 assert(State.graves.size() == 1)
 assert(State.Stories.camp_line(State).contains("Mara") and State.Stories.camp_line(State).contains(quote))
 assert(State.loot_rng.state == rng,"Identity and memorials never consume loot RNG")
 State.save_progression()
 State.hero_journals.clear()
 State.graves.clear()
 State.progress_loaded = false
 State.load_progression()
 assert(State.graves[0].story.memories.size() == 3)
 assert(State.hero_journals.has("occultist"))
 State.start_run(44)
 assert(State.hero_journals.ranger.memories.is_empty(),"Replacement recruit does not inherit a fallen life")
 assert(State.Stories.personality(State,"ranger").name != voice)
 assert(State.hero_journals.occultist.memories.size() == 1,"Survivors retain their history across expeditions")
 combat.queue_free()
 for i in range(3): await process_frame
 await create_timer(0.15).timeout
 print("PASS: distinct cosmetic voices, factual deduplicated memories, bonds, closest-companion farewell, memorial snapshots, save/progression persistence and replacement identity")
 quit()
