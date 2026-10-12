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
	if state.Items.favourites.get(id,false): state.Items.favourites[copy_id] = true
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
		var id: String = str(state.equipment[hero_id][slot])
		var record: Dictionary = state.Items.histories[id]
		var victories: Array = record.get("victories", [])
		var key: String = state.run_id + ":" + boss
		if not victories.has(key): victories.append(key)
		record["victories"] = victories
		if victories.size() >= 3: record["milestone"] = "Guardian's etching"

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

const TROPHIES: Dictionary = {"ash_chieftain":"chieftain_trophy","keep_son":"son_trophy","undying_lord":"lord_trophy","harrowed_giant":"giant_trophy","coterie_seamkeeper":"coterie_trophy","howling_head":"head_trophy","moth_oleander":"oleander_trophy","moth_exuvia":"exuvia_trophy"}
static func boss_relic(state, boss: String) -> String:
	if not TROPHIES.has(boss) or state.party.is_empty(): return ""
	var id: String = "keepsake_" + str(Time.get_ticks_usec())
	while state.Items.histories.has(id): id += "_"
	var bearer: String = str(state.party[state.loot_rng.randi_range(0,state.party.size()-1)])
	state.Items.histories[id] = {"base":TROPHIES[boss],"hero":bearer,"origin":state.creature(boss).get("name",boss),"name":"","deeds":[],"keys":[],"owners":[]}
	return id

const TRANSFORMS: Dictionary = {
	"restored":{"name":"Restore","cost":75,"max_hp":4,"description":"+4 maximum HP · pale steel trim"},
	"consecrated":{"name":"Consecrate","cost":75,"debuff_resist":10,"description":"+10% debuff resistance · warm gold sigils"},
	"corrupted":{"name":"Corrupt","cost":75,"damage_percent":8,"curse_stress":1,"description":"+8% skill damage; +1 Stress each party turn · crimson seams"}
}
static func transform(state, id: String, mode: String) -> String:
	if not state.service_unlocked("workshop") or not TRANSFORMS.has(mode) or not state.Items.item(id).has("slot"): return ""
	if state.Items.histories.get(id,{}).has("transformation") or state.gold < int(TRANSFORMS[mode].cost): return ""
	var owned: bool = int(state.inventory.get(id,0)) > 0
	var wearer: String = ""
	var slot: String = ""
	for hero in state.equipment:
		for place in state.equipment[hero]:
			if state.equipment[hero][place] == id: wearer = hero; slot = place
	if not owned and wearer.is_empty(): return ""
	if not state.Items.histories.has(id):
		if not wearer.is_empty(): id = identify(state,wearer,slot)
		else:
			var base: String = id
			var copy_id: String = "keepsake_" + str(Time.get_ticks_usec())
			while state.Items.histories.has(copy_id): copy_id += "_"
			state.Items.histories[copy_id] = {"base":base,"name":"","deeds":[],"keys":[],"owners":[]}
			state.inventory[base] -= 1
			if state.inventory[base] <= 0: state.inventory.erase(base)
			state.inventory[copy_id] = 1
			if state.Items.favourites.get(base,false): state.Items.favourites[copy_id] = true
			if state.modifications.has(base): state.modifications[copy_id] = state.modifications[base]
			id = copy_id
	state.Items.histories[id]["transformation"] = mode
	state.gold -= int(TRANSFORMS[mode].cost)
	if not wearer.is_empty():
		state.sync_equipped_health(wearer)
		state.Stories.remember(state,wearer,"transform:"+id,"Had %s %s at the Workshop." % [state.Items.item(id).name,mode])
	state.save_progression()
	state._save_economy()
	return id

static func equipped_line(state, hero_id: String, id: String) -> String:
	var record: Dictionary = state.Items.histories.get(id,{})
	if not record.get("owners",[]).is_empty():
		var owner: String = str(record.owners.back())
		state.Stories.remember(state,hero_id,"inherit:"+id,"Carried %s, heirloom of %s." % [state.Items.item(id).name,owner])
		return "“%s carried this. I will keep it close.”" % owner
	if record.has("origin"): return "“A trophy, and a warning. I remember what it cost.”"
	if record.has("transformation"): return "“This bears my mark now.”"
	return ""
