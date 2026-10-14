extends "res://scripts/warden_weapon_preview.gd"
## Measured body/hand profiles share the Warden's smoke and attachment lifecycle.
const WEAPONS = {
 "ranger":["ranger_bow","ranger_epic","ranger_venombow","ranger_legend"],
 "occultist":["occultist_staff","occultist_epic","occultist_plaguestaff","occultist_legend"],
 "healer":["healer_mace","healer_epic","healer_frostmace","healer_legend"]
}
var hero_id: String = "ranger"
var profiles: Dictionary
var profile: Dictionary
var bowstring: Line2D
var arrow: Node2D
var draw_fingers: Polygon2D

static func weapon_element(item_id: String) -> String:
 var base: String = Items.base_id(item_id)
 var supported: bool = false
 for weapons in WEAPONS.values():
  if base in weapons: supported = true
 if not supported: return ""
 var item: Dictionary = Items.item(item_id)
 for status in ["bleed","poison","burn","chill"]:
  if float(item.get("unique_"+status,0)) > 0 or float(item.get(status+"_chance",0)) > 0: return status
 return ""

func configure(chosen_outfit: String, item_id: String) -> void:
 if profiles == null or profiles.is_empty():
  profiles = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_library/party_weapons/profiles.json"))
 outfit = chosen_outfit if chosen_outfit in ["original","alternate","relic"] else "original"
 weapon_id = Items.base_id(item_id)
 element = weapon_element(item_id) if weapon_id in WEAPONS[hero_id] else ""
 wisps.visible = not element.is_empty() and not hide_effects
 smoke.material.set_shader_parameter("tint",COLOURS.get(element,Color.WHITE))
 var column: int = WEAPONS[hero_id].find(weapon_id)
 weapon.visible = column >= 0
 if column < 0: column = 0
 var key: String = "%s:%d" % [hero_id,column]
 if not texture_cache.has(key):
  var atlas := AtlasTexture.new()
  atlas.atlas = load("res://assets/art_library/party_weapons/%s-weapons.png" % hero_id)
  var region: Array = profiles[hero_id].weapons[column].region
  atlas.region = Rect2(region[0],region[1],region[2],region[3])
  atlas.filter_clip = true
  texture_cache[key] = atlas
 weapon.texture = texture_cache[key]
 _place_pose()

func body_fraction() -> float:
 return 360.0/512.0

func painted_bounds() -> Rect2:
 var source: Array = profile.bounds
 var bounds := Rect2(body.position+Vector2(source[0],source[1])*body.scale,Vector2(source[2],source[3])*body.scale)
 if weapon.visible:
  var corners: Array[Vector2] = [Vector2.ZERO,Vector2(weapon.texture.get_width(),0),weapon.texture.get_size(),Vector2(0,weapon.texture.get_height())]
  for corner in corners:
   bounds = bounds.expand(weapon.position+((corner+weapon.offset)*weapon.scale).rotated(weapon.rotation))
 if wisps.visible:
  bounds = bounds.merge(Rect2(wisps.position+smoke.position,smoke.size))
 if hero_id == "ranger" and arrow != null and arrow.visible:
  var nock: Vector2 = body.position+_point(profile.draw_hand)*body.scale
  bounds = bounds.expand(nock).expand(Vector2(weapon.position.x+44,nock.y+4)).expand(Vector2(weapon.position.x+44,nock.y-4))
 return bounds

func _point(values: Array) -> Vector2:
 return Vector2(values[0],values[1])

func _place_pose() -> void:
 var attacking: bool = pose == "attack"
 profile = profiles[hero_id][outfit+"-"+str(1 if attacking else 0)]
 body.texture = load("res://assets/art_library/party_weapons/%s-%s-%d.png" % [hero_id,outfit,1 if attacking else 0])
 var dimensions: Vector2 = body.texture.get_size()
 var factor: float = 360.0/float(profile.foot-profile.head)
 body.scale = Vector2(factor*build_width,factor)
 body.position = Vector2(-dimensions.x*body.scale.x/2.0,-float(profile.foot)*factor)
 var grip: Vector2 = _point(profile.grip)
 weapon.position = body.position+grip*body.scale
 var column: int = maxi(0,WEAPONS[hero_id].find(weapon_id))
 var spec: Dictionary = profiles[hero_id].weapons[column]
 var length: float = 260.0 if hero_id == "ranger" else 345.0 if hero_id == "occultist" else 155.0
 weapon.scale = Vector2.ONE*length/weapon.texture.get_height()
 weapon.offset = -_point(spec.grip)
 weapon.rotation = deg_to_rad(float(profile.get("rotation",0)))
 wisps.position = weapon.position
 var tip: Vector2 = ((_point(spec.head)+weapon.offset)*weapon.scale).rotated(weapon.rotation)
 smoke.position = tip-Vector2(smoke.size.x/2.0,smoke.size.y*0.88)
 var outline: PackedVector2Array = []
 for vertex in profile.hand: outline.append(_point(vertex))
 hand.texture = body.texture
 hand.polygon = outline
 hand.uv = outline
 hand.scale = body.scale
 hand.position = body.position
 if hero_id == "ranger": _place_bow(spec,attacking)

func _place_bow(spec: Dictionary, attacking: bool) -> void:
 if bowstring == null:
  bowstring = Line2D.new()
  bowstring.width = 1.2
  bowstring.default_color = Color("b9ad8b")
  add_child(bowstring)
  move_child(bowstring,2)
  arrow = Node2D.new()
  add_child(arrow)
  move_child(arrow,get_child_count()-2)
  draw_fingers = Polygon2D.new()
  add_child(draw_fingers)
 bowstring.visible = weapon.visible
 arrow.visible = weapon.visible and attacking
 draw_fingers.visible = arrow.visible
 var top: Vector2 = weapon.position+((_point(spec.top)+weapon.offset)*weapon.scale).rotated(weapon.rotation)
 var bottom: Vector2 = weapon.position+((_point(spec.bottom)+weapon.offset)*weapon.scale).rotated(weapon.rotation)
 var draw_hand: Vector2 = body.position+_point(profile.get("draw_hand",profile.grip))*body.scale
 bowstring.points = PackedVector2Array([top,draw_hand,bottom]) if attacking else PackedVector2Array([top,bottom])
 for child in arrow.get_children(): child.free()
 if not attacking: return
 var end := Vector2(weapon.position.x+35,draw_hand.y)
 var shaft := Line2D.new()
 shaft.width = 2.1
 shaft.default_color = Color("8d7651")
 shaft.points = PackedVector2Array([draw_hand,end])
 arrow.add_child(shaft)
 var tip := Polygon2D.new()
 tip.color = Color("b4b6ad")
 tip.polygon = PackedVector2Array([end+Vector2(9,0),end+Vector2(-5,-4),end+Vector2(-3,0),end+Vector2(-5,4)])
 arrow.add_child(tip)
 # The drawing fingertips close over the nock/string rather than sitting behind it.
 var centre: Vector2 = _point(profile.draw_hand)
 var outline: PackedVector2Array = []
 for index in range(12):
  var angle: float = index*TAU/12.0
  outline.append(centre+Vector2(cos(angle)*35,sin(angle)*44))
 draw_fingers.texture = body.texture
 draw_fingers.polygon = outline
 draw_fingers.uv = outline
 draw_fingers.position = body.position
 draw_fingers.scale = body.scale
