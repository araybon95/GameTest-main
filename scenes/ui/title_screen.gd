extends Control
## Ashen Expedition — title screen.
## BEGIN loads the combat scene; QUIT exits. Intended to be the Main Scene.

const SETTLEMENT_SCENE = "res://scenes/hub/settlement.tscn"

const IVORY = "#EADDD0"
const GOLD = "#8F4546"
const PANEL = "#211519"


func _ready() -> void:
	_style_buttons()
	# Gentle fade-in from black when the screen loads.
	modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.9)
	$Menu/StartButton.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_start_pressed() -> void:
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
