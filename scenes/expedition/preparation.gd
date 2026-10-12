extends "res://scenes/ui/party_screen.gd"
const Readiness = preload("res://scripts/expedition_readiness.gd")
var departing: bool = false

func _ready() -> void:
	refresh()

func refresh() -> void:
	clear_screen()
	var expedition: Dictionary = State.selected_expedition
	var art := picture(str(expedition.get("combat_background", "res://assets/generated/bandit_combat.png")), Rect2(0, 0, 1920, 1080), 0.4)
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel(Rect2(40, 35, 1840, 770), Color(0.07, 0.05, 0.07, 0.94))
	label_at("PREPARE · " + str(expedition.get("name", "Expedition")).to_upper(), Vector2(75, 60), 1780, 35)
	label_at("Positions 1–3: 1 is nearest the enemy. Skills show their usable positions and reach. Movement swaps allies.", Vector2(75, 115), 1780, 21)
	var warning: String = "Bandits cause Bleed and Poison. Deeper keep guards can pull rear heroes forward."
	if expedition.get("faction", "") == "remade":
		warning = "The remade use Burn, Bleed, Poison and stressful hymns. The Coterie has three consecutive forms."
	elif expedition.get("faction", "") == "moth":
		warning = "Moths cause Bleed and Poison. Oleander guards then exposes himself; Exuvia's cocoons must be destroyed before hatching."
	label_at("SCOUT REPORT: " + warning, Vector2(75, 155), 1760, 20).size = Vector2(1760, 40)
	var readiness: Dictionary = Readiness.departure_advice(State)
	var advice := label_at(str(readiness["text"]),Vector2(75,201),1760,20)
	advice.name = "DepartureAdvice"
	advice.size = Vector2(1760,48)
	advice.clip_text = true
	advice.add_theme_color_override("font_color",Color("#D8B981") if readiness["veteran"] or readiness["points"] > 0 else Color("#D9CBBB"))
	var summaries: Array[Dictionary] = Readiness.party_snapshot(State)
	for index in range(summaries.size()):
		var hero: Dictionary = summaries[index]
		var id: String = hero["id"]
		var x: float = 125 + index * 570
		var hero_panel := panel(Rect2(x, 254, 530, 278))
		preload("res://scripts/visual_overlays.gd").frame(hero_panel,id)
		var portrait := picture(str(State.hero(id)["art"]), Rect2(x + 15, 269, 145, 208))
		portrait.tooltip_text = role_description(id)
		var chosen := label_at(str(hero["name"]).to_upper(), Vector2(x + 178, 269), 332, 23)
		chosen.name = "HeroName_%s" % id
		chosen.size = Vector2(332,34)
		chosen.clip_text = true
		var class_label := label_at("%s · LEVEL %d" % [hero["class"],hero["level"]], Vector2(x + 178, 306), 332, 18)
		class_label.name = "HeroClass_%s" % id
		class_label.size = Vector2(332,28)
		var vitality := label_at("MAX HP %d" % hero["max_hp"],Vector2(x+178,336),332,19)
		vitality.name = "HeroVitality_%s" % id
		var training := label_at("TRAINING: %d unspent point%s" % [hero["points"],"" if hero["points"] == 1 else "s"],Vector2(x+178,367),332,17)
		training.name = "HeroTraining_%s" % id
		training.add_theme_color_override("font_color",Color("#D8B981") if hero["points"] > 0 else Color("#C9BAA7"))
		var gear := RichTextLabel.new()
		gear.name = "HeroEquipment_%s" % id
		gear.position = Vector2(x+178,401)
		gear.size = Vector2(332,48)
		gear.text = "No equipment equipped." if hero["equipment"].is_empty() else "\n".join(hero["equipment"])
		gear.add_theme_font_size_override("normal_font_size",17)
		gear.add_theme_color_override("default_color",Color("#EADDD0"))
		gear.tooltip_text = role_description(id)+"\n\n"+gear.text
		add_child(gear)
		var formation: Dictionary = Readiness.formation_advice(State,id)
		var availability := label_at(str(formation["text"]),Vector2(x+178,451),332,16)
		availability.name = "FormationAdvice_%s" % id
		availability.size = Vector2(332,32)
		availability.mouse_filter = Control.MOUSE_FILTER_STOP
		availability.tooltip_text = "Position availability only; target reach, AP and cooldowns also matter in combat.\n" + str(formation["details"])
		availability.add_theme_color_override("font_color",Color("#D8B981") if not formation["blocked"].is_empty() else Color("#C9BAA7"))
		var toggle := button_at("POSITION %d · MOVE" % State.Depth.position_of(State, id), Rect2(x + 178, 485, 332, 38), toggle_rank.bind(id))
		toggle.name = "Position_%s" % id
		preload("res://scripts/visual_overlays.gd").frame(toggle,id)
		toggle.tooltip_text = role_description(id)
		toggle.add_theme_font_size_override("font_size", 18)
	label_at("OPTIONAL SUPPLIES · GOLD %d · Three basic rations provided; extras carry over" % State.gold, Vector2(75, 549), 1760, 22)
	var supplies: Array = ["bandage", "antidote", "calming_incense", "healing_potion", "trail_food", "lock_tools", "cleansing_herbs"]
	for index in range(supplies.size()):
		var id: String = supplies[index]
		var item: Dictionary = State.Items.item(id)
		var buy := button_at("%s · %d GOLD\nOwned %d" % [item["name"], State.item_price(id), int(State.inventory.get(id, 0))], Rect2(75 + (index % 4) * 440, 586 + (index / 4) * 85, 420, 75), buy_supply.bind(id))
		buy.name = "Supply_%s" % id
		buy.add_theme_font_size_override("font_size", 21)
		buy.disabled = State.gold < State.item_price(id)
		buy.tooltip_text = State.Items.description(id)
	label_at("I · FIELD GUIDE: formation, shared turns, scouting and recovery",Vector2(75,758),940,19)
	var depart := button_at("EMBARK WITH THIS PARTY", Rect2(1050, 755, 760, 40), embark)
	depart.name = "EmbarkButton"
	depart.disabled = departing
	depart.add_theme_font_size_override("font_size", 21)
	party_bar(return_to_hamlet, "RETURN TO HAMLET")

func role_description(id: String) -> String:
	return {"warden": "Exploits marked targets: +2 damage. Protect the front.", "ranger": "+1 skill damage from the rear. Mark targets for the Warden.", "occultist": "Damaging skills inflict Poison. Stack pressure with the party.", "crusader": "+2 damage against bleeding foes. Charge to create Bleed.", "healer": "Party healing also removes Bleed. Keep allies fighting."}.get(id, "Shared party turns allow heroes to act in any order.")

func toggle_rank(id: String) -> void:
	if departing: return
	State.Depth.move_hero(State, id, (State.Depth.position_of(State,id) % State.party.size()) + 1)
	refresh()

func buy_supply(id: String) -> void:
	if departing: return
	if State.purchase_item(id):
		refresh()

func embark() -> void:
	if departing: return
	departing = true
	get_node("EmbarkButton").disabled = true
	State.start_run()
	get_tree().change_scene_to_file("res://scenes/combat/combatscene.tscn" if State.selected_expedition.get("internal", false) else "res://scenes/expedition/dungeon.tscn")

func return_to_hamlet() -> void:
	if departing: return
	get_tree().change_scene_to_file("res://scenes/hub/settlement.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		return_to_hamlet()
