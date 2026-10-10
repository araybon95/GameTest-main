extends RefCounted
## Read-only preparation advice. It never reveals the map or changes embark rules.
const EQUIPMENT_ORDER: Array[String] = ["weapon","armor","head","trinket","charm"]

static func party_snapshot(state, during_run: bool = false) -> Array[Dictionary]:
	var party: Array[Dictionary] = []
	for id in state.party:
		var hero: Dictionary = state.hero(str(id))
		var growth: Dictionary = state.leveling(str(id))
		var current: Dictionary = state.run_heroes.get(id,{}) if during_run else {}
		var maximum: int = state.hero_max_hp(str(id))
		var equipped: Array[String] = []
		var improved: bool = false
		var loadout: Dictionary = state.equipment.get(id,{})
		var slots: Array = EQUIPMENT_ORDER.duplicate()
		for slot in loadout:
			if not slots.has(slot): slots.append(slot)
		for slot in slots:
			if not loadout.has(slot): continue
			var item: Dictionary = state.Items.item(str(loadout[slot]))
			if item.is_empty(): continue
			equipped.append("%s: %s" % [str(slot).capitalize(),str(item["name"])])
			if item.get("rarity","common") != "common": improved = true
		var statuses: Array[String] = []
		for status in current.get("statuses",{}): statuses.append(str(status).capitalize())
		var trained: bool = growth["stats"].values().any(func(value): return int(value) > 0)
		party.append({"id":str(id),"name":str(hero.get("name",id)),"class":str(state.HEROES[id]["name"]),
			"level":int(growth["level"]),"max_hp":maximum,"hp":int(current.get("hp",maximum)),
			"points":int(growth["points"]),"trained":trained,"equipment":equipped,"improved_gear":improved,
			"stress":int(current.get("stress",0)),"statuses":statuses,"dead":bool(current.get("dead",false)),
			"deaths_door":bool(current.get("deaths_door",false)) or int(current.get("hp",maximum)) <= 0})
	return party

static func departure_advice(state) -> Dictionary:
	var party: Array[Dictionary] = party_snapshot(state)
	var veteran: bool = str(state.selected_expedition.get("difficulty","")).contains("Veteran")
	var low: int = 10
	var high: int = 1
	var geared: int = 0
	var points: int = 0
	var trained: int = 0
	for hero in party:
		low = mini(low,int(hero["level"]))
		high = maxi(high,int(hero["level"]))
		geared += 1 if hero["improved_gear"] else 0
		points += int(hero["points"])
		trained += 1 if hero["trained"] else 0
	var text: String = "Spend level points in the Barracks before departure. Supplies help counter wounds; the party acts in any order."
	if veteran:
		text = "Veteran suggestion: level 3+ with trained stats and gear from earlier expeditions. Party Lv %d–%d · improved gear %d/%d." % [low,high,geared,party.size()]
		if points > 0: text += " %d unspent training points; visit the Barracks first." % points
		elif low >= 3 and geared == party.size() and trained == party.size(): text += " Suggested preparation met; recovery and tactics still matter."
	else:
		text = "%d unspent training point%s. Train in the Barracks before departure. Bring healing and cleansers for the descent." % [points,"" if points == 1 else "s"] if points > 0 else "Shared party turns: heroes act in any order. Healing and cleansers help sustain a longer expedition."
	return {"veteran":veteran,"suggested_level":3 if veteran else 1,"level_ready":low >= 3 if veteran else true,
		"gear_ready":geared == party.size(),"training_ready":trained == party.size(),"points":points,"text":text}

static func known_unused_camps(state) -> Array[Dictionary]:
	var camps: Array[Dictionary] = []
	if not state.run_active or state.floor_index < 0 or state.floor_index >= state.floors.size(): return camps
	var rooms: Dictionary = state.floors[state.floor_index]
	for location in rooms:
		var room: Dictionary = rooms[location]
		if room.get("kind","") != "camp" or not room.get("seen",false) or room.get("camp_used",false): continue
		camps.append({"name":str(room.get("name","Camp")),"location":location})
	camps.sort_custom(func(a,b): return a["location"].y < b["location"].y or (a["location"].y == b["location"].y and a["location"].x < b["location"].x))
	return camps

static func descent_advice(state) -> String:
	var critical: Array[String] = []
	var wounded: Array[String] = []
	var debuffed: Array[String] = []
	var stressed: Array[String] = []
	var fallen: Array[String] = []
	var points: int = 0
	for hero in party_snapshot(state,true):
		points += int(hero["points"])
		if hero["dead"]:
			fallen.append(hero["name"])
			continue
		if hero["deaths_door"]: critical.append(hero["name"])
		elif int(hero["hp"]) < int(hero["max_hp"])*0.5: wounded.append(hero["name"])
		if not hero["statuses"].is_empty(): debuffed.append(hero["name"])
		if int(hero["stress"]) >= 80: stressed.append(hero["name"])
	var advice: Array[String] = []
	if not critical.is_empty(): advice.append("Death's Door: %s. Recover before another damaging hit; it can kill a hero here." % ", ".join(critical))
	elif not wounded.is_empty(): advice.append("Low health: %s. Consider recovering before the next floor." % ", ".join(wounded))
	if not debuffed.is_empty(): advice.append("Active debuffs: %s. Camp clears debuffs and restores living heroes to full health." % ", ".join(debuffed))
	if not stressed.is_empty(): advice.append("High stress: %s. Camp reduces current stress by 90%%." % ", ".join(stressed))
	if not fallen.is_empty(): advice.append("Slain: %s. Camp cannot revive fallen companions." % ", ".join(fallen))
	if points > 0: advice.append("%d unspent level points can be trained at the Barracks between runs." % points)
	var camps: Array[Dictionary] = known_unused_camps(state)
	if camps.is_empty():
		advice.append("No discovered unused camp is marked. You may explore this floor for recovery before leaving.")
	else:
		var places: Array[String] = []
		for camp in camps: places.append("%s (map %d, %d)" % [camp["name"],camp["location"].x+1,camp["location"].y+1])
		advice.append("Discovered unused camps: " + "; ".join(places) + ".")
	return "\n".join(advice)

static func next_threat(state) -> String:
	var id: String = str(state.selected_expedition.get("id",""))
	match id:
		"old_road":
			if state.floor_index == 0: return "The keep's guards hit harder; crossbows threaten the rear. Recover, explore for supplies, and bring cleansing for Bleed, Poison and Chill."
			if state.floor_index == 1: return "The Undying Lord is healed while its support survives. Defeat that attendant first; wolf guards can pull rear heroes forward."
		"path_beast":
			if state.floor_index == 0: return "The Coterie brings three consecutive forms in one battle. Each form has a rite you can break for 1 AP; preserve health for the whole fight."
			if state.floor_index == 1: return "The Howling Head's hymns bring Stress and Chill. Silence its choir idol for 1 AP to weaken Unending Prayer; protect wounded allies."
	return "The next floor brings stronger foes. Explore for supplies and recover before descending if the party is wounded."
