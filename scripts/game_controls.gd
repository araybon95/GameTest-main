extends Node
## Contextual controls live above scenes so the same keys work throughout a journey.
const State = preload("res://scripts/game_data.gd")
const HeroSheet = preload("res://scenes/ui/hero_sheet.gd")
var layer: CanvasLayer
var overlay: Control
var hero_sheet: Control
var current_hero: String = ""
var scene_id: int = 0
var sheet_changed: bool = false

class GuideOrnament extends Control:
	func _draw() -> void:
		var iron := Color("#796A4B")
		var wax := Color("#E6D5AA")
		draw_line(Vector2(0, 60), Vector2(420, 60), iron, 2)
		draw_line(Vector2(460, 60), Vector2(880, 60), iron, 2)
		draw_colored_polygon(PackedVector2Array([Vector2(416, 81), Vector2(423, 65), Vector2(426, 20), Vector2(451, 20), Vector2(454, 68), Vector2(465, 81)]), Color("#0C0B0C"))
		draw_colored_polygon(PackedVector2Array([Vector2(429, 64), Vector2(430, 23), Vector2(437, 27), Vector2(443, 24), Vector2(449, 23), Vector2(449, 64), Vector2(455, 76), Vector2(423, 76)]), wax)
		draw_polyline(PackedVector2Array([Vector2(430, 23), Vector2(431, 42), Vector2(436, 46), Vector2(439, 30), Vector2(445, 42), Vector2(449, 23)]), Color("#5F5948"), 3)
		draw_colored_polygon(PackedVector2Array([Vector2(438, 19), Vector2(430, 10), Vector2(438, -12), Vector2(443, -3), Vector2(446, 10)]), Color("#BF633B"))
		draw_colored_polygon(PackedVector2Array([Vector2(438, 16), Vector2(435, 9), Vector2(439, -3), Vector2(442, 10)]), Color("#F8C976"))

func _ready() -> void:
	layer = CanvasLayer.new()
	layer.name = "ControlsLayer"
	layer.layer = 110
	add_child(layer)
	var help := Button.new()
	help.name = "ControlsButton"
	help.text = "CONTROLS · I"
	help.position = Vector2(1500, 5)
	help.size = Vector2(200, 30)
	help.add_theme_font_size_override("font_size", 15)
	help.tooltip_text = "Open controls for this screen. I to open or close."
	help.pressed.connect(toggle_guide)
	layer.add_child(help)

func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null: return
	if scene_id != scene.get_instance_id():
		scene_id = scene.get_instance_id()
		close_guide()
		close_hero_sheet()

func text_input_focused() -> bool:
	var focus := get_viewport().gui_get_focus_owner()
	return focus is LineEdit or focus is TextEdit

func is_modal_open() -> bool:
	return is_instance_valid(overlay) or is_instance_valid(hero_sheet)

func input_blocked() -> bool:
	var settings := get_node_or_null("/root/GameSettings")
	return is_modal_open() or text_input_focused() or (settings != null and is_instance_valid(settings.overlay))

func context_name() -> String:
	var scene := get_tree().current_scene
	if scene == null: return "GENERAL"
	if scene.has_method("_play_card"): return "COMBAT"
	if scene.scene_file_path.contains("/expedition/preparation."): return "PREPARATION"
	if State.run_active: return "EXPEDITION"
	if scene.scene_file_path.contains("title_screen"): return "TITLE SCREEN"
	return "SETTLEMENT"

func guide_sections() -> Array:
	var sections: Array = [
		["GENERAL", [["I", "Open / close this controls guide"], ["F10", "Sound, brightness and saved journeys"], ["ESC", "Close the current panel or return"]]],
		["HERO DETAILS", [["RIGHT-CLICK", "Inspect a hero portrait or combat card"], ["C", "Open the selected hero's character sheet"], ["Q / E", "Previous / next hero while the sheet is open"]]]
	]
	match context_name():
		"PREPARATION":
			sections.append(["BEFORE YOU EMBARK", [["POSITION · MOVE", "Swap allies freely here. P1 is nearest the enemy; check blocked-skill hints before leaving."], ["PARTY ROLES", "Warden protects P1; Ranger attacks from P2/P3. P2 lets the Occultist use both Drain and Dark Blast."], ["SUPPLIES", "Optional purchases use your gold. Three basic rations are provided even when you cannot buy extras."], ["TRAINING", "Spend earned level points in the Barracks between expeditions. Leveling increases maximum HP without healing current wounds."]]])
			sections.append(["YOUR FIRST EXPEDITION", [["SHARED TURNS", "Each hero has their own AP. Act in any order; selecting another hero does not end the party turn."], ["SCOUT", "Reveal nearby rooms from a cleared room. Hover discovered map icons to inspect encounters and find camps."], ["RECOVERY", "Each camp rests once: full health, debuffs cleared and 90% stress relief for living heroes. Keep Watch prevents the next travel ambush." if State.map_travel_mode else "Each camp rests once: full health, debuffs cleared and 90% stress relief for living heroes. Keep Watch prevents a camp ambush."], ["DESCENT", "Stairs can appear before you earn a level. Explore for XP and equipment before entering the harder keep."]]])
		"EXPEDITION":
			if State.map_travel_mode:
				sections.append(["DUNGEON PROGRESSION", [["ROOM HOVER", "Trace a reachable route and inspect known room details"], ["ROOM CLICK", "Travel automatically; some passages are quiet, others pause for a decision or ambush"], ["EVENT CHOICE", "Choose a living investigator, class skill or supply; then continue the journey"], ["TAB", "Open party inventory; travel pauses while a panel is open"]]])
			else:
				sections.append(["DUNGEON PROGRESSION", [["MAP CLICK", "Choose a connected room or explored route"], ["A / ←", "Walk backward; leave at the starting door"], ["D / →", "Walk forward toward the destination"], ["W / E / ENTER", "Enter the room or encounter when reached"], ["SPACE", "Toggle automatic walking"], ["TAB", "Alternate the map / hallway and party inventory"]]])
			sections.append(["EXPLORATION AND RECOVERY", [["SCOUT", "From a cleared room, reveal nearby rooms. Hover map icons for encounter details; detour to discovered camps when wounded."], ["CAMP", "Rest once per camp to heal living heroes, clear debuffs and relieve 90% of stress. Keep Watch prevents an ambush."], ["STAIRS", "Stay to explore before descending. The descent screen lists discovered unused camps and warns about unprepared heroes."], ["RETREAT", "Return with earned inventory and surviving heroes. Spend level points in the Barracks before the next departure."]]])
		"COMBAT":
			sections.append(["SHARED PARTY TURN", [["1–5", "Select and preview a skill for the active hero"], ["ENEMY CLICK", "Choose an enemy target"], ["ENTER", "Use the selected skill if available"], ["HERO CLICK", "Change the active hero"], ["LOOT", "Victory rewards are collected automatically"]]])
			sections.append(["JOURNEY HUD", [["TAB", "Alternate the dungeon map and battle log"], ["ITEMS", "Inspect party inventory; use consumables in the combat strip"]]])
			sections.append(["TACTICS", [["AP", "Each hero spends their own AP. Switch heroes freely and read skill availability before acting."], ["END PARTY TURN", "Lets enemies act and starts the next party turn. Use remaining AP for attacks, protection or recovery first."], ["POSITION", "Movement swaps allies and normally costs 1 AP. Equipment can change the cost; formation controls show it."], ["BOSS OBJECTIVES", "Read enemy intents and battlefield props. The Undying Lord heals while its support lives; defeat the attendant first."]]])
		"SETTLEMENT":
			sections.append(["SETTLEMENT", [["BUILDING CLICK", "Enter a building or choose an expedition"], ["HERO CLICK", "Choose a party slot / roster hero in the Barracks"], ["ESC", "Return from a building to the settlement"]]])
		_:
			sections.append(["BEGIN A JOURNEY", [["MOUSE", "Choose a menu option"], ["CONTINUE", "Load a saved party and expedition"]]])
	return sections

func toggle_guide() -> void:
	if is_instance_valid(overlay): close_guide()
	else: open_guide()

func open_guide() -> void:
	if is_instance_valid(overlay): return
	close_hero_sheet()
	var settings := get_node_or_null("/root/GameSettings")
	if settings != null: settings.close_settings()
	remember_scene()
	overlay = Control.new()
	overlay.name = "ControlsGuide"
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(overlay)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.82)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(shade)
	var panel := Panel.new()
	panel.position = Vector2(260, 72)
	panel.size = Vector2(1400, 945)
	panel.add_theme_stylebox_override("panel", frame(Color("#0C0B0B"), Color("#7C725B"), 3))
	overlay.add_child(panel)
	var inner := Panel.new()
	inner.position = Vector2(18, 18)
	inner.size = Vector2(1364, 909)
	inner.add_theme_stylebox_override("panel", frame(Color("#0C0B0B"), Color("#373630"), 2))
	inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(inner)
	var ornament := GuideOrnament.new()
	ornament.position = Vector2(260, 8)
	ornament.size = Vector2(880, 90)
	ornament.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(ornament)
	var title := label("CONTROLS · " + context_name(), 31, Color("#D9C991"))
	title.position = Vector2(65, 108)
	title.size = Vector2(1260, 44)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(title)
	var close := Button.new()
	close.name = "CloseControls"
	close.text = "×"
	close.position = Vector2(1310, 25)
	close.size = Vector2(64, 60)
	close.add_theme_font_size_override("font_size", 44)
	close.add_theme_color_override("font_color", Color("#EC5652"))
	close.add_theme_stylebox_override("normal", frame(Color("#1B1113"), Color("#7C403C"), 2))
	close.pressed.connect(close_guide)
	panel.add_child(close)
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(170, 168)
	scroll.size = Vector2(1060, 665)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel.add_child(scroll)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 6)
	scroll.add_child(list)
	for section in guide_sections():
		var heading := label(str(section[0]), 25, Color("#D9C991"))
		heading.custom_minimum_size = Vector2(0, 38)
		list.add_child(heading)
		for entry in section[1]:
			var row := HBoxContainer.new()
			row.add_theme_constant_override("separation", 20)
			row.custom_minimum_size = Vector2(0, 32)
			list.add_child(row)
			var key := label(str(entry[0]), 21, Color("#EADDB9"))
			key.custom_minimum_size = Vector2(205, 32)
			row.add_child(key)
			var description := label(str(entry[1]), 21, Color("#CBC6B9"))
			description.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			row.add_child(description)
		var gap := Control.new()
		gap.custom_minimum_size = Vector2(0, 8)
		list.add_child(gap)
	var note := label("Movement stops while a panel is open.", 20, Color("#AE9B7D"))
	note.position = Vector2(130, 855)
	note.size = Vector2(1140, 40)
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(note)
	overlay.set_meta("grimdark_scope",true)
	get_node("/root/GothicPresentation").decorate(overlay)
	close.grab_focus()

func close_guide() -> void:
	if is_instance_valid(overlay):
		overlay.hide()
		overlay.queue_free()
	overlay = null

func remember_scene() -> void:
	if get_tree().current_scene != null: scene_id = get_tree().current_scene.get_instance_id()

func selected_hero_id() -> String:
	var scene := get_tree().current_scene
	if scene != null:
		for property in scene.get_property_list():
			if property.name in ["selected_hero", "chosen", "training_hero"]:
				var selected := str(scene.get(property.name))
				if State.HEROES.has(selected): return selected
			if property.name == "_selected_slot":
				var slot: int = int(scene.get("_selected_slot"))
				if slot >= 0 and slot < State.party.size(): return str(State.party[slot])
	if State.HEROES.has(current_hero) and State.party.has(current_hero): return current_hero
	return str(State.party[0]) if not State.party.is_empty() else "warden"

func open_hero_sheet(hero_id: String = "", inventory: bool = false) -> void:
	if hero_id.is_empty(): hero_id = selected_hero_id()
	if not State.HEROES.has(hero_id): return
	close_guide()
	close_hero_sheet()
	var settings := get_node_or_null("/root/GameSettings")
	if settings != null: settings.close_settings()
	remember_scene()
	current_hero = hero_id
	sheet_changed = false
	hero_sheet = HeroSheet.new()
	hero_sheet.name = "HeroSheet"
	hero_sheet.hero_id = hero_id
	hero_sheet.inventory_mode = inventory
	hero_sheet.closed.connect(close_hero_sheet)
	hero_sheet.hero_changed.connect(func(id: String): current_hero = id)
	hero_sheet.inventory_changed.connect(func(): sheet_changed = true)
	layer.add_child(hero_sheet)

func close_hero_sheet() -> void:
	if is_instance_valid(hero_sheet):
		hero_sheet.hide()
		hero_sheet.queue_free()
	hero_sheet = null
	if sheet_changed:
		sheet_changed = false
		var scene := get_tree().current_scene
		if scene != null and scene.has_method("refresh"):
			var traveling: bool = false
			for property in scene.get_property_list():
				if property.name == "traveling": traveling = bool(scene.get("traveling"))
			if not traveling: scene.call_deferred("refresh")

func hero_from_control(control: Control) -> String:
	var node: Node = control
	while node != null and node != get_tree().current_scene:
		var id := str(node.get_meta("hero_id", ""))
		if State.HEROES.has(id): return id
		for hero_id in State.HEROES:
			if str(node.name) in ["Hero_" + hero_id, "Party_" + hero_id, "Camper_" + hero_id, "Walker_" + hero_id]: return str(hero_id)
		if node is TextureRect and node.texture != null:
			var path: String = node.texture.resource_path
			for hero_id in State.HEROES:
				if path.contains("hero_" + hero_id): return str(hero_id)
		if node is Button:
			for picture in node.find_children("*", "TextureRect", true, false):
				if picture.texture == null: continue
				for hero_id in State.HEROES:
					if picture.texture.resource_path.contains("hero_" + hero_id): return str(hero_id)
		node = node.get_parent()
	return ""

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if input_blocked(): return
		var hovered := get_viewport().gui_get_hovered_control()
		if hovered == null: return
		var id := hero_from_control(hovered)
		if not id.is_empty():
			open_hero_sheet(id)
			get_viewport().set_input_as_handled()
		return
	if not event is InputEventKey or not event.pressed or event.echo or text_input_focused(): return
	if event.ctrl_pressed or event.alt_pressed or event.meta_pressed: return
	# Settings owns F10 and closes these panels when it opens.
	if event.keycode == KEY_F10: return
	if event.keycode == KEY_I:
		toggle_guide()
		get_viewport().set_input_as_handled()
		return
	if is_instance_valid(overlay):
		if event.keycode == KEY_ESCAPE: close_guide()
		get_viewport().set_input_as_handled()
		return
	if is_instance_valid(hero_sheet):
		if hero_sheet.has_node("EquipmentComparison"):
			if event.keycode == KEY_ESCAPE:
				hero_sheet.get_node("EquipmentComparison").dismiss()
			if event.keycode in [KEY_ESCAPE,KEY_C,KEY_Q,KEY_E,KEY_TAB]: get_viewport().set_input_as_handled()
			return
		match event.keycode:
			KEY_ESCAPE, KEY_C: close_hero_sheet()
			KEY_Q: hero_sheet.cycle_hero(-1)
			KEY_E: hero_sheet.cycle_hero(1)
			KEY_TAB:
				if hero_sheet.inventory_mode: close_hero_sheet()
				else: hero_sheet.show_inventory()
		get_viewport().set_input_as_handled()
		return
	if input_blocked(): return
	if event.keycode == KEY_C:
		open_hero_sheet()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_TAB and State.run_active and context_name() != "COMBAT":
		open_hero_sheet("", true)
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_TAB and context_name() == "COMBAT":
		var scene := get_tree().current_scene
		if scene.has_method("toggle_journey_panel"):
			scene.toggle_journey_panel()
			get_viewport().set_input_as_handled()

func frame(fill: Color, border: Color, width: int = 2) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(width)
	box.shadow_color = Color(0, 0, 0, 0.65)
	box.shadow_size = 10
	return box

func label(value: String, font_size: int, color: Color) -> Label:
	var result := Label.new()
	result.text = value
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result.add_theme_font_size_override("font_size", font_size)
	result.add_theme_color_override("font_color", color)
	return result
