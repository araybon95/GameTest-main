extends RefCounted
## Significant equipment gets a distinct identity; consumables keep stacking.
static func identify(state, hero_id: String, slot: String) -> String:
	var id: String = str(state.equipment.get(hero_id, {}).get(slot, ""))
	if id.is_empty() or not state.Items.EQUIPMENT.has(state.Items.base_id(id)): return ""
	if state.Items.histories.has(id): return id
	var copy_id: String = "keepsake_" + str(Time.get_ticks_usec())
	while state.Items.histories.has(copy_id): copy_id += "_"
	state.Items.histories[copy_id] = {"base":id,"name":"","deeds":[],"keys":[],"owners":[]}
	state.equipment[hero_id][slot] = copy_id
	if state.modifications.has(id): state.modifications[copy_id] = state.modifications[id]
	return copy_id

static func name_item(state, hero_id: String, slot: String, value: String) -> bool:
	if state.run_heroes.get(hero_id, {}).get("dead", false): return false
	var id: String = identify(state, hero_id, slot)
	if id.is_empty(): return false
	state.Items.histories[id]["name"] = value.strip_edges().replace("\n", " ").replace("\r", " ").left(32)
	state.save_progression()
	return true

static func deed(state, hero_id: String, slot: String, key: String, text: String) -> void:
	var id: String = identify(state, hero_id, slot)
	if id.is_empty(): return
	var record: Dictionary = state.Items.histories[id]
	if record["keys"].has(key): return
	record["keys"].append(key)
	record.deeds.append(text)
	while record.deeds.size() > 5: record.deeds.pop_front()

static func guardian(state, hero_id: String, boss: String) -> void:
	for slot in state.equipment.get(hero_id, {}):
		deed(state, hero_id, str(slot), "guardian", "Carried by %s when %s fell." % [state.hero(hero_id).name, boss])

static func heirloom(state, hero_id: String) -> Dictionary:
	var loadout: Dictionary = state.equipment.get(hero_id, {})
	var slot: String = "weapon" if loadout.has("weapon") else str(loadout.keys()[0]) if not loadout.is_empty() else ""
	if slot.is_empty(): return {}
	var id: String = identify(state, hero_id, slot)
	if id.is_empty(): return {}
	var record: Dictionary = state.Items.histories[id]
	var owner: String = str(state.hero(hero_id).name)
	if not record.owners.has(owner): record.owners.append(owner)
	var snapshot: Dictionary = {"id":id,"name":state.Items.item(id).name,"owner":owner,"history":record.duplicate(true)}
	state.add_item(id)
	loadout.erase(slot)
	return snapshot
