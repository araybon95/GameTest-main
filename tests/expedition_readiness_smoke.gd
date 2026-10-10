extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Readiness = preload("res://scripts/expedition_readiness.gd")
const Entrance = preload("res://scenes/expedition/floor_entrance.gd")

func _initialize() -> void: call_deferred("run")

func settle() -> void:
	for frame in range(3): await process_frame

func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://readiness_test_progress.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.hero_progress.clear()
	State.equipment.clear()
	State.inventory.clear()
	State.run_active = false
	State.hero_names = {"warden":"Sir Vane","ranger":"Thorn","occultist":"Mother Ash"}
	assert(State.select_expedition("path_beast"))
	var before: Dictionary = {"levels":State.hero_progress.duplicate(true),"gear":State.equipment.duplicate(true)}
	var advice: Dictionary = Readiness.departure_advice(State)
	assert(advice["suggested_level"] == 3 and not advice["level_ready"] and not advice["gear_ready"])
	var heroes: Array[Dictionary] = Readiness.party_snapshot(State)
	assert(heroes[0]["name"] == "Sir Vane" and heroes[0]["class"] == "Warden" and heroes[0]["max_hp"] == State.hero_max_hp("warden"))
	assert(before["levels"] == State.hero_progress and before["gear"] == State.equipment,"Readiness never grants levels or gear")
	State.gold = 100
	var preparation = load("res://scenes/expedition/preparation.tscn").instantiate()
	root.add_child(preparation)
	await settle()
	assert(not preparation.get_node("EmbarkButton").disabled,"Suggested Veteran progression never blocks departure")
	assert(preparation.get_node("HeroName_warden").text == "SIR VANE")
	assert(preparation.get_node("HeroClass_warden").text.contains("Warden") and preparation.get_node("HeroClass_warden").text.contains("LEVEL 1"))
	assert(preparation.get_node("HeroEquipment_warden").text == "No equipment equipped.")
	var gold: int = State.gold
	preparation.buy_supply("bandage")
	assert(State.gold == gold-State.item_price("bandage") and State.inventory["bandage"] == 1)
	assert(preparation.get_node("Supply_bandage").text.contains("Owned 1"),"Supply purchase refreshes its actual count")
	var position: int = State.Depth.position_of(State,"warden")
	preparation.toggle_rank("warden")
	assert(State.Depth.position_of(State,"warden") != position,"Readiness preserves formation choices")
	for id in State.party:
		assert(State.gain_hero_xp(id,105) == 2)
	preparation.refresh()
	assert(preparation.get_node("HeroTraining_warden").text.contains("4 unspent"))
	assert(Readiness.departure_advice(State)["points"] == 12)
	for entry in [["warden","warden_gravewatch"],["ranger","ranger_chitin_lens"],["occultist","occultist_severed_litany"]]:
		for stat in ["max_hp","damage_percent","block","debuff_resist"]: assert(State.train_hero(entry[0],stat))
		State.add_item(entry[1])
		assert(State.equip_item(entry[0],entry[1]))
	advice = Readiness.departure_advice(State)
	assert(advice["level_ready"] and advice["gear_ready"] and advice["points"] == 0 and advice["text"].contains("Suggested preparation met"))
	preparation.refresh()
	assert(preparation.get_node("HeroVitality_warden").text == "MAX HP %d" % State.hero_max_hp("warden"))
	assert(preparation.get_node("HeroEquipment_warden").text.contains("Gravewatch Medal"))
	assert(not preparation.get_node("EmbarkButton").disabled)
	preparation.queue_free()
	await settle()
	State.start_run(147)
	State.floors[0] = {
		Vector2i.ZERO:{"kind":"stairs","seen":true,"cleared":true},
		Vector2i(2,0):{"kind":"camp","name":"Known Brazier","seen":true,"cleared":false},
		Vector2i(1,0):{"kind":"camp","name":"Secret Crypt Fire","seen":false,"cleared":false},
		Vector2i(3,0):{"kind":"camp","name":"Spent Watchfire","seen":true,"cleared":true,"camp_used":true}}
	State.run_heroes["warden"].merge({"hp":0,"deaths_door":true,"stress":85,"statuses":{"bleed":{"turns":2,"damage":2},"poison":{"turns":2,"damage":2}}},true)
	State.run_heroes["ranger"].merge({"hp":11,"statuses":{"chill":{"turns":2,"damage":0}}},true)
	State.run_heroes["occultist"].merge({"hp":0,"dead":true},true)
	var maps: Array = State.floors.duplicate(true)
	var party: Dictionary = State.run_heroes.duplicate(true)
	var camps: Array[Dictionary] = Readiness.known_unused_camps(State)
	assert(camps.size() == 1 and camps[0]["location"] == Vector2i(2,0))
	var guidance: String = Readiness.descent_advice(State)
	assert(guidance.contains("Death's Door: Sir Vane") and guidance.contains("Active debuffs") and guidance.contains("cannot revive"))
	assert(guidance.contains("Known Brazier") and not guidance.contains("Secret Crypt Fire") and not guidance.contains("Spent Watchfire"),"Only discovered unused camps are listed")
	assert(State.floors == maps and State.run_heroes == party,"Guidance never reveals rooms or heals the party")
	var responses: Array[String] = []
	var prompt = Entrance.new()
	prompt.on_descend = func(): responses.append("descend"); State.descend()
	prompt.on_stay = func(): responses.append("stay")
	root.add_child(prompt)
	await settle()
	assert(not prompt.get_node("DescendButton").disabled,"Health and status danger never hard-gate a legal descent")
	assert(prompt.get_node("DescentClass_warden").text.contains("Lv 3"))
	assert(prompt.get_node("DescentVitality_warden").text.contains("HP 0 /"))
	assert(prompt.get_node("DescentStatus_warden").text.contains("DEATH'S DOOR") and prompt.get_node("DescentStatus_warden").text.contains("Bleed"))
	assert(prompt.get_node("NextFloorThreat").text.contains("three consecutive forms"))
	prompt.accept_entrance()
	prompt.accept_entrance()
	prompt.stay_here()
	assert(responses == ["descend"] and State.floor_index == 1,"Proceed answers once and advances exactly one floor")
	await settle()
	State.floor_index = 0
	State.room_position = Vector2i.ZERO
	prompt = Entrance.new()
	prompt.on_descend = func(): responses.append("descend")
	prompt.on_stay = func(): responses.append("stay")
	root.add_child(prompt)
	await settle()
	var cancel := InputEventAction.new()
	cancel.action = "ui_cancel"
	cancel.pressed = true
	prompt._unhandled_input(cancel)
	prompt.stay_here()
	prompt.accept_entrance()
	assert(responses == ["descend","stay"] and State.floor_index == 0,"Escape stays once without advancing the floor")
	await settle()
	State.floors[0][Vector2i(2,0)]["seen"] = false
	assert(Readiness.known_unused_camps(State).is_empty())
	guidance = Readiness.descent_advice(State)
	assert(guidance.contains("No discovered unused camp") and not guidance.contains("Known Brazier") and not guidance.contains("Secret Crypt Fire"))
	# The helper's caution has no effect on the existing one-use full camp recovery.
	State.room_position = Vector2i(2,0)
	assert(State.rest_at_camp())
	assert(State.run_heroes["warden"]["hp"] == State.hero_max_hp("warden") and not State.run_heroes["warden"]["deaths_door"])
	assert(State.run_heroes["warden"]["statuses"].is_empty() and State.run_heroes["warden"]["stress"] == 8)
	assert(State.run_heroes["occultist"]["dead"] and State.run_heroes["occultist"]["hp"] == 0)
	assert(not State.rest_at_camp() and Readiness.known_unused_camps(State).is_empty())
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	print("PASS: named party/class/level/maxHP/equipment, nonblocking Veteran guidance, training/supplies/formation, dangerous party advice, camp secrecy, exactly-once descend/stay and unchanged recovery")
	quit()
