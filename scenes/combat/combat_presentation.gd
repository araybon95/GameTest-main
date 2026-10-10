extends Control
## Brief original cutout duels: anticipation, strike, impact and recovery.
## All damage and status logic stays in the combat controller.
var pending: Array[Dictionary] = []
var active: Dictionary = {}
var age: float = 0.0
var fighters: Array[TextureRect] = []
var heading: Label
var duration: float = 0.68
func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_STOP
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 z_index = 40
 heading = Label.new()
 heading.position = Vector2(500,180)
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
 pending.append({"source":source.texture,"target":target.texture,"source_material":source.material.duplicate() if source.material != null else null,"target_material":target.material.duplicate() if target.material != null else null,"kind":kind,"title":title,"hero":from_hero})
 if active.is_empty(): next()
func next() -> void:
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
  fighter.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  fighter.size = Vector2(360,420)
  fighter.pivot_offset = fighter.size * 0.5
  fighter.mouse_filter = Control.MOUSE_FILTER_IGNORE
  add_child(fighter)
  fighters.append(fighter)
 var canvas := preload("res://scenes/combat/strike_canvas.gd").new()
 canvas.presentation = self
 canvas.z_index = 2
 add_child(canvas)
 canvas.name = "StrikeCanvas"
func _process(delta: float) -> void:
 if active.is_empty(): return
 age += delta
 if age >= duration:
  next()
  return
 var hero: bool = active["hero"]
 var direction: float = 1.0 if hero else -1.0
 var left: Vector2 = Vector2(530,270)
 var right: Vector2 = Vector2(1040,270)
 var lunge: float = sin(clampf((age - 0.1) / 0.32,0.0,1.0) * PI)
 var impact: float = sin(clampf((age - 0.28) / 0.26,0.0,1.0) * PI)
 var kind: String = active["kind"]
 fighters[0].position = (left if hero else right) + Vector2(direction * lunge * (100.0 if kind == "sword" else 22.0),-lunge * 12.0)
 fighters[0].rotation = direction * lunge * (0.12 if kind == "sword" else -0.045)
 fighters[1].position = (right if hero else left) + Vector2(direction * impact * 28.0,0)
 fighters[1].rotation = direction * impact * 0.08
 fighters[1].self_modulate = Color(1,1.0-impact*0.36,1.0-impact*0.36)
 modulate.a = minf(1.0,age / 0.08) * minf(1.0,(duration-age)/0.12)
 queue_redraw()
func _draw() -> void:
 if active.is_empty(): return
 draw_rect(Rect2(Vector2.ZERO,size),Color(0.02,0.015,0.018,0.68))
 draw_rect(Rect2(495,250,925,450),Color(0.06,0.035,0.035,0.65))
 draw_line(Vector2(495,250),Vector2(1420,250),Color("#AD8D5D"),2)
 draw_line(Vector2(495,700),Vector2(1420,700),Color("#AD8D5D"),2)
 # Effects draw above portraits through a separate child canvas.
func _draw_effects(canvas: Node2D) -> void:
 if active.is_empty(): return
 var hero: bool = active["hero"]
 var direction: float = 1.0 if hero else -1.0
 var point: Vector2 = Vector2(1220 if hero else 710,465)
 var progress: float = clampf((age-0.16)/0.25,0.0,1.0)
 var strength: float = sin(clampf((age-0.24)/0.30,0.0,1.0)*PI)
 match str(active["kind"]):
  "bow":
   var start: Vector2 = Vector2(710 if hero else 1220,440)
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
 # Popups live on the controller so they survive the duel overlay fading.
 get_parent().add_child(label)
 label.z_index = 45
 var tween := create_tween().set_parallel(true)
 tween.tween_property(label,"position:y",label.position.y-65,0.8)
 tween.tween_property(label,"modulate:a",0.0,0.5).set_delay(0.3)
 tween.chain().tween_callback(label.queue_free)

func block_impact() -> void:
 if not pending.is_empty(): pending[-1]["kind"] = "block"
 elif not active.is_empty(): active["kind"] = "block"
