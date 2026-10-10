extends Control
## In-place attacker/target spotlight: anticipation, strike, impact and recovery.
## All damage and status logic stays in the combat controller.
var pending: Array[Dictionary] = []
var active: Dictionary = {}
var age: float = 0.0
var fighters: Array[TextureRect] = []
var heading: Label
var duration: float = 0.76
const Poses = preload("res://scripts/combat_poses.gd")
func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_STOP
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 z_index = 40
 heading = Label.new()
 heading.position = Vector2(500,70)
 heading.size = Vector2(920,60)
 heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 heading.add_theme_font_size_override("font_size",32)
 heading.add_theme_color_override("font_color",Color("#F6E2BA"))
 heading.add_theme_color_override("font_shadow_color",Color.BLACK)
 heading.add_theme_constant_override("shadow_offset_y",3)
 heading.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(heading)
 visible = false
func strike(source: TextureRect, target: TextureRect, kind: String, title: String, from_hero: bool = true) -> void:
 if source == null or target == null or source.texture == null or target.texture == null: return
 if pending.size() >= 8: return
 pending.append({"source":source.texture,"target":target.texture,"source_node":source,"target_node":target,"source_material":source.material.duplicate() if source.material != null else null,"target_material":target.material.duplicate() if target.material != null else null,"kind":kind,"attack_kind":kind,"title":title,"hero":from_hero})
 if active.is_empty(): next()
func restore_participants() -> void:
 if active.is_empty(): return
 for role in ["source","target"]:
  var original: TextureRect = active.get(role + "_node")
  if is_instance_valid(original): original.visible = active.get(role + "_visible",true)
func _exit_tree() -> void: restore_participants()
func next() -> void:
 restore_participants()
 if has_node("StrikeCanvas"): get_node("StrikeCanvas").free()
 for fighter in fighters: fighter.queue_free()
 fighters.clear()
 if pending.is_empty():
  active = {}
  visible = false
  return
 active = pending.pop_front()
 age = 0.0
 visible = true
 heading.text = str(active["title"]).to_upper()
 for role in ["source","target"]:
  var fighter := TextureRect.new()
  fighter.texture = active[role]
  fighter.material = active[role + "_material"]
  fighter.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  fighter.stretch_mode = TextureRect.STRETCH_SCALE
  var original: TextureRect = active[role + "_node"]
  var pose: Rect2 = original.get_global_rect()
  active[role + "_position"] = pose.position - global_position
  active[role + "_size"] = pose.size
  active[role + "_visible"] = active.get("source_visible",true) if role == "target" and active["source_node"] == original else original.visible
  fighter.size = pose.size
  fighter.position = active[role + "_position"]
  fighter.pivot_offset = Vector2(fighter.size.x * 0.5,fighter.size.y)
  original.visible = false
  fighter.mouse_filter = Control.MOUSE_FILTER_IGNORE
  add_child(fighter)
  fighters.append(fighter)
 if active["source_node"] == active["target_node"]: fighters[1].visible = false
 var canvas := preload("res://scenes/combat/strike_canvas.gd").new()
 canvas.presentation = self
 canvas.z_index = 2
 add_child(canvas)
 canvas.name = "StrikeCanvas"
func apply_pose(index: int, role: String, changed: bool, hurt: bool = false) -> Vector2:
 var original: Texture2D = active[role]
 var state: String = "hurt" if hurt else "guard" if active["attack_kind"] == "block" else "cast" if active["attack_kind"] in ["spell","heal"] else "attack"
 var texture: Texture2D = Poses.state_pose(original,state) if changed else original
 var fighter: TextureRect = fighters[index]
 fighter.texture = texture
 fighter.flip_h = changed and not hurt and texture.resource_path.get_file() in ["hero_warden.png","hero_crusader.tres"]
 var base_size: Vector2 = active[role + "_size"]
 var height: float = base_size.y * (texture.get_height()/float(texture.get_meta("idle_pixel_height",texture.get_height())) if changed and texture.has_meta("idle_pixel_height") else 0.92 if changed and hurt else 1.0)
 var width: float = height * texture.get_width()/float(maxi(1,texture.get_height()))
 if width > 480.0:
  height *= 480.0/width
  width = 480.0
 fighter.size = Vector2(width,height)
 fighter.pivot_offset = Vector2(width*0.5,height)
 # Every pose keeps its feet on the same ground plane.
 return active[role + "_position"] + Vector2((base_size.x-width)*0.5,base_size.y-height)
func _process(delta: float) -> void:
 if active.is_empty(): return
 age += delta
 if age >= duration:
  next()
  return
 var hero: bool = active["hero"]
 var direction: float = 1.0 if hero else -1.0
 var source_position: Vector2 = apply_pose(0,"source",age >= 0.11 and age < 0.60)
 var harmful: bool = active["attack_kind"] not in ["heal","block"] and active.get("reaction", "hurt") not in ["miss","block"] and active["source_node"] != active["target_node"]
 var target_position: Vector2 = apply_pose(1,"target",harmful and age >= 0.28 and age < 0.64,true)
 # A brief held contact pose makes each impact readable before recoil.
 var motion_age: float = age if age < 0.28 else 0.28 if age < 0.38 else age - 0.10
 var lunge: float = sin(clampf((motion_age - 0.1) / 0.32,0.0,1.0) * PI)
 var impact: float = sin(clampf((motion_age - 0.28) / 0.26,0.0,1.0) * PI)
 var kind: String = active["kind"]
 var anticipation: float = sin(clampf(age/0.11,0.0,1.0)*PI) if age < 0.11 else 0.0
 fighters[0].position = source_position + Vector2(direction * (lunge * (95.0 if str(active["title"]).to_lower().contains("charge") else 65.0 if active["attack_kind"] == "sword" else 12.0) - anticipation*12.0),0.0)
 fighters[0].rotation = direction * lunge * (0.12 if kind == "sword" else -0.045)
 var dodge: bool = active.get("reaction", "hurt") == "miss"
 fighters[1].position = target_position + Vector2(direction * impact * (40.0 if dodge else 18.0 if harmful else 0.0),0)
 fighters[1].rotation = direction * impact * 0.08
 fighters[1].self_modulate = Color(1,1.0-impact*0.36,1.0-impact*0.36) if harmful and kind != "block" else Color.WHITE
 # Fade the dark curtain, not the highlighted fighters, to avoid ghost copies.
 modulate.a = 1.0
 queue_redraw()
func _draw() -> void:
 if active.is_empty(): return
 var fade: float = minf(1.0,age/0.06) * minf(1.0,(duration-age)/0.10)
 draw_rect(Rect2(Vector2.ZERO,size),Color(0.015,0.012,0.018,0.74*fade))
 # Effects draw above portraits through a separate child canvas.
func _draw_effects(canvas: Node2D) -> void:
 if active.is_empty(): return
 var hero: bool = active["hero"]
 var direction: float = 1.0 if hero else -1.0
 var point: Vector2 = fighters[1].position + fighters[1].size * Vector2(0.5,0.45)
 var progress: float = clampf((age-0.16)/0.25,0.0,1.0)
 var strength: float = sin(clampf((age-0.24)/0.30,0.0,1.0)*PI)
 match str(active["kind"]):
  "bow":
   var start: Vector2 = fighters[0].position + fighters[0].size * Vector2(0.5,0.45)
   var arrow: Vector2 = start.lerp(point,progress)
   canvas.draw_line(arrow-Vector2(direction*75,-5),arrow,Color("#FFE9B5"),4)
   canvas.draw_line(arrow-Vector2(direction*12,9),arrow,Color("#FFE9B5"),3)
   canvas.draw_line(arrow-Vector2(direction*12,-9),arrow,Color("#FFE9B5"),3)
  "spell", "heal":
   var tint: Color = Color("#A986E8") if active["kind"] == "spell" else Color("#A7DC98")
   var spell_name: String = str(active["title"]).to_lower()
   if spell_name.contains("fire") or spell_name.contains("flame") or spell_name.contains("ember"): tint = Color("#FF963F")
   elif spell_name.contains("chill") or spell_name.contains("frost") or spell_name.contains("ice"): tint = Color("#9EE3FF")
   elif spell_name.contains("poison") or spell_name.contains("venom"): tint = Color("#A4DC62")
   elif spell_name.contains("lightning") or spell_name.contains("storm"): tint = Color("#FFED99")
   tint.a = strength
   canvas.draw_arc(point,25+strength*80,0,TAU,48,tint,5)
   for index in range(12):
    var ray := Vector2.from_angle(index*TAU/12.0+age)
    canvas.draw_line(point+ray*35,point+ray*(65+strength*65),tint,3)
  "block":
   canvas.draw_polyline(PackedVector2Array([point+Vector2(-55,-65),point+Vector2(55,-65),point+Vector2(45,35),point+Vector2(0,75),point+Vector2(-45,35),point+Vector2(-55,-65)]),Color(0.8,0.88,1,strength),7,true)
  _:
   if strength > 0:
    canvas.draw_line(point+Vector2(-75,-95),point+Vector2(75,95),Color(0.95,0.82,0.65,strength),14,true)
    canvas.draw_line(point+Vector2(-60,-95),point+Vector2(90,95),Color(0.7,0.08,0.1,strength),5,true)
 if strength > 0:
  for index in range(7):
   var ray := Vector2.from_angle(index*TAU/7.0)
   canvas.draw_line(point+ray*95,point+ray*(100+strength*25),Color(1,0.8,0.6,strength),2)
func popup(target: Control, value: String, tint: Color) -> void:
 if target == null: return
 if target is Button:
  var model: Control = target.get_node_or_null("Portrait")
  if model == null: model = target.get_node_or_null("EnemyArt")
  if model != null: target = model
 if value in ["MISS","BLOCK","BLOCKED"]:
  if not pending.is_empty() and pending[-1].get("target_node") == target: pending[-1]["reaction"] = "miss" if value == "MISS" else "block"
  elif active.get("target_node") == target: active["reaction"] = "miss" if value == "MISS" else "block"
 var label := Label.new()
 label.text = value
 label.position = target.get_global_rect().get_center() - get_global_rect().position - Vector2(80,45)
 label.size = Vector2(160,50)
 label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 label.add_theme_font_size_override("font_size",30)
 label.add_theme_color_override("font_color",tint)
 label.add_theme_color_override("font_outline_color",Color.BLACK)
 label.add_theme_constant_override("outline_size",6)
 label.mouse_filter = Control.MOUSE_FILTER_IGNORE
 # Popups live on the controller so they survive the attack spotlight fading.
 get_parent().add_child(label)
 label.z_index = 45
 var tween := create_tween().set_parallel(true)
 tween.tween_property(label,"position:y",label.position.y-65,0.8)
 tween.tween_property(label,"modulate:a",0.0,0.5).set_delay(0.3)
 tween.chain().tween_callback(label.queue_free)

func block_impact() -> void:
 if not pending.is_empty(): pending[-1]["kind"] = "block"
 elif not active.is_empty(): active["kind"] = "block"
