extends "res://scenes/ui/party_screen.gd"
const Scenery = preload("res://scripts/dungeon_scenery.gd")
const IronFrame = preload("res://scenes/combat/iron_frame.gd")
const BACKGROUND: String = "res://assets/generated/graveyard_ink_background.png"
const IVORY: Color = Color("#E8D7B9")
const PARCHMENT: Color = Color("#C4B399")
const STONE: Color = Color("#25282B")

func _ready() -> void:
	State.load_progression()
	refresh()
	add_child(preload("res://scenes/expedition/scene_arrival.gd").new())

func refresh() -> void:
	clear_screen()
	var backdrop := picture(BACKGROUND,Rect2(0,0,1920,1080))
	backdrop.name = "GraveyardBackground"
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_add_atmosphere()
	var title := label_at("THE GRAVEYARD",Vector2(70,60),690,52)
	title.name = "GraveyardTitle"
	title.add_theme_color_override("font_color",IVORY)
	label_at("The hamlet keeps their names, even when the roads forget their footsteps.",Vector2(74,150),660,24).size.y = 110
	var epitaph := _iron_panel(Rect2(60,805,690,145),Color(0.035,0.035,0.04,0.78),Color("#5B5650"))
	epitaph.name = "CemeteryEpitaph"
	var count := label_at("%d MEMORIAL%s" % [State.graves.size(),"" if State.graves.size() == 1 else "S"],Vector2(88,828),635,27)
	count.name = "MemorialCount"
	count.add_theme_color_override("font_color",IVORY)
	label_at("They carried the light of the hamlet.\nTheir names remain when the road takes all else.",Vector2(88,877),635,20).add_theme_color_override("font_color",PARCHMENT)
	var ledger := _iron_panel(Rect2(845,60,1000,885),Color(0.055,0.052,0.059,0.94),Color("#706354"))
	ledger.name = "MemorialLedger"
	var heading := label_at("CARVED MEMORIALS",Vector2(883,90),920,34)
	heading.add_theme_color_override("font_color",IVORY)
	label_at("Names · Final trials · Deeds remembered",Vector2(886,147),900,20).add_theme_color_override("font_color",PARCHMENT)
	var divider := ColorRect.new()
	divider.color = Color("#635A4F")
	divider.position = Vector2(882,192)
	divider.size = Vector2(925,2)
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(divider)
	var scroll := ScrollContainer.new()
	scroll.name = "MemorialsScroll"
	scroll.position = Vector2(880,220)
	scroll.size = Vector2(930,675)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var list := VBoxContainer.new()
	list.name = "MemorialList"
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation",22)
	scroll.add_child(list)
	if State.graves.is_empty():
		var empty := _record_text("No names have yet been carved.\nMay these stones remain unwritten.",28,IVORY)
		empty.name = "EmptyMemorials"
		empty.custom_minimum_size = Vector2(875,180)
		list.add_child(empty)
	for index in range(State.graves.size()-1,-1,-1):
		list.add_child(_memorial(State.graves[index],index))
	label_at("Newest names are carved first. Scroll to remember those before them.",Vector2(885,907),915,18).add_theme_color_override("font_color",PARCHMENT)
	var back_button := button_at("RETURN TO HAMLET",Rect2(1390,973,435,66),back)
	back_button.name = "GraveyardReturn"
	back_button.add_child(IronFrame.new())
	Scenery.decorate(self)

func _memorial(grave: Dictionary,index: int) -> PanelContainer:
	var row := PanelContainer.new()
	row.name = "Memorial_%d" % index
	row.custom_minimum_size.x = 880
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var box := StyleBoxFlat.new()
	box.bg_color = STONE
	box.border_color = Color("#746B5E")
	box.set_border_width_all(2)
	box.border_width_top = 4
	box.set_corner_radius_all(0)
	box.set_content_margin_all(28)
	box.shadow_color = Color(0,0,0,0.72)
	box.shadow_size = 5
	box.shadow_offset = Vector2(2,4)
	row.add_theme_stylebox_override("panel",box)
	row.add_child(IronFrame.new())
	var contents := VBoxContainer.new()
	contents.name = "Record"
	contents.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	contents.add_theme_constant_override("separation",10)
	row.add_child(contents)
	var hero_name := _record_text(str(grave["name"]),34,IVORY)
	hero_name.name = "HeroName"
	contents.add_child(hero_name)
	var hero_class := _record_text(str(grave["class"]).to_upper(),20,Color("#BFA989"))
	hero_class.name = "HeroClass"
	contents.add_child(hero_class)
	var location := _record_text("Fell in %s · Floor %d" % [grave["dungeon"],int(grave["floor"])],22,PARCHMENT)
	location.name = "FallenLocation"
	contents.add_child(location)
	var date := _record_text("Remembered %s" % str(grave["date"]),19,Color("#AFA595"))
	date.name = "MemorialDate"
	contents.add_child(date)
	var cause := _record_text("Last trial: %s" % str(grave["cause"]),22,Color("#D1A59B"))
	cause.name = "FinalTrial"
	contents.add_child(cause)
	var deeds: Dictionary = grave.get("deeds",{})
	var account := _record_text("Survived %d battles. Dealt %d damage. Recovered %d health." % [int(deeds.get("battles",0)),int(deeds.get("damage",0)),int(deeds.get("healing",0))],22,IVORY)
	account.name = "MemorialDeeds"
	contents.add_child(account)
	return row

func _record_text(value: String,font_size: int,color: Color) -> Label:
	var text := Label.new()
	text.text = value
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text.add_theme_font_size_override("font_size",font_size)
	text.add_theme_color_override("font_color",color)
	text.add_theme_color_override("font_shadow_color",Color.BLACK)
	text.add_theme_constant_override("shadow_offset_x",1)
	text.add_theme_constant_override("shadow_offset_y",2)
	return text

func _iron_panel(rect: Rect2,fill: Color,border: Color) -> Panel:
	var result := panel(rect,fill)
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(2)
	box.set_corner_radius_all(0)
	box.shadow_color = Color(0,0,0,0.8)
	box.shadow_size = 8
	box.shadow_offset = Vector2(3,5)
	result.add_theme_stylebox_override("panel",box)
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result.add_child(IronFrame.new())
	return result

func _add_atmosphere() -> void:
	var haze := CPUParticles2D.new()
	haze.name = "CemeteryMotes"
	haze.texture = load("res://assets/generated/mote.png")
	haze.amount = 32
	haze.lifetime = 12.0
	haze.preprocess = 12.0
	haze.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	haze.emission_rect_extents = Vector2(400,430)
	haze.position = Vector2(420,550)
	haze.gravity = Vector2(2,-5)
	haze.initial_velocity_min = 2.0
	haze.initial_velocity_max = 5.0
	haze.scale_amount_min = 0.08
	haze.scale_amount_max = 0.2
	haze.color = Color(0.68,0.74,0.76,0.18)
	add_child(haze)
	var gradient := Gradient.new()
	gradient.colors = PackedColorArray([Color(0.015,0.015,0.022,0.68),Color.TRANSPARENT])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill_from = Vector2(0,0)
	texture.fill_to = Vector2(0,1)
	var shade := TextureRect.new()
	shade.name = "CemeteryHeaderShade"
	shade.texture = texture
	shade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	shade.position = Vector2.ZERO
	shade.size = Vector2(845,330)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

func back() -> void:
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): back()
