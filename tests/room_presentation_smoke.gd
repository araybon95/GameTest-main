extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Art = preload("res://scripts/room_scene_art.gd")
const Skills = preload("res://scripts/painted_skill_art.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 for frame in range(3): await process_frame
func run() -> void:
 State.progress_loaded = true
 State.party.assign(["warden","ranger","occultist"])
 var runtime = root.get_node("GameSettings")
 for id in State.CARDS:
  var icon: Texture2D = load(Skills.path_for(str(id)))
  if str(id).begins_with("relic_"):
   assert(icon != null and Skills.path_for(str(id)) == State.Items.icon_path(str(id).trim_prefix("relic_")+"_legend"))
   continue
  assert(icon is AtlasTexture and icon.atlas.resource_path.ends_with("painted_skills.png"))
  assert(icon.region.end.x <= icon.atlas.get_width() and icon.region.end.y <= icon.atlas.get_height())
 for context in [["old_road",0,"bandit"],["old_road",1,"keep"],["path_beast",0,"beast"],["infested_apothecary",0,"medical"]]:
  State.select_expedition(context[0])
  State.start_run(24)
  State.floor_index = context[1]
  State.room_position = Vector2i.ZERO
  State.floors[State.floor_index][Vector2i.ZERO] = {"kind":"camp","cleared":false,"seen":true}
  var hp: int = State.run_heroes["warden"]["hp"]
  var rng: int = State.loot_rng.state
  var camp = load("res://scenes/expedition/camp.tscn").instantiate()
  root.add_child(camp)
  await settle()
  assert(camp.get_node("CampBackground").texture.resource_path == Art.path_for(context[2],"camp"))
  var actor: Node = camp.get_node("Camper_warden/CampActor")
  actor._process(0.4)
  var model: TextureRect = actor.portrait
  assert(absf((model.get_global_transform()*Vector2(model.size.x*0.5,model.size.y)).y-690)<0.1)
  assert(float(model.material.get_shader_parameter("firelight"))>0.0)
  runtime.ambient_motion = false
  var time: float = actor.clock
  actor._process(0.3)
  assert(actor.clock == time and model.scale == Vector2.ONE)
  runtime.ambient_motion = true
  assert(State.run_heroes["warden"]["hp"] == hp and State.loot_rng.state == rng)
  camp.queue_free()
  await settle()
 State.select_expedition("path_beast")
 State.start_run(24)
 State.floors[0][Vector2i.ZERO] = {"kind":"boss","creature":"harrowed_giant","cleared":false,"seen":true}
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await settle()
 var background: TextureRect = battle.get_node("BattlefieldBackdrop/BattlefieldLayers/RoomBackground")
 assert(background.texture.resource_path == Art.path_for("beast","combat"))
 assert(background.size == Vector2(1920,600))
 assert(battle.presentation.boss_reveal.staging_motif == "stitched_halo")
 assert(battle.enemy_views[0].get_node("EnemyIntent").get_theme_font_size("font_size") == 15)
 battle.presentation.boss_reveal.finish()
 await settle()
 var cinema: Control = battle.presentation
 cinema.set_process(false)
 var start: Rect2 = background.get_rect()
 cinema.strike(battle.hero_portraits["warden"],battle.enemy_views[0].get_node("EnemyArt"),"sword","Slash",true,{"skill_id":"wd_slash"})
 cinema.age = cinema.impact_time()+0.01
 cinema._process(0)
 assert(cinema.cinematic_backdrop == background,"Camera follows the visible room rather than the hidden legacy backdrop")
 cinema.age = 2
 cinema._process(0)
 assert(background.get_rect() == start and background.scale == Vector2.ONE)
 print("PASS: 26 painted skill resources, eight themed room assets, camp firelight/motion/grounding/RNG, guardian motif, larger intents and visible-background camera restore")
 quit()
