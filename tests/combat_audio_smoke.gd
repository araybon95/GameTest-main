extends SceneTree
const State = preload("res://scripts/game_data.gd")
var cues: Array[String] = []

func _initialize() -> void:
 call_deferred("run")

func settle() -> void:
 for frame in range(4):
  await process_frame

func advance(cinema: Control, time: float) -> void:
 cinema.age = time
 cinema._process(0.0)

func finish(cinema: Control) -> void:
 var count: int = 0
 while not cinema.active.is_empty():
  count += 1
  assert(count <= 8)
  advance(cinema, float(cinema.active["duration"]) + 0.1)

func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://timed_combat_audio.cfg"
 State.party.assign(["warden", "ranger", "occultist"])
 State.equipment.clear()
 State.hero_progress.clear()
 State.select_expedition("old_road")
 State.start_run(20)
 State.room_position = Vector2i.ZERO
 State.floors[0][Vector2i.ZERO] = {"kind": "battle", "creature": "ash_raider", "seen": true, "cleared": false}
 var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await settle()
 var cinema: Control = battle.presentation
 cinema.set_process(false)
 cinema.action_sound.connect(func(kind: String): cues.append(kind))
 for attack in [["warden", "wd_heavy", "Heavy Strike", "sword"], ["ranger", "rg_quick", "Quick Shot", "bow"], ["occultist", "oc_hex", "Hex Bolt", "spell"]]:
  cues.clear()
  battle._attack_with_equipment(attack[0], {"skill_id": attack[1], "name": attack[2], "damage": 1, "effect": "attack"})
  var hp: int = battle.enemy_hp
  assert(cues.is_empty(), "Attack sounds wait for visible release")
  advance(cinema, cinema.release_time() - 0.001)
  assert(cues.is_empty())
  advance(cinema, cinema.release_time() + 0.001)
  assert(cues == [attack[3]] and battle.combat_audio.last_sound == attack[3])
  advance(cinema, cinema.release_time() + 0.002)
  finish(cinema)
  assert(cues == [attack[3],"impact"] and battle.enemy_hp == hp, "Playing or skipping presentation cannot duplicate release/contact sounds or damage")

 cues.clear()
 battle.enemy_block = 100
 battle._attack_with_equipment("ranger", {"skill_id": "rg_quick", "name": "Quick Shot", "damage": 1, "effect": "attack"})
 advance(cinema, cinema.release_time() + 0.001)
 assert(cues == ["bow"])
 advance(cinema, cinema.impact_time() - 0.001)
 assert(cues == ["bow"], "Blocked arrows still release before shield contact")
 advance(cinema, cinema.impact_time() + 0.001)
 assert(cues == ["bow", "block"] and battle.combat_audio.last_sound == "block")
 finish(cinema)
 assert(cues == ["bow", "block"])

 cues.clear()
 battle.round_number = 2
 battle.hero_state["warden"]["block"] = 100
 battle._enemy_action()
 var heroes: Dictionary = battle.hero_state.duplicate(true)
 assert(cinema.pending.size() == 1 and cues.is_empty(), "Each hit queues its own release and contact")
 finish(cinema)
 assert(cues == ["sword", "block", "sword", "block"])
 assert(battle.hero_state == heroes)

 cues.clear()
 cinema.strike(battle.hero_portraits["ranger"], battle.enemy_art, "bow", "Quick Shot", true, {"profile": "bow"})
 battle._play_attack_sound("bow")
 cinema.feedback(battle.enemy_art, "miss")
 finish(cinema)
 assert(cues == ["bow"], "A missed shot still has release audio")

 battle.hero_state["warden"]["block"] = 100
 assert(battle._apply_damage("warden", 5) == 0)
 assert(battle.combat_audio.last_sound == "block", "Standalone damage keeps immediate blocked audio")
 battle._emit_attack_sound("sword")
 battle._deal_enemy_damage(0)
 assert(battle.combat_audio.last_sound == "sword")
 for index in range(20):
  battle._emit_attack_sound("spell")
 assert(battle.combat_audio.voices.size() <= 8)
 for stream in battle.combat_audio.SOUNDS.values():
  assert(stream.get_length() > 0.1)

 cues.clear()
 cinema.strike(battle.hero_portraits["warden"], battle.enemy_art, "sword", "Heavy Strike", true, {"skill_id": "wd_heavy"})
 battle._play_attack_sound("sword")
 battle.queue_free()
 await settle()
 assert(cues.is_empty(), "Leaving combat cancels pending audio")
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print("PASS: actual hero and multi-hit enemy sounds at release/contact, misses, skipped actions, unchanged mechanics, zero damage silence, bounded voices and teardown cancellation")
 quit()
