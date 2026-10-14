extends Node2D
## Isolated equipment art preview. Does not alter the saved game or item balance.
const Items = preload("res://scripts/item_data.gd")
const COLOURS = {"bleed":Color("b45462"),"poison":Color("a0bd72"),"burn":Color("d99c65"),"chill":Color("adcedb")}
# Usable handles, excluding the guard and pommel, measured in each atlas region.
const HANDLE_SPANS = [Vector2(720,905),Vector2(326,872),Vector2(768,904),Vector2(1080,1350),Vector2(1080,1290)]
const WEAPON_COLUMNS = {"warden_sword":0,"warden_epic":3,"warden_legend":4,"warden_frostblade":2,"preview_mace":1}
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
var build_width: float = 1.10
var body_breathing: bool = true
var hide_effects: bool = false
var allow_unarmed: bool = false
var align_feet: bool = false
const FOOT_ROWS = {"original":1219,"original_attack":1275,"ashen_wolf":1226,"ashen_wolf_attack":1276,"alternate":1238,"alternate_attack":1036,"relic":1247,"relic_attack":1044}
const BODY_FRACTIONS = {"original":0.6206,"ashen_wolf":0.63391,"alternate":0.684,"relic":0.662}
var texture_cache: Dictionary = {}
# Tight source-pixel outlines: surrounding armour must never cover the handle.
const GAUNTLETS = {
 "alternate":[Vector2(384,670),Vector2(417,640),Vector2(460,639),Vector2(496,667),Vector2(517,699),Vector2(511,730),Vector2(489,754),Vector2(455,765),Vector2(416,752),Vector2(386,730)],
 "relic":[Vector2(326,646),Vector2(353,620),Vector2(385,625),Vector2(431,653),Vector2(458,681),Vector2(449,710),Vector2(423,736),Vector2(389,745),Vector2(355,728),Vector2(325,696)],
 "alternate_attack":[Vector2(695,274),Vector2(725,239),Vector2(763,231),Vector2(802,252),Vector2(830,282),Vector2(840,308),Vector2(827,337),Vector2(798,353),Vector2(763,365),Vector2(728,346),Vector2(703,320)],
 "relic_attack":[Vector2(655,290),Vector2(675,255),Vector2(710,243),Vector2(751,258),Vector2(779,284),Vector2(791,318),Vector2(779,344),Vector2(754,366),Vector2(714,374),Vector2(681,360),Vector2(659,330)],
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

static func element_for_weapon(item_id: String) -> String:
 if not WEAPON_COLUMNS.has(Items.base_id(item_id)): return ""
 var item: Dictionary = Items.item(item_id)
 for status in ["bleed","poison","burn","chill"]:
  if float(item.get("unique_"+status,0)) > 0 or float(item.get(status+"_chance",0)) > 0: return status
 return ""

func configure(chosen_outfit: String, item_id: String) -> void:
 outfit = chosen_outfit if chosen_outfit in ["original","ashen_wolf","alternate","relic"] else "original"
 weapon_id = Items.base_id(item_id)
 element = element_for_weapon(item_id)
 wisps.visible = not element.is_empty() and not hide_effects
 smoke.material.set_shader_parameter("tint",COLOURS.get(element,Color.WHITE))
 var column: int = WEAPON_COLUMNS.get(weapon_id,0)
 if not texture_cache.has(column):
  var atlas := AtlasTexture.new()
  if column < 3:
   atlas.atlas = load("res://assets/art_library/weapon_preview/weapons.png")
   atlas.region = [Rect2(182,12,270,991),Rect2(602,11,336,1002),Rect2(1086,11,282,1002)][column]
  else:
   atlas.atlas = load("res://assets/art_library/weapon_preview/%s.png" % ("warden_epic" if column == 3 else "warden_legend"))
   atlas.region = Rect2(300,20,424,1492) if column == 3 else Rect2(296,10,442,1509)
  atlas.filter_clip = true
  texture_cache[column] = atlas
 weapon.texture = texture_cache[column]
 weapon.visible = not (allow_unarmed and item_id.is_empty())
 _place_pose()

func set_pose(value: String) -> void:
 pose = "attack" if value == "attack" else "idle"
 _place_pose()

func _place_pose() -> void:
 var attacking: bool = pose == "attack"
 body.texture = load("res://assets/art_library/weapon_preview/%s.png" % (outfit+"_attack" if attacking else outfit))
 var dimensions: Vector2 = body.texture.get_size()
 var factor: float = 360.0 / dimensions.y
 body.scale = Vector2(factor*build_width,factor)
 body.position = Vector2(-dimensions.x*body.scale.x/2.0,-360.0)
 if align_feet: body.position.y = -float(FOOT_ROWS[outfit+"_attack" if attacking else outfit])*factor
 var grip: Vector2 = Vector2(529,744) if outfit == "original" else Vector2(462,676)
 if attacking: grip = Vector2(383,249) if outfit == "original" else Vector2(414,235)
 if outfit == "alternate": grip = Vector2(794,320) if attacking else Vector2(470,730)
 if outfit == "relic": grip = Vector2(763,330) if attacking else Vector2(410,715)
 weapon.position = body.position+grip*body.scale
 var length: float = 150.0 if weapon_id == "preview_mace" else 205.0
 weapon.scale = Vector2.ONE * length/weapon.texture.get_height()
 var span: Vector2 = HANDLE_SPANS[WEAPON_COLUMNS.get(weapon_id,0)]
 var hand_pixel: float = lerpf(span.x,span.y,0.25)
 weapon.offset = Vector2(-weapon.texture.get_width()/2.0,-hand_pixel)
 weapon.rotation = deg_to_rad((98.0 if outfit in ["alternate","relic"] else 65.0) if attacking else 110.0)
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
 scale = Vector2(1.0,1.0+sin(elapsed*1.6)*0.002) if body_breathing else Vector2.ONE
