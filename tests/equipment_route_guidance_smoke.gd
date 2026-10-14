extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Readiness = preload("res://scripts/expedition_readiness.gd")
const Map = preload("res://scenes/expedition/dungeon_map.gd")
const Entrance = preload("res://scenes/expedition/floor_entrance.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
	for frame in range(3): await process_frame
func run() -> void:
	State.map_travel_mode = false # Explicit legacy-walking fixture.
	State.progress_loaded = true
	State.progress_path = "user://equipment_route_guidance.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.hero_progress.clear()
	State.hero_names = {"warden":"Vane","ranger":"Thorn","occultist":"Ash"}
	State.equipment.clear()
	State.inventory.clear()
	State.select_expedition("old_road")
	State.start_run(27)
	State.floors[0] = {
		Vector2i.ZERO:{"kind":"entry","seen":true,"cleared":true},
		Vector2i.RIGHT:{"kind":"battle","name":"Discovered Market","seen":true,"scouted":true,"cleared":false,"merchant_orb":true,"enemies":["ash_raider"]},
		Vector2i.DOWN:{"kind":"battle","name":"Discovered Patrol","seen":true,"scouted":true,"cleared":false,"enemies":["gallows_scout"]},
		Vector2i(2,0):{"kind":"battle","name":"Hidden Market","seen":false,"cleared":false,"merchant_orb":true},
		Vector2i(0,2):{"kind":"battle","name":"Spent Patrol","seen":true,"cleared":true},
		Vector2i(1,1):{"kind":"stairs","seen":true,"cleared":true}}
	var before: Dictionary = {"map":State.floors[0].duplicate(true),"gear":State.equipment.duplicate(true),"journey":State.journey.duplicate(true),"hp":State.run_heroes.duplicate(true)}
	var rng: int = State.loot_rng.state
	var gaps: Dictionary = Readiness.equipment_gaps(State)
	assert(gaps.weapon == ["Vane","Thorn","Ash"] and gaps.armor.size() == 3)
	var advice: String = Readiness.descent_advice(State)
	assert(advice.contains("No weapon equipped: Vane, Thorn, Ash") and advice.contains("No armour equipped"))
	assert(advice.contains("map 2, 1 (win the encounter first)") and not advice.contains("map 3, 1"))
	assert(Readiness.known_merchants(State).size() == 1)
	assert(Map.room_guidance(State.floors[0][Vector2i(2,0)]).is_empty(),"Hidden rooms have no guidance")
	assert(Map.room_guidance(State.floors[0][Vector2i(0,2)]).is_empty(),"Cleared fights offer no repeat XP")
	assert(Map.room_guidance(State.floors[0][Vector2i.RIGHT]).contains("win this encounter") and Map.room_guidance(State.floors[0][Vector2i.DOWN]).contains("chance of equipment"))
	assert(before.map == State.floors[0] and before.gear == State.equipment and before.journey == State.journey and before.hp == State.run_heroes and rng == State.loot_rng.state,"Advice cannot reveal rooms, grant equipment, heal or reroll loot")
	change_scene_to_file("res://scenes/expedition/dungeon.tscn")
	await settle()
	assert(not current_scene.has_node("Room_2_0"))
	assert(current_scene.get_node("Room_1_0").tooltip_text.contains("Merchant") and current_scene.get_node("Room_0_1").tooltip_text.contains("XP"))
	assert(not current_scene.get_node("Room_1_0").disabled,"Discovered adjacent merchant is a legal route")
	var map: Control = current_scene.get_node("DungeonMap")
	var merchant_rect: Rect2 = map.room_rect(Vector2i.RIGHT)
	assert(current_scene.get_node("Room_1_0").get_rect().has_point(map.position+merchant_rect.position+Vector2(merchant_rect.size.x,-5)),"The merchant diamond is included in its room's click target")
	assert(current_scene.get_node("Room_0_2").disabled,"Guidance cannot bypass uncleared intermediate rooms")
	State.room_position = Vector2i(1,1)
	var prompt = Entrance.new()
	current_scene.add_child(prompt)
	await settle()
	assert(not prompt.get_node("DescendButton").disabled,"Missing gear never blocks legal descent")
	prompt.stay_here()
	await settle()
	for entry in [["warden","warden_sword","warden_armor"],["ranger","ranger_bow","ranger_common_armor"],["occultist","occultist_staff","occultist_armor"]]:
		for item in [entry[1],entry[2]]:
			State.add_item(item)
			assert(State.equip_item(entry[0],item))
	assert(Readiness.equipment_gaps(State).weapon.is_empty() and Readiness.equipment_gaps(State).armor.is_empty())
	advice = Readiness.descent_advice(State)
	assert(not advice.contains("No weapon equipped") and not advice.contains("No armour equipped"))
	State.equipment.occultist = {}
	State.run_heroes.occultist.dead = true
	assert(Readiness.equipment_gaps(State).weapon.is_empty(),"Fallen companions are excluded from equipment suggestions")
	State.floors[0][Vector2i.RIGHT].cleared = true
	assert(Map.room_guidance(State.floors[0][Vector2i.RIGHT]).contains("orb ready") and not Map.room_guidance(State.floors[0][Vector2i.RIGHT]).contains("chance of equipment"))
	State.floor_index = 1
	assert(Readiness.known_merchants(State).all(func(m): return State.floors[1][m.location].seen),"Merchant advice is scoped to the current floor")
	print("PASS: equipment gaps, owned gear, fallen exclusion, hidden-room secrecy, merchant/fight tooltips, legal route/descent gates and read-only advice")
	quit()
