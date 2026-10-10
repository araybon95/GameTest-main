extends SceneTree
const Effects = preload("res://scenes/combat/strike_effects.gd")
const Status = preload("res://scenes/combat/status_visual.gd")
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 # Regression: armor, misses, props and beneficial skills must never produce wound contact.
 var hit := {"attack_kind":"sword","kind":"sword","reaction":"hurt","source_node":1,"target_node":2}
 assert(Effects.harmful_contact(hit))
 for reaction in ["miss","block"]:
  var avoided: Dictionary = hit.duplicate()
  avoided["reaction"] = reaction
  assert(not Effects.harmful_contact(avoided))
 for kind in ["heal","block","object"]:
  var noninjury: Dictionary = hit.duplicate()
  noninjury["attack_kind"] = kind
  assert(not Effects.harmful_contact(noninjury))
 var self_action: Dictionary = hit.duplicate()
 self_action["target_node"] = 1
 assert(not Effects.harmful_contact(self_action))
 var fully_mitigated: Dictionary = hit.duplicate()
 fully_mitigated["kind"] = "block"
 assert(not Effects.harmful_contact(fully_mitigated))
 # Jagged wound polygons must remain drawable, mirrored and deterministic.
 for heavy in [false,true]:
  var points: PackedVector2Array = Effects.slash_points(Vector2.ZERO,1,heavy)
  var mirrored: PackedVector2Array = Effects.slash_points(Vector2.ZERO,-1,heavy)
  assert(points == Effects.slash_points(Vector2.ZERO,1,heavy))
  for index in range(points.size()):
   assert(points[index].is_finite() and points[index].is_equal_approx(Vector2(-mirrored[index].x,mirrored[index].y)))
  var polygon: PackedVector2Array = Effects.wound_outline(points,heavy)
  assert(Geometry2D.triangulate_polygon(polygon).size() > 0,"A wound must triangulate rather than disappear on impact")
 # Small portraits and very large bosses must keep persistent marks away from the floor/HUD.
 for dimensions in [Vector2(32,48),Vector2(150,250),Vector2(490,350),Vector2(1000,400)]:
  for time in [0.0,0.01,1.75,12.0,5000.0]:
   for effect in ["burn","bleed","poison","chill","weaken","affliction"]:
    var marks: Array[Dictionary] = Status.effect_marks(effect,dimensions,time)
    assert(not marks.is_empty() and marks == Status.effect_marks(effect,dimensions,time))
    for mark in marks:
     for point in mark["points"]:
      assert(point.is_finite() and Rect2(Vector2.ZERO,dimensions).has_point(point))
     if mark["filled"]: assert(Geometry2D.triangulate_polygon(mark["points"]).size() > 0,"Undrawable %s mark at %s / %s: %s" % [effect,dimensions,time,mark["points"]])
 State.progress_loaded = true
 State.party = ["warden","ranger","occultist"]
 State.select_expedition("old_road")
 State.start_run(20)
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 await process_frame
 await process_frame
 var cinema: Control = battle.presentation
 var foe: TextureRect = battle.enemy_views[0].get_node("EnemyArt")
 var hero: TextureRect = battle.hero_portraits["warden"]
 var hp: int = battle.hero_state["warden"]["hp"]
 var enemy_hp: int = battle.enemy_hp
 cinema.set_process(false)
 for kind in ["sword","spell","object","heal","block"]:
  cinema.strike(hero,foe,kind,"Fire Bolt" if kind == "spell" else "Test")
  cinema.age = 0.415
  cinema._process(0)
  assert(Effects.sample(cinema)["harmful"] == (kind in ["sword","spell"]))
  if kind == "spell":
   cinema.feedback(foe,"block")
   assert(not Effects.sample(cinema)["harmful"])
  cinema.age = 2
  cinema._process(0)
 assert(battle.hero_state["warden"]["hp"] == hp and battle.enemy_hp == enemy_hp)
 assert(hero.visible and foe.visible and not cinema.visible,"No marks or hidden fighters survive the effect")
 battle.queue_free()
 await process_frame
 State.end_run()
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print("PASS: harmful-contact gating, drawable mirrored ink wounds, bounded deterministic status geometry, actual action cleanup and unchanged health")
 quit()
