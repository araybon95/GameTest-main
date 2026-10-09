extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	State.select_expedition("old_road")
	State.start_run(20)
	State.inventory.clear()
	State.equipment.clear()
	State.ensure_run_heroes()
	for id in State.Items.POTIONS.keys() + State.Items.SCROLLS.keys():
		State.add_item(id, 5)
		State.add_item(id, 3)
		assert(State.inventory[id] == 8)
		assert(State.consume_item(id) and State.inventory[id] == 7)
	State.run_heroes["warden"]["hp"] = 10
	assert(State.apply_potion("warden", "healing_potion", State.run_heroes))
	assert(State.run_heroes["warden"]["hp"] == 30 and State.inventory["healing_potion"] == 6)
	State.run_heroes["warden"]["dead"] = true
	assert(not State.apply_potion("warden", "healing_potion", State.run_heroes))
	assert(State.inventory["healing_potion"] == 6)
	State.run_heroes["warden"]["dead"] = false
	Rules.apply_status(State.run_heroes["warden"]["statuses"], "poison")
	assert(State.apply_potion("warden", "cleansing_potion", State.run_heroes))
	assert(State.run_heroes["warden"]["statuses"].is_empty())
	var statuses: Dictionary = {}
	for i in range(20):
		Rules.apply_status(statuses, "poison", 1.0, true)
		Rules.apply_status(statuses, "chill", 1.0, true)
	assert(statuses["poison"]["stacks"] == 3 and statuses["poison"]["damage"] == 6 and statuses["poison"]["turns"] == 2)
	assert(Rules.damage_after_chill(100, statuses) == 55)
	Rules.apply_status(statuses, "poison", 0.3)
	assert(statuses["poison"]["damage"] == 6)
	State.add_item("warden_frostblade")
	assert(not State.equip_item("ranger", "warden_frostblade"))
	assert(State.equip_item("warden", "warden_frostblade"))
	State.add_item("winter_shard")
	assert(State.equip_item("warden", "winter_shard"))
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	await process_frame
	battle.hero_state["warden"]["hp"] = 10
	var count: int = State.inventory["healing_potion"]
	battle._use_scroll("healing_potion")
	assert(battle.hero_state["warden"]["hp"] == 30 and battle.hero_state["warden"]["ap"] == 1)
	assert(State.inventory["healing_potion"] == count - 1)
	battle.enemies[0]["hp"] = 100000
	battle.enemies[0]["max_hp"] = 100000
	for i in range(100):
		battle._attack_with_equipment("warden", {"damage": 1})
	assert(battle.enemies[0]["statuses"]["chill"]["stacks"] == 3)
	assert(battle.scroll_container.get_child_count() == State.Items.POTIONS.size() + State.Items.SCROLLS.size())
	battle.queue_free()
	await process_frame
	print("PASS: consumable stacks, potion use/AP/dead guard, class Unique gear, actual hit procs, stacking caps and duration")
	quit()
