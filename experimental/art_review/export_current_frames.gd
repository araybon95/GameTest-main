extends SceneTree
const Builds = preload("res://scripts/party_builds.gd")
const Ink = preload("res://scripts/ink_sprite_regions.gd")
var records: Array = []
var output: String = "/tmp/art-review-repaired-frames"
var raider_padding := Vector2i.ZERO
func _initialize() -> void: call_deferred("run")
func frame(texture: Texture2D, family: String, state: String, source: String, status: String) -> void:
 var pixels: Image = texture.get_image()
 var original_size: Vector2i = pixels.get_size()
 var offset := Vector2i.ZERO
 if texture is AtlasTexture:
  original_size = Vector2i(texture.get_size())
  offset = raider_padding if family == "hooded-raider" else Vector2i(maxi(0,-floori(texture.margin.position.x)),maxi(0,-floori(texture.margin.position.y)))
  var end: Vector2i = Vector2i(texture.margin.position)+pixels.get_size()+offset
  var dimensions: Vector2i = (original_size+offset).max(end)
  var full := Image.create(dimensions.x,dimensions.y,false,Image.FORMAT_RGBA8)
  full.blit_rect(pixels,Rect2i(Vector2i.ZERO,pixels.get_size()),Vector2i(texture.margin.position)+offset)
  pixels = full
 var filename: String = family+"--"+state+".png"
 assert(pixels.save_png(output+"/"+filename) == OK)
 records.append({"family":family,"state":state,"file":filename,"source":source,"status":status,"dimensions":[pixels.get_width(),pixels.get_height()],"original_registered_dimensions":[original_size.x,original_size.y],"canvas_origin_offset":[offset.x,offset.y],"sha256":FileAccess.get_sha256(output+"/"+filename)})
func run() -> void:
 var args: PackedStringArray = OS.get_cmdline_user_args()
 if not args.is_empty(): output = args[0]
 assert(DirAccess.make_dir_recursive_absolute(output) == OK)
 # Share padding across the entire sequence so comparison anchors stay consistent.
 for i in range(12):
  var texture: AtlasTexture = preload("res://scripts/enemy_variants.gd").frame(i)
  raider_padding = raider_padding.max(Vector2i(maxi(0,-floori(texture.margin.position.x)),maxi(0,-floori(texture.margin.position.y))))
 for id in Builds.HEIGHTS:
  var reference := AtlasTexture.new()
  reference.set_meta("pose_id",id)
  for state in ["idle","windup","attack","guard","cast","hurt","death"]:
   frame(Builds.pose(reference,state),"default-"+id,state,"assets/art_library/party_builds/"+id+".png","current default combat")
 for id in Ink.COMBAT:
  if id in ["warden","crusader","ranger","occultist","raider"]: continue
  var sheet := Image.load_from_file(ProjectSettings.globalize_path(Ink.SHEETS[id]))
  for i in range(Ink.COMBAT[id].size()):
   var image := ImageTexture.create_from_image(sheet.get_region(Rect2i(Ink.COMBAT[id][i])))
   frame(image,"combat-atlas-"+id,"frame-%02d"%i,Ink.SHEETS[id].trim_prefix("res://"),"combat atlas reference; check routing before treating as current")
 for i in range(12):
  frame(preload("res://scripts/enemy_variants.gd").frame(i),"hooded-raider","frame-%02d"%i,preload("res://scripts/enemy_variants.gd").SHEET.trim_prefix("res://"),"current hooded raider variant")
 for outfit in ["original","ashen_wolf"]:
  for i in range(12):
   frame(preload("res://scripts/warden_outfits.gd").frame(outfit,i),"warden-outfit-"+outfit,"frame-%02d"%i,"assets/art_library/warden_outfits/"+outfit+".png","selectable outfit; do not compare different outfits as continuity errors")
 for kind in ["execution","judgment"]:
  var scene = load("res://experimental/witch_hunter/"+kind+"/showcase.tscn").instantiate()
  root.add_child(scene)
  scene.set_process(false)
  for i in range(scene.sources.size()): frame(scene.sources[i],"witch-hunter-"+kind,"hero-%02d"%i,"experimental/witch_hunter/"+kind+"/assets/","current experimental; not integrated")
  for i in range(scene.contacts.size()): frame(scene.contacts[i],"witch-hunter-"+kind+"-contact","contact-%02d"%i,"experimental/witch_hunter/"+kind+"/assets/","current experimental paired contact; different artwork resolution")
  if kind == "execution":
   for i in range(scene.targets.size()): frame(scene.targets[i],"bandit-execution","reaction-%02d"%i,"experimental/witch_hunter/execution/assets/poses.png","current experimental")
   frame(scene.cleaver,"bandit-cleaver","complete-prop","experimental/witch_hunter/execution/assets/cleaver.png","current standalone prop")
  scene.free()
 var ranger = load("res://experimental/ranger_showcase/showcase.tscn").instantiate()
 root.add_child(ranger)
 ranger.set_process(false)
 for i in range(ranger.source_frames.size()): frame(ranger.source_frames[i],"ranger-execution","hero-%02d"%i,"experimental/ranger_showcase/assets/ranger-execution.png","current experimental")
 for i in range(ranger.target_frames.size()): frame(ranger.target_frames[i],"ranger-bandit-reactions","reaction-%02d"%i,"experimental/ranger_showcase/assets/","current experimental; pose scales differ; use motion strips for world size")
 ranger.free()
 var file := FileAccess.open(output+"/frames.json",FileAccess.WRITE)
 file.store_string(JSON.stringify(records,"  "))
 print("PASS: extracted ",records.size()," complete registered frames, retaining canvas-origin offsets")
 quit()
