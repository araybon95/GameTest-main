extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize(): call_deferred("run")
func run():
 root.get_node("GameSettings").ambient_motion = false
 State.progress_loaded = true
 State.progress_path = "user://hero-proportions-test.cfg"
 State.select_expedition("old_road")
 State.start_run(42)
 State.party.assign(["warden","ranger","healer"])
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","creature":"ash_raider","enemies":["ash_raider"],"cleared":false,"seen":true}
 var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(combat)
 for i in range(6): await process_frame
 var heavy: TextureRect = combat.hero_portraits.warden
 var ranger: TextureRect = combat.hero_portraits.ranger
 var healer: TextureRect = combat.hero_portraits.healer
 assert(heavy.size.y > ranger.size.y*1.05,"Melee body must be taller than Ranger in actual combat")
 assert(heavy.texture.has_meta("hero_body_fraction"),"Combat must measure body height instead of padded sprite canvas")
 State.hero_colors.ranger = "blue"
 root.get_node("GameSettings").style_portraits(combat)
 assert(ranger.get_meta("hero_palette",false),"Cropped combat artwork must retain saved hero colors")
 assert(ranger.material.get_shader_parameter("accent") == Color("#438CCD"))
 State.hero_colors.ranger = "original"
 root.get_node("GameSettings").style_portraits(combat)
 assert(ranger.material == ranger.get_node("StatusVisual").effect_material,"Returning to original color retains combat status rendering")
 var stats: Dictionary = State.run_heroes.duplicate(true)
 var baseline: Vector2 = heavy.size
 for id in combat.party: combat._plant_combatant(combat.hero_buttons[id],combat.hero_portraits[id],280.0)
 for i in range(3): await process_frame
 assert(heavy.size.is_equal_approx(baseline),"Rebuilding the battlefield cannot compound proportions")
 for id in combat.party:
  var image: TextureRect = combat.hero_portraits[id]
  assert(is_equal_approx((image.get_global_transform()*Vector2(0,image.size.y)).y,combat.global_position.y+combat.GROUND_Y),"Feet remain aligned")
 assert(State.run_heroes == stats,"Visual proportions cannot change stats")
 var cinema = combat.presentation
 cinema.strike(heavy,ranger,"melee","Proportions check",true,{"profile":"heavy"})
 cinema._process(0.01)
 cinema.apply_pose(0,"source",true)
 var fighter: TextureRect = cinema.fighters[0]
 assert(is_equal_approx(fighter.size.x/fighter.size.y,fighter.texture.get_width()/float(fighter.texture.get_height())*1.10),"Attack pose retains the melee build")
 combat.free()
 var profile = load("res://scripts/hero_proportions.gd")
 for id in ["warden","crusader","ranger","healer","occultist"]:
  var standing = load("res://scripts/standing_party.gd").create(id,Vector2(200,600),280)
  root.add_child(standing)
  standing.set_process(false)
  var dimensions: Vector2 = profile.dimensions(standing.texture,id,280)
  assert(standing.size.is_equal_approx(dimensions),"Exploration shares combat build profiles")
  assert(is_equal_approx(standing.position.y+standing.size.y,600))
  standing.free()
 print("PASS: class body profiles, repeated placement, planted feet, shared exploration proportions and unchanged stats")
 quit()
