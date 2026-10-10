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
const Effects = preload("res://scenes/combat/strike_effects.gd")
var boss_reveals: Array[Dictionary] = []
var boss_reveal: Control
var cinematic_stage: Control
var cinematic_backdrop: TextureRect
var backdrop_position: Vector2
var backdrop_scale: Vector2
var backdrop_pivot: Vector2
var focus: Vector2 = Vector2(960,280)
var feedback_count: Dictionary = {}
var popup_sequence: int = 0
var motion_strength: float = 1.0
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
 heading.z_index = 3
 add_child(heading)
 cinematic_stage = Control.new()
 cinematic_stage.position = Vector2.ZERO
 cinematic_stage.size = Vector2(1920,600)
 cinematic_stage.clip_contents = true
 cinematic_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
 cinematic_stage.z_index = -1
 add_child(cinematic_stage)
 visible = false
func strike(source: TextureRect, target: TextureRect, kind: String, title: String, from_hero: bool = true) -> void:
 if not is_instance_valid(source) or not is_instance_valid(target) or source.texture == null or target.texture == null: return
 if pending.size() >= 8: return
 var source_boss: bool = source.get_meta("boss",false)
 pending.append({"source":source.texture,"target":target.texture,"source_node":source,"target_node":target,"source_material":source.material.duplicate() if source.material != null else null,"target_material":target.material.duplicate() if target.material != null else null,"kind":kind,"attack_kind":kind,"title":title,"hero":from_hero,"source_boss":source_boss,"target_boss":target.get_meta("boss",false),"creature":source.get_meta("creature",""),"duration":1.04 if source_boss else duration})
 if active.is_empty() and boss_reveal == null: next()
func restore_participants() -> void:
 if active.is_empty(): return
 for role in ["source","target"]:
  var original: TextureRect = active.get(role + "_node")
  if is_instance_valid(original): original.visible = active.get(role + "_visible",true)
func _exit_tree() -> void:
 restore_participants()
 _restore_backdrop()
 if is_instance_valid(boss_reveal): boss_reveal.finish()
func next() -> void:
 _flush_feedback(active)
 restore_participants()
 _restore_backdrop()
 if has_node("StrikeCanvas"): get_node("StrikeCanvas").free()
 for fighter in fighters: fighter.queue_free()
 fighters.clear()
 if not boss_reveals.is_empty():
  active = {}
  visible = true
  heading.visible = false
  cinematic_stage.visible = false
  boss_reveal = preload("res://scenes/combat/boss_reveal.gd").new()
  boss_reveal.entry = boss_reveals.pop_front()
  add_child(boss_reveal)
  boss_reveal.finished.connect(_reveal_finished)
  return
 if pending.is_empty():
  active = {}
  visible = false
  return
 active = pending.pop_front()
 if not is_instance_valid(active["source_node"]) or not is_instance_valid(active["target_node"]):
  active = {}
  next()
  return
 age = 0.0
 visible = true
 heading.visible = true
 cinematic_stage.visible = true
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
 focus = (fighters[0].position+fighters[0].size*Vector2(0.5,0.5)+fighters[1].position+fighters[1].size*Vector2(0.5,0.5))*0.5
 _prepare_backdrop()
 var canvas := preload("res://scenes/combat/strike_canvas.gd").new()
 canvas.presentation = self
 canvas.z_index = 2
 add_child(canvas)
 canvas.name = "StrikeCanvas"

func _prepare_backdrop() -> void:
 var original: TextureRect = get_parent().get_node_or_null("BattlefieldBackdrop/BackgroundArt")
 if original == null or original.texture == null: return
 # Move only the actual scenery inside its stage clip. A duplicate backdrop
 # above the actors would obscure the dimmed, nonparticipating combatants.
 cinematic_backdrop = original
 backdrop_position = original.position
 backdrop_scale = original.scale
 backdrop_pivot = original.pivot_offset
 cinematic_backdrop.pivot_offset = focus-(original.get_global_rect().position-global_position)

func _restore_backdrop() -> void:
 if is_instance_valid(cinematic_backdrop):
  cinematic_backdrop.position = backdrop_position
  cinematic_backdrop.scale = backdrop_scale
  cinematic_backdrop.pivot_offset = backdrop_pivot
 cinematic_backdrop = null

func reveal_boss(portrait: TextureRect, name: String, lore: String, theme: String = "bandit", phase: int = 1, total: int = 1) -> void:
 if not is_instance_valid(portrait) or portrait.texture == null or boss_reveals.size() >= 4: return
 var reveal_texture: Texture2D = Poses.state_pose(portrait.texture,"reveal")
 boss_reveals.append({"portrait":portrait,"texture":reveal_texture,"name":name,"lore":lore.split("\n")[0],"theme":theme,"phase":phase,"total":total})
 if active.is_empty() and boss_reveal == null: next()

func _reveal_finished() -> void:
 boss_reveal = null
 call_deferred("next")
func apply_pose(index: int, role: String, changed: bool, hurt: bool = false, state_override: String = "") -> Vector2:
 var original: Texture2D = active[role]
 var state: String = state_override if not state_override.is_empty() else "hurt" if hurt else "guard" if active["attack_kind"] == "block" else "cast" if active["attack_kind"] in ["spell","heal"] else "attack"
 var texture: Texture2D = Poses.state_pose(original,state) if changed else original
 var fighter: TextureRect = fighters[index]
 fighter.texture = texture
 fighter.flip_h = changed and not hurt and texture.resource_path.get_file() in ["hero_warden.png","hero_crusader.tres"]
 var base_size: Vector2 = active[role + "_size"]
 var height: float = base_size.y * (texture.get_height()/float(texture.get_meta("idle_pixel_height",texture.get_height())) if changed and texture.has_meta("idle_pixel_height") else 0.92 if changed and hurt else 1.0)
 var width: float = height * texture.get_width()/float(maxi(1,texture.get_height()))
 var max_width: float = 620.0 if active.get(role+"_boss",false) else 480.0
 if width > max_width:
  height *= max_width/width
  width = max_width
 fighter.size = Vector2(width,height)
 fighter.pivot_offset = Vector2(width*0.5,height)
 # Every pose keeps its feet on the same ground plane.
 return active[role + "_position"] + Vector2((base_size.x-width)*0.5,base_size.y-height)
func _process(delta: float) -> void:
 if active.is_empty(): return
 age += delta
 var active_duration: float = float(active.get("duration",duration))
 if age >= active_duration:
  next()
  return
 var hero: bool = active["hero"]
 var direction: float = 1.0 if hero else -1.0
 var clock: float = age/(active_duration/duration)
 if clock >= 0.28: _flush_feedback(active)
 var source_position: Vector2 = apply_pose(0,"source",clock >= 0.11 and clock < 0.60)
 var harmful: bool = active["attack_kind"] not in ["heal","block","object"] and active.get("reaction", "hurt") not in ["miss","block"] and active["source_node"] != active["target_node"]
 var defending: bool = active["attack_kind"] == "block" or active.get("reaction","") == "block"
 var target_position: Vector2 = apply_pose(1,"target",(harmful or defending) and clock >= 0.28 and clock < 0.64,harmful,"guard" if defending else "")
 # A brief held contact pose makes each impact readable before recoil.
 var motion_age: float = clock if clock < 0.28 else 0.28 if clock < 0.38 else clock - 0.10
 var lunge: float = sin(clampf((motion_age - 0.1) / 0.32,0.0,1.0) * PI)
 var impact: float = sin(clampf((motion_age - 0.28) / 0.26,0.0,1.0) * PI)
 var kind: String = active["kind"]
 var anticipation: float = sin(clampf(clock/0.11,0.0,1.0)*PI) if clock < 0.11 else 0.0
 var boss: bool = active.get("source_boss",false)
 var weight: float = 1.35 if boss else 1.0
 var zoom: float = sin(clampf(clock/duration,0,1)*PI)*0.032*clampf(motion_strength,0,1)
 var shake: float = sin(clock*135)*exp(-maxf(0,clock-0.28)*28)*(4.0 if boss else 1.6)*clampf(motion_strength,0,1) if clock >= 0.28 and clock < 0.45 and harmful else 0.0
 fighters[0].position = source_position + Vector2(direction * (lunge * (95.0 if str(active["title"]).to_lower().contains("charge") else 65.0 if active["attack_kind"] == "sword" else 12.0)*weight - anticipation*(23 if boss else 12)),0.0)
 var tilt: float = 0.12 if kind == "sword" else -0.045
 if boss:
  tilt = {"harrowed_giant":0.065,"undying_lord":0.17,"keep_son":0.15,"moth_oleander":0.14,"howling_head":0.10}.get(str(active.get("creature","")),tilt)
 fighters[0].rotation = direction*lunge*tilt
 var dodge: bool = active.get("reaction", "hurt") == "miss"
 fighters[1].position = target_position + Vector2(direction * impact * (40.0 if dodge else 18.0*weight if harmful else 0.0),0)
 fighters[1].rotation = direction * impact * 0.08
 fighters[1].self_modulate = Color(1,1.0-impact*0.36,1.0-impact*0.36) if harmful and kind != "block" else Color.WHITE
 for fighter in fighters:
  fighter.scale = Vector2.ONE*(1.0+zoom)
  fighter.position.x += (focus.x-(fighter.position.x+fighter.size.x*0.5))*zoom+shake
 if cinematic_backdrop != null:
  cinematic_backdrop.scale = backdrop_scale*(1.0+zoom*0.7)
  cinematic_backdrop.position = backdrop_position+Vector2(shake*0.45,0)
 # Fade the dark curtain, not the highlighted fighters, to avoid ghost copies.
 modulate.a = 1.0
 queue_redraw()
func _draw() -> void:
 if active.is_empty(): return
 var fade: float = minf(1.0,age/0.06) * minf(1.0,(float(active.get("duration",duration))-age)/0.10)
 draw_rect(Rect2(Vector2.ZERO,size),Color(0.015,0.012,0.018,0.74*fade))
 draw_rect(Rect2(0,0,size.x,25),Color(0.006,0.004,0.008,0.7*fade))
 # Effects draw above portraits through a separate child canvas.
func _draw_effects(canvas: Node2D) -> void:
 Effects.draw(self,canvas)
func popup(target: Control, value: String, tint: Color, defer_to_impact: bool = true) -> void:
 if not is_instance_valid(target): return
 if target is Button:
  var model: Control = target.get_node_or_null("Portrait")
  if model == null: model = target.get_node_or_null("EnemyArt")
  if model != null: target = model
 if value in ["MISS","BLOCK","BLOCKED"]:
  if not pending.is_empty() and pending[-1].get("target_node") == target: pending[-1]["reaction"] = "miss" if value == "MISS" else "block"
  elif active.get("target_node") == target: active["reaction"] = "miss" if value == "MISS" else "block"
 if defer_to_impact:
  var entry: Dictionary = pending[-1] if not pending.is_empty() and pending[-1].get("target_node") == target else active if active.get("target_node") == target else {}
  if not entry.is_empty():
   var waiting: Array = entry.get("feedback",[])
   waiting.append({"target":target,"value":value,"tint":tint})
   entry["feedback"] = waiting
   if entry == active and age/float(active.get("duration",duration))*duration >= 0.28: _flush_feedback(active)
   return
 _spawn_popup(target,value,tint)

func _flush_feedback(entry: Dictionary) -> void:
 var waiting: Array = entry.get("feedback",[])
 entry.erase("feedback")
 for item in waiting:
  if is_instance_valid(item["target"]): _spawn_popup(item["target"],item["value"],item["tint"])

func _spawn_popup(target: Control, value: String, tint: Color) -> void:
 var label := Label.new()
 popup_sequence += 1
 label.name = "CombatFeedback%d" % popup_sequence
 label.text = value
 var origin: Vector2 = target.get_global_rect().get_center()-get_global_rect().position
 var sequence: int = int(target.get_meta("feedback_sequence",0))
 target.set_meta("feedback_sequence",sequence+1)
 label.position = origin-Vector2(180,70)+Vector2((sequence%3-1)*22,-(sequence%2)*36)
 label.size = Vector2(360,62)
 label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 label.add_theme_font_size_override("font_size",38 if value.contains("CRITICAL") else 28 if value.length()>10 else 34)
 label.add_theme_color_override("font_color",tint)
 label.add_theme_color_override("font_outline_color",Color.BLACK)
 label.add_theme_constant_override("outline_size",6)
 label.mouse_filter = Control.MOUSE_FILTER_IGNORE
 label.pivot_offset = Vector2(180,30)
 label.scale = Vector2.ONE*1.13
 # Popups live on the controller so they survive the attack spotlight fading.
 get_parent().add_child(label)
 label.z_index = 45
 var tween := create_tween().set_parallel(true)
 tween.tween_property(label,"scale",Vector2.ONE,0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
 tween.tween_property(label,"position:y",label.position.y-70,0.92).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
 tween.tween_property(label,"modulate:a",0.0,0.42).set_delay(0.5)
 tween.chain().tween_callback(label.queue_free)

func feedback(target: Control, kind: String, amount: int = 0, effect: String = "") -> void:
 # Explicit categories avoid making status ticks look like fresh weapon hits.
 feedback_count[kind] = int(feedback_count.get(kind,0))+1
 var colors: Dictionary = {"damage":Color("#F7A18A"),"critical":Color("#FFE18B"),"miss":Color("#E0D3BC"),"block":Color("#BEDFFF"),"heal":Color("#C4EBAE"),"resist":Color("#DFD8A4"),"status":Color("#E8B7BC"),"status_tick":Color("#F7A18A")}
 var color: Color = colors.get(kind,Color("#F0E2C4"))
 var value: String = str(amount)
 match kind:
  "critical": value = "CRITICAL %d" % amount
  "miss": value = "MISS"
  "block": value = "BLOCKED"
  "heal": value = "+%d HP" % amount
  "resist": value = "RESISTED"+(" · "+effect.to_upper() if not effect.is_empty() else "")
  "status": value = effect.to_upper()
  "status_tick": value = "%s −%d" % [effect.to_upper(),amount]
 if kind in ["status","status_tick"]:
  color = {"burn":Color("#FFA66B"),"bleed":Color("#FF879B"),"poison":Color("#C0E991"),"chill":Color("#BAECFF")}.get(effect,color)
 popup(target,value,color,kind != "status_tick")

func block_impact() -> void:
 if not pending.is_empty(): pending[-1]["kind"] = "block"
 elif not active.is_empty(): active["kind"] = "block"
