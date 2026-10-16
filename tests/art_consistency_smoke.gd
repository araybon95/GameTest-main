extends SceneTree
## Regressions identified by the October art audit; exercises production render inputs.
const Motion = preload("res://scripts/warden_transitions.gd")
const Builds = preload("res://scripts/party_builds.gd")
const Outfits = preload("res://scripts/warden_outfits.gd")
const Presentation = preload("res://scenes/combat/combat_presentation.gd")
var failures: Array[String] = []

func _initialize() -> void: call_deferred("run")

func check(ok: bool, message: String) -> void:
 if not ok: failures.append(message)

func clear_region(texture: AtlasTexture, rect: Rect2i) -> bool:
 var pixels: Image = texture.atlas.get_image().get_region(Rect2i(texture.region))
 for y in range(rect.position.y,rect.end.y):
  for x in range(rect.position.x,rect.end.x):
   if pixels.get_pixel(x,y).a > 0.0: return false
 return true

func run() -> void:
 for skill in ["wd_slash","wd_heavy"]:
  var timing: Dictionary = Motion.timing({},skill)
  var single_pose := true
  for sample in range(300):
   var layers: Array = Motion.layers(float(sample)/240.0,timing,true)
   var visible := 0
   for layer in layers:
    if layer[1] > 0.001: visible += 1
   single_pose = single_pose and visible == 1
  check(single_pose,skill+": a held weapon and body must have one opaque silhouette throughout transitions")
 var original: Texture2D = Outfits.frame("original",0)
 var target := TextureRect.new()
 var cinema := Presentation.new()
 for entry in [
  [Builds.idle(original),true,"default"], [original,true,"original outfit"],
  [Outfits.frame("ashen_wolf",0),false,"Ashen Wolf"],
  [preload("res://scripts/hero_appearance.gd").frame("warden",0),false,"alternate"],
  [preload("res://scripts/equipment_art.gd").frame("warden",0),false,"relic"]]:
  cinema.active = {"source":entry[0],"target_node":target}
  check(cinema.execute_warden(target) == entry[1],"Execution must preserve the selected "+str(entry[2])+" appearance")
 cinema.free()
 target.free()
 var portrait := TextureRect.new()
 portrait.texture = Builds.idle(original)
 portrait.size = Vector2(240,285)
 root.add_child(portrait)
 var visual := preload("res://scenes/combat/status_visual.gd").new()
 visual.attach_to(portrait)
 visual.set_process(false)
 var settings = root.get_node("GameSettings")
 var saved: bool = settings.ambient_motion
 settings.ambient_motion = false
 visual.sync({},50,50)
 visual._process(0.3)
 check(portrait.scale == Vector2.ONE,"Disabling ambient motion must stop healthy portrait breathing")
 visual.sync({},10,50)
 visual._process(0.3)
 check(portrait.scale.is_equal_approx(Vector2(0.97,0.94)),"Reduced motion must retain the static wounded stance")
 visual.sync({},0,50,true)
 visual._process(0.3)
 check(portrait.scale.is_equal_approx(Vector2(0.88,0.76)),"Reduced motion must retain the death stance")
 visual.sync({},50,50)
 settings.ambient_motion = true
 visual._process(0.3)
 check(not is_equal_approx(portrait.scale.y,1.0),"Enabling ambient motion must retain breathing")
 settings.ambient_motion = saved
 portrait.free()
 check(clear_region(Builds.pose(original,"death"),Rect2i(0,125,5,40)),"Warden death must exclude the neighboring boot")
 check(clear_region(Outfits.frame("original",7),Rect2i(0,306,2,6)),"Original travel frame 07 must exclude the neighboring toe")
 check(clear_region(Outfits.frame("ashen_wolf",5),Rect2i(362,220,4,8)),"Ashen Wolf travel frame 05 must exclude the neighboring cape")
 var hunter := AtlasTexture.new()
 hunter.set_meta("pose_id","crusader")
 var hunter_windup: AtlasTexture = Builds.pose(hunter,"windup")
 check(clear_region(hunter_windup,Rect2i(0,369,8,29)),"Witch Hunter windup must exclude the adjacent hammer fragment")
 check(hunter_windup.region == Builds.REGIONS.crusader[2] and hunter_windup.atlas.get_size() == Vector2(1536,1024),"Local masks must preserve atlas UVs used by combat status shaders")
 for entry in [["original",7],["ashen_wolf",5]]:
  var travel: AtlasTexture = Outfits.frame(entry[0],entry[1])
  check(travel.atlas.get_size() == Vector2(1448,1086) and travel.region.position.y == 389,"Travel masks must preserve firelight and forearm shader coordinates")
 hunter.set_meta("pose_id","occultist")
 var flame: AtlasTexture = Builds.pose(hunter,"windup")
 check(flame.region.end.x > 1521 and is_equal_approx(flame.get_width()/2.0,1325-flame.region.position.x+flame.margin.position.x),"Occultist windup must include the full book flame without moving its body anchor")
 await process_frame
 if failures.is_empty(): print("PASS: single Warden silhouettes, outfit-safe executions, reduced motion and clean registered crops")
 else:
  for failure in failures: push_error(failure)
 quit(0 if failures.is_empty() else 1)
