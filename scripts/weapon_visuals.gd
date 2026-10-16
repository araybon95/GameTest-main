extends RefCounted
## Native-resolution registered composition; no equipment state mutation.
const Items = preload("res://scripts/item_data.gd")
const Manifest = preload("res://assets/art_library/weapons/manifest.gd")
const MAX_CACHE = 64
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
 if not record.get("foot") is Vector2 or not record.get("metadata") is Dictionary:
  result.append("Missing body/foot registration")
 if not record.get("grips") is Array or record.get("grips",[]).is_empty() or not record.get("weapon_axis") is PackedVector2Array:
  result.append("Missing grip/weapon-axis registration")
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
 if cache.has(key): return cache[key]
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
 if cache.size() >= MAX_CACHE: cache.erase(cache.keys()[0])
 cache[key] = texture
 return texture

static func coverage_errors(hero_id: String, style: String) -> Array[String]:
 var result: Array[String] = []
 for id in Items.EQUIPMENT:
  var item: Dictionary = Items.EQUIPMENT[id]
  if item.get("hero","") != hero_id or item.get("slot","") != "weapon": continue
  var poses: Array = Manifest.POSES.duplicate()
  if hero_id == "warden": poses.append_array(["execution_0","execution_1","execution_2","execution_3","execution_4","execution_contact"])
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
 errors.clear()
