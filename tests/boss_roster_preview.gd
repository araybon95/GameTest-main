extends SceneTree
## Deterministic visual inspection of real encounters, current atlases and poses.
const State = preload("res://scripts/game_data.gd")
const PHASES = ["coterie_seamkeeper","coterie_cantor","coterie_matron"]
const CASES = [
 ["old_road",1,"keep_son","keep_footman"],
 ["old_road",2,"undying_lord","keep_wolfguard"],
 ["path_beast",0,"harrowed_giant","anguish_penitent"],
 ["path_beast",1,"coterie_seamkeeper","anguish_vessel"],
 ["path_beast",1,"coterie_cantor","anguish_vessel"],
 ["path_beast",1,"coterie_matron","anguish_vessel"],
 ["path_beast",2,"howling_head","anguish_vessel"],
 ["infested_apothecary",0,"moth_oleander","moth_metamorph"],
 ["infested_apothecary",0,"moth_exuvia",""]
]

func _initialize() -> void: call_deferred("run")

func settle() -> void:
 for index in range(4): await process_frame

func shot(path: String) -> void:
 await settle()
 await RenderingServer.frame_post_draw
 var error: Error = root.get_texture().get_image().save_png(path)
 assert(error == OK,"The visual review screenshot must be saved")

func run() -> void:
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 State.progress_loaded = true
 State.party = ["warden","ranger","occultist"]
 State.equipment.clear()
 State.inventory.clear()
 State.hero_progress.clear()
 var screenshot_count: int = 0
 for data in CASES:
  if OS.get_cmdline_user_args().has("--coterie-only") and not str(data[2]).begins_with("coterie_"): continue
  assert(State.select_expedition(data[0]))
  State.start_run(905)
  State.floor_index = data[1]
  State.room_position = Vector2i.ZERO
  var room := {"kind":"boss","creature":data[2],"cleared":false,"seen":true}
  if not str(data[3]).is_empty(): room["support_creature"] = data[3]
  if PHASES.has(data[2]): room["boss_phases"] = PHASES
  State.floors[data[1]][Vector2i.ZERO] = room
  var battle: Control = load("res://scenes/combat/combatscene.tscn").instantiate()
  root.add_child(battle)
  # The preview enters each form directly, preserving its actual phase marker.
  # boss_staging_smoke separately checks progression through the full encounter.
  if PHASES.has(data[2]):
   battle.enemies[0]["phase_index"] = PHASES.find(data[2])
   battle._refresh_enemies()
  await settle()
  var reveal: Control = battle.presentation.boss_reveal
  assert(reveal != null)
  reveal.set_process(false)
  reveal.age = 1.0
  reveal._process(0.0)
  await shot("C:/GAME/Ashen/boss-%s-reveal.png" % data[2])
  assert(reveal.lore.size.x <= 1080.1,"Reveal lore must wrap inside the allocated width")
  reveal.finish()
  await settle()
  await shot("C:/GAME/Ashen/boss-%s-stage.png" % data[2])
  var boss: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
  var target: TextureRect = battle.hero_portraits[battle._enemy_target()]
  var move: Dictionary = battle._enemy_move(0)
  var kind: String = "spell" if move.get("status","") in ["burn","poison","chill"] else "sword"
  battle.presentation.strike(boss,target,kind,str(move.get("name","Boss attack")),false)
  battle.presentation.feedback(target,"damage",8)
  battle.presentation.set_process(false)
  battle.presentation.age = 0.42
  battle.presentation._process(0.0)
  await shot("C:/GAME/Ashen/boss-%s-attack.png" % data[2])
  battle.presentation.age = 2.0
  battle.presentation._process(0.0)
  await create_timer(1.0).timeout # Let the preceding target's floating number clear.
  battle.presentation.strike(battle.hero_portraits["warden"],boss,"sword","Boss hurt pose")
  battle.presentation.feedback(boss,"damage",8)
  battle.presentation.age = 0.34
  battle.presentation._process(0.0)
  await shot("C:/GAME/Ashen/boss-%s-hurt.png" % data[2])
  battle.presentation.age = 2.0
  battle.presentation._process(0.0)
  screenshot_count += 4
  battle.queue_free()
  await settle()
 State.end_run()
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print("PASS: %d actual boss stage/reveal/attack/hurt screenshots captured" % screenshot_count)
 quit()
