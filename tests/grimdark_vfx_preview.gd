extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func shot(path: String) -> void:
 await process_frame
 await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("C:/GAME/Ashen/grimdark-%s.png" % path)
func run() -> void:
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 State.progress_loaded = true
 State.party = ["warden","ranger","occultist"]
 State.select_expedition("old_road")
 State.start_run(20)
 State.floors[0][Vector2i.ZERO] = {"kind":"combat","enemies":["ash_raider","gallows_scout","ash_raider"],"cleared":false,"seen":true}
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await process_frame
 await process_frame
 var battle = current_scene
 var cinema: Control = battle.presentation
 cinema.set_process(false)
 var foe: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
 var hero: TextureRect = battle.hero_portraits["warden"]
 var caster: TextureRect = battle.hero_portraits["occultist"]
 var actions: Array[Dictionary] = [
  {"shot":"slash","kind":"sword","title":"Vanguard Cut","reaction":"damage"},
  {"shot":"fire","kind":"spell","title":"Fire Bolt","reaction":"damage"},
  {"shot":"block","kind":"sword","title":"Vanguard Cut","reaction":"block"},
  {"shot":"fire-block","kind":"spell","title":"Fire Bolt","reaction":"block"},
  {"shot":"miss","kind":"sword","title":"Vanguard Cut","reaction":"miss"},
  {"shot":"fire-miss","kind":"spell","title":"Fire Bolt","reaction":"miss"},
  {"shot":"heal","kind":"heal","title":"Recover","reaction":"heal"},
  {"shot":"object","kind":"object","title":"Break the Fetters","reaction":""}]
 for action in actions:
  cinema.strike(caster if action["kind"] in ["spell","heal"] else hero,foe,action["kind"],action["title"])
  cinema.age = 0.415
  cinema._process(0)
  if not str(action["reaction"]).is_empty(): cinema.feedback(foe,action["reaction"],8)
  cinema._process(0)
  await shot(action["shot"])
  cinema.age = 2
  cinema._process(0)
  for child in battle.get_children():
   if child is Label and child.name.begins_with("CombatFeedback"): child.queue_free()
  await process_frame
 # Statuses are held at one deterministic cosmetic time, on both sides of the battlefield.
 for effect in ["burn","bleed","poison","chill"]:
  for portrait in [hero,foe]:
   var visual = portrait.get_node("StatusVisual")
   visual.set_process(false)
   visual.elapsed = 1.75
   visual.sync({effect:{"turns":2}},40,40)
   visual._process(0)
  battle.hero_state["warden"]["statuses"] = {effect:{"turns":2}}
  battle.enemies[0]["statuses"] = {effect:{"turns":2}}
  battle._refresh_all()
  await shot("persistent-%s" % effect)
 State.end_run()
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print("PASS: wrote twelve deterministic grimdark effect previews")
 quit()
