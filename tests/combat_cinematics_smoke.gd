extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Effects = preload("res://scenes/combat/strike_effects.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.party = ["warden","ranger","occultist"]
 State.select_expedition("old_road")
 State.start_run(20)
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await process_frame
 await process_frame
 var cinema: Control = battle.presentation
 var boss: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
 var hero: TextureRect = battle.hero_portraits["warden"]
 var hp: int = battle.hero_state["warden"]["hp"]
 var enemy_hp: int = battle.enemy_hp
 var backdrop: TextureRect = battle.get_node("BattlefieldBackdrop/BackgroundArt")
 var backdrop_rect: Rect2 = backdrop.get_rect()
 var backdrop_pivot: Vector2 = backdrop.pivot_offset
 boss.set_meta("boss",true)
 boss.set_meta("creature","harrowed_giant")
 cinema.strike(boss,hero,"sword","Chain Litany",false)
 assert(cinema.active["duration"] > cinema.duration,"Boss swings have a longer anticipation")
 cinema.set_process(false)
 cinema.age = 0.30
 cinema._process(0.0)
 assert(cinema.fighters[0].scale.x > 1.0 and cinema.cinematic_backdrop != null,"Only cinematic fighters and scenery zoom")
 assert(absf(cinema.fighters[0].position.y+cinema.fighters[0].size.y-430.0)<2,"Camera scale pivots around planted feet")
 cinema.reveal_boss(boss,"The Coterie: Bone Cantor","The hymn continues.","remade",2,3)
 assert(cinema.boss_reveal == null,"Phase entrances wait for the current hit to finish")
 cinema.age = 1.1
 cinema._process(0.0)
 assert(cinema.active.is_empty() and cinema.boss_reveal != null)
 assert(backdrop.get_rect() == backdrop_rect and backdrop.scale == Vector2.ONE and backdrop.pivot_offset == backdrop_pivot,"Scenery restores before the phase entrance")
 assert(cinema.boss_reveal.marker.text.contains("PHASE 2 / 3"))
 assert(not boss.visible and hero.visible,"Entrance spotlight restores previous participants")
 cinema.strike(hero,boss,"spell","Fire Bolt")
 assert(cinema.pending.size() == 1,"Player strikes wait for the reveal to finish")
 cinema.boss_reveal.finish()
 await process_frame
 await process_frame
 assert(cinema.boss_reveal == null and cinema.active["title"] == "Fire Bolt")
 cinema.age = 0.14
 cinema._process(0.0)
 var early: Dictionary = Effects.sample(cinema)
 cinema.feedback(boss,"damage",10)
 assert(cinema.active.get("feedback",[]).size() == 1,"Damage numbers wait for projectile impact")
 cinema.age = 0.28
 cinema._process(0.0)
 var late: Dictionary = Effects.sample(cinema)
 assert(not cinema.active.has("feedback"),"Feedback emits exactly once at impact")
 assert(early["progress"] < late["progress"] and late["element"] == "fire","Projectile travels from caster to its target")
 cinema.feedback(boss,"miss")
 assert(cinema.active["reaction"] == "miss")
 assert(Effects.sample(cinema)["aim"].y < Effects.sample(cinema)["target"].y,"A miss flies past the target")
 for kind in ["critical","heal","resist","status_tick","block"]:
  cinema.feedback(hero,kind,4,"poison")
  assert(cinema.feedback_count[kind] == 1)
 var labels: Array[String] = []
 for child in battle.get_children():
  if child is Label and child.name.begins_with("CombatFeedback"): labels.append(child.text)
 assert(labels.has("CRITICAL 4") and labels.has("+4 HP") and labels.has("RESISTED · POISON") and labels.has("POISON −4") and labels.has("BLOCKED"))
 for pair in [["Frost-tipped Arrow","frost"],["Septic Blessing","poison"],["Lightning Bolt","lightning"],["Cold Chorus","frost"],["Purifying Brand","fire"]]:
  assert(Effects.element(pair[0]) == pair[1])
 assert(State.run_heroes["warden"]["hp"] == hp and battle.enemy_hp == enemy_hp,"Cinematics and feedback never apply damage")
 cinema.age = 1.2
 cinema._process(0.0)
 assert(hero.visible and boss.visible and not cinema.visible)
 assert(backdrop.get_rect() == backdrop_rect and backdrop.pivot_offset == backdrop_pivot)
 cinema.motion_strength = 0.0
 cinema.strike(hero,boss,"sword","Opening")
 cinema.age = 0.4
 cinema._process(0.0)
 assert(cinema.fighters[0].scale == Vector2.ONE and backdrop.scale == Vector2.ONE,"Optional zero motion suppresses the camera effect")
 var doomed := TextureRect.new()
 doomed.texture = boss.texture
 doomed.size = boss.size
 battle.add_child(doomed)
 cinema.strike(hero,doomed,"sword","Discarded target")
 doomed.free()
 cinema.age = 1.2
 cinema._process(0.0)
 assert(cinema.pending.is_empty() and cinema.active.is_empty() and hero.visible and boss.visible,"Freed queued targets are discarded without hiding living actors")
 battle.queue_free()
 await process_frame
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print("PASS: boss anticipation, planted/restored camera, queued phases and feedback, elemental flight/miss, freed-target cleanup and unchanged health")
 quit()
