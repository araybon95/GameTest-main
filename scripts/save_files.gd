extends RefCounted
const State = preload("res://scripts/game_data.gd")
static var directory: String = "user://saves/"
static func path(slot: int) -> String:
	return directory + ("checkpoint.cfg" if slot == 0 else "slot_%d.cfg" % slot)
static func summary(slot: int) -> String:
	return str(slot_info(slot)["summary"])

static func slot_info(slot: int) -> Dictionary:
	var result: Dictionary = {"loadable":false,"summary":"Empty","detail":"","error":"","data":{}}
	if slot < 0 or slot > 3:
		result.error = "Unknown save slot."
		return result
	if not FileAccess.file_exists(path(slot)): return result
	var cfg := ConfigFile.new()
	if cfg.load(path(slot)) != OK:
		result.summary = "Unreadable save"
		result.error = "The save file could not be read. Choose another slot; this file was left unchanged."
		return result
	if cfg.get_value("save","version",0) != 1:
		result.summary = "Unsupported save version"
		result.error = "This save uses an unsupported version. Choose another slot or a compatible game version."
		return result
	var data: Variant = cfg.get_value("save","data",null)
	var error: String = validation_error(data)
	if not error.is_empty():
		result.summary = "Invalid saved journey"
		result.error = error + " The current journey and this file were left unchanged."
		return result
	result.loadable = true
	result.data = data
	result.summary = str(cfg.get_value("save","summary","Saved journey"))
	var heroes: Array[String] = []
	for id in data.party:
		var growth: Dictionary = data.get("hero_progress",{}).get(id,{})
		heroes.append("%s Lv %d" % [State.HEROES[id]["name"],int(growth.get("level",1))])
	result.detail = " · ".join(heroes)
	return result

static func validation_error(data: Variant) -> String:
	if not data is Dictionary: return "The save contains no journey data."
	for key in ["party","gold","inventory","equipment","card_levels","discovered","completed","crusader","modifications","names","colors","formation","expedition","active","complete","floor","count","floors","position","heroes","seed","rng","scouts"]:
		if not data.has(key): return "Missing journey field: " + key + "."
	for key in ["party","discovered","completed","floors"]:
		if not data[key] is Array: return "Invalid journey list: " + key + "."
	for key in ["discovered","completed"]:
		for id in data[key]:
			if not id is String: return "Invalid entry in journey list: " + key + "."
	if data.party.size() != 3: return "A saved party must contain three heroes."
	var unique: Array = []
	for id in data.party:
		if not id is String or not State.HEROES.has(id) or unique.has(id): return "The saved party contains an unknown or repeated hero."
		unique.append(id)
	for key in ["inventory","equipment","card_levels","modifications","names","colors","formation","heroes","hero_progress","hero_journals","item_histories","item_favourites","hero_outfits","hero_portraits","hero_positions","journey","last_report","deeds"]:
		if not data.get(key,{}) is Dictionary: return "Invalid journey record: " + key + "."
	for key in ["gold","floor","count","seed","rng","scouts"]:
		if not data[key] is int: return "Invalid journey number: " + key + "."
	for key in ["active","complete","crusader"]:
		if not data[key] is bool: return "Invalid journey flag: " + key + "."
	if data.gold < 0 or data.scouts < 0 or not data.position is Vector2i: return "Invalid saved resources or location."
	for key in ["inventory","card_levels","hero_positions"]:
		for id in data.get(key,{}):
			if not data[key][id] is int or data[key][id] < 0: return "Invalid count in " + key + "."
	for key in ["names","colors","formation","hero_outfits","hero_portraits"]:
		for value in data.get(key,{}).values():
			if not value is String: return "Invalid hero detail: " + key + "."
	for value in data.modifications.values():
		if not value is String: return "Invalid equipment modification."
	if not data.expedition is String or State.expedition_by_id(data.expedition).is_empty(): return "The saved expedition is unknown."
	if not data.get("graves",[]) is Array: return "Invalid memorial records."
	for grave in data.get("graves",[]):
		if not grave is Dictionary: return "Invalid memorial record."
	for id in data.equipment:
		if not data.equipment[id] is Dictionary: return "Invalid hero equipment."
		for item in data.equipment[id].values():
			if not item is String: return "Invalid equipped item."
	for id in data.get("hero_progress",{}):
		var growth: Variant = data.hero_progress[id]
		if not growth is Dictionary or not growth.get("stats",{}) is Dictionary: return "Invalid hero progression."
		for key in ["level","xp","points"]:
			if not growth.get(key,0) is int: return "Invalid hero progression number."
		for value in growth.get("stats",{}).values():
			if not value is int: return "Invalid hero training value."
	for entry in data.get("item_histories",{}).values():
		if not entry is Dictionary: return "Invalid item history."
	for id in data.heroes:
		var hero: Variant = data.heroes[id]
		if not hero is Dictionary or not hero.get("hp") is int or not hero.get("statuses",{}) is Dictionary: return "Invalid saved hero state."
		for key in ["stress","block"]:
			if not hero.get(key,0) is int: return "Invalid saved hero number."
		for key in ["dead","deaths_door"]:
			if not hero.get(key,false) is bool: return "Invalid saved hero flag."
		for effect in hero.get("statuses",{}).values():
			if not effect is Dictionary: return "Invalid saved status effect."
			for key in ["turns","damage","stacks","base_damage"]:
				if effect.has(key) and not effect[key] is int: return "Invalid saved status number."
	if data.active:
		if data.count != data.floors.size() or data.floor < 0 or data.floor >= data.floors.size() or not data.position is Vector2i: return "Invalid saved floor or location."
		for floor in data.floors:
			if not floor is Dictionary: return "Invalid saved floor map."
			for location in floor:
				var room: Variant = floor[location]
				if not location is Vector2i or not room is Dictionary or not room.get("kind") is String or not room.get("cleared") is bool or not room.get("seen") is bool: return "Invalid saved room."
		if not data.floors[data.floor].has(data.position): return "The saved location does not exist."
		for id in data.party:
			if not data.heroes.has(id): return "A saved party hero is missing."
	var runtime_error: String = _runtime_validation_error(data)
	if not runtime_error.is_empty(): return runtime_error
	for hero_id in data.equipment:
		if not hero_id is String and not hero_id is StringName: return "Invalid hero equipment owner."
	# Gear that no longer fits its hero is unequipped on load, not a reason to refuse the save.
	return ""

## Splits saved equipment into gear that still fits and gear to return to the pack.
## Unknown items are dropped. The weapon is checked first so it wins an off-hand conflict.
static func repair_equipment(equipment: Dictionary, histories: Dictionary) -> Dictionary:
	var rules = preload("res://scripts/weapon_rules.gd")
	var kept: Dictionary = {}
	var returned: Array[String] = []
	var dropped: Array[String] = []
	for hero_id in equipment:
		var loadout: Dictionary = {}
		var slots: Array = equipment[hero_id].keys()
		slots.sort_custom(func(a, b): return a == "weapon" and b != "weapon")
		for slot in slots:
			var item_id: String = equipment[hero_id][slot]
			var candidate: Dictionary = loadout.duplicate()
			candidate[slot] = item_id
			if rules.loadout_error(State,hero_id,candidate,histories).is_empty(): loadout[slot] = item_id
			elif State.Items.EQUIPMENT.has(str(histories.get(item_id,{}).get("base",item_id))): returned.append(item_id)
			else: dropped.append(item_id)
		if State.HEROES.has(hero_id): kept[hero_id] = loadout
	return {"equipment":kept,"returned":returned,"dropped":dropped}

static func _record_matches(value: Variant, fields: Dictionary, required: Array = []) -> bool:
	if not value is Dictionary: return false
	for key in required:
		if not value.has(key): return false
	for key in fields:
		if value.has(key) and typeof(value[key]) != fields[key]: return false
	return true

static func _list_matches(value: Variant, entry_type: int) -> bool:
	if not value is Array: return false
	for entry in value:
		if typeof(entry) != entry_type: return false
	return true

static func _string_map_matches(value: Variant, entry_type: int) -> bool:
	if not value is Dictionary: return false
	for key in value:
		if not key is String or typeof(value[key]) != entry_type: return false
	return true

static func _runtime_validation_error(data: Dictionary) -> String:
	# Validate fields their consumers dereference before load_slot changes State.
	# Absent later records still use the existing version-1 legacy defaults.
	if not data.get("run_id","") is String: return "Invalid saved run identity."
	if not data.get("equipment_appearance",true) is bool: return "Invalid equipment appearance flag."
	if not preload("res://scripts/equipment_looks.gd").valid_weapon_costumes(data.get("legacy_weapon_costumes",{})): return "Invalid retained weapon costume."
	var hero_fields := {"stress":TYPE_INT,"block":TYPE_INT,"max_hp":TYPE_INT,"damage_mod":TYPE_INT,"stress_per_turn":TYPE_INT,"dead":TYPE_BOOL,"deaths_door":TYPE_BOOL,"resolved":TYPE_BOOL,"resolve_tag":TYPE_STRING,"resolve_type":TYPE_STRING,"buffs":TYPE_DICTIONARY}
	for id in data.heroes:
		var hero: Dictionary = data.heroes[id]
		var required: Array = ["stress","damage_mod","stress_per_turn","dead","deaths_door","resolved","resolve_tag","resolve_type"] if data.active and data.party.has(id) else []
		if not _record_matches(hero,hero_fields,required): return "Invalid saved hero combat details."
		for effect_id in hero.get("statuses",{}):
			var effect: Dictionary = hero.statuses[effect_id]
			if not effect_id is String or not effect.has("turns"): return "Invalid saved status duration."
			if effect_id != "chill" and not effect.has("damage") and not effect.has("base_damage"): return "Missing saved status damage."
		for effect in hero.get("buffs",{}).values():
			if not _record_matches(effect,{"turns":TYPE_INT,"amount":TYPE_INT},["turns","amount"]): return "Invalid saved temporary buff."
	var journey: Dictionary = data.get("journey",{})
	if not _record_matches(journey,{"start_gold":TYPE_INT,"steps":TYPE_INT,"rations":TYPE_INT,"kills":TYPE_INT,"loot":TYPE_DICTIONARY,"xp":TYPE_DICTIONARY,"levels":TYPE_DICTIONARY,"boons":TYPE_DICTIONARY,"passages":TYPE_DICTIONARY,"transit":TYPE_DICTIONARY,"passage_watch":TYPE_BOOL,"recent_discoveries":TYPE_ARRAY}): return "Invalid saved journey details."
	for key in ["loot","xp","levels"]:
		if not _string_map_matches(journey.get(key,{}),TYPE_INT): return "Invalid saved journey totals."
	if not _string_map_matches(journey.get("boons",{}),TYPE_BOOL): return "Invalid saved camp preparation."
	if not _list_matches(journey.get("recent_discoveries",[]),TYPE_VECTOR2I): return "Invalid saved discoveries."
	if not _string_map_matches(journey.get("passages",{}),TYPE_DICTIONARY): return "Invalid saved hallway records."
	for event in journey.get("passages",{}).values():
		if not _record_matches(event,{"key":TYPE_STRING,"kind":TYPE_STRING,"resolved":TYPE_BOOL,"room":TYPE_DICTIONARY,"result":TYPE_DICTIONARY,"destination":TYPE_VECTOR2I},["key","kind","resolved"]): return "Invalid saved hallway event."
		if event.kind == "curio" and not _record_matches(event.get("room"),{"event_id":TYPE_STRING},["event_id"]): return "Invalid saved hallway curio."
	var transit: Dictionary = journey.get("transit",{})
	if not transit.is_empty():
		if not _record_matches(transit,{"run_id":TYPE_STRING,"floor":TYPE_INT,"origin":TYPE_VECTOR2I,"route":TYPE_ARRAY,"index":TYPE_INT,"stage":TYPE_STRING,"event_key":TYPE_STRING,"event_done":TYPE_BOOL},["run_id","floor","origin","route","index","stage","event_key","event_done"]): return "Invalid saved hallway traversal."
		if not _list_matches(transit.route,TYPE_VECTOR2I): return "Invalid saved hallway route."
	for journal in data.get("hero_journals",{}).values():
		if not _record_matches(journal,{"voice":TYPE_INT,"generation":TYPE_INT,"keys":TYPE_ARRAY,"memories":TYPE_ARRAY,"ties":TYPE_DICTIONARY},["generation","keys","memories","ties"]): return "Invalid saved hero journal."
		if not _list_matches(journal.keys,TYPE_STRING) or not _list_matches(journal.memories,TYPE_STRING) or not _string_map_matches(journal.ties,TYPE_INT): return "Invalid saved hero memories or bonds."
	for history in data.get("item_histories",{}).values():
		if not _record_matches(history,{"base":TYPE_STRING,"name":TYPE_STRING,"hero":TYPE_STRING,"origin":TYPE_STRING,"transformation":TYPE_STRING,"milestone":TYPE_STRING,"deeds":TYPE_ARRAY,"keys":TYPE_ARRAY,"owners":TYPE_ARRAY,"victories":TYPE_ARRAY}): return "Invalid saved item history details."
		for key in ["deeds","keys","owners","victories"]:
			if not _list_matches(history.get(key,[]),TYPE_STRING): return "Invalid saved item memories."
	var report: Dictionary = data.get("last_report",{})
	if not _record_matches(report,{"dungeon":TYPE_STRING,"complete":TYPE_BOOL,"floor":TYPE_INT,"gold":TYPE_INT,"kills":TYPE_INT,"rooms":TYPE_INT,"loot":TYPE_DICTIONARY,"survivors":TYPE_ARRAY,"fallen":TYPE_ARRAY,"cosmetic_reward":TYPE_STRING}): return "Invalid saved expedition report."
	for group in ["survivors","fallen"]:
		for hero in report.get(group,[]):
			if not _record_matches(hero,{"id":TYPE_STRING,"name":TYPE_STRING,"class":TYPE_STRING,"level":TYPE_INT,"old_level":TYPE_INT,"xp":TYPE_INT,"hp":TYPE_INT,"stress":TYPE_INT,"deeds":TYPE_DICTIONARY},["id","name","class","level","old_level","xp","hp","stress"]): return "Invalid saved expedition survivor."
	if data.active:
		for floor in data.floors:
			for room in floor.values():
				if room.kind in ["battle","boss"] and room.has("enemies"):
					if not _list_matches(room.enemies,TYPE_STRING) or room.enemies.is_empty(): return "Invalid saved enemy roster."
	return ""

static func save(slot: int) -> bool:
	if slot < 0 or slot > 3: return false
	DirAccess.make_dir_recursive_absolute(directory)
	var data: Dictionary = {
		"hero_positions": State.hero_positions, "journey": State.journey, "last_report": State.last_report, "hero_progress": State.hero_progress, "party": State.party, "gold": State.gold, "inventory": State.inventory,
		"equipment": State.equipment, "card_levels": State.card_levels, "discovered": State.discovered,
		"completed": State.completed_expeditions, "crusader": State.crusader_unlocked,
		"modifications": State.modifications, "names": State.hero_names, "colors": State.hero_colors,
		"graves": State.graves, "deeds": State.run_deeds, "run_id": State.run_id,
		"hero_journals": State.hero_journals,
		"item_histories": State.Items.histories,
		"item_favourites": State.Items.favourites,
		"equipment_appearance":State.equipment_appearance,
		"legacy_weapon_costumes":State.legacy_weapon_costumes,
		"hero_outfits":State.hero_outfits,"hero_portraits":State.hero_portraits,
		"formation": State.formation, "expedition": State.selected_expedition.get("id", "old_road"),
		"active": State.run_active, "complete": State.run_complete, "floor": State.floor_index,
		"count": State.floor_count, "floors": State.floors, "position": State.room_position,
		"heroes": State.run_heroes, "seed": State.run_seed, "rng": State.loot_rng.state, "scouts": State.scout_uses
	}
	var cfg := ConfigFile.new()
	cfg.set_value("save", "version", 1)
	cfg.set_value("save", "data", data)
	cfg.set_value("save", "summary", "%s | %s | %d gold" % [Time.get_datetime_string_from_system().replace("T", " "), State.selected_expedition.get("name", "Hamlet") + " - Floor %d" % (State.floor_index + 1) if State.run_active else "Hamlet", State.gold])
	var temp: String = path(slot) + ".tmp"
	if cfg.save(temp) != OK: return false
	# Replace only after the complete new file has been written.
	return DirAccess.rename_absolute(temp, path(slot)) == OK
static func load_slot(slot: int) -> bool:
	var info: Dictionary = slot_info(slot)
	if not info.loadable: return false
	var data: Dictionary = info.data
	var retained: Dictionary = preload("res://scripts/equipment_looks.gd").migrate_weapon_costumes(State,data)
	State.legacy_weapon_costumes = retained
	State.hero_positions = data.get("hero_positions", {})
	State.journey = data.get("journey", {})
	State.last_report = data.get("last_report", {})
	State.hero_progress = data.get("hero_progress", {})
	State.party.assign(data["party"])
	State.gold = data["gold"]
	State.inventory = data["inventory"]
	var repaired: Dictionary = repair_equipment(data["equipment"],data.get("item_histories",{}))
	State.equipment = repaired.equipment
	for item_id in repaired.returned: State.inventory[item_id] = int(State.inventory.get(item_id,0))+1
	if not repaired.returned.is_empty() or not repaired.dropped.is_empty():
		push_warning("Save %d: unequipped %s; removed unknown %s" % [slot, repaired.returned, repaired.dropped])
	State.card_levels = data["card_levels"]
	State.discovered.assign(data["discovered"])
	State.completed_expeditions.assign(data["completed"])
	State.crusader_unlocked = data["crusader"]
	State.modifications = data["modifications"]
	State.hero_names = data["names"]
	State.hero_journals = data.get("hero_journals", {})
	State.Items.histories = data.get("item_histories", {})
	State.Items.favourites = data.get("item_favourites", {})
	State.equipment_appearance = bool(data.get("equipment_appearance",true))
	State.hero_outfits = data.get("hero_outfits", {})
	State.hero_portraits = data.get("hero_portraits", {})
	State.hero_colors = data["colors"]
	for grave in data.get("graves", []):
		if not State.graves.any(func(existing): return existing.get("id", "") == grave.get("id", "")): State.graves.append(grave)
	State.run_deeds = data.get("deeds", {})
	State.run_id = data.get("run_id", str(Time.get_unix_time_from_system()))
	State.formation = data["formation"]
	State.selected_expedition = State.expedition_by_id(data["expedition"])
	State.run_active = data["active"]
	State.run_complete = data["complete"]
	State.floor_index = data["floor"]
	State.floor_count = data["count"]
	State.floors = data["floors"]
	State.room_position = data["position"]
	State.run_heroes = data["heroes"]
	State.run_seed = data["seed"]
	State.loot_rng.state = data["rng"]
	State.scout_uses = data["scouts"]
	State.Depth.normalize_positions(State)
	if State.run_active and State.journey.is_empty(): State.journey = State.Depth.begin_journey(State)
	State.navigation_votes.clear()
	State.progress_loaded = true
	State.save_progression()
	return true
