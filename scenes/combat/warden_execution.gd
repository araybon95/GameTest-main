extends Node2D
## GPU-drawn approved poses. Presentation only; never accesses combat state or RNG.
const ART = "res://assets/art_library/executions/warden/"
const DURATION = 2.4
const FINAL_HIT = 0.95
const ORIGIN = Vector2(500,preload("res://scenes/combat/battlefield_ground.gd").SURFACE_Y-390*1.15)
static var bodies: Array[Texture2D] = []
static var targets: Array[Texture2D] = []
static var contact: Texture2D
static var dropped_weapon: Texture2D
# Sole midpoints measured in the approved, alpha-trimmed illustrations.
# Registration uses anatomy instead of the changing weapon/cape bounding box.
const CONTACT_SOLES = Vector2(469,926)
const FOLLOW_SOLES = Vector2(177.5,310)
const WINDUP_SOLES = Vector2(200,458)
const RECOVERY_SOLES = Vector2(175,374)
const KNEEL_FLOOR = Vector2(275,315)
const CRUSHED_FLOOR = Vector2(268,343)
const WEAPON_REGION = Rect2i(0,254,145,70)
const KNEEL_BLADE = Vector2(4,281)
const KNEEL_HANDLE = Vector2(143,273)
const CRUSHED_BLADE = Vector2(11,324)
const CRUSHED_HANDLE = Vector2(157,317)
var age: float = 0.0
var animate: bool = true
var corpse_only: bool = false
func crop(sheet: Image, rect: Rect2i) -> Texture2D:
 var part: Image = sheet.get_region(rect)
 return ImageTexture.create_from_image(part.get_region(part.get_used_rect()))
func _ready() -> void:
 if not bodies.is_empty(): return
 var sheet: Image = load(ART+"poses.png").get_image()
 var windup: Image = load(ART+"windup.png").get_image()
 var raised := Image.create(382,465,false,Image.FORMAT_RGBA8)
 raised.blend_rect(windup,Rect2i(560,0,320,465),Vector2i(62,0))
 raised.blend_rect(windup,Rect2i(498,270,62,195),Vector2i(0,270))
 var attacks: Image = load(ART+"attacks.png").get_image()
 bodies.append(crop(attacks,Rect2i(1057,28,338,341)))
 bodies.append(crop(attacks,Rect2i(515,729,479,344)))
 bodies.append(ImageTexture.create_from_image(raised.get_region(raised.get_used_rect())))
 bodies.append(crop(sheet,Rect2i(895,150,485,320)))
 bodies.append(crop(sheet,Rect2i(1380,85,345,385)))
 targets.append(crop(load(ART+"raider.png").get_image(),Rect2i(0,0,380,380)))
 for rect in [Rect2i(0,505,452,360),Rect2i(460,525,420,345),Rect2i(890,490,430,375),Rect2i(1320,690,454,187)]:
  targets.append(crop(sheet,rect))
 contact = ImageTexture.create_from_image(load(ART+"contact.png").get_image().get_region(Rect2i(23,2,1492,965)))
 var kneeling: Image = targets[2].get_image()
 var weapon: Image = kneeling.get_region(WEAPON_REGION)
 # Two finger-edge pixels touch this rectangle; they stay with the hand.
 weapon.fill_rect(Rect2i(144,0,1,2),Color.TRANSPARENT)
 dropped_weapon = ImageTexture.create_from_image(weapon)
 kneeling.fill_rect(Rect2i(0,254,144,70),Color.TRANSPARENT)
 kneeling.fill_rect(Rect2i(144,256,1,68),Color.TRANSPARENT)
 targets[2] = ImageTexture.create_from_image(kneeling)
func set_frame(time: float, motion: bool) -> void:
 age = time
 animate = motion
 queue_redraw()
func place(texture: Texture2D, foot: Vector2, scale_factor: float) -> void:
 var dimensions := texture.get_size()*scale_factor
 draw_texture_rect(texture,Rect2(foot-Vector2(dimensions.x*0.5,dimensions.y),dimensions),false)
func registered_rect(texture: Texture2D, anchor: Vector2, floor_point: Vector2, factor: float) -> Rect2:
 return Rect2(floor_point-anchor*factor,texture.get_size()*factor)
func frame_layout(time: float, motion: bool) -> Dictionary:
 var zoom: float = (1.0+0.16*smoothstep(0.0,0.4,time) if time < 1.5 else lerpf(1.16,1.08,smoothstep(1.5,1.8,time))) if motion else 1.0
 var source_index: int = 0 if time < 0.12 else 1 if time < 0.42 else 2 if time < FINAL_HIT else 3 if time < 1.5 else 4
 var target_index: int = 0 if time < 0.29 else 1 if time < 0.42 else 2 if time < FINAL_HIT else 3 if time < 1.18 else 4
 var shift: float = 65*smoothstep(0.05,0.25,time)+65*smoothstep(0.12,0.22,time)*(1-smoothstep(0.34,0.58,time)) if motion else 130.0 if source_index == 1 else 0.0
 var body: Texture2D = bodies[source_index]
 var body_scale: float = minf([0.78,0.78,0.65,0.72,0.64][source_index]*zoom,342.0/body.get_height())
 var half: float = body.get_width()*body_scale*0.5
 var body_anchor := Vector2(body.get_width()*0.5,body.get_height())
 var body_floor := Vector2(clampf(400+(220+shift-400)*zoom,24+half,776-half),390)
 var contact_floor := Vector2(400+(330-400)*zoom,390)
 if source_index == 2:
  # Close the remaining distance during the windup, then plant for impact.
  var previous_floor: Vector2 = body_floor+(WINDUP_SOLES-body_anchor)*body_scale
  body_anchor = WINDUP_SOLES
  body_floor = previous_floor.lerp(contact_floor,smoothstep(0.42,0.72,time) if motion else 1.0)
 elif source_index >= 3:
  body_anchor = FOLLOW_SOLES if source_index == 3 else RECOVERY_SOLES
  body_floor = contact_floor
  if source_index == 4 and motion:
   body_floor.x = lerpf(contact_floor.x,400+(285-400)*zoom,smoothstep(1.5,1.95,time))
 var target: Texture2D = targets[target_index]
 var target_scale: float = [0.77,0.6,0.6,0.58,0.7][target_index]*zoom
 var target_anchor := Vector2(target.get_width()*0.5,target.get_height())
 if target_index == 2: target_anchor = KNEEL_FLOOR
 if target_index == 3: target_anchor = CRUSHED_FLOOR
 var target_floor := Vector2(400+140*zoom,390)
 var pair_scale: float = 0.28*zoom
 # Register the separate prop to the next pose's painted blade AND handle.
 # This lets the final illustration take over without a floor-prop jump.
 var from_axis: Vector2 = KNEEL_HANDLE-KNEEL_BLADE
 var to_axis: Vector2 = CRUSHED_HANDLE-CRUSHED_BLADE
 var weapon_scale: float = 0.58*zoom*to_axis.length()/from_axis.length()
 var weapon_transform := Transform2D(to_axis.angle()-from_axis.angle(),Vector2.ONE*weapon_scale,0,Vector2.ZERO)
 weapon_transform.origin = target_floor+(CRUSHED_BLADE-CRUSHED_FLOOR)*0.58*zoom-weapon_transform.basis_xform(KNEEL_BLADE-Vector2(WEAPON_REGION.position))
 return {"source_index":source_index,"target_index":target_index,
  "paired":time >= FINAL_HIT and time < FINAL_HIT+0.13,
  "body":registered_rect(body,body_anchor,body_floor,body_scale),
  "target":registered_rect(target,target_anchor,target_floor,target_scale),
  "pair":registered_rect(contact,CONTACT_SOLES,contact_floor,pair_scale),
  "weapon_transform":weapon_transform}
func _draw() -> void:
 if bodies.is_empty(): return
 # Keep all execution artwork and gore inside the battlefield, above the HUD.
 draw_set_transform(ORIGIN,0,Vector2(1.15,1.15))
 if corpse_only:
  var held_zoom: float = 1.08 if animate else 1.0
  place(targets[4],Vector2(400+140*held_zoom,390),0.7*held_zoom)
  pool()
  return
 draw_rect(Rect2(-435,16,1670,522),Color(0.025,0.015,0.02,0.80))
 var layout: Dictionary = frame_layout(age,animate)
 var shake: float = sin((age-FINAL_HIT)*110)*4*(1-smoothstep(FINAL_HIT,1.1,age)) if animate and age >= FINAL_HIT and age < 1.1 else 0.0
 if age >= 0.42 and age < FINAL_HIT+0.13:
  var weapon_transform: Transform2D = layout.weapon_transform
  draw_set_transform(ORIGIN+weapon_transform.origin*1.15,weapon_transform.get_rotation(),weapon_transform.get_scale()*1.15)
  draw_texture(dropped_weapon,Vector2.ZERO)
  draw_set_transform(ORIGIN,0,Vector2(1.15,1.15))
 if layout.paired:
  var pair_rect: Rect2 = layout.pair
  pair_rect.position.x += shake
  draw_texture_rect(contact,pair_rect,false)
 else:
  var target_rect: Rect2 = layout.target
  # At follow-through the embedded floor prop is stationary too.
  if layout.target_index < 3: target_rect.position.x += shake
  draw_texture_rect(targets[layout.target_index],target_rect,false)
  draw_texture_rect(bodies[layout.source_index],layout.body,false)
 gore()
func pool() -> void:
 for i in range(6):
  draw_set_transform(ORIGIN+Vector2(510+i*13,390+(i%2)*3)*1.15,0,Vector2(1.15,1.15)*Vector2(23-i*2,4+i%3))
  draw_circle(Vector2.ZERO,1,Color("#4a0b14"))
 draw_set_transform(ORIGIN,0,Vector2(1.15,1.15))
func gore() -> void:
 var elapsed: float = age-FINAL_HIT
 if elapsed < 0: return
 if animate and elapsed <= 0.72:
  for i in range(54):
   var angle: float = lerpf(-2.9,-0.1,float((i*17)%54)/53.0)
   var velocity := Vector2(-absf(cos(angle)),sin(angle))*(110+float((i*43)%155))
   var color := Color("#a99a7b") if i%9 == 0 else Color("#791322")
   color.a = (1-smoothstep(0.26,0.72,elapsed))*0.95
   draw_circle(Vector2(518,220)+velocity*elapsed+Vector2(0,500*elapsed*elapsed),2+float(i%5)*0.75,color)
 if elapsed >= 0.12: pool()
