extends Control
## Shared character record, with equipment and a separate party inventory tab.
signal closed
signal hero_changed(hero_id: String)
signal inventory_changed
const State = preload("res://scripts/game_data.gd")
const ItemButton = preload("res://scenes/ui/item_icon_button.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
var hero_id: String = "warden"
var inventory_mode: bool = false
var inventory_filter: String = "All"
var status_text: String = ""

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	refresh()

func combat_open() -> bool:
	var scene := get_tree().current_scene
	return scene != null and scene.has_method("_play_card")

func hero_state() -> Dictionary:
	if combat_open(): return get_tree().current_scene.hero_state.get(hero_id, {})
	return State.run_heroes.get(hero_id, {}) if State.run_active else {}

func available_heroes() -> Array:
	var scene := get_tree().current_scene
	if State.run_active or combat_open(): return State.party.duplicate()
	if scene != null and scene.scene_file_path.contains("barracks"):
		var roster: Array = State.HEROES.keys()
		if not State.crusader_unlocked: roster.erase("crusader")
		return roster
	return State.party.duplicate()

func cycle_hero(direction: int) -> void:
	var heroes := available_heroes()
	if heroes.is_empty(): return
	select_hero(str(heroes[posmod(heroes.find(hero_id) + direction, heroes.size())]))

func select_hero(id: String) -> void:
	if not State.HEROES.has(id): return
	hero_id = id
	status_text = ""
	hero_changed.emit(id)
	refresh()

func show_inventory() -> void:
	switch_mode(true)

func refresh() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.84)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	panel(Rect2(85, 65, 1750, 950), Color("#0C0B0C"), Color("#8E7954"))
	panel(Rect2(102, 82, 1716, 916), Color("#0C0B0C"), Color("#38332A"))
	var hero: Dictionary = State.hero(hero_id)
	var state: Dictionary = hero_state()
	var progress: Dictionary = State.leveling(hero_id)
	label_at(str(hero["name"]), Vector2(140, 98), 750, 40, Color("#F0DCAC"))
	label_at("%s · Level %d  ·  %d / %d XP" % [hero["class"], progress["level"], progress["xp"], State.xp_required(progress["level"])], Vector2(143, 148), 850, 23, Color("#BDA989"))
	button("‹", Rect2(903, 103, 60, 56), cycle_hero.bind(-1))
	button("›", Rect2(973, 103, 60, 56), cycle_hero.bind(1))
	label_at("PARTY INVENTORY" if inventory_mode else "CHARACTER RECORD", Vector2(1140, 118), 580, 29, Color("#D7C392"))
	button("×", Rect2(1740, 98, 62, 58), func(): closed.emit())
	panel(Rect2(130, 189, 1650, 2), Color("#7F6B48"), Color("#7F6B48"))
	build_equipment()
	build_portrait(hero, state)
	if inventory_mode: build_inventory()
	else: build_character(hero, state)
	var character_tab := button("CHARACTER", Rect2(135, 904, 210, 48), switch_mode.bind(false))
	character_tab.disabled = not inventory_mode
	var inventory_tab := button("INVENTORY", Rect2(355, 904, 210, 48), switch_mode.bind(true))
	inventory_tab.disabled = inventory_mode
	label_at("Q / E · Previous / next hero     C / Esc · Close", Vector2(610, 914), 900, 21, Color("#C9B28A"))
	button("RETURN", Rect2(1590, 899, 190, 54), func(): closed.emit())
	var heroes := available_heroes()
	for index in range(heroes.size()):
		var id: String = str(heroes[index])
		var switch := button(("▶ " if id == hero_id else "") + str(State.hero(id)["name"]), Rect2(135 + index * 325, 962, 313, 34), select_hero.bind(id))
		switch.add_theme_font_size_override("font_size", 17)
		switch.set_meta("hero_id", id)
		preload("res://scripts/visual_overlays.gd").frame(switch, id)

	set_meta("grimdark_scope",true)
	get_node("/root/GothicPresentation").decorate(self)

func build_equipment() -> void:
	band("EQUIPMENT", Rect2(135, 211, 190, 35), 20)
	for index in range(State.Items.SLOTS.size()):
		var slot: String = State.Items.SLOTS[index]
		var item_id: String = str(State.equipment.get(hero_id, {}).get(slot, ""))
		var icon = ItemButton.new()
		icon.name = "Equipment_" + slot
		icon.configure(item_id,1,"",slot)
		icon.favourite_changed.connect(refresh)
		icon.position = Vector2(145 + (index % 2) * 89, 269 + (index / 2) * 101)
		icon.custom_minimum_size = Vector2(74, 74)
		icon.size = Vector2(74, 74)
		icon.disabled = item_id.is_empty() or combat_open() or not State.party.has(hero_id)
		icon.pressed.connect(remove_equipment.bind(slot))
		add_child(icon)
		label_at(slot.replace("_", " ").capitalize(), icon.position + Vector2(-3, 76), 88, 14, Color("#BAAA89"))
	band("BASE STATS", Rect2(135, 590, 190, 35), 20)
	label_at("Max HP  %d\nDamage  +%d\nMight  +%d%%\nBlock  +%d\nHealing  +%d\nAccuracy  %d%%\nTraining  %d" % [State.hero_max_hp(hero_id), State.hero_bonus(hero_id, "damage"), State.hero_bonus(hero_id, "damage_percent"), State.hero_bonus(hero_id, "block"), State.hero_bonus(hero_id, "heal"), State.hero_accuracy(hero_id, hero_state()), State.leveling(hero_id)["points"]], Vector2(148, 641), 180, 18)
	var inscribe := button("NAME EQUIPMENT", Rect2(135, 841, 190, 45), inscribe_item)
	inscribe.add_theme_font_size_override("font_size",18)
	inscribe.disabled = combat_open() or State.equipment.get(hero_id, {}).is_empty() or hero_state().get("dead", false)

func inscribe_item() -> void:
	if combat_open() or hero_state().get("dead", false): return
	var loadout: Dictionary = State.equipment.get(hero_id, {})
	if loadout.is_empty(): return
	var dialog := ConfirmationDialog.new()
	dialog.title = "Name a cherished item"
	dialog.ok_button_text = "Inscribe"
	dialog.add_theme_stylebox_override("panel", frame(Color("#110D0F"),Color("#A58C5C")))
	dialog.add_theme_color_override("title_color",Color("#EAD5A3"))
	var column := VBoxContainer.new()
	var slots := OptionButton.new()
	slots.name = "KeepsakeSlot"
	for slot in loadout:
		slots.add_item(str(slot).capitalize() + " · " + str(State.Items.item(loadout[slot]).name))
		slots.set_item_metadata(slots.item_count - 1, slot)
	var field := LineEdit.new()
	field.name = "KeepsakeName"
	field.max_length = 32
	field.placeholder_text = "Leave blank to restore the original name"
	field.add_theme_stylebox_override("normal",frame(Color("#21171B"),Color("#705439")))
	field.add_theme_color_override("font_color",Color("#FFF0D4"))
	for control in [slots,dialog.get_ok_button(),dialog.get_cancel_button()]:
		control.add_theme_stylebox_override("normal",frame(Color("#27191B"),Color("#927747")))
		control.add_theme_stylebox_override("hover",frame(Color("#45302C"),Color("#E8C88D")))
		control.add_theme_color_override("font_color",Color("#EAD5A3"))
	column.add_child(slots)
	column.add_child(field)
	var hint := Label.new()
	hint.text = "The item keeps its original type, rarity and effects."
	column.add_child(hint)
	dialog.add_child(column)
	add_child(dialog)
	var select_name := func(_index: int):
		var id: String = str(loadout[slots.get_item_metadata(slots.selected)])
		field.text = str(State.Items.histories.get(id, {}).get("name", ""))
	slots.item_selected.connect(select_name)
	select_name.call(0)
	dialog.confirmed.connect(func():
		if State.ItemStories.name_item(State,hero_id,str(slots.get_item_metadata(slots.selected)),field.text):
			State._save_economy()
			status_text = "Equipment inscription saved."
			inventory_changed.emit()
		dialog.queue_free()
		refresh())
	dialog.canceled.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(620, 180))

func build_portrait(hero: Dictionary, state: Dictionary) -> void:
	panel(Rect2(350, 211, 390, 620), Color("#171718"), Color("#5D513A"))
	var stage := TextureRect.new()
	stage.name = "HeroBackdrop"
	stage.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stage.texture = load(hero_backdrop_path(hero_id))
	stage.position = Vector2(352, 213)
	stage.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	stage.size = Vector2(386, 616)
	stage.modulate = Color(0.48, 0.44, 0.43)
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)
	var portrait := TextureRect.new()
	portrait.name = "SheetPortrait"
	portrait.texture = Scenery.grounded_texture(str(hero.get("portrait_art",hero["art"])))
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.position = Vector2(359, 236)
	portrait.size = Vector2(373, 516)
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(portrait)
	Scenery.apply_hero_palette(portrait, hero_id, str(State.hero_colors.get(hero_id, "original")))
	label_at("%d / %d HP    ·    %d Stress" % [int(state.get("hp", State.hero_max_hp(hero_id))), State.hero_max_hp(hero_id), int(state.get("stress", 0))], Vector2(372, 762), 350, 22, Color("#E7CD9D"))
	var condition: String = "SLAIN" if state.get("dead", false) else Rules.status_text(state.get("statuses", {}))
	var conditions := label_at(condition, Vector2(370, 798), 350, 17, Color("#E89683"))
	conditions.clip_text = true
	conditions.size.y = 29

static func hero_backdrop_path(id: String) -> String:
	var backdrops: Dictionary = {
		"warden":"keep_hall.png",
		"ranger":"hallway_bandit_panorama.png",
		"occultist":"beast_sanctuary.png",
		"healer":"apothecary_reclaimed.png",
		"crusader":"bg_crypt.png"
	}
	return "res://assets/art_library/generated/" + str(backdrops.get(id,"keep_hall.png"))

func build_character(hero: Dictionary, state: Dictionary) -> void:
	band("LORE", Rect2(780, 211, 325, 35))
	var lore: String = str(hero.get("lore", ""))
	if lore.is_empty():
		lore = {"warden": "Sworn to hold the road when every wall has fallen. The Warden carries the weight of those who could not stand again.", "ranger": "Beyond the ruined fields, a patient hunter tracks the things that have learned to wear human fear.", "occultist": "Forbidden names answer from the dark. Each invocation buys a moment of power at a price no ledger can contain.", "healer": "Mercy endures beneath ash and blood. The healer's rites offer a fragile shelter against the terrors of the road."}.get(hero_id, "The record of this wanderer is yet to be written.")
	var lore_scroll := ScrollContainer.new()
	lore_scroll.position = Vector2(785, 265)
	lore_scroll.size = Vector2(313, 270)
	lore_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(lore_scroll)
	var lore_label := Label.new()
	lore_label.text = lore+"\n\n"+State.Stories.biography(State,hero_id)
	lore_label.add_theme_font_size_override("font_size", 21)
	lore_label.add_theme_color_override("font_color", Color("#CABB9F"))
	lore_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lore_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lore_scroll.add_child(lore_label)
	band("DEEDS & CONDITION", Rect2(780, 560, 325, 35), 21)
	var deeds: Dictionary = State.run_deeds.get(hero_id, {})
	label_at("Battles survived  %d\nDamage dealt  %d\nHealing given  %d\n\nFormation  %s\n%s" % [int(deeds.get("battles", 0)), int(deeds.get("damage", 0)), int(deeds.get("healing", 0)), State.rank_of(hero_id).capitalize(), State.buff_text(state)], Vector2(791, 614), 310, 21, Color("#D9C8A5"))
	band("COMBAT SKILLS", Rect2(1145, 211, 630, 35))
	var abilities: Array = State.hero_abilities(hero_id)
	for index in range(abilities.size()):
		var ability_id: String = str(abilities[index])
		var ability: Dictionary = State.card_stats(ability_id)
		var pos := Vector2(1148 + (index % 3) * 213, 266 + (index / 3) * (91 if abilities.size() > 6 else 134))
		panel(Rect2(pos, Vector2(202, 84 if abilities.size() > 6 else 119)), Color("#191314"), Color("#594932"))
		var art := TextureRect.new()
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		var path := preload("res://scripts/painted_skill_art.gd").path_for(str(ability_id))
		if not ResourceLoader.exists(path): path = "res://assets/art_library/generated/%s.png" % ability_id
		if ResourceLoader.exists(path): art.texture = load(path)
		art.position = pos + Vector2(8, 9)
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		art.size = Vector2(62, 62)
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(art)
		var title := label_at(str(ability["name"]), pos + Vector2(77, 7), 118, 16, Color("#EDCF9B"))
		title.clip_text = true
		title.size.y = 51
		label_at("%d AP · CD %d" % [int(ability["cost"]), State.ability_cooldown(ability_id)], pos + Vector2(77, 60), 118, 14)
		var effects := label_at(State.card_description(ability), pos + Vector2(8, 82), 184, 14, Color("#BFAE90"))
		effects.clip_text = true
		effects.size.y = 31
		effects.visible = abilities.size() <= 6
		var hover := Control.new()
		hover.position = pos
		hover.size = Vector2(202, 84 if abilities.size() > 6 else 119)
		hover.tooltip_text = str(ability["name"]) + "\n" + State.card_description(ability) + "\n" + State.Depth.rank_text(ability_id)
		hover.mouse_filter = Control.MOUSE_FILTER_STOP
		add_child(hover)
	band("CAMPING SKILLS", Rect2(1145, 551, 630, 35))
	var choices: Array = State.Depth.CAMP_CHOICES.keys()
	for index in range(choices.size()):
		var choice: Dictionary = State.Depth.CAMP_CHOICES[choices[index]]
		var skill := preload("res://scenes/ui/camp_action_card.gd").new()
		skill.position = Vector2(1148+(index%2)*318,606+(index/2)*54)
		skill.size = Vector2(310,50)
		skill.configure(str(choices[index]),choice,false,3,false,true)
		add_child(skill)
	band("RESISTANCES", Rect2(1145, 723, 630, 35))
	label_at("Bleed  %d%%\nPoison  %d%%" % [mini(100, State.equipment_bonus(hero_id, "bleed_resist") + State.hero_bonus(hero_id, "debuff_resist")), mini(100, State.equipment_bonus(hero_id, "poison_resist") + State.hero_bonus(hero_id, "debuff_resist"))], Vector2(1163, 782), 280, 21)
	label_at("Debuffs  %d%%\nMaximum health  +%d%%" % [State.hero_bonus(hero_id, "debuff_resist"), State.equipment_bonus(hero_id, "max_hp_percent")], Vector2(1463, 782), 300, 21)
	label_at("Equipment and restorative items are on the Inventory tab.", Vector2(780, 855), 995, 17, Color("#9F9076"))

func build_inventory() -> void:
	band("PARTY INVENTORY · GOLD %d" % State.gold, Rect2(780, 211, 995, 35))
	label_at("Read only in combat · Use consumables from the combat bar" if combat_open() else "Select gear to equip · Click a slot to remove · Select a restorative item to use", Vector2(785, 264), 980, 19, Color("#BBAA8E"))
	var filters: Array = ["All", "Weapons", "Armor", "Trinkets", "Usable"]
	for index in range(filters.size()):
		var category: String = filters[index]
		var filter := button(("• " if inventory_filter == category else "") + category, Rect2(785 + index * 193, 306, 184, 43), filter_items.bind(category))
		filter.add_theme_font_size_override("font_size", 19)
	panel(Rect2(780, 365, 995, 330), Color("#060606"), Color("#544A35"))
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(795, 380)
	scroll.size = Vector2(965, 300)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 11
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	scroll.add_child(grid)
	for item_id in State.inventory:
		var item: Dictionary = State.Items.item(item_id)
		var category: String = "Usable" if item.get("kind", "") in ["scroll", "potion", "provision"] else "Trinkets" if item.get("kind", "") == "trinket" else "Weapons" if item.get("slot", "") == "weapon" else "Armor" if item.get("slot", "") in ["armor", "head"] else "Other"
		if inventory_filter != "All" and category != inventory_filter: continue
		var icon = ItemButton.new()
		icon.name = "Inventory_" + str(item_id)
		icon.configure(str(item_id), int(State.inventory[item_id]),hero_id)
		icon.favourite_changed.connect(refresh)
		icon.pressed.connect(choose_item.bind(str(item_id)))
		grid.add_child(icon)
	if grid.get_child_count() == 0:
		var empty := Label.new()
		empty.text = "No items in this category."
		grid.add_child(empty)
	band("ITEM DETAILS", Rect2(780, 723, 995, 35))
	var details := label_at(status_text if not status_text.is_empty() else "Hover to read effects and history. Name equipped gear with NAME EQUIPMENT. Consumables stack; cherished equipment keeps its own history.", Vector2(794, 783), 965, 20, Color("#E4CC9F"))
	details.clip_text = true
	details.size.y = 88

func switch_mode(inventory: bool) -> void:
	inventory_mode = inventory
	refresh()

func band(value: String, rect: Rect2, font_size: int = 23) -> void:
	panel(rect, Color("#351719"), Color("#705439"))
	label_at(value, rect.position + Vector2(9, 3), rect.size.x - 18, font_size, Color("#DEC795"))

func filter_items(category: String) -> void:
	inventory_filter = category
	refresh()

func choose_item(item_id: String) -> void:
	var item: Dictionary = State.Items.item(item_id)
	if combat_open():
		status_text = "Equipment cannot change in combat. Use potions and scrolls from the combat bar."
	elif not State.party.has(hero_id):
		status_text = "Assign this hero to the party in the Barracks before equipping items."
	elif State.is_restorative(item_id):
		if State.run_active and State.apply_potion(hero_id, item_id, State.run_heroes):
			status_text = str(item["name"]) + " used."
			inventory_changed.emit()
		else: status_text = "Restorative items can be used on a living hero during an expedition."
	elif item.has("slot"):
		show_equipment_comparison(item_id)
		return
	else:
		status_text = State.Items.tooltip(item_id)
	refresh()

func show_equipment_comparison(item_id: String) -> void:
	if has_node("EquipmentComparison"): return
	var comparison = preload("res://scenes/ui/equipment_compare.gd").new()
	comparison.hero_id = hero_id
	comparison.item_id = item_id
	comparison.equip_requested.connect(confirm_equipment.bind(item_id))
	add_child(comparison)

func confirm_equipment(item_id: String) -> void:
	if combat_open() or not State.party.has(hero_id): return
	if State.equip_item(hero_id,item_id):
		status_text = str(State.Items.item(item_id).name) + " equipped."
		var reaction: String = State.ItemStories.equipped_line(State,hero_id,item_id)
		if not reaction.is_empty(): status_text += " " + reaction
		inventory_changed.emit()
	else: status_text = "This item belongs to another class or is no longer available."
	refresh()

func remove_equipment(slot: String) -> void:
	if combat_open() or not State.party.has(hero_id): return
	State.unequip_item(hero_id, slot)
	inventory_changed.emit()
	status_text = slot.replace("_", " ").capitalize() + " removed."
	refresh()

func panel(rect: Rect2, fill: Color, border: Color) -> void:
	var result := Panel.new()
	result.position = rect.position
	result.size = rect.size
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result.add_theme_stylebox_override("panel", frame(fill, border))
	add_child(result)
	if rect.size.y > 80: preload("res://scripts/visual_overlays.gd").frame(result, hero_id)

func frame(fill: Color, border: Color) -> StyleBoxFlat:
	return preload("res://scripts/ui_skin.gd").frame(fill,border)

func label_at(value: String, position: Vector2, width: float, font_size: int, color: Color = Color("#EADFC7")) -> Label:
	var result := Label.new()
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result.text = value
	result.position = position
	result.size = Vector2(width, 0)
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result.add_theme_font_size_override("font_size", font_size)
	result.add_theme_color_override("font_color", color)
	add_child(result)
	return result

func button(value: String, rect: Rect2, action: Callable) -> Button:
	var result := Button.new()
	result.text = value
	result.position = rect.position
	result.size = rect.size
	result.add_theme_font_size_override("font_size", 21)
	result.add_theme_color_override("font_color", Color("#F1DFC0"))
	result.add_theme_stylebox_override("normal", frame(Color("#23191A"), Color("#806749")))
	result.add_theme_stylebox_override("hover", frame(Color("#402A24"), Color("#DAC294")))
	result.add_theme_stylebox_override("disabled", frame(Color("#3A2520"), Color("#B19A6B")))
	result.add_theme_color_override("font_disabled_color", Color("#D6C59E"))
	result.pressed.connect(action)
	add_child(result)
	preload("res://scripts/visual_overlays.gd").frame(result, hero_id)
	return result
