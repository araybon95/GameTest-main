extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func shot(path: String) -> void:
 await process_frame
 await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func run() -> void:
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 State.progress_loaded = true
 State.select_expedition("old_road")
 State.start_run(20)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout","ash_chieftain"],"cleared":false,"seen":true}
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await create_timer(0.35).timeout
 var battle = current_scene
 battle.hero_state["ranger"]["statuses"] = {"poison":{"turns":2,"damage":2},"chill":{"turns":1,"damage":0}}
 battle.enemies[1]["statuses"] = {"bleed":{"turns":2,"damage":4,"stacks":2}}
 battle._refresh_all()
 await shot("C:/GAME/Ashen/ink-expanded-combat.png")
 battle._on_hero_pressed("occultist")
 await shot("C:/GAME/Ashen/ink-expanded-occultist.png")
 for id in ["ranger","occultist"]:
  battle.presentation.strike(battle.hero_portraits[id],battle.enemy_views[1].get_node("EnemyArt"),"spell" if id == "occultist" else "arrow","Casting" if id == "occultist" else "Quick Shot")
  await create_timer(0.30).timeout
  await shot("C:/GAME/Ashen/ink-expanded-%s-impact.png" % id)
  await create_timer(0.50).timeout
 State.party = ["healer","ranger","occultist"]
 State.start_run(20)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["gallows_scout","ash_chieftain"],"cleared":false,"seen":true}
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await create_timer(0.35).timeout
 battle = current_scene
 await shot("C:/GAME/Ashen/ink-expanded-healer.png")
 battle.presentation.strike(battle.hero_portraits["healer"],battle.enemy_views[0].get_node("EnemyArt"),"spell","Smite")
 await create_timer(0.30).timeout
 await shot("C:/GAME/Ashen/ink-expanded-healer-impact.png")
 await create_timer(0.5).timeout
 battle.presentation.strike(battle.enemy_views[1].get_node("EnemyArt"),battle.hero_portraits["healer"],"sword","Executioner's Cut",false)
 await create_timer(0.30).timeout
 await shot("C:/GAME/Ashen/ink-expanded-captain-impact.png")
 await create_timer(0.5).timeout
 var travel = preload("res://scenes/expedition/hallway_travel.gd").new()
 travel.duration = 10
 travel.arrival_duration = 10
 battle.add_child(travel)
 await create_timer(0.35).timeout
 await shot("C:/GAME/Ashen/ink-expanded-walk.png")
 travel.skip_travel()
 await shot("C:/GAME/Ashen/ink-expanded-arrival.png")
 travel.finish()
 await process_frame
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 quit()
