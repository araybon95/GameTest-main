extends SceneTree
## Lifecycle integration. Encounter victories are controlled fixtures, not a balance simulation.
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
const Music = preload("res://scripts/settlement_music.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
const DIRECTIONS = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]
const BOSS_EXIT = Vector2i(4, 3)
var combats: int = 0
var camps: int = 0
var shops: int = 0
var checkpoints: int = 0
var observed_turn: bool = false

func _initialize() -> void:
	call_deferred("run")

func settle() -> void:
	await process_frame
	await process_frame

func show_scene(path: String) -> void:
	assert(change_scene_to_file(path) == OK)
	await settle()

func reset_fixture() -> void:
	State.run_active = false
	State.run_complete = false
	State.party.assign(["warden", "ranger", "occultist"])
	State.hero_progress.clear()
	State.inventory.clear()
	State.equipment.clear()
	State.card_levels.clear()
	State.modifications.clear()
	State.formation.clear()
	State.hero_positions.clear()
	State.completed_expeditions.clear()
	State.graves.clear()
	State.hero_names = {"warden": "Alden", "ranger": "Rowan", "occultist": "Morrow"}
	State.crusader_unlocked = false
	State.gold = 24
	State.navigation_voters.assign(["local"])
	State.navigation_votes.clear()

func room() -> Dictionary:
	return State.floors[State.floor_index][State.room_position]

func move_through_ui(destination: Vector2i) -> void:
	assert(current_scene.scene_file_path == "res://scenes/expedition/dungeon.tscn")
	var dungeon = current_scene
	assert(not dungeon.route_to(destination).is_empty())
	dungeon.move_to(destination)
	# Skip just the timed travel presentation, retaining its signal and scene routing.
	var passage = null
	for child in dungeon.get_children():
		if child.get_script() == Travel:
			passage = child
	assert(passage != null and dungeon.traveling)
	passage.finish()
	await settle()
	assert(State.room_position == destination)

func controlled_victory() -> void:
	var battle = current_scene
	assert(battle.scene_file_path == "res://scenes/combat/combatscene.tscn")
	assert(not battle.battle_over and battle.enemies.size() >= 1 and battle.enemies.size() <= 3)
	if State.current_room_kind() == "boss" and battle.enemies.size() > 1 and battle.enemies[1].get("support", false):
		assert(battle.enemies[1]["max_hp"] == int(round(battle.enemies[1]["normal_hp"] * 0.3)))
		assert(battle.enemies[1]["attack"] == int(round(battle.enemies[1]["normal_attack"] * 0.3)))
	if not observed_turn:
		# Exercise AP expenditure, incoming attacks and a round reset once, at full departure HP.
		battle._select_hero("warden")
		battle._play_card("warden", 1)
		assert(battle.hero_state["warden"]["ap"] == 1)
		battle._end_turn()
		assert(battle.round_number == 2 and battle.hero_state["warden"]["ap"] == 2)
		observed_turn = true
	# Controlled lethal damage drives the production death/phase/victory/reward pipeline.
	var gold_before: int = State.gold
	var previous_inventory: Dictionary = State.inventory.duplicate(true)
	var kind: String = State.current_room_kind()
	var phase_count: int = room().get("boss_phases", []).size()
	var phases_defeated: int = 0
	while not battle._living_enemies().is_empty():
		battle._load_enemy(battle._living_enemies()[0])
		battle._deal_enemy_damage(999, true)
		phases_defeated += 1
		assert(phases_defeated <= 6)
		if kind == "boss" and not battle._living_enemies().is_empty():
			battle._check_battle_over()
			assert(not battle.battle_over and not battle.reward_given)
			assert(not battle.has_node("FloorEntrancePrompt"), "Forms/support must fall before descent")
		if phase_count > 0 and phases_defeated < phase_count:
			assert(State.gold == gold_before and not room().get("loot_claimed", false))
	battle._check_battle_over()
	await settle()
	assert(battle.battle_over and battle.reward_given)
	assert(room().get("loot_claimed", false) and room().get("xp_awarded", false))
	var reward: int = int(State.selected_expedition["reward"]) if kind == "boss" else 2
	assert(State.gold == gold_before + reward)
	if kind == "boss":
		var legendary_found: bool = false
		for id in State.inventory:
			var item: Dictionary = State.Items.item(str(id))
			if item["rarity"] == "legendary" and State.party.has(item.get("hero", "")) and int(State.inventory[id]) > int(previous_inventory.get(id, 0)):
				legendary_found = true
		assert(legendary_found, "A boss awards class-compatible legendary equipment")
	var earned_gold: int = State.gold
	var earned_items: Dictionary = State.inventory.duplicate(true)
	var earned_progress: Dictionary = State.hero_progress.duplicate(true)
	battle._check_battle_over()
	assert(State.gold == earned_gold and State.inventory == earned_items and State.hero_progress == earned_progress)
	assert(State.claim_room_loot().is_empty() and State.award_victory_xp().is_empty())
	combats += 1
	if battle.has_node("FloorEntrancePrompt"):
		assert(State.can_descend())
		battle.get_node("FloorEntrancePrompt").stay_here()
	else:
		battle._on_end_turn_button_pressed()
	await settle()
	assert(room().get("cleared", false) if State.run_active else State.last_report["complete"])

func check_camp() -> void:
	assert(current_scene.scene_file_path == "res://scenes/expedition/camp.tscn")
	# Deliberately wound the survivors to verify recovery without asserting balance.
	for id in State.party:
		State.run_heroes[id]["hp"] = 7
		State.run_heroes[id]["stress"] = 70
		State.run_heroes[id]["statuses"] = {"burn": {"turns": 2, "damage": 3}}
	current_scene.rest_party()
	for id in State.party:
		assert(State.run_heroes[id]["hp"] == State.hero_max_hp(id))
		assert(State.run_heroes[id]["stress"] == 7 and State.run_heroes[id]["statuses"].is_empty())
	assert(not State.rest_at_camp())
	current_scene.prepare("watch")
	assert(room()["camp_choices"].has("watch"))
	current_scene.leave_camp()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/expedition/dungeon.tscn")
	camps += 1

func check_shop() -> void:
	assert(State.merchant_orb_available())
	var position: Vector2i = State.room_position
	var heroes: Dictionary = State.run_heroes.duplicate(true)
	current_scene.open_shop()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/hub/item_shop.tscn")
	assert(not State.purchase_item("warden_legend"))
	# Use earned/preserved gold through the production shop handler.
	if State.gold >= State.item_price("trail_food"):
		var gold_before: int = State.gold
		var stock_before: int = State.inventory.get("trail_food", 0)
		current_scene.purchase("trail_food")
		assert(State.gold == gold_before - State.item_price("trail_food"))
		assert(State.inventory["trail_food"] == stock_before + 1)
	current_scene.return_to_party()
	await settle()
	assert(State.room_position == position and State.run_heroes == heroes)
	shops += 1

func resolve_current() -> void:
	match current_scene.scene_file_path:
		"res://scenes/combat/combatscene.tscn":
			await controlled_victory()
		"res://scenes/expedition/camp.tscn":
			await check_camp()
		"res://scenes/expedition/event_room.tscn":
			var event_id: String = str(room()["event_id"])
			var selected: String = current_scene.selected_hero
			var result: Dictionary = State.Events.resolve(State, selected, false, "class" if not State.Mechanics.event_option(event_id, selected).is_empty() else "investigate")
			assert(not result.is_empty() and room()["event_resolved"] and room()["cleared"])
			assert(State.Events.resolve(State, selected).is_empty())
			await show_scene("res://scenes/expedition/dungeon.tscn")
		"res://scenes/expedition/dungeon.tscn":
			assert(room()["cleared"] or room()["kind"] == "stairs")
		_:
			assert(false, "Unexpected encounter destination")
	if State.run_active and State.merchant_orb_available():
		await check_shop()

func save_roundtrip() -> void:
	assert(State.run_active and room()["cleared"])
	assert(Saves.save(1))
	var gold: int = State.gold
	var floor: int = State.floor_index
	var position: Vector2i = State.room_position
	var floors: Array = State.floors.duplicate(true)
	var heroes: Dictionary = State.run_heroes.duplicate(true)
	var progress: Dictionary = State.hero_progress.duplicate(true)
	var inventory: Dictionary = State.inventory.duplicate(true)
	var deeds: Dictionary = State.run_deeds.duplicate(true)
	var rng: int = State.loot_rng.state
	var expected_roll: int = State.loot_rng.randi()
	State.gold = -1
	State.inventory.clear()
	State.run_heroes.clear()
	State.floors.clear()
	State.hero_progress.clear()
	assert(Saves.load_slot(1))
	assert(State.gold == gold and State.floor_index == floor and State.room_position == position)
	assert(State.floors == floors and State.run_heroes == heroes and State.hero_progress == progress)
	assert(State.inventory == inventory and State.run_deeds == deeds and State.loot_rng.state == rng)
	assert(State.loot_rng.randi() == expected_roll, "Loading resumes the same loot stream")
	checkpoints += 1

func explore_floor() -> void:
	# Complete all optional spaces before the exit, via cleared-route navigation.
	var iterations: int = 0
	while true:
		var destination = null
		var best_length: int = 999
		for location in State.floors[State.floor_index]:
			if location == BOSS_EXIT or State.floors[State.floor_index][location]["cleared"]:
				continue
			var route: Array = current_scene.route_to(location)
			if not route.is_empty() and route.size() < best_length:
				destination = location
				best_length = route.size()
		if destination == null:
			break
		iterations += 1
		assert(iterations <= 25)
		await move_through_ui(destination)
		await resolve_current()
		assert(State.run_active)
	# Some branches may connect only through the exit; they are optional.
	await save_roundtrip()
	await move_through_ui(BOSS_EXIT)
	await resolve_current()

func check_retreat_and_deaths() -> void:
	State.start_run(83)
	await show_scene("res://scenes/expedition/dungeon.tscn")
	var inventory: Dictionary = State.inventory.duplicate(true)
	current_scene.retreat()
	await settle()
	assert(not State.run_active and not State.last_report["complete"])
	assert(State.inventory == inventory and State.last_report["survivors"].size() == 3)
	current_scene.return_home()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/hub/settlement.tscn")
	assert(Music.player().playing)
	State.start_run(84)
	var target = null
	for location in State.floors[0]:
		if State.floors[0][location]["kind"] == "battle":
			target = location
			break
	assert(target != null)
	# Defeat fixture uses actual Death's Door and memorial handling in a battle.
	State.room_position = target
	State.add_deed("warden", "damage", 17)
	await show_scene("res://scenes/combat/combatscene.tscn")
	var battle = current_scene
	for id in State.party:
		battle._apply_damage(id, 999, true, "Milestone test foe")
		assert(battle.hero_state[id]["deaths_door"] and not battle.hero_state[id]["dead"])
		battle._apply_damage(id, 1, true, "Milestone test foe")
		assert(battle.hero_state[id]["dead"])
	battle._check_battle_over()
	assert(battle.battle_over and not battle.reward_given)
	assert(State.graves.size() == 3 and State.graves[0]["name"] == "Alden")
	assert(State.graves[0]["deeds"]["damage"] == 17)
	battle._on_end_turn_button_pressed()
	await settle()
	assert(not State.run_active and State.last_report["fallen"].size() == 3)
	assert(State.last_report["survivors"].is_empty() and not State.last_report["complete"])
	assert(Saves.save(2) and Saves.load_slot(2))
	assert(State.graves.size() == 3 and State.last_report["fallen"].size() == 3)

func check_beast_boss_chain() -> void:
	assert(State.select_expedition("path_beast"))
	State.start_run(2026)
	for floor in range(3):
		assert(State.floor_index == floor)
		State.room_position = BOSS_EXIT
		await show_scene("res://scenes/combat/combatscene.tscn")
		await controlled_victory()
		if floor < 2:
			assert(State.can_descend() and not State.run_complete)
			current_scene.descend()
			assert(current_scene.has_node("FloorEntrancePrompt"))
			current_scene.get_node("FloorEntrancePrompt").accept_entrance()
			await settle()
			assert(State.room_position == Vector2i.ZERO)
	assert(not State.run_active and State.last_report["complete"])
	assert(State.completed_expeditions.has("path_beast"))

func run() -> void:
	seed(2026)
	State.progress_loaded = true
	State.progress_path = "user://run_milestone_progress.cfg"
	Saves.directory = "user://run_milestone_saves/"
	reset_fixture()
	assert(State.select_expedition("old_road"))
	await show_scene("res://scenes/hub/settlement.tscn")
	assert(Music.player().playing)
	await show_scene("res://scenes/expedition/preparation.tscn")
	assert(Music.player().playing)
	current_scene.buy_supply("bandage")
	assert(State.inventory["bandage"] == 1)
	current_scene.embark()
	await settle()
	assert(State.run_active and not Music.player().playing)
	# The UI departure is exercised above; use a fixed world for repeatable coverage.
	State.start_run(2026)
	assert(State.floor_count == 3)
	current_scene.refresh()
	for floor in range(3):
		assert(State.floor_index == floor)
		await explore_floor()
		if floor < 2:
			assert(State.run_active and not State.run_complete and State.can_descend())
			current_scene.descend()
			assert(current_scene.has_node("FloorEntrancePrompt"))
			current_scene.get_node("FloorEntrancePrompt").accept_entrance()
			await settle()
			assert(State.floor_index == floor + 1 and State.room_position == Vector2i.ZERO)
			assert(State.scout_uses == 2)
	assert(not State.run_active and State.run_complete)
	assert(State.completed_expeditions.has("old_road"))
	assert(State.last_report["complete"] and State.last_report["floor"] == 3)
	assert(State.last_report["survivors"].size() == 3 and State.last_report["fallen"].is_empty())
	assert(State.last_report["kills"] >= 4 and not State.last_report["loot"].is_empty())
	assert(State.last_report["survivors"][0]["xp"] > 0 and State.leveling("warden")["level"] > 1)
	assert(camps >= 3 and shops == 3 and checkpoints == 3)
	assert(State.crusader_unlocked, "Floor-two coffin remains part of the same run")
	assert(Saves.save(1))
	var report: Dictionary = State.last_report.duplicate(true)
	State.last_report.clear()
	assert(Saves.load_slot(1) and State.last_report == report and not State.run_active)
	current_scene.return_home()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/hub/settlement.tscn")
	assert(Music.player().playing)
	await check_retreat_and_deaths()
	await check_beast_boss_chain()
	for slot in [0, 1, 2]:
		DirAccess.remove_absolute(Saves.path(slot))
	DirAccess.remove_absolute(State.progress_path)
	Music.stop()
	await create_timer(0.12).timeout
	print("PASS: deterministic three-floor Old Road lifecycle, actual scene routes/AP/turn, %d controlled victories, camp/orb per floor, once-only rewards/XP, coffin rescue, three checkpoints/RNG, victory/retreat/Death's Door/graves, return music and Beast three-boss/Coterie phase chain" % combats)
	quit()
