extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Signatures = preload("res://scripts/weapon_signatures.gd")
const Compare = preload("res://scripts/equipment_comparison.gd")
const Effects = preload("res://scenes/combat/strike_effects.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://equipment-feedback.cfg"
	State.equipment.clear()
	State.inventory.clear()
	State.Items.histories.clear()
	State.modifications.clear()
	State.party.assign(["warden","ranger","occultist"])
	State.select_expedition("old_road")
	State.start_run(59)
	State.add_item("warden_sword")
	State.equip_item("warden","warden_sword")
	State.add_item("warden_frostblade")
	State.add_item("ranger_venombow")
	State.equip_item("ranger","ranger_venombow")
	var rng: int = State.loot_rng.state
	var inventory: Dictionary = State.inventory.duplicate(true)
	var gear: Dictionary = State.equipment.duplicate(true)
	State.modifications.warden_sword = "keen"
	var comparison: Dictionary = Compare.compare(State,"warden","warden_frostblade")
	assert(not comparison.changes.any(func(row): return row.stat == "damage"))
	assert(comparison.changes.any(func(row): return row.stat == "unique_chill" and row.delta == 30))
	assert(not Compare.compare(State,"ranger","warden_frostblade").compatible)
	assert(State.equipment == gear and State.inventory == inventory and State.loot_rng.state == rng)
	var sheet = load("res://scenes/ui/hero_sheet.gd").new()
	sheet.hero_id = "warden"
	sheet.inventory_mode = true
	root.add_child(sheet)
	await process_frame
	sheet.choose_item("warden_frostblade")
	assert(sheet.has_node("EquipmentComparison") and State.equipment.warden.weapon == "warden_sword")
	assert(sheet.get_node("EquipmentComparison/ConfirmEquip").disabled == false)
	sheet.get_node("EquipmentComparison").dismiss()
	await process_frame
	assert(State.equipment.warden.weapon == "warden_sword")
	sheet.choose_item("warden_frostblade")
	sheet.get_node("EquipmentComparison").request_equip()
	await process_frame
	assert(State.equipment.warden.weapon == "warden_frostblade")
	assert(Signatures.resolve(State,"warden") == "frost" and Signatures.resolve(State,"ranger") == "venom")
	sheet.queue_free()
	await process_frame
	var combat = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(combat)
	current_scene = combat
	await process_frame
	combat.presentation.set_process(false)
	if combat.presentation.boss_reveal != null: combat.presentation.boss_reveal.finish()
	combat._attack_with_equipment("warden",State.card_stats("wd_slash"))
	assert(combat.presentation.active.weapon_signature == "frost")
	combat.presentation.active.reaction = "miss"
	assert(not Effects.sample(combat.presentation).harmful)
	combat.presentation.active.reaction = "block"
	assert(not Effects.sample(combat.presentation).harmful)
	assert(combat.presentation.active.weapon_signature == "frost")
	assert(State.loot_rng.state == rng)
	combat.queue_free()
	for i in range(3): await process_frame
	print("PASS: weapon visual signatures, modified gear comparisons without mutation/RNG, class gates, current/proposed appearance, explicit equip/cancel and blocked/missed hit suppression")
	quit()
