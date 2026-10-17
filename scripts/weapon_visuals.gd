extends RefCounted
## Native-resolution registered composition; no equipment state mutation.
const Items = preload("res://scripts/item_data.gd")
const Manifest = preload("res://assets/art_library/weapons/manifest.gd")
const MAX_CACHE = 64
## Composites are only an intermediate step for runtime frames, so few are kept.
const MAX_COMPOSITES = 16
## A full four-hero party needs about 64 runtime frames; keep room for previews.
const MAX_RUNTIME = 96
static var cache: Dictionary = {}
static var errors: Array[String] = []

static func weapon_id(state, hero_id: String, preview_item: String = "") -> String:
 var item: String = str(state.equipment.get(hero_id,{}).get("weapon",""))
 if not preview_item.is_empty() and state.Items.item(preview_item).get("slot","") == "weapon": item = preview_item
 return str(Manifest.STARTERS.get(hero_id,"")) if item.is_empty() else state.Items.base_id(item)

static func frame(state, hero_id: String, style: String, pose: String, preview_item: String = "") -> Texture2D:
 return _frame_for_weapon(hero_id,style,pose,weapon_id(state,hero_id,preview_item))

static func _key(hero_id: String, style: String, pose: String, weapon: String) -> String:
 return "|".join([hero_id,style,weapon,pose])

static func _image(path: String) -> Image:
 if path.begins_with("res://") and ResourceLoader.exists(path):
  var resource = load(path)
  return resource.get_image() if resource is Texture2D else null
 return Image.load_from_file(path) if FileAccess.file_exists(path) else null

static func _record_errors(record: Dictionary) -> Array[String]:
 var result: Array[String] = []
 if not record.get("canvas_size") is Vector2i or record.canvas_size.x <= 0 or record.canvas_size.y <= 0:
  result.append("Missing positive native canvas size")
 if not record.get("foot") is Vector2 or not record.get("foot",Vector2.INF).is_finite():
  result.append("Missing finite foot registration")
 var metadata: Variant = record.get("metadata")
 if not metadata is Dictionary:
  result.append("Missing body registration metadata")
 else:
  if metadata.get("pose_id","") != record.get("hero",""): result.append("Missing matching body identity")
  for field in ["body_height_pixels","idle_pixel_height"]:
   var value: Variant = metadata.get(field)
   if (not value is float and not value is int) or not is_finite(float(value)) or float(value) <= 0:
    result.append("Missing positive body registration: "+field)
  for field in ["hit_point","emitter_point"]:
   if not metadata.get(field) is Vector2 or not metadata.get(field,Vector2.INF).is_finite():
    result.append("Missing finite body registration: "+field)
 var grips: Variant = record.get("grips")
 if not grips is Array or grips.is_empty():
  result.append("Missing grip registration")
 else:
  for grip in grips:
   if not grip is Vector2 or not grip.is_finite(): result.append("Malformed grip registration")
 var axis: Variant = record.get("weapon_axis")
 if not axis is PackedVector2Array or axis.size() != 2:
  result.append("Missing two-point weapon axis")
 elif not axis[0].is_finite() or not axis[1].is_finite() or axis[0].is_equal_approx(axis[1]):
  result.append("Invalid weapon axis")
 if not record.get("layers") is Array:
  result.append("Missing layers")
  return result
 var roles: Array[String] = []
 var order: int = -1
 for layer in record.layers:
  if not layer is Dictionary or not layer.get("path") is String or not layer.get("offset") is Vector2i:
   result.append("Malformed layer")
   continue
  var role: String = str(layer.get("role",""))
  var index: int = ["rear_weapon","body","front_weapon","hands","full_frame"].find(role)
  if index < 0 or index < order: result.append("Invalid layer order")
  order = index
  roles.append(role)
  if not FileAccess.file_exists(layer.path) and not ResourceLoader.exists(layer.path): result.append("Missing layer: "+layer.path)
 if roles != ["full_frame"] and (not roles.has("body") or not roles.has("hands") or (not roles.has("front_weapon") and not roles.has("rear_weapon"))):
  result.append("Body, weapon and foreground hands are required")
 return result

static func _frame_for_weapon(hero_id: String, style: String, pose: String, weapon: String) -> Texture2D:
 var key: String = _key(hero_id,style,pose,weapon)
 if cache.has(key): return _recall(cache,key)
 if not Manifest.frames.has(key):
  if not errors.has("Missing pose: "+key): errors.append("Missing pose: "+key)
  return null
 var record: Dictionary = Manifest.frames[key]
 var invalid: Array[String] = _record_errors(record)
 if record.get("hero","") != hero_id or record.get("style","") != style or record.get("pose","") != pose or record.get("weapon_profile","") != weapon:
  invalid.append("Manifest identity does not match lookup key")
 for message in invalid:
  if not errors.has(key+": "+message): errors.append(key+": "+message)
 if not invalid.is_empty(): return null
 var image := Image.create(record.canvas_size.x,record.canvas_size.y,false,Image.FORMAT_RGBA8)
 image.fill(Color.TRANSPARENT)
 for layer in record.layers:
  var source: Image = _image(layer.path)
  if source == null:
   errors.append("Unreadable layer: "+str(layer.path))
   return null
  source.convert(Image.FORMAT_RGBA8)
  image.blend_rect(source,Rect2i(Vector2i.ZERO,source.get_size()),layer.offset)
 var texture := ImageTexture.create_from_image(image)
 for field in record.metadata: texture.set_meta(field,record.metadata[field])
 texture.set_meta("foot_anchor",record.foot)
 texture.set_meta("weapon_id",weapon)
 texture.set_meta("weapon_style",style)
 texture.set_meta("weapon_pose",pose)
 _remember(cache,key,texture,MAX_COMPOSITES)
 return texture

## Least-recently-used caches: a hit moves the entry to the newest end.
static func _recall(store: Dictionary, key: Variant) -> Variant:
 var value: Variant = store[key]
 store.erase(key)
 store[key] = value
 return value

static func _remember(store: Dictionary, key: Variant, value: Variant, limit: int) -> void:
 store.erase(key)
 while store.size() >= limit: store.erase(store.keys()[0])
 store[key] = value

static func coverage_errors(hero_id: String, style: String) -> Array[String]:
 var result: Array[String] = []
 for id in Items.EQUIPMENT:
  var item: Dictionary = Items.EQUIPMENT[id]
  if item.get("hero","") != hero_id or item.get("slot","") != "weapon": continue
  var poses: Array = Manifest.POSES.duplicate()
  if hero_id == "warden": poses.append_array(["execution_0","execution_1","execution_2","execution_3","execution_4","execution_contact"])
  if style == "original" and hero_id == "ranger":
   for i in range(6): poses.append("study_execution_"+str(i))
  if style == "original" and hero_id == "crusader":
   for i in range(3): poses.append("study_execution_"+str(i))
   for i in range(2): poses.append("study_contact_"+str(i))
  for pose in poses:
   var key: String = _key(hero_id,style,pose,id)
   if not Manifest.frames.has(key): result.append("Missing pose: "+key)
   else:
    var record: Dictionary = Manifest.frames[key]
    for message in _record_errors(record): result.append(key+": "+message)
    if str(record.get("hero","")) != hero_id or str(record.get("style","")) != style or str(record.get("pose","")) != pose or str(record.get("weapon_profile","")) != id:
     result.append(key+": Manifest identity does not match lookup key")
 return result

static func clear_cache() -> void:
 cache.clear()
 runtime_cache.clear()
 display_cache.clear()
 errors.clear()

## Runtime canvases end at the sole line and keep it horizontally centred.
## This preserves the existing scene contract without moving bodies or weapons.
static var runtime_cache: Dictionary = {}
static func runtime_frame(hero_id: String, style: String, pose: String, weapon: String) -> Texture2D:
 var key: String = _key(hero_id,style,pose,weapon)
 if runtime_cache.has(key): return _recall(runtime_cache,key)
 var source: Texture2D = _frame_for_weapon(hero_id,style,pose,weapon)
 if source == null: return null
 var foot: Vector2 = source.get_meta("foot_anchor")
 var half: int = 350
 var offset := Vector2i(half-int(foot.x),0)
 var image := Image.create(half*2,int(foot.y),false,Image.FORMAT_RGBA8)
 image.fill(Color.TRANSPARENT)
 image.blit_rect(source.get_image(),Rect2i(Vector2i.ZERO,Vector2i(source.get_width(),int(foot.y))),offset)
 var crop_top: int = 0
 if pose.begins_with("walk_"):
  crop_top = image.get_used_rect().position.y
  image = image.get_region(Rect2i(0,crop_top,image.get_width(),image.get_height()-crop_top))
 var texture := ImageTexture.create_from_image(image)
 for field in source.get_meta_list(): texture.set_meta(field,source.get_meta(field))
 texture.set_meta("foot_anchor",Vector2(half,image.get_height()))
 texture.set_meta("idle_pixel_height",float(image.get_height()))
 for field in ["hit_point","emitter_point"]: texture.set_meta(field,source.get_meta(field)+Vector2(offset.x,-crop_top))
 texture.set_meta("combat_state",pose)
 texture.set_meta("party_build",hero_id)
 texture.set_meta("appearance_style","equipment" if style == "relic" else "alternate" if style == "alternate" else "warden_complete" if hero_id == "warden" else source.get_meta("appearance_style",""))
 if pose.begins_with("walk_"):
  texture.set_meta("stride_anchor",0.5)
  texture.set_meta("arm_center",Vector2.ZERO)
  texture.set_meta("arm_shift",Vector2.ZERO)
  texture.set_meta("stride_scale",float(image.get_height())/float(source.get_meta("body_height_pixels"))*(1.08 if hero_id in ["warden","crusader"] else 1.0))
 texture.set_meta("registered_bounds",Rect2(image.get_used_rect()))
 _remember(runtime_cache,key,texture,MAX_RUNTIME)
 return texture

static func selected(state, hero_id: String, pose: String = "idle", preview_item: String = "") -> Texture2D:
 if not Manifest.ENABLED.get(hero_id,false) or not state.equipment_appearance: return null
 var style: String = str(state.hero(hero_id,preview_item).get("equipment_look","original"))
 return runtime_frame(hero_id,style,pose,weapon_id(state,hero_id,preview_item))

static func from_texture(original: Texture2D, pose: String) -> Texture2D:
 if original == null or not original.has_meta("weapon_id"): return null
 return runtime_frame(str(original.get_meta("pose_id")),str(original.get_meta("weapon_style")),pose,str(original.get_meta("weapon_id")))

static func path_frame(state, path: String) -> Texture2D:
 if not state.equipment_appearance: return null
 for hero in Manifest.ENABLED:
  if not Manifest.ENABLED[hero]: continue
  var data: Dictionary = state.hero(hero)
  if path == data.get("art",""): return selected(state,hero)
  if path == data.get("camp_art",""): return selected(state,hero,"camp")
  if path == data.get("portrait_art","") and state.hero_portraits.get(hero,"full") != "bust": return selected(state,hero,"portrait")
 return null

static func walks(state, hero_id: String) -> Array[Texture2D]:
 var frames: Array[Texture2D] = []
 if not Manifest.ENABLED.get(hero_id,false) or not state.equipment_appearance: return frames
 var style: String = str(state.hero(hero_id).get("equipment_look","original"))
 var count: int = 10 if hero_id == "warden" and style in ["original","ashen_wolf"] else 4
 for i in range(count): frames.append(selected(state,hero_id,"walk_"+str(i)))
 return frames

static func appearance_key(state, hero_id: String) -> String:
 return str(state.hero(hero_id).get("equipment_look","original"))+"|"+weapon_id(state,hero_id)+"|"+str(state.equipment_appearance)

static var display_cache: Dictionary = {}
static func display_texture(source: Texture2D) -> Texture2D:
 if source == null or not source.has_meta("weapon_id") or source.get_meta("display_cropped",false): return source
 var cache_key: int = source.get_instance_id()
 if display_cache.has(cache_key): return _recall(display_cache,cache_key)
 var image: Image = source.get_image()
 var bounds: Rect2i = image.get_used_rect()
 if bounds.size.x <= 0 or bounds.size.y <= 0: return source
 var texture := ImageTexture.create_from_image(image.get_region(bounds))
 for key in source.get_meta_list(): texture.set_meta(key,source.get_meta(key))
 for key in ["foot_anchor","hit_point","emitter_point"]: texture.set_meta(key,source.get_meta(key)-Vector2(bounds.position))
 texture.set_meta("idle_pixel_height",float(bounds.size.y))
 texture.set_meta("display_cropped",true)
 _remember(display_cache,cache_key,texture,MAX_CACHE)
 return texture

static func execution_frame(_state, hero_id: String, style: String, phase: String, explicit_weapon: String) -> Texture2D:
 return _frame_for_weapon(hero_id,style,phase,explicit_weapon)
