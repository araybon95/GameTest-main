extends Control
## A presentation-only reveal. The controller owns phases, rewards and damage.
signal finished
var entry: Dictionary = {}
var age: float = 0.0
var duration: float = 1.85
var model: TextureRect
var title: Label
var lore: Label
var marker: Label
var original: TextureRect
var was_visible: bool = true
var complete: bool = false
var tint: Color = Color("#CC554B")

func _ready() -> void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 mouse_filter = Control.MOUSE_FILTER_STOP
 focus_mode = Control.FOCUS_ALL
 grab_focus()
 original = entry.get("portrait")
 if not is_instance_valid(original) or original.texture == null:
  call_deferred("finish")
  return
 was_visible = original.visible
 original.visible = false
 tint = {"remade":Color("#D96867"),"keep":Color("#B0CCD9"),"moth":Color("#B3D497")}.get(str(entry.get("theme","bandit")),Color("#CC554B"))
 model = TextureRect.new()
 model.texture = entry.get("texture",original.texture)
 model.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 model.stretch_mode = TextureRect.STRETCH_SCALE
 var rect: Rect2 = original.get_global_rect()
 var pixel_height: float = float(model.texture.get_meta("idle_pixel_height",model.texture.get_height()))
 var height: float = rect.size.y*model.texture.get_height()/maxf(1.0,pixel_height)
 var width: float = height*model.texture.get_width()/float(maxi(1,model.texture.get_height()))
 if width > 620:
  height *= 620/width
  width = 620
 model.size = Vector2(width,height)
 model.position = rect.position-global_position+Vector2((rect.size.x-width)*0.5,rect.size.y-height)
 model.pivot_offset = Vector2(model.size.x*0.5,model.size.y)
 model.mouse_filter = Control.MOUSE_FILTER_IGNORE
 model.material = original.material.duplicate() if original.material != null else null
 add_child(model)
 marker = label("FLOOR GUARDIAN" if int(entry.get("total",1)) == 1 else "THE COTERIE · PHASE %d / %d" % [int(entry.get("phase",1)),int(entry.get("total",1))],Vector2(350,485),1220,19,tint)
 title = label(str(entry.get("name","The Guardian")).to_upper(),Vector2(220,520),1480,42,Color("#F5E5C7"))
 lore = label(str(entry.get("lore","")),Vector2(420,585),1080,22,Color("#CFBDA6"),true)
 lore.size = Vector2(1080,95)
 var skip := Button.new()
 skip.text = "CONTINUE"
 skip.position = Vector2(850,715)
 skip.size = Vector2(220,45)
 skip.add_theme_font_size_override("font_size",18)
 skip.pressed.connect(finish)
 add_child(skip)

func label(value: String, pos: Vector2, width: float, font_size: int, color: Color, wrapped: bool = false) -> Label:
 var result := Label.new()
 if wrapped: result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 result.text = value
 result.position = pos
 result.size = Vector2(width,55)
 result.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 result.add_theme_font_size_override("font_size",font_size)
 result.add_theme_color_override("font_color",color)
 result.add_theme_color_override("font_outline_color",Color.BLACK)
 result.add_theme_constant_override("outline_size",5)
 result.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(result)
 return result

func _process(delta: float) -> void:
 if complete: return
 age += delta
 if age >= duration:
  finish()
  return
 if model != null:
  # Enlarges around the feet: the boss remains in its actual battlefield slot.
  var reveal: float = smoothstep(0.0,0.65,age)
  model.scale = Vector2.ONE*(1.035-0.035*reveal)
  model.self_modulate = Color(0.4+0.6*reveal,0.35+0.65*reveal,0.35+0.65*reveal)
  title.modulate.a = smoothstep(0.15,0.55,age)
  lore.modulate.a = smoothstep(0.35,0.8,age)
 queue_redraw()

func _draw() -> void:
 var fade: float = minf(1.0,age/0.12)*minf(1.0,(duration-age)/0.18)
 draw_rect(Rect2(Vector2.ZERO,size),Color(0.025,0.012,0.016,0.85*fade))
 draw_rect(Rect2(0,475,size.x,300),Color(0.025,0.018,0.021,0.9*fade))
 var line_color := tint
 line_color.a = fade*0.7
 draw_line(Vector2(420,478),Vector2(1500,478),line_color,2)
 draw_line(Vector2(570,693),Vector2(1350,693),line_color,1)
 draw_circle(Vector2(960,478),4,Color("#EED8B1"))

func finish() -> void:
 if complete: return
 complete = true
 if is_instance_valid(original): original.visible = was_visible
 finished.emit()
 queue_free()

func _exit_tree() -> void:
 if is_instance_valid(original): original.visible = was_visible

func _gui_input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed and event.keycode in [KEY_SPACE,KEY_ESCAPE,KEY_ENTER]:
  accept_event()
  finish()
