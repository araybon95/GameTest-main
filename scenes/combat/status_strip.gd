extends HBoxContainer
## Visible effect symbols with remaining turns; tooltip explains each effect.
const COLORS = {"burn":"#FF8D3C","bleed":"#ED546A","poison":"#A7E451","chill":"#91E8FF","weaken":"#BF9BDD","mark":"#FFD174"}
const SYMBOLS = {"burn":"F","bleed":"B","poison":"P","chill":"C","weaken":"↓","mark":"◎"}
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
  var badge := HBoxContainer.new()
  badge.custom_minimum_size = Vector2(36,25)
  badge.add_theme_constant_override("separation",1)
  var turns: int = int(entries[id].get("turns",0))
  if id in ["burn","bleed","poison","chill"]:
   var icon := TextureRect.new()
   icon.texture = load("res://assets/ui/status_%s.svg" % id)
   icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
   icon.custom_minimum_size = Vector2(22,22)
   icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
   badge.add_child(icon)
  var counter := Label.new()
  counter.text = "%dt" % turns if id in ["burn","bleed","poison","chill"] else "%s%d" % [SYMBOLS[id],turns]
  counter.add_theme_font_size_override("font_size",17)
  counter.add_theme_color_override("font_color",Color(COLORS[id]))
  counter.mouse_filter = Control.MOUSE_FILTER_IGNORE
  badge.add_child(counter)
  badge.mouse_filter = Control.MOUSE_FILTER_PASS
  badge.tooltip_text = "%s · %d turns remaining%s%s" % [str(id).capitalize(),turns," · %d stacks" % int(entries[id]["stacks"]) if int(entries[id].get("stacks",1)) > 1 else ""," · %d damage per tick" % int(entries[id].get("damage",0)) if int(entries[id].get("damage",0)) > 0 else ""]
  add_child(badge)
