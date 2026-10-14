extends Node
## Scene-owned composite textures keep weapons in every cinematic/status pass.
const Model = preload("res://scripts/warden_weapon_preview.gd")
const Items = preload("res://scripts/item_data.gd")
var frames: Dictionary = {}
var actor: TextureRect
var hero_id: String = "warden"

static func attach(target: TextureRect, hero: String = "warden") -> void:
 var renderer = load("res://scripts/warden_combat_art.gd").new()
 renderer.name = "WardenCombatArt" if hero == "warden" else "PaintedCombatArt"
 renderer.hero_id = hero
 renderer.actor = target
 target.add_child(renderer)
 renderer.sync()

func sync() -> bool:
 var state = load("res://scripts/game_data.gd")
 var outfit: String = state.hero(hero_id).equipment_look
 var item: String = str(state.equipment.get(hero_id,{}).get("weapon",""))
 var wanted: Texture2D = frame(outfit,item,"idle")
 var changed: bool = actor.texture != wanted
 if changed: actor.texture = wanted
 var accents = actor.get_node_or_null("EquipmentAccents")
 if accents != null:
  accents.set_process(false)
  accents.visible = false
 return changed

func frame(outfit: String, item: String, state: String) -> Texture2D:
 var pose: String = "attack" if state in ["attack","cast","windup"] else "death" if state == "death" else "idle"
 var key: String = "%s:%s:%s" % [outfit,item,state]
 if frames.has(key): return frames[key]
 var viewport := SubViewport.new()
 viewport.name = "Composite_%d" % frames.size()
 viewport.size = Vector2i(512 if hero_id == "warden" else 896,512)
 viewport.disable_3d = true
 viewport.transparent_bg = true
 viewport.world_2d = World2D.new()
 viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
 add_child(viewport)
 var model = Model.new() if hero_id == "warden" else load("res://scripts/party_weapon_model.gd").new()
 if hero_id != "warden": model.hero_id = hero_id
 model.outfit = outfit
 model.weapon_id = item
 model.pose = "attack" if pose == "attack" else "idle"
 model.build_width = 1.0
 model.body_breathing = false
 model.allow_unarmed = true
 model.align_feet = true
 model.hide_effects = pose == "death"
 model.position = Vector2(viewport.size.x/2.0,512)
 viewport.add_child(model)
 var texture: Texture2D = viewport.get_texture()
 texture.set_meta("appearance_style","warden_weapon" if hero_id == "warden" else "painted_weapon")
 texture.set_meta("pose_id",hero_id)
 texture.set_meta("warden_outfit",outfit)
 texture.set_meta("equipment_outfit",outfit)
 texture.set_meta("equipped_weapon",item)
 texture.set_meta("weapon_element",Model.element_for_weapon(item) if hero_id == "warden" else load("res://scripts/party_weapon_model.gd").weapon_element(item))
 texture.set_meta("combat_state",state)
 texture.set_meta("idle_pixel_height",512)
 texture.set_meta("hero_body_fraction",Model.BODY_FRACTIONS.get(outfit,0.655) if hero_id == "warden" else model.body_fraction())
 texture.set_meta("weapon_renderer",self)
 frames[key] = texture
 _cache_when_visible.call_deferred(viewport)
 return texture

func _cache_when_visible(viewport: SubViewport) -> void:
 # Prime a new pose once; thereafter only textures actually drawn need rendering.
 if not is_inside_tree(): return
 var model = viewport.get_child(0)
 if hero_id != "warden": viewport.get_texture().set_meta("painted_bounds",Rect2(model.position+model.painted_bounds().position,model.painted_bounds().size))
 await get_tree().process_frame
 if not is_inside_tree(): return
 await get_tree().process_frame
 if is_inside_tree() and is_instance_valid(viewport): viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE

static func pose(texture: Texture2D, state: String) -> Texture2D:
 var renderer = texture.get_meta("weapon_renderer",null)
 if not is_instance_valid(renderer): return texture
 return renderer.frame(str(texture.get_meta("warden_outfit","original")),str(texture.get_meta("equipped_weapon","")),state)
