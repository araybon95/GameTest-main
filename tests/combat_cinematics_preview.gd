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
 State.party = ["warden","ranger","occultist"]
 State.select_expedition("old_road")
 State.start_run(20)
 State.floors[0][Vector2i.ZERO] = {"kind":"boss","creature":"ash_chieftain","support_creature":"gallows_scout","cleared":false,"seen":true}
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await create_timer(0.7).timeout
 var battle = current_scene
 if battle.presentation.boss_reveal != null:
  battle.presentation.boss_reveal.age = 1.0
  battle.presentation.boss_reveal._process(0.0)
 await shot("C:/GAME/Ashen/cinematic-boss-reveal.png")
 await create_timer(1.45).timeout
 await shot("C:/GAME/Ashen/cinematic-boss-staging.png")
 var boss: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
 var hero: TextureRect = battle.hero_portraits["warden"]
 battle.presentation.strike(hero,boss,"sword","Vanguard Charge")
 battle.presentation.feedback(boss,"damage",11)
 await create_timer(0.33).timeout
 await shot("C:/GAME/Ashen/cinematic-melee-impact.png")
 await create_timer(0.55).timeout
 battle.presentation.strike(boss,hero,"sword","Executioner's Cut",false)
 battle.presentation.feedback(hero,"damage",8)
 await create_timer(0.46).timeout
 await shot("C:/GAME/Ashen/cinematic-boss-impact.png")
 await create_timer(0.68).timeout
 for element in ["Fire Bolt","Lightning Bolt","Frost Lance","Septic Blessing"]:
  battle.presentation.strike(battle.hero_portraits["occultist"],boss,"spell",element)
  await create_timer(0.34).timeout
  await shot("C:/GAME/Ashen/cinematic-%s.png" % element.to_lower().replace(" ","-"))
  await create_timer(0.52).timeout
 State.end_run()
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 quit()
