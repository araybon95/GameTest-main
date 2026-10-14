extends Node
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
const Music = preload("res://scripts/settlement_music.gd")
const LocalArt = preload("res://scripts/local_dungeon_art.gd")
var values: Dictionary = {"master": 0.8, "music": 0.8, "effects": 0.8, "brightness": 1.0}
var ambient_motion: bool = true
var experimental_walking: bool = false
var combat_speed: float = 1.0
var settings_path: String = "user://settings.cfg"
var layer: CanvasLayer
var overlay: Control
var brightness: ColorRect
var materials: Dictionary = {}
var elapsed: float = 0.0
var save_elapsed: float = 0.0
var scene_path: String = ""
var checkpoint_pending: bool = false
var loaded_game: bool = false
var notice: Label

func _ready() -> void:
	for bus in ["Music", "Effects"]:
		if AudioServer.get_bus_index(bus) == -1:
			AudioServer.add_bus()
			AudioServer.set_bus_name(AudioServer.bus_count - 1, bus)
	var cfg := ConfigFile.new()
	if cfg.load(settings_path) == OK:
		for key in values: values[key] = clampf(float(cfg.get_value("settings", key, values[key])), 0.65 if key == "brightness" else 0.0, 1.4 if key == "brightness" else 1.0)
	layer = CanvasLayer.new()
	layer.layer = 100
	add_child(layer)
	var button := Button.new()
	button.text = "SETTINGS · F10"
	button.position = Vector2(1710, 5)
	button.size = Vector2(200, 30)
	button.add_theme_font_size_override("font_size", 15)
	button.pressed.connect(open_settings)
	layer.add_child(button)
	var light_layer := CanvasLayer.new()
	light_layer.layer = 90
	add_child(light_layer)
	brightness = ColorRect.new()
	brightness.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	brightness.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader := Shader.new()
	shader.code = "shader_type canvas_item; uniform sampler2D screen_tex : hint_screen_texture, filter_nearest; uniform float brightness = 1.0; void fragment(){ COLOR = vec4(texture(screen_tex, SCREEN_UV).rgb * brightness, 1.0); }"
	var material := ShaderMaterial.new()
	material.shader = shader
	brightness.material = material
	light_layer.add_child(brightness)
	ambient_motion = bool(cfg.get_value("settings","ambient_motion",true))
	State.map_travel_mode = bool(cfg.get_value("settings","room_to_room_travel",true))
	experimental_walking = bool(cfg.get_value("settings","experimental_walking",false))
	var stored_speed: Variant = cfg.get_value("settings","combat_speed",1.0)
	combat_speed = float(stored_speed) if stored_speed is float or stored_speed is int else 1.0
	if not combat_speed in [1.0,1.5,2.0]: combat_speed = 1.0
	apply_values()

func apply_values() -> void:
	for key in ["master", "music", "effects"]:
		var bus: int = AudioServer.get_bus_index({"master": "Master", "music": "Music", "effects": "Effects"}[key])
		AudioServer.set_bus_mute(bus, float(values[key]) <= 0.0)
		AudioServer.set_bus_volume_db(bus, linear_to_db(maxf(0.0001, float(values[key]))))
	if brightness != null: brightness.material.set_shader_parameter("brightness", values["brightness"])

func set_value(key: String, value: float) -> void:
	if not values.has(key): return
	values[key] = clampf(value, 0.65 if key == "brightness" else 0.0, 1.4 if key == "brightness" else 1.0)
	apply_values()
	var cfg := ConfigFile.new()
	for setting in values: cfg.set_value("settings", setting, values[setting])
	cfg.set_value("settings","ambient_motion",ambient_motion)
	cfg.set_value("settings","experimental_walking",experimental_walking)
	cfg.set_value("settings","combat_speed",combat_speed)
	cfg.set_value("settings","room_to_room_travel",State.map_travel_mode)
	cfg.save(settings_path)

func set_combat_speed(value: float) -> void:
	combat_speed = value if value in [1.0,1.5,2.0] else 1.0
	set_value("brightness",values["brightness"])

func _process(delta: float) -> void:
	elapsed += delta
	save_elapsed += delta
	var current := get_tree().current_scene
	if current == null: return
	if current.scene_file_path != scene_path:
		scene_path = current.scene_file_path
		checkpoint_pending = true
		elapsed = 0.0
	if elapsed < 0.4: return
	elapsed = 0.0
	style_portraits(current)
	if (checkpoint_pending or save_elapsed >= 5.0) and safe_to_save() and not is_instance_valid(overlay):
		save_elapsed = 0.0
		checkpoint_pending = false
		if scene_path != "res://scenes/ui/title_screen.tscn": Saves.save(0)

func safe_to_save() -> bool:
	if get_tree().current_scene == null: return false
	var path: String = get_tree().current_scene.scene_file_path
	if path == "res://scenes/expedition/dungeon.tscn" and get_tree().current_scene.traveling: return false
	if not State.run_active: return path != "res://scenes/ui/title_screen.tscn"
	if path in ["res://scenes/expedition/merchant_orb_room.tscn", "res://scenes/hub/item_shop.tscn"]:
		return State.merchant_orb_available()
	return path == "res://scenes/expedition/dungeon.tscn" and not State.floors.is_empty() and State.floors[State.floor_index][State.room_position].get("cleared", false)

func save_unavailable_reason() -> String:
	var current := get_tree().current_scene
	if current == null or current.scene_file_path.contains("title_screen"): return "Begin or load a journey before saving."
	if current.scene_file_path == "res://scenes/expedition/dungeon.tscn" and current.traveling: return "Finish the hallway or return to its starting door before saving."
	if State.run_active: return "Return to a cleared map room or merchant between encounters to save. Combat and camp actions cannot be saved mid-encounter."
	return "Saving is unavailable on this screen."

func style_portraits(node: Node) -> void:
	if node.get_meta("palette_preview", false): return
	if node is TextureRect and node.texture != null:
		var path: String = node.texture.resource_path
		for id in State.HEROES:
			if not path.contains("hero_" + id): continue
			var color: String = State.hero_colors.get(id, "original")
			if color == "original":
				if node.has_meta("hero_palette"): node.material = null
				return
			var key: String = id + color
			if not materials.has(key):
				var material := ShaderMaterial.new()
				material.shader = preload("res://scripts/hero_palette.gdshader")
				material.set_shader_parameter("accent", {"red": Color("#B93640"), "green": Color("#389B58"), "blue": Color("#438CCD"), "gold": Color("#D5A03A")}.get(color, Color.WHITE))
				material.set_shader_parameter("source_family", 1 if id == "ranger" else 2 if id == "occultist" else 0)
				materials[key] = material
			node.material = materials[key]
			node.set_meta("hero_palette", true)
	for child in node.get_children(): style_portraits(child)

func text(value: String, position: Vector2, width: float, font_size: int = 24) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.position = position
	label.add_theme_font_size_override("font_size", font_size)
	label.size = Vector2(width, 60)
	overlay.add_child(label)
	return label

func open_settings() -> void:
	if overlay != null: return
	var controls := get_node_or_null("/root/GameControls")
	if controls != null:
		controls.close_guide()
		controls.close_hero_sheet()
	overlay = Control.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(overlay)
	var background := ColorRect.new()
	background.color = Color(0.035, 0.025, 0.04, 0.98)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(background)
	var backing := Panel.new()
	backing.position = Vector2(145,72)
	backing.size = Vector2(1630,960)
	backing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backing.add_theme_stylebox_override("panel",preload("res://scripts/ui_skin.gd").frame(Color("#111012"),Color("#665B4E")))
	overlay.add_child(backing)
	text("SETTINGS & SAVED JOURNEYS", Vector2(180, 100), 1550, 40)
	for index in range(4):
		var key: String = ["master", "music", "effects", "brightness"][index]
		var y: float = 175 + index * 75
		text(key.capitalize(), Vector2(180, y), 300)
		var slider := HSlider.new()
		slider.position = Vector2(510, y + 8)
		slider.size = Vector2(890, 40)
		slider.min_value = 0.65 if key == "brightness" else 0.0
		slider.max_value = 1.4 if key == "brightness" else 1.0
		slider.step = 0.01
		slider.value = values[key]
		var amount := text("%d%%" % roundi(slider.value * 100), Vector2(1460, y), 180)
		slider.value_changed.connect(func(value): set_value(key, value); amount.text = "%d%%" % roundi(value * 100))
		overlay.add_child(slider)
	var local_art := CheckBox.new()
	local_art.name = "LocalDungeonArtwork"
	local_art.text = "Use layered dungeon artwork and painted UI"
	local_art.position = Vector2(180, 465)
	local_art.size = Vector2(800, 43)
	local_art.add_theme_font_size_override("font_size", 23)
	local_art.button_pressed = LocalArt.get_enabled()
	local_art.tooltip_text = "Use editable images in assets/presentation first, with installed art as a fallback. Disable for the original drawn presentation. Applies when a scene is rebuilt."
	local_art.toggled.connect(set_local_dungeon_art)
	local_art.focus_mode = Control.FOCUS_ALL
	overlay.add_child(local_art)
	var motion := CheckBox.new()
	motion.name = "AmbientMotion"
	motion.text = "Animate scenes & hero movement"
	motion.tooltip_text = "Breathing, idle movement and scene transitions. Disable for a quieter presentation; hallway travel stays available."
	motion.position = Vector2(1080,465)
	motion.size = Vector2(650,43)
	motion.add_theme_font_size_override("font_size",22)
	motion.button_pressed = ambient_motion
	motion.toggled.connect(func(enabled): ambient_motion = enabled; set_value("brightness",values["brightness"]))
	overlay.add_child(motion)
	text("Combat playback",Vector2(180,522),300,22)
	var speed := OptionButton.new()
	speed.name = "CombatPlayback"
	speed.position = Vector2(510,517)
	speed.size = Vector2(310,45)
	speed.add_theme_font_size_override("font_size",22)
	for option in ["1× · Original","1.5× · Brisk","2× · Fast"]: speed.add_item(option)
	speed.select([1.0,1.5,2.0].find(combat_speed))
	speed.item_selected.connect(func(index): set_combat_speed([1.0,1.5,2.0][index]))
	overlay.add_child(speed)
	speed.tooltip_text = "Speeds attacks and boss reveals; combat rules stay the same."
	var travel_mode := OptionButton.new()
	travel_mode.name = "DungeonTravelMode"
	travel_mode.position = Vector2(1080,517)
	travel_mode.size = Vector2(650,43)
	travel_mode.add_theme_font_size_override("font_size",22)
	travel_mode.add_item("Dungeon travel · Room to room")
	travel_mode.add_item("Dungeon travel · Manual walking")
	travel_mode.select(0 if State.map_travel_mode else 1)
	travel_mode.disabled = not State.journey.get("transit",{}).is_empty() or (get_tree().current_scene != null and get_tree().current_scene.get("traveling") == true)
	travel_mode.item_selected.connect(func(index):
		State.map_travel_mode = index == 0
		set_value("brightness",values["brightness"])
		var scene = get_tree().current_scene
		if scene != null and scene.scene_file_path == "res://scenes/expedition/dungeon.tscn":
			if State.map_travel_mode: preload("res://scripts/room_discoveries.gd").prepare_floor(State)
			else: preload("res://scripts/passage_events.gd").restore_floor(State)
			scene.refresh()
	)
	overlay.add_child(travel_mode)
	var walking := CheckBox.new()
	walking.name = "ExperimentalWalking"
	walking.text = "Experimental walking"
	walking.tooltip_text = "Opt into subtle hallway breathing and weight shifts. Disable to use the original four-frame walking animation. Scene animation must be enabled for breathing."
	walking.position = Vector2(1080,563)
	walking.size = Vector2(650,43)
	walking.add_theme_font_size_override("font_size",22)
	walking.button_pressed = experimental_walking
	walking.toggled.connect(func(enabled): experimental_walking = enabled; set_value("brightness",values["brightness"]))
	overlay.add_child(walking)
	text(save_unavailable_reason() if not safe_to_save() else "Ready to save. AUTO is a separate checkpoint; manual slots can be overwritten.", Vector2(180, 578), 1560, 20).name = "SaveAvailability"
	for slot in range(4):
		var y: float = 625 + slot * 75
		var info: Dictionary = Saves.slot_info(slot)
		var summary_label := text(("AUTO" if slot == 0 else "SLOT %d" % slot) + " · " + str(info.summary) + ("\n"+str(info.detail) if info.loadable else ""), Vector2(180, y), 1120, 18)
		summary_label.tooltip_text = str(info.error)
		summary_label.mouse_filter = Control.MOUSE_FILTER_PASS
		if slot > 0:
			var save_button := action_button("SAVE", Vector2(1320, y), request_save.bind(slot))
			save_button.name = "SaveSlot%d" % slot
			save_button.disabled = not safe_to_save()
			save_button.tooltip_text = "Save this journey here." if safe_to_save() else save_unavailable_reason()
		var load_button := action_button("LOAD", Vector2(1510, y), request_load.bind(slot))
		load_button.name = "LoadSlot%d" % slot
		load_button.disabled = not info.loadable
		load_button.tooltip_text = str(info.error) if not info.loadable else "Resume this saved party and journey."
	notice = text("Changes apply immediately. F10 or Escape to close.", Vector2(180, 975), 1200, 20)
	action_button("CLOSE", Vector2(1510, 965), close_settings)
	overlay.set_meta("grimdark_scope",true)
	get_node("/root/GothicPresentation").decorate(overlay)

func set_local_dungeon_art(is_enabled: bool) -> void:
	var source_root: String = LocalArt.get_root()
	LocalArt.configure(source_root, is_enabled)
	var configuration := ConfigFile.new()
	configuration.load(LocalArt.CONFIG_PATH)
	configuration.set_value("art", "root", source_root)
	configuration.set_value("art", "enabled", is_enabled)
	var saved: bool = configuration.save(LocalArt.CONFIG_PATH) == OK
	if is_instance_valid(notice):
		notice.text = "Dungeon artwork choice saved; applies to the next hallway." if saved else "Artwork applies to the next hallway; this choice could not be saved."

func action_button(title: String, position: Vector2, action: Callable) -> Button:
	var button := Button.new()
	button.text = title
	button.position = position
	button.size = Vector2(170, 50)
	button.pressed.connect(action)
	overlay.add_child(button)
	return button

func save_slot(slot: int) -> void:
	if not safe_to_save(): return
	var ok: bool = Saves.save(slot)
	close_settings()
	open_settings()
	notice.text = "Journey saved." if ok else "Could not write the save file."

func request_load(slot: int) -> void:
	var info: Dictionary = Saves.slot_info(slot)
	if not info.loadable:
		if is_instance_valid(notice): notice.text = str(info.error) if not str(info.error).is_empty() else "This slot is empty."
		return
	var dialog := ConfirmationDialog.new()
	dialog.name = "LoadJourneyConfirmation"
	dialog.title = "Load saved journey?"
	dialog.dialog_text = str(info.summary)+"\n"+str(info.detail)
	if get_tree().current_scene != null and not get_tree().current_scene.scene_file_path.contains("title_screen"):
		dialog.dialog_text += "\nYour current unsaved journey will be replaced."
	dialog.confirmed.connect(func(): load_slot(slot))
	dialog.canceled.connect(dialog.queue_free)
	overlay.add_child(dialog)
	dialog.popup_centered(Vector2i(600, 200))

func load_slot(slot: int) -> bool:
	if not Saves.load_slot(slot):
		if is_instance_valid(notice): notice.text = str(Saves.slot_info(slot).error)
		return false
	close_settings()
	if State.run_active: Music.stop()
	else: Music.play()
	get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn" if State.run_active else "res://scenes/hub/settlement.tscn")
	return true

func request_save(slot: int) -> void:
	if not safe_to_save(): return
	if Saves.summary(slot) == "Empty":
		save_slot(slot)
		return
	var dialog := ConfirmationDialog.new()
	dialog.name = "SaveOverwriteConfirmation"
	dialog.title = "Replace saved journey?"
	dialog.dialog_text = "Replace SLOT %d?\n%s\nThe previous journey in this slot will be overwritten." % [slot,Saves.summary(slot)]
	dialog.confirmed.connect(func(): save_slot(slot))
	dialog.canceled.connect(dialog.queue_free)
	overlay.add_child(dialog)
	dialog.popup_centered(Vector2i(680,230))

func close_settings() -> void:
	if overlay != null: overlay.queue_free()
	overlay = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F10:
			if overlay == null: open_settings()
			else: close_settings()
			get_viewport().set_input_as_handled()
		elif overlay != null and event.keycode == KEY_ESCAPE:
			close_settings()
			get_viewport().set_input_as_handled()

func request_continue() -> void:
	open_settings()
	request_load(0)
