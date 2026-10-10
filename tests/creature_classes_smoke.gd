extends SceneTree
const State = preload("res://scripts/game_data.gd")
const HUMANS = ["ash_raider", "gallows_scout", "ash_chieftain"]
const INSECTS = ["moth_metamorph", "moth_oleander", "moth_exuvia"]
const REMADE = ["anguish_penitent", "anguish_vessel", "harrowed_giant", "coterie_seamkeeper", "coterie_cantor", "coterie_matron", "howling_head"]

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	State.progress_loaded = true
	for id in State.CREATURES:
		var expected: String = "Human" if HUMANS.has(id) else "The Remade" if REMADE.has(id) else "Insect" if INSECTS.has(id) else "Corrupted"
		assert(State.CREATURES[id]["creature_class"] == expected)
		assert(State.creature(id)["creature_class"] == expected)
	# Taxonomy is presentation/lore; holy damage and old faction tags keep their traits.
	assert(State.creature("keep_footman")["undead"])
	assert(State.creature("bone_rabble")["undead"])
	assert(not State.creature("moth_metamorph")["undead"])
	assert(not State.creature("anguish_vessel")["undead"])
	assert(State.creature("anguish_vessel")["tags"].has("Remade"))
	assert(State.hero("warden")["class"] == "Warden")
	State.discovered.clear()
	for id in ["gallows_scout", "anguish_vessel", "moth_metamorph", "bone_rabble"]:
		State.discover_creature(id)
	var book = load("res://scenes/hub/bestiary.tscn").instantiate()
	root.add_child(book)
	for entry in [["old_road", 1, "Human"], ["path_beast", 1, "The Remade"], ["infested_apothecary", 0, "Insect"], ["bone_warrens", 0, "Corrupted"]]:
		book.open_volume(entry[0])
		book.turn_page(entry[1])
		assert(book.book_view.get_node("CreatureClass").text == "CLASS: " + entry[2])
	book.open_volume("path_beast")
	book.turn_page(2)
	assert(book.book_view.get_node("CreatureClass").text == "CLASS: UNRECORDED")
	book.queue_free()
	await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: Human/Corrupted/The Remade/Insect taxonomy, book labels/discovery and preserved hero/undead traits")
	quit()
