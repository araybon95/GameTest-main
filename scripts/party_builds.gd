extends RefCounted
## Default combat bodies; selected alternate/relic outfits retain their own art.
const HEIGHTS = {"warden":285.0,"crusader":290.0,"ranger":260.0,"occultist":255.0}
const BODY_PIXELS = {"warden":479.0,"crusader":461.0,"ranger":440.0,"occultist":443.0}
const REGIONS = {
 "warden":[Rect2(56,61,399,479),Rect2(518,124,532,413),Rect2(1075,0,406,544),Rect2(30,580,455,399),Rect2(552,583,413,398),Rect2(960,810,563,205)],
 "crusader":[Rect2(62,68,398,461),Rect2(539,121,546,408),Rect2(1079,10,386,519),Rect2(51,531,315,453),Rect2(501,605,438,379),Rect2(976,868,542,123)],
 "occultist":[Rect2(83,32,328,513),Rect2(481,152,608,380),Rect2(1101,6,422,539),Rect2(23,552,400,429),Rect2(525,596,445,378),Rect2(936,838,594,170)],
 "ranger":[Rect2(95,76,336,440),Rect2(573,44,437,472),Rect2(1082,42,379,474),Rect2(91,562,334,433),Rect2(588,567,403,428),Rect2(1053,779,457,203)],
}
# Absolute body anchors in each atlas; weapons do not move the pivot.
const ANCHORS = {"warden":[277,735,1259,271,858,1250],"crusader":[227,717,1292,208,692,1271],"occultist":[229,705,1325,241,697,1230],"ranger":[278,752,1265,280,795,1280]}
static var parts: Dictionary = {}
static var cache: Dictionary = {}
static func eligible(original: Texture2D) -> bool:
 if original == null or original.get_meta("portrait_view",false): return false
 if not HEIGHTS.has(str(original.get_meta("pose_id",""))): return false
 if original.get_meta("appearance_style","") in ["alternate","equipment"]: return false
 return original.get_meta("warden_outfit","original") == "original"
static func idle(original: Texture2D) -> Texture2D:
 if original != null and original.has_meta("weapon_id"): return original
 return pose(original,"idle") if eligible(original) else original
static func supports(texture: Texture2D) -> bool:
 return texture != null and HEIGHTS.has(str(texture.get_meta("party_build","")))
static func pose(original: Texture2D, state: String) -> Texture2D:
 if original != null and original.has_meta("weapon_id"): return preload("res://scripts/weapon_visuals.gd").from_texture(original,state)
 var id: String = str(original.get_meta("party_build",original.get_meta("pose_id","")))
 var key: String = id+":"+state
 if cache.has(key): return cache[key]
 var index: int = {"idle":0,"attack":1,"windup":2,"cast":2,"guard":3,"hurt":4,"death":5}.get(state,0)
 if id == "ranger": index = {"idle":0,"attack":2,"windup":1,"cast":2,"guard":3,"hurt":4,"death":5}.get(state,0)
 if id in ["warden","crusader"] and state == "cast": index = 3
 var sheet: Texture2D = load("res://assets/art_library/party_builds/%s.png" % id)
 var area: Rect2 = REGIONS[id][index]
 var anchor: float = float(ANCHORS[id][index])-area.position.x
 var texture := AtlasTexture.new()
 texture.atlas = sheet
 texture.region = area
 # Exclude a neighboring corpse's corner without cutting the held staff/shield.
 if index == 4 and id in ["warden","occultist"]:
  var part_key: String = id+":hurt"
  if not parts.has(part_key):
   var source: Image = sheet.get_image()
   var part := Image.create(int(area.size.x),int(area.size.y),false,Image.FORMAT_RGBA8)
   var cut_y: int = 227 if id == "warden" else 242
   var lower_width: int = 408 if id == "warden" else 411
   part.blit_rect(source,Rect2i(area.position,Vector2i(int(area.size.x),cut_y)),Vector2i.ZERO)
   part.blit_rect(source,Rect2i(Vector2i(area.position)+Vector2i(0,cut_y),Vector2i(lower_width,int(area.size.y)-cut_y)),Vector2i(0,cut_y))
   parts[part_key] = ImageTexture.create_from_image(part)
  texture.atlas = parts[part_key]
  texture.region = Rect2(Vector2.ZERO,area.size)
 # Local atlas overlap masks keep every approved body pixel and its registration.
 if (id == "warden" and index == 5) or (id == "crusader" and index == 2):
  var part_key: String = id+":edge:"+str(index)
  if not parts.has(part_key):
   # Keep sheet coordinates: status shaders also use atlas UVs.
   var part: Image = sheet.get_image()
   var mask := Rect2i(0,125,5,40) if id == "warden" else Rect2i(0,369,8,29)
   mask.position += Vector2i(area.position)
   part.fill_rect(mask,Color.TRANSPARENT)
   parts[part_key] = ImageTexture.create_from_image(part)
  texture.atlas = parts[part_key]
 # Minimal side padding centers the feet without inflating combat/UI bounds.
 # Variable pose heights retain the idle sheet scale through combat_presentation.
 var left_pad: float = maxf(0,area.size.x-2*anchor)
 var right_pad: float = maxf(0,2*anchor-area.size.x)
 texture.margin = Rect2(left_pad,0,left_pad+right_pad,0)
 texture.filter_clip = true
 texture.set_meta("party_build",id)
 texture.set_meta("pose_id",id)
 texture.set_meta("combat_state",state)
 texture.set_meta("idle_pixel_height",REGIONS[id][0].size.y)
 texture.set_meta("body_height_pixels",BODY_PIXELS[id])
 texture.set_meta("hit_point",Vector2(texture.get_width()/2.0,area.size.y-float(BODY_PIXELS[id])*0.62))
 texture.set_meta("emitter_point",Vector2(texture.get_width()/2.0+220,area.size.y-336) if id == "ranger" else Vector2(texture.get_width()/2.0+170,area.size.y-float(BODY_PIXELS[id])*0.65))
 if id == "warden":
  texture.set_meta("appearance_style","warden_complete")
  texture.set_meta("warden_outfit","original")
 cache[key] = texture
 return texture

static func visible_rect(fighter: TextureRect) -> Rect2:
 if not fighter.texture is AtlasTexture:
  var bounds: Rect2 = fighter.texture.get_meta("registered_bounds",Rect2(Vector2.ZERO,fighter.texture.get_size()))
  var scale_factor: Vector2 = fighter.size/fighter.texture.get_size()
  return Rect2(fighter.position+bounds.position*scale_factor,bounds.size*scale_factor)
 var atlas: AtlasTexture = fighter.texture
 var factor: Vector2 = fighter.size/atlas.get_size()
 return Rect2(fighter.position+atlas.margin.position*factor,atlas.region.size*factor)
static func point(fighter: TextureRect, key: String) -> Vector2:
 var local: Vector2 = fighter.texture.get_meta(key,Vector2(512,400))
 return fighter.get_transform()*(local*fighter.size/fighter.texture.get_size())
