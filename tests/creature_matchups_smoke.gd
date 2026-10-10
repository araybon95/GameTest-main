extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Matchups = preload("res://scripts/creature_matchups.gd")
const GEAR: Array[String] = ["outlaw_tally","warden_gravewatch","occultist_severed_litany","ranger_chitin_lens","roadward_seal","graveward_locket","crusader_penitent_stitch","healer_chrysalis_rosary"]

func _initialize() -> void: call_deferred("run")

func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://creature_matchups_test.cfg"
	State.hero_progress.clear()
	State.inventory.clear()
	State.equipment.clear()
	State.select_expedition("old_road")
	State.start_run(37)
	var original: Dictionary = State.CREATURES.duplicate(true)
	for entry in [["ash_raider","Human","human"],["keep_footman","Corrupted","corrupted"],["anguish_vessel","The Remade","remade"],["moth_metamorph","Insect","insect"]]:
		var creature: Dictionary = State.creature(entry[0])
		assert(Matchups.class_of(creature) == entry[1])
		assert(Matchups.offense_stat(creature) == "damage_vs_" + entry[2])
		assert(Matchups.ward_stat(creature) == "ward_vs_" + entry[2])
	assert(Matchups.class_of({"tags":["Human","Bandit"]}) == "Human")
	assert(Matchups.class_of({"tags":["Remade","Cult"]}) == "The Remade")
	assert(Matchups.class_of({"tags":["Moth","Cultist"]}) == "Insect")
	assert(Matchups.class_of({"undead":true,"tags":["Undead"]}) == "Corrupted")
	assert(is_equal_approx(Matchups.offense_multiplier(15),1.15))
	assert(is_equal_approx(Matchups.offense_multiplier(40),1.25))
	assert(is_equal_approx(Matchups.offense_multiplier(-10),1.0))
	assert(is_equal_approx(Matchups.ward_multiplier(15),0.85))
	assert(is_equal_approx(Matchups.ward_multiplier(40),0.8))
	assert(is_equal_approx(Matchups.ward_multiplier(-10),1.0))
	for entry in [["keep_footman","bleed",20],["anguish_vessel","chill",15],["moth_metamorph","poison",20]]:
		var creature: Dictionary = State.creature(entry[0])
		assert(Matchups.status_resistance(creature,entry[1]) == entry[2])
		assert(Matchups.status_resisted(creature,entry[1],float(entry[2])-0.01))
		assert(not Matchups.status_resisted(creature,entry[1],float(entry[2])))
		assert(Matchups.resistance_text(creature).contains("application"))
	for id in State.CREATURES:
		for status in ["burn","bleed","poison","chill"]:
			assert(Matchups.status_resistance(State.creature(id),status) <= 20)
			assert(not Matchups.status_resisted(State.creature(id),status,99.0),"Every creature remains susceptible to every status")
	assert(not Matchups.status_resisted(State.creature("ash_raider"),"bleed",0.0))
	assert(Matchups.tactics(State.creature("keep_footman")).contains("undead bonus"))
	assert(not Matchups.tactics(State.creature("weald_stalker")).contains("undead bonus"),"Corrupted class does not make living creatures undead")
	assert(State.CREATURES == original,"Matchup lookup preserves factions and undead traits")
	State.add_item("warden_gravewatch")
	assert(not State.equip_item("ranger","warden_gravewatch"))
	assert(State.equip_item("warden","warden_gravewatch"))
	assert(State.equipment_bonus("warden",Matchups.offense_stat(State.creature("keep_footman"))) == 15)
	assert(State.equipment_bonus("warden",Matchups.offense_stat(State.creature("ash_raider"))) == 0)
	State.add_item("roadward_seal")
	assert(State.equip_item("warden","roadward_seal"))
	assert(State.equipment_bonus("warden",Matchups.ward_stat(State.creature("ash_raider"))) == 10)
	assert(State.equipment_bonus("warden",Matchups.ward_stat(State.creature("keep_footman"))) == 0)
	State.add_item("outlaw_tally")
	assert(State.equip_item("ranger","outlaw_tally"),"Universal hunt pieces fit any current party class")
	State.gold = 1000
	for id in GEAR:
		var item: Dictionary = State.Items.item(id)
		assert(item["rarity"] in ["rare","epic"] and item["kind"] == "trinket")
		assert(State.Items.description(id).contains("direct damage") and State.Items.description(id).contains("damage-over-time"))
		assert(State.Items.description(id).contains("cap 20%") or State.Items.description(id).contains("cap 25%"))
		assert(ResourceLoader.exists(State.Items.icon_path(id)))
		assert(State.purchase_item(id) == (not item.has("hero") or State.party.has(item["hero"])),"Shop availability follows current party classes")
	assert(not State.purchase_item("warden_legend"),"Merchant legendary exclusion is preserved")
	var rng := RandomNumberGenerator.new()
	rng.seed = 846
	var seen: Dictionary = {}
	var all_heroes: Array = State.HEROES.keys()
	for trial in range(8000):
		var id: String = State.Items.roll_equipment(rng,all_heroes)
		if GEAR.has(id): seen[id] = true
		id = State.Items.roll_equipment(rng,State.party)
		var item: Dictionary = State.Items.item(id)
		assert(not item.has("hero") or State.party.has(item["hero"]))
	for id in GEAR: assert(seen.has(id),"Every new eligible trinket is in the regular loot pool")
	for trial in range(100):
		var item: Dictionary = State.Items.item(State.Items.roll_equipment(rng,State.party,true))
		assert(item["rarity"] == "legendary" and State.party.has(item["hero"]))
	State.discovered.clear()
	for id in ["gallows_scout","keep_footman","anguish_vessel","moth_metamorph"]: State.discover_creature(id)
	var book = load("res://scenes/hub/bestiary.tscn").instantiate()
	root.add_child(book)
	await process_frame
	for entry in [["old_road",1,"Human"],["old_road",3,"Corrupted"],["path_beast",1,"The Remade"],["infested_apothecary",0,"Insect"]]:
		book.open_volume(entry[0])
		book.turn_page(entry[1])
		assert(book.book_view.get_node("CreatureClass").text == "CLASS: " + entry[2])
		assert(book.book_view.get_node("CreatureTactics").text.contains("direct"))
	book.open_volume("path_beast")
	book.turn_page(2)
	assert(book.book_view.get_node_or_null("CreatureTactics") == null,"Undiscovered pages do not reveal tactics")
	assert(book.book_view.get_node("CreatureResistance").text == "Innate traits not yet recorded.")
	assert(book.book_view.get_node("CreatureNotes").text == "No observations recorded.","Undiscovered boss objectives remain unrecorded")
	for entry in [["harrowed_giant",2,"Chains 2/2"],["coterie_seamkeeper",3,"Once per form"],["coterie_cantor",4,"Once per form"],["coterie_matron",5,"Once per form"],["howling_head",6,"Idol intact"]]:
		State.discover_creature(entry[0])
		book.turn_page(entry[1])
		var notes: String = book.book_view.get_node("CreatureNotes").text
		assert(notes.contains(entry[2]) and notes.contains("Selected hero spends 1 AP."),"Discovered Path bosses describe their optional objective and AP cost")
		assert(book.book_view.get_node("CreatureTactics").text.contains("direct"))
	book.queue_free()
	await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: class keys, bounded direct-hit multipliers, resistible statuses, matching equipment, class/loot/shop eligibility, legendary preservation and discovered-only tactics")
	quit()
