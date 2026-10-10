extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
const Poses = preload("res://scripts/combat_poses.gd")
func _initialize() -> void: call_deferred("run")

func settle() -> void:
 for index in range(4): await process_frame

func battle_room(expedition: String, depth: int, room: Dictionary) -> Control:
 assert(State.select_expedition(expedition))
 State.start_run(904)
 State.floor_index = depth
 State.room_position = Vector2i.ZERO
 State.floors[depth][Vector2i.ZERO] = room
 var combat: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(combat)
 await settle()
 return combat

func area(rect: Rect2) -> float: return rect.size.x*rect.size.y

func stage_failure(message: String) -> Rect2:
 push_error(message)
 quit(1)
 return Rect2()

func check_stage(combat: Control, index: int) -> Rect2:
 var view: Button = combat.enemy_views[index]
 var model: TextureRect = view.get_node("EnemyArt")
 # Check planted layout independently of the tiny breathing/impact transform.
 var rect := Rect2(view.get_global_rect().position+model.position,model.size)
 var foot: Vector2 = model.get_global_transform()*Vector2(model.size.x*0.5,model.size.y)
 if model.texture == null or rect.size.x <= 0 or rect.size.y <= 0: return stage_failure("The model is missing")
 if absf(rect.end.y-430.0)>=2 or absf(foot.y-430.0)>=2: return stage_failure("The model's feet leave the ground plane")
 if rect.size.y > 350.1 or rect.size.x > 490.1: return stage_failure("Boss dimensions exceed the stage allocation")
 var button_rect: Rect2 = view.get_global_rect()
 if button_rect.position.x < 0 or button_rect.end.x > 1920: return stage_failure("Enemy slots exceed the viewport")
 var info: Rect2 = view.get_node("EnemyInfo").get_global_rect()
 var intent: Rect2 = view.get_node("EnemyIntent").get_global_rect()
 var health: Rect2 = view.get_node("HealthBar").get_global_rect()
 if info.end.y > intent.position.y or intent.end.y > health.position.y:
  return stage_failure("%s HUD overlap: name %s; intent %s; health %s; font %d" % [combat.enemies[index]["creature"],info,intent,health,view.get_node("EnemyInfo").get_theme_font_size("font_size")])
 if rect.intersects(info): return stage_failure("The model overlaps its information rows")
 return rect

func finish_reveal(combat: Control) -> void:
 assert(combat.presentation.boss_reveal != null,"The floor boss receives an initial reveal after layout")
 var reveal: Control = combat.presentation.boss_reveal
 assert(reveal.lore.size.x <= 1080.1,"Boss lore wraps within its allocated width")
 var continued: bool = false
 for child in reveal.get_children():
  if child is Button and child.text == "CONTINUE":
   child.pressed.emit()
   continued = true
   break
 assert(continued,"The reveal has a working Continue action")
 await settle()
 assert(combat.presentation.boss_reveal == null and not combat.presentation.visible)

func run() -> void:
 State.progress_loaded = true
 State.party = ["warden","ranger","occultist"]
 State.equipment.clear()
 State.inventory.clear()
 State.hero_progress.clear()
 if OS.get_cmdline_user_args().has("--dot-only"):
  if not await test_dots():
   quit(1)
   return
  await finish_checks("PASS: live equipment curse, cached base damage and poison resistance before rounding")
  return
 for data in [["path_beast",0,"harrowed_giant","anguish_penitent"],["path_beast",2,"howling_head","anguish_vessel"],["old_road",1,"keep_son","keep_footman"]]:
  var normal: Control = await battle_room(data[0],data[1],{"kind":"battle","enemies":[data[3]],"seen":true,"cleared":false})
  var normal_rect: Rect2 = check_stage(normal,0)
  if normal_rect.size == Vector2.ZERO: return
  assert(normal.presentation.boss_reveal == null,"Ordinary fights enter without a boss reveal")
  normal.queue_free()
  await process_frame
  var combat: Control = await battle_room(data[0],data[1],{"kind":"boss","creature":data[2],"support_creature":data[3],"seen":true,"cleared":false})
  assert(combat.enemies.size() == 2)
  var boss_rect: Rect2 = check_stage(combat,0)
  var support_rect: Rect2 = check_stage(combat,1)
  if boss_rect.size == Vector2.ZERO or support_rect.size == Vector2.ZERO: return
  var model: TextureRect = combat.enemy_views[0].get_node("EnemyArt")
  assert(model.get_meta("boss") and model.get_meta("creature") == data[2])
  assert(area(boss_rect) > area(normal_rect)*1.15 and area(boss_rect) > area(support_rect)*1.5,"A boss is visibly larger than regular creatures and its support")
  assert(not combat.enemy_views[0].get_global_rect().intersects(combat.enemy_views[1].get_global_rect()),"Boss and support occupy distinct slots")
  assert(combat.presentation.boss_reveal.entry["portrait"] == model)
  await finish_reveal(combat)
  assert(model.visible)
  combat.queue_free()
  await process_frame

 # Each Coterie replacement must update its model/metadata immediately, then
 # wait for the previous hit before presenting the next form.
 var phases: Array = ["coterie_seamkeeper","coterie_cantor","coterie_matron"]
 var coterie: Control = await battle_room("path_beast",1,{"kind":"boss","creature":phases[0],"boss_phases":phases,"seen":true,"cleared":false})
 await finish_reveal(coterie)
 var hero: TextureRect = coterie.hero_portraits["warden"]
 var hero_hp: int = coterie.hero_state["warden"]["hp"]
 for phase in [1,2]:
  var model: TextureRect = coterie.enemy_views[0].get_node("EnemyArt")
  coterie.presentation.set_process(false)
  coterie.presentation.strike(hero,model,"sword","Phase-ending strike")
  coterie._deal_enemy_damage(9999,true)
  assert(not coterie.battle_over and coterie.enemies[0]["phase_index"] == phase)
  assert(model.get_meta("creature") == phases[phase] and model.get_meta("boss"))
  assert(model.texture.resource_path == State.creature(phases[phase])["art"],"The battlefield uses the replacement form's current art")
  if check_stage(coterie,0).size == Vector2.ZERO: return
  assert(coterie.presentation.boss_reveal == null and coterie.presentation.boss_reveals.size() == 1)
  var queued: Dictionary = coterie.presentation.boss_reveals[0]
  assert(queued["phase"] == phase+1 and queued["total"] == 3 and queued["name"] == coterie.enemies[0]["name"])
  assert(queued["texture"] != model.texture and queued["texture"] == Poses.state_pose(model.texture,"reveal"),"The reveal is the new form's separate roar pose")
  coterie.presentation.age = 2.0
  coterie.presentation._process(0.0)
  assert(coterie.presentation.boss_reveal.marker.text.contains("PHASE %d / 3" % (phase+1)))
  await finish_reveal(coterie)
  assert(coterie.hero_state["warden"]["hp"] == hero_hp)
 await test_guard_and_heal_queue(coterie)
 coterie.queue_free()
 await process_frame

 if not await test_dots():
  quit(1)
  return
 await finish_checks("PASS: boss/support hierarchy, grounded nonoverlapping HUD, initial and Coterie reveals, live curse damage and poison resistance order")

func test_guard_and_heal_queue(combat: Control) -> void:
 var cinema: Control = combat.presentation
 var boss: TextureRect = combat.enemy_views[0].get_node("EnemyArt")
 var hero: TextureRect = combat.hero_portraits["ranger"]
 var hero_hp: int = combat.hero_state["ranger"]["hp"]
 var boss_hp: int = combat.enemy_hp
 cinema.set_process(false)
 cinema.strike(boss,hero,"block","Cover ally",false)
 cinema.feedback(hero,"block")
 cinema.strike(boss,boss,"heal","Remake flesh",false)
 cinema.feedback(boss,"heal",12)
 assert(cinema.pending.size() == 1 and cinema.pending[0].get("feedback",[]).size() == 1,"Queued healing keeps its feedback with the correct action")
 cinema.age = 0.45
 cinema._process(0.0)
 assert(cinema.fighters[0].texture == Poses.state_pose(boss.texture,"guard"))
 assert(cinema.fighters[1].texture == Poses.state_pose(hero.texture,"guard"),"A defended target shows its guard pose rather than a hurt pose")
 assert(cinema.fighters[1].self_modulate == Color.WHITE,"Non-damaging guard never flashes the ally red")
 cinema.age = 2.0
 cinema._process(0.0)
 assert(cinema.active["attack_kind"] == "heal" and not cinema.fighters[1].visible,"Self healing spotlights one model without a duplicate target")
 cinema.age = 0.45
 cinema._process(0.0)
 assert(cinema.fighters[0].texture == Poses.state_pose(boss.texture,"cast"),"Self healing uses the current boss form's cast pose")
 cinema.age = 2.0
 cinema._process(0.0)
 assert(boss.visible and hero.visible and cinema.active.is_empty())
 assert(combat.hero_state["ranger"]["hp"] == hero_hp and combat.enemy_hp == boss_hp,"Guard/heal presentation never modifies health")

func test_dots() -> bool:
 # Legacy saves cache the curse in damage but also retain base_damage. The
 # live equipment must govern each tick, without double charging that curse.
 State.equipment.clear()
 State.inventory.clear()
 var dots: Control = await battle_room("old_road",0,{"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false})
 State.add_item("cursed_physician_seal")
 assert(State.equip_item("warden","cursed_physician_seal"))
 assert(State.try_hero_status("warden",dots.hero_state["warden"]["statuses"],"bleed",1.0,99.0))
 var bleed: Dictionary = dots.hero_state["warden"]["statuses"]["bleed"]
 assert(bleed["base_damage"] == 2 and bleed["damage"] == 2,"Newly applied status stores unmodified damage")
 bleed["damage"] = 3 # Simulate a legacy save with an application-time curse.
 var before: int = dots.hero_state["warden"]["hp"]
 dots._tick_hero_statuses("warden")
 assert(before-int(dots.hero_state["warden"]["hp"]) == 3,"The equipped seal adds one to baseline Bleed")
 State.unequip_item("warden","charm")
 before = dots.hero_state["warden"]["hp"]
 dots._tick_hero_statuses("warden")
 assert(before-int(dots.hero_state["warden"]["hp"]) == 2,"Removing the seal removes its curse from the next cached tick")
 assert(not dots.hero_state["warden"]["statuses"].has("bleed"))
 assert(State.equip_item("occultist","cursed_physician_seal"))
 State.add_item("occultist_focus")
 assert(State.equip_item("occultist","occultist_focus"))
 dots.hero_state["occultist"]["statuses"] = {"poison":{"base_damage":3,"stacks":1,"damage":4,"turns":3}}
 before = dots.hero_state["occultist"]["hp"]
 dots._tick_hero_statuses("occultist")
 assert(before-int(dots.hero_state["occultist"]["hp"]) == 2,"Poison resistance reduces baseline plus current curse before rounding")
 State.unequip_item("occultist","charm")
 before = dots.hero_state["occultist"]["hp"]
 dots._tick_hero_statuses("occultist")
 assert(before-int(dots.hero_state["occultist"]["hp"]) == 2)
 State.unequip_item("occultist","off_hand")
 before = dots.hero_state["occultist"]["hp"]
 dots._tick_hero_statuses("occultist")
 assert(before-int(dots.hero_state["occultist"]["hp"]) == 3,"Removing resistance restores the unmodified base tick")
 dots.queue_free()
 await process_frame
 return true

func finish_checks(message: String) -> void:
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print(message)
 quit()
