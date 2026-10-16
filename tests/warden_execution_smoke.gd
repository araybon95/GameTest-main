extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> bool:
 if not ok:
  push_error(message)
  quit(1)
 return ok
func fixture(roster: Array, outfit: String = "original") -> Control:
 State.progress_loaded = true
 State.party.assign(["warden","ranger","occultist"])
 State.equipment.clear()
 State.hero_outfits.clear()
 State.equipment_appearance = true
 State.select_expedition("old_road")
 State.start_run(2304)
 if outfit == "alternate": State.hero_outfits.warden = "alternate"
 if outfit == "relic":
  State.add_item("warden_relic_armor")
  State.equip_item("warden","warden_relic_armor")
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":roster,"seen":true,"cleared":false}
 var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 battle.presentation.set_process(false)
 return battle
func run() -> void:
 var battle = fixture(["ash_raider"])
 var heard: Array[String] = []
 battle.presentation.action_sound.connect(func(kind: String): heard.append(kind))
 battle.enemy_hp = 1
 battle._store_enemy()
 battle._play_card("warden",battle.hero_state["warden"]["abilities"].find("wd_heavy"))
 if not check(battle.enemy_hp == 0 and battle.hero_state["warden"]["ap"] == 0 and battle.presentation.active.get("execution",false),"A real Warden direct kill on the final Raider must promote its strike to the approved execution"): return
 battle._check_battle_over()
 battle._refresh_all()
 if not check(battle.battle_over and battle.reward_given and battle.end_turn_button.disabled,"Rewards settle once while victory controls wait for execution"): return
 var gold: int = State.gold
 var rng: int = State.loot_rng.state
 battle._check_battle_over()
 if not check(State.gold == gold and State.loot_rng.state == rng,"Repeated completion checks cannot repeat rewards"): return
 var cinema: Control = battle.presentation
 var settings = root.get_node("GameSettings")
 var saved_motion: bool = settings.ambient_motion
 var saved_speed: float = settings.combat_speed
 settings.ambient_motion = false
 settings.combat_speed = 2.0
 cinema.age = 0.0
 cinema._process(0.35)
 if not check(is_equal_approx(cinema.age,0.7) and not cinema.execution_visual.animate,"Execution must honor combat speed and reduced motion"): return
 settings.ambient_motion = saved_motion
 settings.combat_speed = saved_speed
 if not check(cinema.has_node("WardenExecution") and cinema.visible,"Execution must render through the production presentation"): return
 cinema.age = 2.5
 cinema._process(0)
 if not check(not cinema.visible and not battle.end_turn_button.disabled and battle.has_node("ExecutedRaider"),"Completion must unlock victory and retain a corpse"): return
 if not check(State.gold == gold and State.loot_rng.state == rng,"Execution animation cannot deal damage or consume loot RNG"): return
 if not check(heard == ["block","sword","impact","death"],"Execution contact/death cues must each play once in order"): return
 battle.free()
 await process_frame
 await process_frame
 battle = fixture(["ash_raider"])
 battle._attack_with_equipment("warden",{"name":"Heavy Strike","damage":999,"skill_id":"wd_heavy"})
 battle.presentation.age = 10.0
 battle.presentation._process(0)
 if not check(battle.has_node("ExecutedRaider"),"A long first frame must still leave a corpse"): return
 battle.free()
 await process_frame
 battle = fixture(["ash_raider"])
 for i in range(9): battle.presentation.strike(battle.hero_portraits["ranger"],battle.enemy_art,"bow","Earlier shot")
 battle._attack_with_equipment("warden",{"name":"Heavy Strike","damage":999,"skill_id":"wd_heavy"})
 if not check(not battle.presentation.has_execution(),"Rejected full-queue strikes must not promote an earlier shot"): return
 battle.free()
 await process_frame
 for scenario in ["surviving","other_hero","other_enemy","not_final","indirect","blocked","other_outfit"]:
  battle = fixture(["ash_raider","ash_raider"] if scenario == "not_final" else ["gallows_scout"] if scenario == "other_enemy" else ["ash_raider"])
  if scenario == "other_outfit": battle.hero_portraits["warden"].texture = preload("res://scripts/warden_outfits.gd").frame("ashen_wolf",0)
  if scenario == "blocked": battle.enemy_block = 9999
  if scenario == "indirect": battle._deal_enemy_damage(999)
  else: battle._attack_with_equipment("ranger" if scenario == "other_hero" else "warden",{"name":"Strike","damage":1 if scenario == "surviving" else 999,"skill_id":"wd_slash"})
  if not check(not battle.presentation.active.get("execution",false),"Execution must reject " + scenario): return
  battle.free()
  await process_frame
  await process_frame
 for outfit in ["alternate","relic"]:
  battle = fixture(["ash_raider"],outfit)
  var selected: Texture2D = battle.hero_portraits.warden.texture
  if not check(selected.get_meta("appearance_style","") == ("alternate" if outfit == "alternate" else "equipment"),"Fixture must resolve the actual selected/equipped outfit"): return
  battle._attack_with_equipment("warden",{"name":"Heavy Strike","damage":999,"skill_id":"wd_heavy"})
  if not check(battle.enemy_hp == 0 and not battle.presentation.has_execution(),"A real lethal hit must keep the "+outfit+" appearance"): return
  battle.free()
  await process_frame
  await process_frame
 print("PASS: real final-Raider Warden kill, presentation, corpse, control lock, once-only rewards, excluded kills and automatically selected alternate/relic outfits")
 quit()
