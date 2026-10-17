extends TextureRect
## Standing party art shared by the map, entrance and automatic travel.
const State = preload("res://scripts/game_data.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
const HEAD_FRACTIONS = {"ranger":0.026,"occultist":0.084,"healer":0.156}
static var textures: Dictionary = {}
var hero_id: String = ""
var foot: Vector2
var base_height: float = 200.0
var clock: float = 0.0
var appearance_path: String = ""
var equipment_key: String = ""
var palette: String = ""
static func heavy(id: String) -> bool: return id in ["warden","crusader"]
static func standing_texture(id: String) -> Texture2D:
 var selected: Texture2D = preload("res://scripts/weapon_visuals.gd").selected(State,id)
 if selected != null:
  selected.set_meta("standing_pose",true)
  selected.set_meta("standing_body_height",selected.get_meta("body_height_pixels"))
  return selected
 var path: String = State.hero(id).art
 if textures.has(path): return textures[path]
 var source: Texture2D = load(path)
 var bounds: Rect2i = source.get_image().get_used_rect()
 var result := AtlasTexture.new()
 if source is AtlasTexture:
  result.atlas = source.atlas
  result.region = Rect2(source.region.position+Vector2(bounds.position),Vector2(bounds.size))
 else:
  result.atlas = source
  result.region = Rect2(bounds)
 result.filter_clip = true
 for key in source.get_meta_list(): result.set_meta(key,source.get_meta(key))
 result.set_meta("pose_id",id)
 result.set_meta("standing_pose",true)
 result.set_meta("standing_body_height",bounds.size.y*(1.0-float(HEAD_FRACTIONS.get(id,0.0))))
 result.set_meta("idle_pixel_height",bounds.size.y)
 textures[path] = result
 return result
static func create(id: String, feet: Vector2, height: float) -> TextureRect:
 var image = load("res://scripts/standing_party.gd").new()
 image.hero_id = id
 image.foot = feet
 image.base_height = height
 image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 image.stretch_mode = TextureRect.STRETCH_SCALE
 image.mouse_filter = Control.MOUSE_FILTER_IGNORE
 image.set_meta("hero_id",id)
 image.set_meta("palette_preview",true)
 image.refresh_art()
 return image
func refresh_art() -> void:
 appearance_path = State.hero(hero_id).art
 equipment_key = preload("res://scripts/weapon_visuals.gd").appearance_key(State,hero_id)
 texture = load("res://scripts/standing_party.gd").standing_texture(hero_id)
 var physical_height: float = base_height*(1.08 if heavy(hero_id) else 1.0)
 var pixels: float = maxf(1.0,texture.get_meta("standing_body_height",texture.get_height()))
 size = Vector2(texture.get_width()/pixels*physical_height*(1.05 if heavy(hero_id) else 1.0),texture.get_height()/pixels*physical_height)
 position = foot-Vector2(size.x*0.5,size.y)
 pivot_offset = Vector2(size.x*0.5,size.y)
 material = null
 palette = str(State.hero_colors.get(hero_id,"original"))
 Scenery.apply_hero_palette(self,hero_id,palette)
 if has_node("WardenIdleMotion"): get_node("WardenIdleMotion").set_process(false)
 modulate.a = 0.25 if State.run_heroes.get(hero_id,{}).get("dead",false) else 1.0
func _process(delta: float) -> void: update_motion(delta)
func update_motion(delta: float) -> void:
 if appearance_path != State.hero(hero_id).art or equipment_key != preload("res://scripts/weapon_visuals.gd").appearance_key(State,hero_id) or palette != str(State.hero_colors.get(hero_id,"original")): refresh_art()
 var settings = get_node_or_null("/root/GameSettings")
 var controls = get_node_or_null("/root/GameControls")
 var enabled: bool = settings == null or settings.ambient_motion
 var paused: bool = (settings != null and is_instance_valid(settings.overlay)) or (controls != null and controls.is_modal_open())
 var alive: bool = not State.run_heroes.get(hero_id,{}).get("dead",false)
 if enabled and not paused and alive: clock += delta
 scale.y = 1.0+sin(clock*TAU/3.6)*0.003 if enabled and alive else 1.0
