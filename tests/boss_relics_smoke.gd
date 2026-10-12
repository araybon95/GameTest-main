extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://relic-test.cfg"
	Saves.directory = "user://relic-test-saves/"
	State.inventory.clear()
	State.Items.histories.clear()
	State.Items.favourites.clear()
	State.equipment.clear()
	State.party.assign(["warden","ranger","occultist"])
	State.select_expedition("old_road")
	State.start_run(47)
	for boss in State.ItemStories.TROPHIES:
		State.floors[0][State.room_position] = {"kind":"boss","creature":boss,"enemies":[boss],"cleared":false,"seen":true}
		var loot: Array[String] = State.claim_room_loot()
		var id: String = loot[0]
		var item: Dictionary = State.Items.item(id)
		assert(item.rarity == "legendary" and item.boss_only and State.party.has(item.hero))
		assert(ResourceLoader.exists(State.Items.icon_path(id)))
		assert(State.Items.tooltip(id).contains(State.creature(boss).name))
		assert(State.claim_room_loot().is_empty())
		var wrong: String = "ranger" if item.hero != "ranger" else "warden"
		assert(not State.equip_item(wrong,id))
		assert(State.equip_item(item.hero,id))
		State.unequip_item(item.hero,item.slot)
		assert(State.toggle_item_favourite(id))
		var gold: int = State.gold
		assert(not State.sell_item(id) and State.gold == gold and State.inventory[id] == 1)
		assert(not State.purchase_item(id))
	var shop = load("res://scenes/hub/item_shop.tscn").instantiate()
	shop.trade_mode = "Sell"
	root.add_child(shop)
	await process_frame
	var id: String = str(State.inventory.keys()[0])
	assert(shop.find_child("Sell_"+id,true,false).disabled)
	var reveal = load("res://scenes/ui/relic_reveal.gd").new()
	reveal.item_id = id
	root.add_child(reveal)
	await process_frame
	reveal.toggle_favourite()
	assert(not State.Items.favourites.has(id))
	reveal.toggle_favourite()
	assert(State.Items.favourites[id])
	assert(Saves.save(1))
	State.Items.favourites.clear()
	State.Items.histories.clear()
	assert(Saves.load_slot(1))
	assert(State.Items.favourites[id] and State.Items.item(id).boss_only)
	assert(State.toggle_item_favourite(id))
	assert(State.sell_item(id))
	State.add_item("healing_potion",3)
	var icon = load("res://scenes/ui/item_icon_button.gd").new()
	icon.configure("healing_potion",3)
	root.add_child(icon)
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_RIGHT
	click.pressed = true
	icon._gui_input(click)
	assert(icon.get_node("FavouriteStar").text == "★")
	assert(State.inventory.healing_potion == 3 and not State.sell_item("healing_potion"))
	var rng := RandomNumberGenerator.new()
	rng.seed = 37
	for i in range(500):
		var rolled: String = State.Items.roll_equipment(rng,State.party)
		assert(not State.Items.item(rolled).get("boss_only",false))
	shop.queue_free()
	reveal.queue_free()
	icon.queue_free()
	for i in range(3): await process_frame
	print("PASS: eight boss-specific legendary relics, icons/lore, class restrictions, single awards, favourite UI/core sale guard, unmarking, saved protection and normal loot exclusion")
	quit()
