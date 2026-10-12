extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://item-stories-progress.cfg"
	Saves.directory = "user://item-stories-saves/"
	State.Items.histories.clear()
	State.inventory.clear()
	State.equipment.clear()
	State.graves.clear()
	State.party.assign(["warden","ranger","occultist"])
	State.hero_names = {"warden":"Alden"}
	State.select_expedition("old_road")
	State.start_run(43)
	State.add_item("warden_sword",2)
	State.add_item("warden_shield")
	State.add_item("healing_potion",3)
	assert(State.equip_item("warden","warden_sword"))
	assert(State.equip_item("warden","warden_shield"))
	var damage: int = State.equipment_bonus("warden","damage")
	var rng: int = State.loot_rng.state
	assert(State.ItemStories.name_item(State,"warden","weapon"," Last Vigil "))
	var sword: String = State.equipment.warden.weapon
	assert(sword != "warden_sword" and State.Items.item(sword).name == "Last Vigil")
	assert(State.Items.item("warden_sword").name != "Last Vigil")
	assert(State.inventory.warden_sword == 1 and State.inventory.healing_potion == 3)
	assert(State.Items.icon_path(sword) == State.Items.icon_path("warden_sword"))
	assert(State.equipment_bonus("warden","damage") == damage and State.loot_rng.state == rng)
	State.floors[0][State.room_position] = {"kind":"boss","enemies":["ash_raider"],"seen":true,"cleared":false}
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	current_scene = combat
	await process_frame
	await process_frame
	combat.hero_state.warden.hp = 0
	combat.hero_state.warden.deaths_door = true
	combat.hero_state.warden.block = 20
	combat._apply_damage("warden",2)
	var armor: String = State.equipment.warden.off_hand
	assert(State.Items.tooltip(armor).contains("Death's Door"))
	combat._award_reward()
	assert(State.Items.histories[sword].deeds.size() == 1)
	combat._award_reward()
	assert(State.Items.histories[sword].deeds.size() == 1)
	combat.hero_state.warden.block = 0
	combat._apply_damage("warden",2)
	assert(State.graves.size() == 1)
	assert(State.graves[0].heirloom.id == sword and State.inventory[sword] == 1)
	assert(not State.equipment.warden.has("weapon"))
	assert(State.Items.tooltip(sword).contains("Heirloom of Alden"))
	var frozen: Dictionary = State.graves[0].heirloom.history.duplicate(true)
	State.record_death("warden","again")
	assert(State.inventory[sword] == 1)
	State.run_heroes.warden.dead = false
	assert(State.equip_item("warden",sword))
	assert(State.ItemStories.name_item(State,"warden","weapon","Vigil Continues"))
	assert(State.graves[0].heirloom.history == frozen)
	State.unequip_item("warden","weapon")
	assert(State.inventory[sword] == 1 and State.inventory.warden_sword == 1)
	assert(not State.purchase_item(sword))
	assert(Saves.save(1))
	State.Items.histories.clear()
	assert(Saves.load_slot(1))
	assert(State.Items.item(sword).name == "Vigil Continues")
	assert(State.Items.tooltip(sword).contains("Heirloom of Alden"))
	assert(not State.equip_item("ranger",sword))
	State.completed_expeditions.append(str(State.Mechanics.SERVICES.workshop.quest))
	State.gold = 100
	assert(State.modify_equipment(sword,"keen"))
	assert(State.equip_item("warden",sword))
	assert(State.equipment_bonus("warden","damage") == damage + 1)
	assert(State.ItemStories.name_item(State,"warden","weapon",""))
	assert(State.Items.item(sword).name == State.Items.item("warden_sword").name)
	State.ItemStories.name_item(State,"warden","weapon","Vigil Continues")
	State.unequip_item("warden","weapon")
	assert(Saves.save(2))
	var gold: int = State.gold
	assert(State.sell_item(sword))
	assert(not State.inventory.has(sword) and State.inventory.warden_sword == 1)
	assert(State.gold == gold + State.item_sell_price(sword))
	assert(Saves.load_slot(2))
	assert(State.inventory[sword] == 1)
	current_scene = null
	var sheet = load("res://scenes/ui/hero_sheet.gd").new()
	root.add_child(sheet)
	await process_frame
	State.equip_item("warden",sword)
	sheet.inscribe_item()
	assert(sheet.find_child("KeepsakeName",true,false) != null)
	sheet.queue_free()
	combat.queue_free()
	for i in range(3): await process_frame
	await create_timer(0.2).timeout
	print("PASS: distinct named copies, real boss/block/death hooks, immutable heirlooms, unchanged stats/RNG, stacked consumables, save continuity and inscription UI")
	quit()
