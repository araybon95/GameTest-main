extends "res://scenes/ui/party_screen.gd"

func _ready() -> void:
	refresh()

func refresh() -> void:
	clear_screen()
	var expedition: Dictionary = State.selected_expedition
	var art := picture(str(expedition.get("combat_background", "res://assets/generated/bandit_combat.png")), Rect2(0, 0, 1920, 1080), 0.4)
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel(Rect2(40, 35, 1840, 750), Color(0.07, 0.05, 0.07, 0.94))
	label_at("PREPARE · " + str(expedition.get("name", "Expedition")).to_upper(), Vector2(75, 60), 1780, 35)
	label_at("Formation: front draws melee attacks and gains 2 Block each new party turn. Ranged enemies can reach the rear.", Vector2(75, 115), 1780, 23)
	var warning: String = "Bandits cause Bleed and Poison. Deeper keep guards can pull rear heroes forward."
	if expedition.get("faction", "") == "remade":
		warning = "The remade use Burn, Bleed, Poison and stressful hymns. The Coterie has three consecutive forms."
	elif expedition.get("faction", "") == "moth":
		warning = "Moths cause Bleed and Poison. Oleander guards then exposes himself; Exuvia's cocoons must be destroyed before hatching."
	label_at("SCOUT REPORT: " + warning, Vector2(75, 165), 1760, 22).size = Vector2(1760, 70)
	for index in range(State.party.size()):
		var id: String = State.party[index]
		var x: float = 125 + index * 570
		panel(Rect2(x, 245, 530, 295))
		picture(str(State.hero(id)["art"]), Rect2(x + 20, 260, 180, 235))
		label_at(str(State.hero(id)["name"]).to_upper(), Vector2(x + 210, 270), 300, 25)
		label_at(role_description(id), Vector2(x + 210, 320), 280, 20).size = Vector2(280, 125)
		var toggle := button_at(State.rank_of(id).to_upper() + " · CHANGE", Rect2(x + 210, 470, 285, 50), toggle_rank.bind(id))
		toggle.add_theme_font_size_override("font_size", 20)
	label_at("OPTIONAL SUPPLIES · GOLD %d · Stock carries into the expedition" % State.gold, Vector2(75, 575), 1760, 24)
	var supplies: Array = ["bandage", "antidote", "calming_incense", "healing_potion"]
	for index in range(supplies.size()):
		var id: String = supplies[index]
		var item: Dictionary = State.Items.item(id)
		var buy := button_at("%s · %d GOLD\nOwned %d" % [item["name"], State.item_price(id), int(State.inventory.get(id, 0))], Rect2(75 + index * 440, 625, 420, 85), buy_supply.bind(id))
		buy.add_theme_font_size_override("font_size", 21)
		buy.disabled = State.gold < State.item_price(id)
		buy.tooltip_text = State.Items.description(id)
	button_at("EMBARK WITH THIS PARTY", Rect2(1050, 725, 760, 45), embark).add_theme_font_size_override("font_size", 21)
	party_bar(return_to_hamlet, "RETURN TO HAMLET")

func role_description(id: String) -> String:
	return {"warden": "Exploits marked targets: +2 damage. Protect the front.", "ranger": "+1 skill damage from the rear. Mark targets for the Warden.", "occultist": "Damaging skills inflict Poison. Stack pressure with the party.", "crusader": "+2 damage against bleeding foes. Charge to create Bleed.", "healer": "Party healing also removes Bleed. Keep allies fighting."}.get(id, "Shared party turns allow heroes to act in any order.")

func toggle_rank(id: String) -> void:
	State.formation[id] = "rear" if State.rank_of(id) == "front" else "front"
	if not State.party.any(func(hero): return State.rank_of(str(hero)) == "front"):
		State.formation[id] = "front"
	refresh()

func buy_supply(id: String) -> void:
	if State.purchase_item(id):
		refresh()

func embark() -> void:
	State.start_run()
	get_tree().change_scene_to_file("res://scenes/combat/combatscene.tscn" if State.selected_expedition.get("internal", false) else "res://scenes/expedition/dungeon.tscn")

func return_to_hamlet() -> void:
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		return_to_hamlet()
