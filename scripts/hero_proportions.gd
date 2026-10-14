extends RefCounted
## Shared visual class builds, measured from visible bodies rather than atlas padding.
const BUILDS = {"warden":Vector2(1.10,1.08),"crusader":Vector2(1.10,1.08),"ranger":Vector2(0.90,0.95),"healer":Vector2(0.90,1.0),"occultist":Vector2(0.90,1.0)}
# Staff tips and bow tips sit above the head; they do not set body height.
const HEAD_FRACTIONS = {"ranger":0.026,"occultist":0.084,"healer":0.156}
static var textures: Dictionary = {}
static func width_factor(id: String) -> float:
 return BUILDS.get(id,Vector2.ONE).x
static func texture(source: Texture2D, id: String) -> Texture2D:
 if source == null: return null
 var key: String = "%s:%s" % [id,source.get_rid().get_id()]
 if textures.has(key): return textures[key]
 var pixels: Image = source.get_image()
 var bounds: Rect2i = pixels.get_used_rect()
 if bounds.size.x <= 0 or bounds.size.y <= 0: return source
 # get_image includes AtlasTexture margins. Cropping that image avoids translating
 # padded atlas coordinates into a neighbouring pose or cutting off costume edges.
 var cropped := ImageTexture.create_from_image(pixels.get_region(bounds))
 for meta in source.get_meta_list(): cropped.set_meta(meta,source.get_meta(meta))
 cropped.set_meta("hero_source_art",source.resource_path)
 cropped.set_meta("pose_id",id)
 cropped.set_meta("hero_body_fraction",1.0-float(HEAD_FRACTIONS.get(id,0.0)))
 cropped.set_meta("idle_pixel_height",bounds.size.y)
 textures[key] = cropped
 return cropped
static func dimensions(source: Texture2D, id: String, body_height: float) -> Vector2:
 var build: Vector2 = BUILDS.get(id,Vector2.ONE)
 var height: float = body_height*build.y/maxf(0.01,float(source.get_meta("hero_body_fraction",1.0)))
 return Vector2(height*source.get_width()/float(maxi(1,source.get_height()))*build.x,height)
