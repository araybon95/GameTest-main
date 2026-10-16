extends Node
const UISkin = preload("res://scripts/ui_skin.gd")
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
func frame(fill: Color, border: Color, state: String = "panel") -> StyleBoxFlat:
 return UISkin.frame(fill,border,state)
func decorate(node: Node) -> void:
 if node is Control and (node == get_tree().current_scene or node.get_meta("grimdark_scope",false)):
  var skin: Theme = node.theme.duplicate() if node.theme != null else Theme.new()
  for state in ["normal", "hover", "pressed", "disabled", "focus"]:
   skin.set_stylebox(state,"Button",frame(Color("#181617") if state != "hover" else Color("#302722"),UISkin.EDGE if state != "hover" else UISkin.BRASS,state))
  skin.set_color("font_color","Button",UISkin.PAPER)
  skin.set_color("font_hover_color","Button",Color("#FFF1D4"))
  skin.set_color("font_disabled_color","Button",UISkin.MUTED)
  skin.set_stylebox("panel","PanelContainer",frame(Color("#141112"),Color("#665240")))
  node.theme = skin
 if node is Control:
  for state in ["panel", "normal", "hover", "pressed", "focus", "disabled"]:
   if node.has_theme_stylebox_override(state):
    var existing: StyleBox = node.get_theme_stylebox(state)
    if existing is StyleBoxFlat and existing.draw_center and existing.bg_color.a > 0.0:
     var angular: StyleBoxFlat = existing.duplicate()
     angular = UISkin.refine(angular,state)
     node.add_theme_stylebox_override(state,angular)
 if node is Panel or node is PanelContainer:
  if node.size.x >= 180 and node.size.y >= 80 and not node.get_meta("untextured",false):
   preload("res://scripts/visual_overlays.gd").frame(node,str(node.get_meta("hero_id",node.get_node("IronFittings").hero_id if node.has_node("IronFittings") else "")))
 if node is Button and not node.text.is_empty() and node.size.x >= 120:
  preload("res://scripts/visual_overlays.gd").frame(node,str(node.get_meta("hero_id",node.get_node("IronFittings").hero_id if node.has_node("IronFittings") else "")))
 if node is Label:
  if not node.has_theme_color_override("font_shadow_color"):
   node.add_theme_color_override("font_shadow_color",Color.BLACK)
   node.add_theme_constant_override("shadow_offset_x",1)
   node.add_theme_constant_override("shadow_offset_y",2)
  if node.get_theme_font_size("font_size") >= 28:
   # Theme notifications can reshape text synchronously. Keep the old font's
   # data alive until replacement has completed, including its cached RIDs.
   var previous_font: Font = node.get_theme_font("font")
   if previous_font != heading_font: node.add_theme_font_override("font",heading_font)
 if node is TextureRect and node.texture != null and node.material == null:
  var path: String = node.texture.resource_path.to_lower()
  if path.contains("bg_") or path.contains("background") or path.contains("settlement") or path.contains("estate_map"):
   var ink := ShaderMaterial.new()
   ink.shader = preload("res://scripts/ink_art.gdshader")
   node.material = ink
 for child in node.get_children(): decorate(child)
