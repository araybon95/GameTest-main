extends SceneTree
## Extracts existing approved frames; no costume, pose or weapon is authored here.
const State = preload("res://scripts/game_data.gd")
const Builds = preload("res://scripts/party_builds.gd")
const Appearance = preload("res://scripts/hero_appearance.gd")
const Equipment = preload("res://scripts/equipment_art.gd")
const Poses = ["idle","attack","hurt","guard","walk_0","walk_1","walk_2","walk_3","camp","death","windup","cast"]
func _initialize() -> void: call_deferred("run")
func raster(texture: Texture2D) -> Image:
 var source: Image = texture.get_image()
 if not texture is AtlasTexture: return source
 var result := Image.create(texture.get_width(),texture.get_height(),false,Image.FORMAT_RGBA8)
 result.fill(Color.TRANSPARENT)
 result.blit_rect(source,Rect2i(Vector2i.ZERO,source.get_size()),Vector2i(texture.margin.position))
 return result
func source_frame(hero: String, style: String, pose: String) -> Texture2D:
 if style != "original":
  var art = Appearance if style == "alternate" else Equipment
  if hero == "ranger" and style == "relic" and pose in ["windup","cast"]: return art.frame(hero,1)
  if pose.begins_with("walk_"): return art.frame(hero,4+int(pose.trim_prefix("walk_")))
  if pose == "camp": return art.frame(hero,8)
  return art.pose(art.frame(hero,0),pose)
 if pose.begins_with("walk_"):
  var texture := AtlasTexture.new()
  texture.atlas = load("res://assets/art_library/generated/hero_"+hero+"_walk.png")
  texture.region = preload("res://scripts/ink_sprite_regions.gd").WALK[hero][int(pose.trim_prefix("walk_"))]
  return texture
 if pose == "camp": return load(State.HEROES[hero].camp_art)
 return Builds.pose(load(State.HEROES[hero].art),pose)
func run() -> void:
 for hero in ["ranger","crusader","occultist"]:
  var dir: String = "res://experimental/weapon_swapping/"+hero+"/"
  DirAccess.make_dir_recursive_absolute(dir+"assets")
  var registration: Dictionary = {}
  for style in ["original","alternate","relic"]:
   var sheet := Image.create(1536,1024,false,Image.FORMAT_RGBA8)
   sheet.fill(Color.TRANSPARENT)
   registration[style] = []
   for index in range(12):
    var pose: String = Poses[index]
    var texture: Texture2D = source_frame(hero,style,pose)
    var image := raster(texture)
    var baseline: float = float(Builds.BODY_PIXELS[hero]) if style == "original" else float(source_frame(hero,style,"idle").get_height())
    var factor: float = minf(270.0/baseline,minf(325.0/image.get_height(),370.0/image.get_width()))
    var old_size: Vector2 = image.get_size()
    image.resize(maxi(1,roundi(old_size.x*factor)),maxi(1,roundi(old_size.y*factor)),Image.INTERPOLATE_LANCZOS)
    var cell := Vector2i((index%4)*384,(index/4)*341)
    var foot := Vector2i(cell.x+192,cell.y+333)
    var offset := foot-Vector2i(image.get_width()/2,image.get_height())
    sheet.blit_rect(image,Rect2i(Vector2i.ZERO,image.get_size()),offset)
    registration[style].append({"pose":pose,"foot":[192,333],"body_height":baseline*factor,"source_size":[old_size.x,old_size.y],"scale":factor})
   assert(sheet.save_png(dir+"assets/"+style+"-reference.png") == OK)
  var output := FileAccess.open(dir+"registration.json",FileAccess.WRITE)
  output.store_string(JSON.stringify(registration,"  ")+"\n")
 print("PASS: extracted nine exact approved class/outfit reference atlases with registered soles and real combat/travel/camp/death poses")
 quit()
