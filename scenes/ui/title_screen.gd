extends Control
## Ashen Expedition — title screen.
## BEGIN loads the combat scene; QUIT exits. Intended to be the Main Scene.

const SETTLEMENT_SCENE = "res://scenes/hub/settlement.tscn"

const IVORY = "#EADDD0"
const GOLD = "#8F4546"
const PANEL = "#211519"
static var adult_confirmed: bool = false


func _ready() -> void:
	var music := AudioStreamPlayer.new()
	music.name = "TitleMusic"
	var theme_music := load("res://assets/audio/title_theme.mp3") as AudioStreamMP3
	theme_music.loop = true
	music.stream = theme_music
	music.volume_db = -14.0
	add_child(music)
	tree_exiting.connect(music.stop)
	music.play()
	_style_buttons()
	# Gentle fade-in from black when the screen loads.
	modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.9)
	$Menu/StartButton.grab_focus()
	var warning := Label.new()
	warning.text = "18+ · ADULT GRIMDARK HORROR · BLOOD AND VIOLENCE"
	warning.position = Vector2(390, 985)
	warning.size = Vector2(1140, 40)
	warning.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	warning.add_theme_font_size_override("font_size", 22)
	warning.add_theme_color_override("font_color", Color(IVORY))
	add_child(warning)
	var credits := Label.new()
	credits.text = "Item icons: Lorc, Delapouite & Willdabeast · Game-icons.net · CC BY 3.0"
	credits.position = Vector2(390, 945)
	credits.size = Vector2(1140, 30)
	credits.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credits.add_theme_font_size_override("font_size", 17)
	credits.add_theme_color_override("font_color", Color(IVORY))
	add_child(credits)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_start_pressed() -> void:
	if not adult_confirmed:
		if has_node("AdultConfirmation"):
			return
		var confirmation := ConfirmationDialog.new()
		confirmation.name = "AdultConfirmation"
		confirmation.title = "Ashen Expedition · Adults only"
		confirmation.dialog_text = "This game is intended for adults aged 18 and over.\nIt contains grimdark horror, blood and violence.\nConfirm that you are at least 18 to continue."
		confirmation.ok_button_text = "I am 18 or older"
		confirmation.cancel_button_text = "Return"
		confirmation.confirmed.connect(func():
			adult_confirmed = true
			get_tree().change_scene_to_file(SETTLEMENT_SCENE))
		confirmation.canceled.connect(func(): confirmation.queue_free())
		add_child(confirmation)
		confirmation.popup_centered(Vector2i(720, 220))
		return
	get_tree().change_scene_to_file(SETTLEMENT_SCENE)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _style_buttons() -> void:
	for button_name in ["StartButton", "QuitButton"]:
		var button: Button = $Menu.get_node(button_name)
		for state in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color", "font_focus_color"]:
			button.add_theme_color_override(state, Color(IVORY))
		button.add_theme_stylebox_override("normal", _style(Color(PANEL), Color(GOLD)))
		button.add_theme_stylebox_override("hover", _style(Color("#452029"), Color("#D68177")))
		button.add_theme_stylebox_override("pressed", _style(Color("#5D202D"), Color("#D68177")))
		button.add_theme_stylebox_override("focus", _style(Color("#2A1A20"), Color("#E6A095")))


func _style(fill: Color, outline: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = outline
	box.set_border_width_all(2)
	box.set_corner_radius_all(8)
	box.set_content_margin_all(18)
	return box
