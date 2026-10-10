extends Node
## Original ink, iron and parchment presentation shared by every scene.
var scene_id: int = 0
var timer: float = 0.0
var heading_font: SystemFont
func _ready() -> void:
 heading_font = SystemFont.new()
 heading_font.font_names = PackedStringArray(["Georgia", "DejaVu Serif", "serif"])
 heading_font.font_weight = 700
func _process(delta: float) -> void:
 timer += delta
 if timer < 0.25: return
 timer = 0.0
 var scene := get_tree().current_scene
 if scene == null or scene.get_instance_id() == scene_id: return
 scene_id = scene.get_instance_id()
 decorate(scene)
func frame(fill: Color, border: Color) -> StyleBoxFlat:
 var box := StyleBoxFlat.new()
 box.bg_color = fill
 box.border_color = border
 box.set_border_width_all(2)
 box.set_corner_radius_all(0)
 box.set_content_margin_all(10)
 box.shadow_color = Color(0,0,0,0.8)
 box.shadow_size = 4
 box.shadow_offset = Vector2(2,3)
 return box
func decorate(node: Node) -> void:
 if node is Control and node == get_tree().current_scene:
  var skin: Theme = node.theme.duplicate() if node.theme != null else Theme.new()
  for state in ["normal", "hover", "pressed", "disabled", "focus"]:
   skin.set_stylebox(state,"Button",frame(Color("#171313") if state != "hover" else Color("#39251D"),Color("#786044") if state != "hover" else Color("#DBC291")))
  skin.set_color("font_color","Button",Color("#F1E2C5"))
  skin.set_color("font_hover_color","Button",Color("#FFF1D4"))
  skin.set_color("font_disabled_color","Button",Color("#897D6C"))
  skin.set_stylebox("panel","PanelContainer",frame(Color("#141112"),Color("#665240")))
  node.theme = skin
 if node is Control:
  for state in ["panel", "normal", "hover", "pressed", "focus", "disabled"]:
   if node.has_theme_stylebox_override(state):
    var existing: StyleBox = node.get_theme_stylebox(state)
    if existing is StyleBoxFlat:
     var angular: StyleBoxFlat = existing.duplicate()
     angular.set_corner_radius_all(0)
     node.add_theme_stylebox_override(state,angular)
 if node is Label:
  node.add_theme_color_override("font_shadow_color",Color.BLACK)
  node.add_theme_constant_override("shadow_offset_x",1)
  node.add_theme_constant_override("shadow_offset_y",2)
  if node.get_theme_font_size("font_size") >= 28:
   node.add_theme_font_override("font",heading_font)
 if node is TextureRect and node.texture != null and node.material == null:
  var path: String = node.texture.resource_path.to_lower()
  if path.contains("bg_") or path.contains("background") or path.contains("settlement") or path.contains("estate_map"):
   var ink := ShaderMaterial.new()
   ink.shader = preload("res://scripts/ink_art.gdshader")
   node.material = ink
 for child in node.get_children(): decorate(child)
