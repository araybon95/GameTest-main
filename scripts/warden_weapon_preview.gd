extends Node2D
## Isolated equipment art preview. Does not alter the saved game or item balance.
const Items = preload("res://scripts/item_data.gd")
const COLOURS = {"bleed":Color("b45462"),"poison":Color("a0bd72"),"burn":Color("d99c65"),"chill":Color("adcedb")}
const WEAPON_COLUMNS = {"warden_sword":0,"warden_epic":0,"warden_frostblade":2,"preview_mace":1}
var body: Sprite2D
var weapon: Sprite2D
var wisps: Node2D
var hand: Polygon2D
var smoke: ColorRect
var element: String = ""
var outfit: String = "original"
var weapon_id: String = "warden_sword"
var pose: String = "idle"
var elapsed: float = 0.0
var motion_enabled: bool = true
var texture_cache: Dictionary = {}
# Tight source-pixel outlines: surrounding armour must never cover the handle.
const GAUNTLETS = {
 "original":[Vector2(456,690),Vector2(487,672),Vector2(517,667),Vector2(547,684),Vector2(563,709),Vector2(565,733),Vector2(554,749),Vector2(540,763),Vector2(510,768),Vector2(482,763),Vector2(461,748),Vector2(446,730)],
 "ashen_wolf":[Vector2(396,622),Vector2(432,598),Vector2(461,592),Vector2(488,603),Vector2(509,626),Vector2(519,652),Vector2(508,676),Vector2(490,699),Vector2(464,709),Vector2(436,711),Vector2(407,699),Vector2(388,682),Vector2(384,655)],
 "original_attack":[Vector2(299,214),Vector2(316,192),Vector2(348,175),Vector2(379,180),Vector2(414,208),Vector2(433,234),Vector2(429,252),Vector2(407,272),Vector2(371,286),Vector2(337,279),Vector2(310,264),Vector2(297,241)],
 "ashen_wolf_attack":[Vector2(326,212),Vector2(346,184),Vector2(374,164),Vector2(405,162),Vector2(433,177),Vector2(460,203),Vector2(467,229),Vector2(455,246),Vector2(428,263),Vector2(393,276),Vector2(361,270),Vector2(337,248)]
}

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
 smoke.size = Vector2(56,110)
 var shader_material := ShaderMaterial.new()
 shader_material.shader = preload("res://assets/shaders/weapon_wisps.gdshader")
 smoke.material = shader_material
 wisps.add_child(smoke)
 hand = Polygon2D.new()
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
 var grip: Vector2 = Vector2(529,744) if outfit == "original" else Vector2(462,676)
 if attacking: grip = Vector2(383,249) if outfit == "original" else Vector2(414,235)
 weapon.position = body.position+grip*body.scale
 var length: float = 150.0 if weapon_id == "preview_mace" else 205.0
 weapon.scale = Vector2.ONE * length/weapon.texture.get_height()
 weapon.offset = Vector2(-weapon.texture.get_width()/2.0,-weapon.texture.get_height()*0.86)
 weapon.rotation = deg_to_rad(65.0 if attacking else 110.0)
 wisps.position = weapon.position
 var head_pixel := Vector2(weapon.texture.get_width()/2.0,weapon.texture.get_height()*(0.18 if weapon_id == "preview_mace" else 0.04))
 var tip: Vector2 = ((head_pixel+weapon.offset)*weapon.scale).rotated(weapon.rotation)
 smoke.position = tip-Vector2(smoke.size.x/2.0,smoke.size.y*0.88)
 var outline := PackedVector2Array(GAUNTLETS[outfit+"_attack" if attacking else outfit])
 hand.texture = body.texture
 hand.polygon = outline
 hand.uv = outline
 hand.scale = body.scale
 hand.position = body.position

func _process(delta: float) -> void:
 var settings = get_node_or_null("/root/GameSettings")
 if motion_enabled and (settings == null or settings.ambient_motion): elapsed += delta
 smoke.material.set_shader_parameter("clock",elapsed)
 # Move the full figure together: attachments cannot drift against the torso.
 scale = Vector2(1.0,1.0+sin(elapsed*1.6)*0.002)
