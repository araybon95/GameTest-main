extends RefCounted
const State = preload("res://scripts/game_data.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
static func choice(owner: Control, group: Control, title: String, consequence: String, y: float, action: Callable, node_name: String) -> Button:
 var button: Button = owner.button_at("",Rect2(965,y,855,94),action)
 button.name = node_name
 button.alignment = HORIZONTAL_ALIGNMENT_LEFT
 button.add_theme_font_size_override("font_size",21)
 button.tooltip_text = title+" · "+consequence
 var title_label := Label.new()
 title_label.text = title
 title_label.position = Vector2(25,12)
 title_label.size = Vector2(800,30)
 title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
 title_label.add_theme_font_size_override("font_size",23)
 title_label.add_theme_color_override("font_color",Color("#DEC58D"))
 button.add_child(title_label)
 var detail := Label.new()
 detail.text = consequence
 detail.position = Vector2(25,43)
 detail.size = Vector2(800,46)
 detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 detail.mouse_filter = Control.MOUSE_FILTER_IGNORE
 detail.add_theme_font_size_override("font_size",18)
 detail.add_theme_color_override("font_color",Color("#D4DEDA"))
 button.add_child(detail)
 button.modulate = Color(0.6,0.6,0.6) if button.disabled else Color.WHITE
 if button.has_node("IronFittings"): button.get_node("IronFittings").hide()
 for state in ["normal","hover","pressed","focus","disabled"]:
  var box := StyleBoxFlat.new()
  box.bg_color = Color("#233B3D") if state == "hover" else Color("#17292C") if state != "disabled" else Color("#151B1D")
  box.border_color = Color("#B69B65") if state in ["hover","focus"] else Color("#57777B") if state != "disabled" else Color("#364447")
  box.set_border_width_all(2)
  box.set_corner_radius_all(5)
  box.content_margin_left = 25
  button.add_theme_stylebox_override(state,box)
 button.reparent(group)
 return button
static func build(owner: Control, room: Dictionary) -> void:
 var id: String = str(room.event_id)
 var event: Dictionary = State.Events.definition(id)
 var resolved: bool = room.get("event_resolved",false)
 var artwork: String = "res://assets/art_library/generated/story_strongbox.png"
 var bespoke: bool = id == "bandit_strongbox" and ResourceLoader.exists(artwork)
 var background: String = artwork if bespoke else Scenery.stage_path(State.floor_background("combat"))
 var backdrop: TextureRect = owner.picture(background,Rect2(0,0,1920,1080))
 backdrop.name = "StoryArt"
 backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 if not bespoke:
  backdrop.modulate = Color(0.47,0.48,0.5)
  var prop: TextureRect = owner.picture("res://assets/art_library/generated/event_%s.png" % id,Rect2(120,230,700,700))
  prop.name = "StoryProp"
 var shade := TextureRect.new()
 var gradient := Gradient.new()
 gradient.colors = PackedColorArray([Color(0,0,0,0),Color(0.02,0.025,0.03,0.82),Color(0.02,0.025,0.03,0.97)])
 gradient.offsets = PackedFloat32Array([0.0,0.5,1.0])
 var texture := GradientTexture2D.new()
 texture.gradient = gradient
 shade.texture = texture
 shade.position = Vector2(720,0)
 shade.size = Vector2(1200,1080)
 shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
 owner.add_child(shade)
 owner.label_at("? · MYSTERIOUS CHAMBER",Vector2(965,75),855,18).add_theme_color_override("font_color",Color("#98ADAF"))
 var heading: Label = owner.label_at(str(event.name),Vector2(965,120),855,42)
 heading.add_theme_color_override("font_color",Color("#DEC58D"))
 var description: Label = owner.label_at(str(event.description),Vector2(965,205),855,25)
 description.size = Vector2(855,140)
 var group := Control.new()
 group.name = "StoryChoices"
 owner.add_child(group)
 if resolved:
  var result: Dictionary = room.get("event_result",{})
  owner.label_at("LEFT UNTOUCHED" if result.get("left",false) else "YOUR CHOICE · THE OUTCOME",Vector2(965,390),855,19).add_theme_color_override("font_color",Color("#DEC58D"))
  var outcome: Label = owner.label_at(str(result.get("text","The chamber is silent.")),Vector2(965,445),855,27)
  outcome.name = "StoryOutcome"
  outcome.size = Vector2(855,250)
  choice(owner,group,"Continue","Return to the dungeon map.",800,owner.return_to_dungeon,"StoryContinue")
  return
 owner.label_at("WHO WILL INVESTIGATE?",Vector2(965,355),855,17)
 for index in range(State.party.size()):
  var hero_id: String = State.party[index]
  var choose: Button = owner.button_at(("▶ " if hero_id == owner.selected_hero else "")+str(State.hero(hero_id).name),Rect2(965+index*285,390,275,52),owner.select_hero.bind(hero_id))
  choose.add_theme_font_size_override("font_size",20)
  choose.disabled = State.run_heroes[hero_id].get("dead",false) or int(State.run_heroes[hero_id].hp) <= 0
 var investigate: Button = choice(owner,group,"Investigate",str(event.risk),475,owner.investigate,"EventObject")
 investigate.add_theme_font_size_override("font_size",18)
 investigate.disabled = owner.selected_hero.is_empty() or (id == "crusader_coffin" and int(State.run_heroes.get(owner.selected_hero,{}).get("hp",0)) <= 3)
 var y: float = 583
 var option: Dictionary = State.Mechanics.event_option(id,owner.selected_hero)
 if not option.is_empty():
  var special: Button = choice(owner,group,str(option.name)+" · "+str(State.hero(owner.selected_hero).name),str(option.risk),y,owner.investigate_as_class,"ClassInvestigation")
  special.disabled = int(State.run_heroes[owner.selected_hero].hp) <= int(option.cost)
  y += 108
 var supply_id: String = State.Depth.EVENT_SUPPLIES.get(id,"")
 if not supply_id.is_empty():
  var supply: Button = choice(owner,group,"Use "+str(State.Items.item(supply_id).name),"Spend 1 · Reduce opening damage to 1 HP." if id == "crusader_coffin" else "Spend 1 · Guaranteed reward · No harmful effect.",y,owner.investigate_with_supply,"SupplyInvestigation")
  supply.disabled = int(State.inventory.get(supply_id,0)) <= 0 or owner.selected_hero.is_empty() or (id == "crusader_coffin" and int(State.run_heroes.get(owner.selected_hero,{}).get("hp",0)) <= 1)
  supply.tooltip_text += " Available: %d" % int(State.inventory.get(supply_id,0))
  y += 108
 choice(owner,group,"Leave untouched","No reward · No risk.",y,owner.leave_untouched,"LeaveDiscovery")

 for child in group.get_children():
  if child is Button and child.disabled: child.modulate = Color(0.55,0.55,0.55)
