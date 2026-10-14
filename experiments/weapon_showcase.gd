extends Control
const Preview = preload("res://experiments/warden_weapon_preview.tscn")
var figures: Array = []
var captions: Array[Label] = []
var mode: String = "idle"

func label_at(text: String, where: Vector2, font_size: int, width: float = 600.0) -> Label:
 var label := Label.new()
 label.text = text
 label.position = where
 label.size.x = width
 label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 label.add_theme_font_size_override("font_size",font_size)
 label.add_theme_color_override("font_color",Color("d6c4a0"))
 add_child(label)
 return label

func _ready() -> void:
 var background := TextureRect.new()
 background.texture = load("res://assets/art_library/presentation/rooms/beast_combat.png")
 background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(background)
 var shade := ColorRect.new()
 shade.color = Color(0.015,0.02,0.025,0.76)
 shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(shade)
 label_at("THE WARDEN · WEAPON STUDY",Vector2(0,20),32,1920)
 label_at("Same armour and build · interchangeable weapon · restrained elemental wisps",Vector2(0,70),20,1920)
 for row in range(2):
  label_at("Original armour" if row == 0 else "Ashen Wolf armour",Vector2(30,160+row*430),20,190)
  for column in range(3):
   var figure = Preview.instantiate()
   add_child(figure)
   figure.position = Vector2(430+column*560,500+row*430)
   figure.configure("original" if row == 0 else "ashen_wolf",["warden_sword","preview_mace","warden_frostblade"][column])
   figures.append(figure)
   captions.append(label_at(["IRON LONGSWORD · no effect","SPIKED MACE · no effect","VIGIL OF WINTER · faint frost"][column],Vector2(230+column*560,510+row*430),18,440))
 var controls := HBoxContainer.new()
 controls.position = Vector2(740,1005)
 controls.add_theme_constant_override("separation",20)
 add_child(controls)
 for entry in [["Idle","idle"],["Attack pose","attack"],["Element colours","effects"]]:
  var button := Button.new()
  button.text = entry[0]
  button.custom_minimum_size = Vector2(135,42)
  button.pressed.connect(show_mode.bind(entry[1]))
  controls.add_child(button)

func show_mode(value: String) -> void:
 mode = value
 for index in range(figures.size()):
  var figure = figures[index]
  var column: int = index%3
  figure.configure("original" if index < 3 else "ashen_wolf",["warden_sword","preview_mace","warden_frostblade"][column])
  figure.set_pose("attack" if value == "attack" else "idle")
  captions[index].text = ["IRON LONGSWORD · no effect","SPIKED MACE · no effect","VIGIL OF WINTER · faint frost"][column]
  if value == "effects":
   figure.configure("original" if index < 3 else "ashen_wolf","warden_sword")
   var element: String = ["bleed","poison","burn"][column]
   figure.wisps.visible = true
   figure.smoke.material.set_shader_parameter("tint",figure.COLOURS[element])
   captions[index].text = element.to_upper()+" WISP · colour sample only"
