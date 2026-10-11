extends HBoxContainer
## Visible effect symbols with remaining turns; tooltip explains each effect.
const COLORS = {"burn":"#FF8D3C","bleed":"#ED546A","poison":"#A7E451","chill":"#91E8FF","weaken":"#BF9BDD","mark":"#FFD174"}
const SYMBOLS = {"burn":"F","bleed":"B","poison":"P","chill":"C","weaken":"↓","mark":"◎"}
const LocalArt = preload("res://scripts/local_dungeon_art.gd")
const LOCAL_ICONS = {"burn":"tray_dot_burn.png","bleed":"tray_bleed.png","poison":"tray_poison.png"}
func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_PASS
 add_theme_constant_override("separation",5)
func sync(statuses: Dictionary, weak: int = 0, marked: int = 0) -> void:
 for child in get_children():
  remove_child(child)
  child.queue_free()
 var entries: Dictionary = statuses.duplicate(true)
 if weak > 0: entries["weaken"] = {"turns":weak}
 if marked > 0: entries["mark"] = {"turns":marked}
 for id in entries:
  if not COLORS.has(id): continue
  var backing := PanelContainer.new()
  backing.name = "Effect_"+str(id)
  backing.mouse_filter = Control.MOUSE_FILTER_PASS
  var frame := StyleBoxFlat.new()
  frame.bg_color = Color("#120F13")
  frame.border_color = Color(COLORS[id]).darkened(0.45)
  frame.set_border_width_all(1)
  frame.content_margin_left = 3
  frame.content_margin_right = 3
  backing.add_theme_stylebox_override("panel",frame)
  var badge := HBoxContainer.new()
  badge.custom_minimum_size = Vector2(44,25)
  badge.add_theme_constant_override("separation",1)
  var turns: int = int(entries[id].get("turns",0))
  if id in ["burn","bleed","poison","chill"]:
   var icon := TextureRect.new()
   var local_icon: Texture2D = LocalArt.texture("../overlays/%s" % LOCAL_ICONS[id]) if LOCAL_ICONS.has(id) else null
   icon.texture = local_icon if local_icon != null else load("res://assets/ui/status_%s.svg" % id)
   icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
   icon.custom_minimum_size = Vector2(18,22)
   icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
   badge.add_child(icon)
  var counter := Label.new()
  counter.text = "%dt" % turns if id in ["burn","bleed","poison","chill"] else "%s%d" % [SYMBOLS[id],turns]
  counter.add_theme_font_size_override("font_size",16)
  counter.add_theme_color_override("font_color",Color(COLORS[id]))
  counter.mouse_filter = Control.MOUSE_FILTER_IGNORE
  badge.add_child(counter)
  badge.mouse_filter = Control.MOUSE_FILTER_PASS
  badge.tooltip_text = "%s · %d turns remaining%s%s" % [str(id).capitalize(),turns," · %d stacks" % int(entries[id]["stacks"]) if int(entries[id].get("stacks",1)) > 1 else ""," · %d damage per tick" % int(entries[id].get("damage",0)) if int(entries[id].get("damage",0)) > 0 else ""]
  backing.tooltip_text = badge.tooltip_text
  backing.add_child(badge)
  add_child(backing)
