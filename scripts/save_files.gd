extends RefCounted
const State = preload("res://scripts/game_data.gd")
static var directory: String = "user://saves/"
static func path(slot: int) -> String:
	return directory + ("checkpoint.cfg" if slot == 0 else "slot_%d.cfg" % slot)
static func summary(slot: int) -> String:
	var cfg := ConfigFile.new()
	if cfg.load(path(slot)) != OK: return "Empty"
	return str(cfg.get_value("save", "summary", "Saved journey"))
static func save(slot: int) -> bool:
	if slot < 0 or slot > 3: return false
	DirAccess.make_dir_recursive_absolute(directory)
	var data: Dictionary = {
		"hero_progress": State.hero_progress, "party": State.party, "gold": State.gold, "inventory": State.inventory,
		"equipment": State.equipment, "card_levels": State.card_levels, "discovered": State.discovered,
		"completed": State.completed_expeditions, "crusader": State.crusader_unlocked,
		"modifications": State.modifications, "names": State.hero_names, "colors": State.hero_colors,
		"graves": State.graves, "deeds": State.run_deeds, "run_id": State.run_id,
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
	var cfg := ConfigFile.new()
	if slot < 0 or slot > 3 or cfg.load(path(slot)) != OK or cfg.get_value("save", "version", 0) != 1: return false
	var data: Variant = cfg.get_value("save", "data", null)
	if not data is Dictionary: return false
	for key in ["party", "gold", "inventory", "equipment", "card_levels", "discovered", "completed", "crusader", "modifications", "names", "colors", "formation", "expedition", "active", "complete", "floor", "count", "floors", "position", "heroes", "seed", "rng", "scouts"]:
		if not data.has(key): return false
	if not data["party"] is Array or data["party"].size() != 3: return false
	for id in data["party"]:
		if not State.HEROES.has(id): return false
	for key in ["inventory", "equipment", "card_levels", "modifications", "names", "colors", "formation", "heroes"]:
		if not data[key] is Dictionary: return false
	if State.expedition_by_id(str(data["expedition"])).is_empty(): return false
	if data["active"] and (not data["floors"] is Array or int(data["floor"]) < 0 or int(data["floor"]) >= data["floors"].size() or not data["floors"][int(data["floor"])].has(data["position"])): return false
	if not data.get("hero_progress", {}) is Dictionary: return false
	State.hero_progress = data.get("hero_progress", {})
	State.party.assign(data["party"])
	State.gold = data["gold"]
	State.inventory = data["inventory"]
	State.equipment = data["equipment"]
	State.card_levels = data["card_levels"]
	State.discovered.assign(data["discovered"])
	State.completed_expeditions.assign(data["completed"])
	State.crusader_unlocked = data["crusader"]
	State.modifications = data["modifications"]
	State.hero_names = data["names"]
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
	State.navigation_votes.clear()
	State.progress_loaded = true
	State.save_progression()
	return true
