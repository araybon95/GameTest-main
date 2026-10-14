extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize(): call_deferred("run")
func run():
 assert(ResourceLoader.exists("res://scripts/standing_party.gd"),"Shared standing presentation is required")
 var standing = load("res://scripts/standing_party.gd")
 State.progress_loaded = true
 State.progress_path = "user://standing-party.cfg"
 State.equipment.clear()
 State.hero_outfits.clear()
 var health: Dictionary = {}
 for id in State.HEROES: health[id] = State.hero_max_hp(id)
 for id in State.HEROES:
  var picture = standing.create(id,Vector2(300,600),200)
  root.add_child(picture)
  assert(picture.texture.get_meta("standing_pose",false))
  assert(picture.texture.get_meta("pose_id","") == id)
  var body_height: float = picture.size.y*picture.texture.get_meta("standing_body_height")/picture.texture.get_height()
  assert(absf(body_height-(216 if id in ["warden","crusader"] else 190 if id == "ranger" else 200)) < 0.01,"Heavy fighters are 8% taller; Ranger is 5% shorter; casters share baseline body height")
  assert(absf(picture.position.y+picture.size.y-600) < 0.01)
  assert(State.hero_max_hp(id) == health[id],"Build is visual only")
  picture.free()
 State.completed_expeditions.assign(["restore_workshop","old_road"])
 State.hero_outfits.warden = "ashen_wolf"
 assert(standing.standing_texture("warden").get_meta("warden_outfit") == "ashen_wolf")
 assert(not standing.standing_texture("warden").get_meta("travel_unarmed",false),"Map standing pose is combat-ready")
 State.hero_outfits.ranger = "alternate"
 assert(standing.standing_texture("ranger").get_meta("appearance_style") == "alternate")
 print("PASS: five standing poses, grounded normalized height, heavier fighters and preserved outfits/stats")
 quit()
