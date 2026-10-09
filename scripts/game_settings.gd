extends Node
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
const Music = preload("res://scripts/settlement_music.gd")
var values: Dictionary = {"master": 0.8, "music": 0.8, "effects": 0.8, "brightness": 1.0}
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
	cfg.save(settings_path)

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
	if (checkpoint_pending or save_elapsed >= 5.0) and safe_to_save():
		save_elapsed = 0.0
		checkpoint_pending = false
		if scene_path != "res://scenes/ui/title_screen.tscn": Saves.save(0)

func safe_to_save() -> bool:
	if get_tree().current_scene == null: return false
	var path: String = get_tree().current_scene.scene_file_path
	if not State.run_active: return path != "res://scenes/ui/title_screen.tscn"
	return path == "res://scenes/expedition/dungeon.tscn" and not State.floors.is_empty() and State.floors[State.floor_index][State.room_position].get("cleared", false)

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
	overlay = Control.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(overlay)
	var background := ColorRect.new()
	background.color = Color(0.035, 0.025, 0.04, 0.98)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(background)
	text("SETTINGS & SAVED JOURNEYS", Vector2(180, 100), 1550, 40)
	for index in range(4):
		var key: String = ["master", "music", "effects", "brightness"][index]
		var y: float = 190 + index * 90
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
	text("Save between encounters. Loading replaces the current journey. Slots can be overwritten; the automatic checkpoint uses a separate file.", Vector2(180, 555), 1560, 21)
	for slot in range(4):
		var y: float = 625 + slot * 75
		text(("AUTO" if slot == 0 else "SLOT %d" % slot) + " · " + Saves.summary(slot), Vector2(180, y), 1120, 18)
		if slot > 0:
			var save_button := action_button("SAVE", Vector2(1320, y), save_slot.bind(slot))
			save_button.disabled = not safe_to_save()
		var load_button := action_button("LOAD", Vector2(1510, y), request_load.bind(slot))
		load_button.disabled = Saves.summary(slot) == "Empty"
	notice = text("F10 or Escape to close. Settings apply immediately.", Vector2(180, 975), 1200, 20)
	action_button("CLOSE", Vector2(1510, 965), close_settings)

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
	var dialog := ConfirmationDialog.new()
	dialog.title = "Load saved journey?"
	dialog.dialog_text = "Your current unsaved journey will be replaced."
	dialog.confirmed.connect(func(): load_slot(slot))
	dialog.canceled.connect(dialog.queue_free)
	overlay.add_child(dialog)
	dialog.popup_centered(Vector2i(600, 200))

func load_slot(slot: int) -> bool:
	if not Saves.load_slot(slot):
		if notice != null: notice.text = "This save could not be loaded."
		return false
	close_settings()
	if State.run_active: Music.stop()
	else: Music.play()
	get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn" if State.run_active else "res://scenes/hub/settlement.tscn")
	return true

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
