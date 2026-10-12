extends Control
signal chosen(hero_id: String, action: String)
signal dismissed
const State = preload("res://scripts/game_data.gd")
var discovery: bool = false
var room: Dictionary = {}
var selected_hero: String = ""

func _ready() -> void:
 name = "DoorwayChoices"
 z_index = 220
 size = Vector2(1920,1080)
 for id in State.party:
  if not State.run_heroes[id].get("dead",false) and int(State.run_heroes[id].get("hp",0)) > 0:
   selected_hero = id
   break
 refresh()

func refresh() -> void:
 for child in get_children():
  remove_child(child)
  child.queue_free()
 var shade := ColorRect.new()
 shade.color = Color(0.01,0.008,0.012,0.82)
 shade.size = size
 add_child(shade)
 var panel := Panel.new()
 panel.position = Vector2(380,230)
 panel.size = Vector2(1160,650)
 var skin := StyleBoxFlat.new()
 skin.bg_color = Color("#161015")
 skin.border_color = Color("#A08661")
 skin.set_border_width_all(2)
 panel.add_theme_stylebox_override("panel",skin)
 add_child(panel)
 preload("res://scripts/visual_overlays.gd").frame(panel)
 var event: Dictionary = State.Events.definition(str(room.get("event_id",""))) if discovery else {}
 label(str(event.get("name","AT THE THRESHOLD")),Vector2(420,260),1080,30)
 label(str(event.get("description","Arrange the party and use supplies before stepping into the encounter.")),Vector2(420,317),1080,22)
 label(str(event.get("risk","Choose a hero to inspect their inventory. Rank 1 is the front of the party.")),Vector2(420,387),1080,19)
 for i in range(State.party.size()):
  var id: String = State.party[i]
  var stats: Dictionary = State.run_heroes[id]
  var x: float = 420+i*350
  var alive: bool = not stats.get("dead",false) and int(stats.get("hp",0)) > 0
  var choose := button(("◆ " if id == selected_hero else "")+str(State.hero(id)["name"]),Rect2(x,465,330,55),func(): selected_hero=id; refresh())
  choose.disabled = not alive
  label("%s\nHP %d / %d · Rank %d\nStress %d" % [State.hero(id)["class"],stats.get("hp",0),State.hero_max_hp(id),State.Depth.position_of(State,id),stats.get("stress",0)],Vector2(x,530),240,18)
  var portrait := TextureRect.new()
  portrait.texture = preload("res://scripts/dungeon_scenery.gd").grounded_texture(str(State.hero(id)["art"]))
  portrait.position = Vector2(x+248,525)
  portrait.size = Vector2(65,80)
  portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
  preload("res://scripts/dungeon_scenery.gd").apply_hero_palette(portrait,id,State.hero_colors.get(id,"original"))
  add_child(portrait)
  portrait.set_deferred("size",Vector2(65,80))
  if not discovery:
   var rank := button("CHANGE RANK",Rect2(x,615,330,48),func(): State.Depth.move_hero(State,id,State.Depth.position_of(State,id)%State.party.size()+1); refresh())
   rank.disabled = not alive
 var inventory := button("SUPPLIES / INVENTORY",Rect2(420,695,330,52),open_inventory)
 inventory.disabled = selected_hero.is_empty()
 button("LEAVE UNTOUCHED" if discovery else "BACK",Rect2(780,695,330,52),decline)
 var proceed := button("INVESTIGATE" if discovery else "ENTER ENCOUNTER",Rect2(1140,695,330,52),func(): chosen.emit(selected_hero,"investigate" if discovery else "enter"))
 proceed.disabled = selected_hero.is_empty()
 if discovery:
  var event_id: String = str(room.get("event_id",""))
  if event_id == "crusader_coffin": proceed.disabled = int(State.run_heroes.get(selected_hero,{}).get("hp",0)) <= 3
  var option: Dictionary = State.Mechanics.event_option(event_id,selected_hero)
  if not option.is_empty():
   var special := button(str(option["name"]),Rect2(420,615,505,48),func(): chosen.emit(selected_hero,"class"))
   special.disabled = int(State.run_heroes.get(selected_hero,{}).get("hp",0)) <= int(option.get("cost",0))
  var supply_id: String = str(State.Depth.EVENT_SUPPLIES.get(event_id,""))
  if not supply_id.is_empty():
   var supply := button("USE %s ×%d" % [State.Items.item(supply_id)["name"],State.inventory.get(supply_id,0)],Rect2(955,615,515,48),func(): chosen.emit(selected_hero,"supply"))
   supply.disabled = selected_hero.is_empty() or int(State.inventory.get(supply_id,0)) <= 0 or (event_id == "crusader_coffin" and int(State.run_heroes.get(selected_hero,{}).get("hp",0)) <= 1)
 label("Any harmful discovery affects the chosen hero. Rewards are rolled only after entry." if discovery else "Formation and supplies carry into combat. You may still back away from the doorway.",Vector2(420,784),1080,18)

func label(value: String, where: Vector2, width: float, font_size: int) -> void:
 var text := Label.new()
 text.text = value
 text.position = where
 text.size = Vector2(width,65)
 text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 text.add_theme_font_size_override("font_size",font_size)
 text.add_theme_color_override("font_color",Color("#E9D4AE"))
 text.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(text)

func button(value: String, rect: Rect2, action: Callable) -> Button:
 var result := Button.new()
 result.text = value
 result.position = rect.position
 result.size = rect.size
 result.add_theme_font_size_override("font_size",19)
 for state in ["normal","hover","pressed","focus","disabled"]:
  var skin := StyleBoxFlat.new()
  skin.bg_color = Color("#362329") if state in ["hover","pressed"] else Color("#1B141A")
  skin.border_color = Color("#D6B77F") if state in ["hover","focus"] else Color("#5B4744")
  skin.set_border_width_all(1)
  skin.set_content_margin_all(8)
  result.add_theme_stylebox_override(state,skin)
 result.add_theme_color_override("font_color",Color("#E4CDA5"))
 result.add_theme_color_override("font_disabled_color",Color("#71666A"))
 result.pressed.connect(action)
 add_child(result)
 return result

func decline() -> void:
 if discovery: chosen.emit("","leave")
 else: dismissed.emit()

func _unhandled_input(event: InputEvent) -> void:
 if event.is_action_pressed("ui_cancel"):
  get_viewport().set_input_as_handled()
  dismissed.emit()

func open_inventory() -> void:
 var controls := get_node("/root/GameControls")
 controls.open_hero_sheet(selected_hero,true)
 controls.hero_sheet.closed.connect(func():
  if is_inside_tree(): refresh())
