extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> bool:
 if not ok:
  push_error(message)
  quit(1)
 return ok
func run() -> void:
 if not check(ResourceLoader.exists("res://scripts/enemy_variants.gd"),"Enemy variant animation is missing"): return
 var variants = load("res://scripts/enemy_variants.gd")
 State.progress_loaded = true
 State.select_expedition("old_road")
 State.start_run(42)
 var rng_before: int = State.loot_rng.state
 var choices: Array = []
 for seed_id in range(20):
  var choice: String = variants.choose("ash_raider",seed_id,0,Vector2i.ZERO,0)
  if not check(choice == variants.choose("ash_raider",seed_id,0,Vector2i.ZERO,0),"Reopening an encounter must retain its variant"): return
  choices.append(choice)
 if not check(choices.has(variants.SHEET) and choices.has(""),"Both original and hooded Raiders must remain available"): return
 if not check(variants.choose("gallows_scout",42,0,Vector2i.ZERO,0).is_empty() and State.loot_rng.state == rng_before,"Cosmetic selection must not alter other enemies or gameplay RNG"): return
 var idle: Texture2D = variants.frame(0)
 if not check(idle != null,"Variant artwork must load"): return
 if not check(variants.upper_weight(0.65) == 0.0 and variants.upper_weight(1.0) == 0.0,"Breathing must leave every lower-body row unmoved"): return
 if not check(variants.upper_weight(0.2) == 1.0 and variants.breathing(0.0) == 0.0 and variants.breathing(0.8) == 6.0,"Breathing must rise smoothly through a bounded upper-body cycle"): return
 if not check(variants.has_method("limb_weight"),"Forearm and weapon sway is missing"): return
 for point in [Vector2(145,285),Vector2(200,320),Vector2(315,325),Vector2(129,275),Vector2(132,271)]:
  if not check(variants.limb_weight(point) == 0.0,"Limb sway must not move legs or boots"): return
 if not check(variants.limb_weight(Vector2(60,280)) == 1.0 and variants.limb_weight(Vector2(100,245)) == 1.0,"Cleaver blade and grip must share one rigid motion"): return
 if not check(variants.limb_weight(Vector2(130,210)) > 0.9 and variants.limb_weight(Vector2(300,215)) > 0.9,"Both lower arms must follow the breathing"): return
 if not check(variants.idle_offset(Vector2(60,280),6.0) == variants.idle_offset(Vector2(100,245),6.0),"Blade and grip must translate together without weapon bending"): return
 var regions: Array = []
 for index in range(12):
  var texture: AtlasTexture = variants.frame(index)
  if not check(texture.region.size.x > 0 and texture.region.size.y > 0 and not regions.has(texture.region),"Twelve distinct nonempty frames required"): return
  regions.append(texture.region)
  if not check(texture.atlas.get_image().get_region(Rect2i(texture.region)).get_used_rect().size.x > 0,"Each animation frame must contain artwork"): return
  var bounds: Rect2i = texture.get_image().get_used_rect()
  if not check(bounds.end.y+texture.margin.position.y == texture.get_height(),"Every frame must share its canvas ground line"): return
 if not check(variants.sample(idle,"idle",0.0) == variants.sample(idle,"idle",0.4),"Idle must retain identical painted legs and feet"): return
 if not check(variants.sample(idle,"attack",0.1) != variants.sample(idle,"attack",0.9),"Attack must advance between painted frames"): return
 if not check(variants.sample(idle,"death",1.0) == variants.frame(11),"Death must hold the final collapsed frame"): return
 if not check(variants.sample(idle,"idle",0.9,false) == variants.frame(0),"Reduced motion freezes the idle sequence"): return
 var original: Texture2D = load("res://assets/art_library/generated/enemy_ash_raider_combat_idle.tres")
 if not check(variants.sample(original,"idle",0.5) == original,"Unmodified enemies retain their original art"): return
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","ash_raider"],"cleared":false,"seen":true}
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await process_frame
 var baseline = preload("res://scripts/encounter_rules.gd").make_enemy(State.creature("ash_raider"),"ash_raider",0,false)
 for enemy in battle.enemies:
  if not check(enemy.max_hp == baseline.max_hp and enemy.attack == baseline.attack,"Variant must preserve enemy stats"): return
 var selected_art: Array = []
 for enemy in battle.enemies: selected_art.append(enemy.art)
 var animated: TextureRect
 for view in battle.enemy_views:
  var portrait: TextureRect = view.get_node("EnemyArt")
  if variants.supports(portrait.texture): animated = portrait
 if not check(animated != null and animated.has_node("EnemyVariantMotion"),"A real encounter must render and animate its selected variant"): return
 var cinema = battle.presentation
 cinema.set_process(false)
 cinema.strike(animated,battle.hero_portraits["warden"],"sword","Cleaver strike",false,{"profile":"light"})
 for entry in [[0.01,3],[float(cinema.active.timing.release)*0.8,4],[float(cinema.active.timing.impact),6],[float(cinema.active.timing.duration)-0.01,7]]:
  cinema.age = float(entry[0])
  cinema._process(0.0)
  if not check(cinema.fighters[0].texture.get_meta("variant_frame") == int(entry[1]),"Actual combat must select the expected windup/contact/recovery frame"): return
  if not check(cinema.fighters[0].material.get_shader_parameter("raider_breath") == 0.0,"Idle breathing must never deform an attack pose"): return
 cinema.age = float(cinema.active.duration)+1.0
 cinema._process(0.0)
 var motion = animated.get_node("EnemyVariantMotion")
 motion.set_process(false)
 var settings = root.get_node("GameSettings")
 settings.ambient_motion = false
 motion._process(0.4)
 if not check(animated.texture == variants.frame(0),"Reduced-motion encounters must freeze idle art"): return
 settings.ambient_motion = true
 var visual = animated.get_node("StatusVisual")
 visual.set_process(false)
 visual._process(0.5)
 motion._process(0.5)
 if not check(animated.scale == Vector2.ONE,"Variant breathing must not scale the entire body"): return
 if not check(absf(animated.material.get_shader_parameter("raider_breath")) > 0.1,"Upper-body breathing must move continuously"): return
 settings.ambient_motion = false
 motion._process(0.2)
 if not check(animated.material.get_shader_parameter("raider_breath") == 0.0,"Reduced motion disables upper-body breathing"): return
 settings.ambient_motion = true
 animated.get_node("StatusVisual").sync({},0,58,true)
 motion._process(0.4)
 if not check(animated.texture == variants.frame(11),"Idle playback must never revive a defeated enemy"): return
 battle._apply_expedition()
 for index in range(battle.enemies.size()):
  if not check(battle.enemies[index].art == selected_art[index],"Scene rebuild must retain appearances"): return
 battle.free()
 print("PASS: deterministic cosmetic variants, twelve painted frames, idle/attack/death playback, reduced motion and unchanged stats/RNG")
 quit()
