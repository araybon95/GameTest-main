extends "res://scenes/hub/item_shop.gd"

func _ready() -> void:
	State.load_progression()
	State.shop_return_scene = "res://scenes/hub/settlement.tscn"
	if State.apothecary_unlocked():
		apothecary_mode = true
		refresh()
	else:
		show_infestation()

func show_infestation() -> void:
	clear_screen()
	var art := picture("res://assets/generated/apothecary_interior.png", Rect2(0, 0, 1920, 1080), 0.55)
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel(Rect2(70, 55, 1780, 980), Color(0.07, 0.05, 0.07, 0.88))
	label_at("THE INFESTED APOTHECARY", Vector2(110, 85), 1660, 42)
	label_at("Initiate difficulty · Between Apprentice and Adept · Four rooms", Vector2(110, 150), 1600, 25)
	label_at("A luminous infestation has claimed the medical ward. Defeat its three guardians to restore the apothecary permanently.\nA one-use camp after the first fight restores all health, clears debuffs and reduces stress by 90%.", Vector2(110, 200), 1660, 24)
	var foes: Array = ["moth_metamorph", "moth_oleander", "moth_exuvia"]
	for index in range(3):
		var x: float = 145 + index * 565
		panel(Rect2(x, 320, 510, 435))
		picture(str(State.creature(foes[index])["art"]), Rect2(x + 35, 330, 440, 300))
		label_at(str(State.creature(foes[index])["name"]), Vector2(x + 25, 650), 460, 25)
		label_at(["Room 1 · Three weakened metamorphs", "Room 3 · Mini boss", "Room 4 · Final boss"][index], Vector2(x + 25, 705), 460, 21)
	label_at("Room 2: the sealed sickroom camp. Clear all three fights to unlock healing remedies and buff tonics for gold.", Vector2(110, 785), 1660, 24)
	button_at("ENTER THE INFESTED WARD", Rect2(170, 890, 720, 75), enter_ward)
	button_at("RETURN TO HAMLET", Rect2(1030, 890, 720, 75), return_to_party)

func enter_ward() -> void:
	if State.select_expedition("infested_apothecary"):
		get_tree().change_scene_to_file("res://scenes/expedition/preparation.tscn")
