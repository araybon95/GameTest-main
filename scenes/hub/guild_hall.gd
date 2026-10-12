extends Control
## Local hall foundation; the board reserves the future network voting surface.
const State = preload("res://scripts/game_data.gd")
const Profile = preload("res://scripts/guild_hall_profile.gd")
const UISkin = preload("res://scripts/ui_skin.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
const ART = "res://assets/art_library/presentation/guild_hall/interior.png"
const DECOR = "res://assets/art_library/presentation/guild_hall/decor.png"
const BANNER_ART = "res://assets/art_library/presentation/guild_hall/banner.png"
const BANNER_COLORS = {"wine":Color("#762B38"),"forest":Color("#2B5443"),"slate":Color("#384D66"),"ochre":Color("#866130")}
const LIGHT_COLORS = {"hearth":Color(1.0,0.96,0.88),"moonlit":Color(0.70,0.80,1.0),"candlelit":Color(0.88,0.75,0.63)}
var profile_path: String = Profile.PATH
var profile: Dictionary
var title: Label
var backdrop: TextureRect
var banner: HallBanner
var prop: TextureRect
var notice: Label
var board_title: Label
var board_detail: Label
var modal: Control
var clock: float = 0
var chatter: Label
var ambience: HallAmbience
var actors: Array[TextureRect] = []
var save_error: bool = false
const CHATTER = ["A scout unfolds a rain-stained map. Somewhere, a tankard meets the table.","The quartermaster counts provisions while two veterans argue over a shortcut.","A tired company returns to warm lanterns, louder stories, and an empty bench.","By the hearth, a healer stitches a sleeve. At the board, another journey begins."]

func _ready() -> void:
	State.load_progression()
	preload("res://scripts/settlement_music.gd").play()
	profile = Profile.read_profile(profile_path)
	backdrop = TextureRect.new()
	backdrop.name = "GuildHallInterior"
	backdrop.texture = load(ART) if ResourceLoader.exists(ART) else load("res://assets/art_library/presentation/settlement/barracks_interior.png")
	backdrop.size = Vector2(1920,1080)
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_SCALE
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	# Quiet header/footer bands keep text readable while preserving the room.
	shade(Rect2(0,0,1920,160),Color(0.025,0.02,0.025,0.72))
	shade(Rect2(0,956,1920,124),Color(0.025,0.02,0.025,0.87))
	title = label_at("",Vector2(62,34),1080,42)
	title.name = "GuildName"
	title.autowrap_mode = TextServer.AUTOWRAP_OFF
	title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label_at("ADVENTURERS' GUILD · A fire, a fellowship, a road ahead",Vector2(65,98),1060,20,UISkin.MUTED)
	var decorate := button_at("CUSTOMIZE HALL",Rect2(1210,65,280,57),open_customization)
	decorate.name = "CustomizeHall"
	button_at("RETURN TO HAMLET",Rect2(1520,65,325,57),back).name = "GuildHallReturn"
	banner = HallBanner.new()
	banner.fabric = load(BANNER_ART) if ResourceLoader.exists(BANNER_ART) else null
	banner.position = Vector2(804,176)
	add_child(banner)
	prop = TextureRect.new()
	prop.name = "HallFurnishing"
	prop.position = Vector2(48,723)
	prop.size = Vector2(265,265)
	prop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	prop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	prop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(prop)
	ambience = HallAmbience.new()
	ambience.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ambience)
	build_party()
	build_board()
	chatter = label_at(CHATTER[0],Vector2(60,977),1190,20,UISkin.MUTED)
	notice = label_at("Hall appearance saves automatically.",Vector2(60,1016),1170,18,UISkin.MUTED)
	var online := button_at("ONLINE GATHERING · COMING LATER",Rect2(1295,975,550,58),func(): pass)
	online.name = "OnlineGathering"
	online.disabled = true
	online.tooltip_text = "This hall is local. Steam invites, online players, and shared expedition votes are not connected yet."
	apply_profile()
	preload("res://scripts/static_screen_art.gd").transition(self)

func build_party() -> void:
	for index in range(State.party.size()):
		var id: String = State.party[index]
		var picture := TextureRect.new()
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_SCALE
		picture.name = "GuildHero_"+id
		picture.texture = Scenery.grounded_texture(str(State.hero(id).art))
		var height: float = 295
		var width: float = height*picture.texture.get_width()/maxf(1,picture.texture.get_height())
		var center: float = 420+index*275
		picture.position = Vector2(center-width*0.5,914-height)
		picture.size = Vector2(width,height)
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var shadow = preload("res://scenes/combat/ground_shadow.gd").new()
		shadow.position = Vector2(center,912)
		add_child(shadow)
		add_child(picture)
		actors.append(picture)
		Scenery.apply_hero_palette(picture,id,State.hero_colors.get(id,"original"))
		picture.add_child(preload("res://scenes/expedition/camp_actor.gd").new())
		var caption := label_at(str(State.hero(id).name).to_upper(),Vector2(center-110,916),220,20)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.autowrap_mode = TextServer.AUTOWRAP_OFF
		caption.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		caption.tooltip_text = caption.text
	label_at("YOUR CURRENT PARTY · Change companions in the Barracks",Vector2(350,566),755,18,UISkin.MUTED)

func build_board() -> void:
	var board := button_at("",Rect2(1160,264,575,320),open_board)
	board.name = "ExpeditionBoard"
	board.tooltip_text = "Inspect the expedition notices. This is the future party-voting board."
	for state in ["normal","pressed","disabled"]:
		board.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	var hover := UISkin.frame(Color(0.22,0.16,0.07,0.17),Color("#B89C71"))
	board.add_theme_stylebox_override("hover",hover)
	label_at("THE EXPEDITION BOARD",Vector2(1200,279),495,27)
	board_title = label_at("",Vector2(1200,334),480,30)
	board_title.name = "PinnedExpedition"
	board_detail = label_at("",Vector2(1200,388),470,21,UISkin.MUTED)
	label_at("INSPECT NOTICES  ›",Vector2(1200,532),470,22,UISkin.BRASS)
	label_at("Gather here to decide your next expedition.\nShared voting arrives with online lobbies.",Vector2(1175,732),600,20,UISkin.PAPER)

func apply_profile() -> void:
	title.text = str(profile.name).to_upper()
	title.tooltip_text = title.text
	banner.tint = BANNER_COLORS[profile.banner]
	banner.emblem = profile.emblem
	banner.queue_redraw()
	backdrop.modulate = LIGHT_COLORS[profile.lighting]
	prop.modulate = backdrop.modulate
	banner.modulate = backdrop.modulate
	for actor in actors: actor.modulate = backdrop.modulate
	if ResourceLoader.exists(DECOR):
		var tile := AtlasTexture.new()
		tile.atlas = load(DECOR)
		var cell := tile.atlas.get_size()/Vector2(3,2)
		tile.region = Rect2(Vector2(Profile.CHOICES.furnishing.find(profile.furnishing)*cell.x,0),cell)
		tile.filter_clip = true
		prop.texture = tile
	var route: Dictionary = State.expedition_by_id(profile.pinned_expedition)
	board_title.text = str(route.get("name","The Old Road"))
	board_detail.text = "%s\n\nPinned for discussion\nNo expedition votes cast yet." % str(route.get("region","Beyond the hamlet"))

func change_choice(key: String, value: Variant) -> void:
	var candidate: Dictionary = profile.duplicate(true)
	candidate[key] = value
	profile = Profile.clean(candidate)
	apply_profile()
	save_error = Profile.write_profile(profile,profile_path) != OK
	notice.text = "Hall saved · yours to return to." if not save_error else "Preview applied; hall profile could not be saved. Existing file was preserved."
	if is_instance_valid(modal):
		var feedback := modal.get_node_or_null("SaveFeedback")
		if feedback != null: feedback.text = notice.text

func make_modal(heading: String) -> void:
	close_modal()
	modal = Control.new()
	modal.name = "HallModal"
	modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(modal)
	var veil := ColorRect.new()
	veil.size = Vector2(1920,1080)
	veil.color = Color(0.015,0.012,0.02,0.90)
	modal.add_child(veil)
	var panel := Panel.new()
	panel.position = Vector2(420,150)
	panel.size = Vector2(1080,795)
	panel.add_theme_stylebox_override("panel",UISkin.frame(Color("#171416"),UISkin.BRASS))
	modal.add_child(panel)
	label_at(heading,Vector2(465,180),955,38,UISkin.PAPER,modal)
	button_at("RETURN TO THE HALL",Rect2(1090,855,355,57),close_modal,modal).name = "CloseHallModal"

func open_customization() -> void:
	make_modal("MAKE THIS HALL YOUR OWN")
	label_at("A company is remembered by the warmth it leaves behind.",Vector2(468,240),960,21,UISkin.MUTED,modal)
	label_at("GUILD NAME",Vector2(468,307),250,22,UISkin.BRASS,modal)
	var field := LineEdit.new()
	field.name = "GuildNameEdit"
	field.position = Vector2(795,295)
	field.size = Vector2(635,55)
	field.max_length = 32
	field.text = profile.name
	field.add_theme_font_size_override("font_size",25)
	field.text_submitted.connect(func(value): change_choice("name",value); field.text = profile.name)
	field.focus_exited.connect(func(): change_choice("name",field.text); field.text = profile.name)
	modal.add_child(field)
	var labels := {"banner":"BANNER CLOTH","emblem":"GUILD EMBLEM","lighting":"HALL LIGHTING","furnishing":"GATHERING CORNER"}
	var display := {"banner":["Oxblood","Forest green","Slate blue","Old gold"],"emblem":["The lantern","Crossed blades","Wayfarer's star"],"lighting":["Hearth warmth","Moonlit blue","Candlelight"],"furnishing":["Tankards & stools","Weapons & shields","Books & maps"]}
	var index: int = 0
	for key in Profile.CHOICES:
		var y: float = 391+index*87
		label_at(labels[key],Vector2(468,y+10),300,22,UISkin.BRASS,modal)
		var select := OptionButton.new()
		select.name = "Choice_"+key
		select.position = Vector2(795,y)
		select.size = Vector2(635,55)
		select.add_theme_font_size_override("font_size",24)
		for name in display[key]: select.add_item(name)
		select.select(Profile.CHOICES[key].find(profile[key]))
		select.item_selected.connect(func(choice): change_choice(key,Profile.CHOICES[key][choice]))
		modal.add_child(select)
		index += 1
	var feedback := label_at("Changes save automatically. Name: Enter or leave the field to save.",Vector2(468,775),960,19,UISkin.MUTED,modal)
	feedback.name = "SaveFeedback"
	get_node("/root/GothicPresentation").decorate(modal)
	field.grab_focus()

func open_board() -> void:
	make_modal("THE EXPEDITION BOARD")
	label_at("Pin a route for discussion. Online party voting will use this board.",Vector2(468,242),950,22,UISkin.MUTED,modal)
	var scroll := ScrollContainer.new()
	scroll.name = "ExpeditionNotices"
	scroll.position = Vector2(465,305)
	scroll.size = Vector2(980,465)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	modal.add_child(scroll)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation",12)
	scroll.add_child(list)
	for route in State.EXPEDITIONS:
		if not bool(route.get("released",true)) or bool(route.get("internal",false)): continue
		var id: String = route.id
		var available: bool = State.can_embark(id)
		var row := Panel.new()
		row.custom_minimum_size = Vector2(950,145)
		row.add_theme_stylebox_override("panel",UISkin.frame(Color("#241E19"),UISkin.EDGE))
		list.add_child(row)
		label_at(str(route.name),Vector2(16,9),630,29,UISkin.PAPER,row)
		label_at(str(route.get("region",""))+" · "+("Available" if available else "Not yet unlocked"),Vector2(16,54),610,19,UISkin.BRASS,row)
		label_at(str(route.get("blurb","")).substr(0,115),Vector2(16,84),625,18,UISkin.MUTED,row)
		var pin := button_at("PINNED" if profile.pinned_expedition == id else "PIN ROUTE",Rect2(680,35,250,55),func(): change_choice("pinned_expedition",id); open_board(),row)
		pin.name = "Pin_"+id
		pin.disabled = not available or profile.pinned_expedition == id
		pin.tooltip_text = "Pin for discussion; this does not launch an expedition or count as a multiplayer vote."
	label_at("No online votes yet. Each connected adventurer will have a voice here.",Vector2(468,808),960,19,UISkin.MUTED,modal)
	get_node("/root/GothicPresentation").decorate(modal)

func close_modal() -> void:
	if is_instance_valid(modal):
		var old: Control = modal
		var field := old.get_node_or_null("GuildNameEdit")
		if field != null and field.has_focus(): field.release_focus()
		modal = null
		old.queue_free()

func back() -> void:
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_instance_valid(modal): close_modal()
		else: back()
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	var settings := get_node_or_null("/root/GameSettings")
	var animated: bool = (settings == null or settings.ambient_motion) and not is_instance_valid(modal) and (settings == null or not is_instance_valid(settings.overlay))
	if animated: clock += maxf(delta,0)
	ambience.clock = clock
	ambience.queue_redraw()
	chatter.text = CHATTER[int(clock/10.0)%CHATTER.size()]

func shade(rect: Rect2, tint: Color) -> void:
	var block := ColorRect.new()
	block.position = rect.position
	block.size = rect.size
	block.color = tint
	block.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(block)

func label_at(value: String, pos: Vector2, width: float, font_size: int, tint: Color = UISkin.PAPER, parent: Node = null) -> Label:
	var result := Label.new()
	result.text = value
	result.position = pos
	result.size = Vector2(width,0)
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result.add_theme_font_size_override("font_size",font_size)
	result.add_theme_color_override("font_color",tint)
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	(parent if parent != null else self).add_child(result)
	return result

func button_at(value: String, rect: Rect2, action: Callable, parent: Node = null) -> Button:
	var result := Button.new()
	result.text = value
	result.position = rect.position
	result.size = rect.size
	result.add_theme_font_size_override("font_size",22)
	result.pressed.connect(action)
	result.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	(parent if parent != null else self).add_child(result)
	return result

class HallBanner extends Node2D:
	var tint: Color = Color("#762B38")
	var emblem: String = "lantern"
	var fabric: Texture2D
	func _draw() -> void:
		if fabric != null:
			draw_texture_rect(fabric,Rect2(-38,-14,225,310),false,tint.lightened(0.15))
		else:
			draw_line(Vector2(-15,0),Vector2(165,0),Color("#463C31"),12)
			var cloth := PackedVector2Array([Vector2(0,5),Vector2(150,5),Vector2(146,214),Vector2(75,250),Vector2(4,214)])
			draw_colored_polygon(cloth,tint)
			draw_polyline(cloth+PackedVector2Array([cloth[0]]),Color("#B89C71"),3,true)
		var gold := Color("#D8BE89")
		if emblem == "lantern":
			draw_arc(Vector2(75,81),18,PI,TAU,16,gold,4,true)
			draw_rect(Rect2(54,87,42,60),gold,false,4)
			draw_line(Vector2(47,84),Vector2(103,84),gold,5)
			draw_colored_polygon(PackedVector2Array([Vector2(75,105),Vector2(65,130),Vector2(75,139),Vector2(85,130)]),gold)
		elif emblem == "blades":
			for mirror in [-1,1]:
				draw_line(Vector2(75-mirror*35,149),Vector2(75+mirror*30,76),gold,8)
				draw_line(Vector2(75-mirror*43,122),Vector2(75-mirror*12,145),gold,6)
		else:
			var star := PackedVector2Array()
			for i in range(16): star.append(Vector2(75,119)+Vector2.from_angle(i*PI/8-PI/2)*(43 if i%2 == 0 else 13))
			draw_colored_polygon(star,gold)

class HallAmbience extends Control:
	var clock: float = 0
	func _draw() -> void:
		# Deterministic dust/firelight; never consume the expedition's RNG.
		for i in range(26):
			var x: float = fposmod(i*79.7+sin(clock*0.3+i)*18,1800)+50
			var y: float = 230+fposmod(i*47.1-clock*(7+i%4),630)
			draw_circle(Vector2(x,y),1.3,Color(0.93,0.70,0.39,0.12+0.09*sin(clock+i)))
		for light in [Vector2(280,400),Vector2(980,224)]:
			draw_set_transform(light,0,Vector2(1.5,0.65))
			for i in range(5): draw_circle(Vector2.ZERO,32+i*15,Color(1.0,0.58,0.22,(0.012+0.003*sin(clock*2.2))*float(5-i)))
