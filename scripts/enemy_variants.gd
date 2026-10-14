extends Node
## Cosmetic-only Raider animation. Selection never consumes gameplay RNG.
const SHEET = "res://assets/art_library/enemy_variants/ash_raider_hooded.png"
## Measured cells include complete weapons and leave adjacent poses out.
const CELLS = [
 Rect2i(0,0,380,380),Rect2i(390,0,350,380),Rect2i(750,0,350,380),Rect2i(1110,0,338,380),
 Rect2i(0,385,380,360),Rect2i(400,385,345,360),Rect2i(747,385,356,360),Rect2i(1105,385,343,360),
 Rect2i(0,750,405,336),Rect2i(420,750,330,336),Rect2i(755,750,345,336),Rect2i(1105,750,343,336),
]
const ANCHORS = [220,590,955,1310,210,590,970,1310,220,600,940,1280]
static var frames: Array[Texture2D] = []
var elapsed: float = 0.0
static func choose(creature: String, seed_value: int, floor_id: int, room: Vector2i, slot: int) -> String:
 if creature != "ash_raider": return ""
 var key: String = "%d:%d:%d:%d:%d" % [seed_value,floor_id,room.x,room.y,slot]
 return SHEET if key.hash()%2 == 0 else ""
static func supports(texture: Texture2D) -> bool:
 return texture != null and texture.get_meta("enemy_variant","") == "hooded_raider"
static func frame(index: int) -> Texture2D:
 if frames.is_empty():
  var sheet: Texture2D = load(SHEET)
  if sheet == null: return null
  var cell := Vector2(400,400)
  var image: Image = sheet.get_image()
  for i in range(12):
   var texture := AtlasTexture.new()
   texture.atlas = sheet
   var origin := Vector2(CELLS[i].position)
   var bounds: Rect2i = image.get_region(CELLS[i]).get_used_rect()
   if i == 0:
    bounds = bounds.grow(8).intersection(Rect2i(Vector2i.ZERO,CELLS[i].size))
    # Keep the baseline at the painted feet; padding is only above/alongside.
    var painted_bottom: int = image.get_region(CELLS[i]).get_used_rect().end.y
    bounds.size.y = painted_bottom-bounds.position.y
   texture.region = Rect2(origin+Vector2(bounds.position),Vector2(bounds.size))
   # Equal canvases and a common bottom anchor prevent scale/foot jitter.
   texture.margin = Rect2(200-(ANCHORS[i]-origin.x-bounds.position.x),cell.y-bounds.size.y,cell.x-bounds.size.x,cell.y-bounds.size.y)
   texture.filter_clip = true
   texture.set_meta("enemy_variant","hooded_raider")
   texture.set_meta("variant_frame",i)
   texture.set_meta("idle_pixel_height",cell.y)
   frames.append(texture)
 return frames[clampi(index,0,11)]
static func sample(original: Texture2D, state: String, progress: float, animate: bool = true) -> Texture2D:
 if not supports(original): return original
 var t: float = clampf(progress,0,1) if animate else 1.0
 var index: int = 0
 match state:
  "idle": index = 0
  "windup": index = 3 if t < 0.5 else 4
  "attack", "cast": index = 5 if t < 0.5 else 6
  "recover": index = 7
  "hurt": index = 8 if t < 0.5 else 9
  "death": index = 10 if t < 0.5 and animate else 11
 return frame(index)
static func attach(target: TextureRect) -> void:
 if not supports(target.texture) or target.has_node("EnemyVariantMotion"): return
 var motion = load("res://scripts/enemy_variants.gd").new()
 motion.name = "EnemyVariantMotion"
 target.add_child(motion)
static func breathing(elapsed_seconds: float) -> float:
 return 6.0*(0.5-0.5*cos(elapsed_seconds*TAU/1.6))
static func upper_weight(local_y: float) -> float:
 return 1.0-smoothstep(0.22,0.62,local_y)
static func limb_weight(point: Vector2) -> float:
 # Source-pixel islands stop at the forearms and outside the leg silhouettes.
 var edge: float = 146.0-0.5*(point.y-240.0) if point.y < 270.0 else 131.0-0.6*(point.y-270.0)
 var outside_leg: float = 1.0-smoothstep(edge-3.0,edge,point.x)
 var weapon: float = smoothstep(20,30,point.x)*outside_leg*smoothstep(218,235,point.y)*(1.0-smoothstep(325,340,point.y))
 var left: float = smoothstep(90,100,point.x)*(1.0-smoothstep(150,165,point.x))*smoothstep(175,195,point.y)*(1.0-smoothstep(235,255,point.y))*outside_leg
 var right: float = smoothstep(275,290,point.x)*(1.0-smoothstep(328,340,point.x))*smoothstep(175,195,point.y)*(1.0-smoothstep(235,245,point.y))
 return maxf(weapon,maxf(left,right))
static func idle_offset(point: Vector2, breath: float) -> Vector2:
 var region: Rect2 = frame(0).region
 var local: Vector2 = (point-region.position)/region.size
 var upper: float = upper_weight(local.y)
 var torso := Vector2(-(local.x-0.5)*breath*0.5*upper,breath*upper)
 # Blade and gripping hand share a translation, preserving the cleaver shape.
 return torso.lerp(Vector2(0.9,1.8)*breath/6.0,limb_weight(point))
func _process(delta: float) -> void:
 var target: TextureRect = get_parent()
 if not supports(target.texture): return
 var material: ShaderMaterial = target.material as ShaderMaterial
 if material == null: return
 var status = target.get_node_or_null("StatusVisual")
 if not target.is_visible_in_tree() or (status != null and status.dead):
  material.set_shader_parameter("raider_breath",0.0)
  return
 var settings = get_node_or_null("/root/GameSettings")
 var controls = get_node_or_null("/root/GameControls")
 var animate: bool = settings == null or settings.ambient_motion
 if not animate: material.set_shader_parameter("raider_breath",0.0)
 if (settings != null and is_instance_valid(settings.overlay)) or (controls != null and controls.is_modal_open()): return
 if animate: elapsed += delta
 target.texture = frame(0)
 var region: Rect2 = target.texture.region
 var size: Vector2 = target.texture.atlas.get_size()
 material.set_shader_parameter("raider_region",Vector4(region.position.x/size.x,region.position.y/size.y,region.size.x/size.x,region.size.y/size.y))
 material.set_shader_parameter("raider_breath",breathing(elapsed) if animate else 0.0)
