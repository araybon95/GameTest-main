extends Node2D
## Isolated equipment art preview. Does not alter the saved game or item balance.
const Items = preload("res://scripts/item_data.gd")
const COLOURS = {"bleed":Color("8d3342"),"poison":Color("86a95d"),"burn":Color("c57b42"),"chill":Color("a1cad5")}
const WEAPON_COLUMNS = {"warden_sword":0,"warden_epic":0,"warden_frostblade":2,"preview_mace":1}
var body: Sprite2D
var weapon: Sprite2D
var wisps: Node2D
var hand: Sprite2D
var smoke: ColorRect
var element: String = ""
var outfit: String = "original"
var weapon_id: String = "warden_sword"
var pose: String = "idle"
var elapsed: float = 0.0
var motion_enabled: bool = true
var texture_cache: Dictionary = {}

func _ready() -> void:
 body = Sprite2D.new()
 body.centered = false
 add_child(body)
 weapon = Sprite2D.new()
 weapon.centered = false
 add_child(weapon)
 wisps = Node2D.new()
 add_child(wisps)
 smoke = ColorRect.new()
 smoke.mouse_filter = Control.MOUSE_FILTER_IGNORE
 smoke.size = Vector2(36,90)
 var shader_material := ShaderMaterial.new()
 shader_material.shader = preload("res://assets/shaders/weapon_wisps.gdshader")
 smoke.material = shader_material
 wisps.add_child(smoke)
 hand = Sprite2D.new()
 hand.centered = false
 add_child(hand)
 configure(outfit,weapon_id)

func effect_for(item: Dictionary) -> String:
 for status in ["bleed","poison","burn","chill"]:
  if float(item.get("unique_"+status,0)) > 0 or float(item.get(status+"_chance",0)) > 0:
   return status
 return ""

func configure_equipped(state, hero: String, chosen_outfit: String) -> void:
 configure(chosen_outfit,str(state.equipment.get(hero,{}).get("weapon","")))

func configure(chosen_outfit: String, item_id: String) -> void:
 outfit = chosen_outfit if chosen_outfit in ["original","ashen_wolf"] else "original"
 weapon_id = item_id
 element = effect_for(Items.item(item_id)) if WEAPON_COLUMNS.has(item_id) else ""
 wisps.visible = not element.is_empty()
 smoke.material.set_shader_parameter("tint",COLOURS.get(element,Color.WHITE))
 var column: int = WEAPON_COLUMNS.get(item_id,0)
 if not texture_cache.has(column):
  var atlas := AtlasTexture.new()
  atlas.atlas = load("res://assets/art_library/weapon_preview/weapons.png")
  atlas.region = [Rect2(182,12,270,991),Rect2(602,11,336,1002),Rect2(1086,11,282,1002)][column]
  atlas.filter_clip = true
  texture_cache[column] = atlas
 weapon.texture = texture_cache[column]
 _place_pose()

func set_pose(value: String) -> void:
 pose = "attack" if value == "attack" else "idle"
 _place_pose()

func _place_pose() -> void:
 var attacking: bool = pose == "attack"
 body.texture = load("res://assets/art_library/weapon_preview/%s.png" % (outfit+"_attack" if attacking else outfit))
 var dimensions: Vector2 = body.texture.get_size()
 var factor: float = 360.0 / dimensions.y
 body.scale = Vector2(factor*1.10,factor)
 body.position = Vector2(-dimensions.x*body.scale.x/2.0,-360.0)
 var grip: Vector2 = Vector2(503,735) if outfit == "original" else Vector2(442,657)
 if attacking: grip = Vector2(359,231) if outfit == "original" else Vector2(385,228)
 weapon.position = body.position+grip*body.scale
 var length: float = 150.0 if weapon_id == "preview_mace" else 205.0
 weapon.scale = Vector2.ONE * length/weapon.texture.get_height()
 weapon.offset = Vector2(-weapon.texture.get_width()/2.0,-weapon.texture.get_height()*0.86)
 weapon.rotation = deg_to_rad(65.0 if attacking else 110.0)
 wisps.position = weapon.position
 var tip: Vector2 = Vector2(0,-length*0.62).rotated(weapon.rotation)
 smoke.position = tip+Vector2(-18,-75)
 var patch := AtlasTexture.new()
 patch.atlas = body.texture
 patch.region = Rect2(grip-Vector2(65,45),Vector2(130,90))
 hand.texture = patch
 hand.scale = body.scale
 hand.position = body.position+patch.region.position*body.scale

func _process(delta: float) -> void:
 var settings = get_node_or_null("/root/GameSettings")
 if motion_enabled and (settings == null or settings.ambient_motion): elapsed += delta
 smoke.material.set_shader_parameter("clock",elapsed)
 # Move the full figure together: attachments cannot drift against the torso.
 scale = Vector2(1.0,1.0+sin(elapsed*1.6)*0.002)
