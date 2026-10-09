extends RefCounted

const Rules = preload("res://scripts/encounter_rules.gd")
const EVENTS = {
 "crusader_coffin": {"name": "The Thornbound Prisoner", "description": "A spiked iron coffin rattles inside the bandits' jail. A crusader whispers from behind its barbed locks: 'Let me feel the road again.'", "risk": "Open the coffin: the chosen hero loses 2–3 HP, ignoring protection. Requires enough health to survive. Permanently recruits the Penitent Crusader to the Barracks."},
	"bandit_strongbox": {"name": "The Abandoned Strongbox", "description": "A rusted lock guards an outlaw's forgotten wages. Something sharp glints beneath the lid.", "risk": "Possible rewards: gold or equipment. Risk: a blade trap causes Bleed for two combat rounds.", "status": "bleed"},
	"bandit_supplies": {"name": "The Tainted Supply Cache", "description": "Cracked bottles and stained wrappings crowd a stolen crate. A sealed scroll lies beneath them.", "risk": "Possible rewards: gold or a spell scroll. Risk: tainted residue causes Poison for two combat rounds.", "status": "poison"},
	"beast_reliquary": {"name": "The Votive Reliquary", "description": "A scroll rests inside a bone shrine. Its candles still burn, though no pilgrim remains to tend them.", "risk": "Possible rewards: gold or a spell scroll. Risk: the votive flame causes Burn for two combat rounds.", "status": "burn"},
	"beast_offering": {"name": "The Stitched Offering", "description": "The congregation bound its treasures inside a remade vessel. The seams tremble as you approach.", "risk": "Possible rewards: gold or equipment. Risk: a cold benediction causes Chill for two combat rounds.", "status": "chill"},
}

static func pool(faction: String) -> Array:
	return ["beast_reliquary", "beast_offering"] if faction == "remade" else ["bandit_strongbox", "bandit_supplies"]

static func definition(id: String) -> Dictionary:
	return EVENTS.get(id, {})

static func resolve(state, hero_id: String, leave: bool = false, action: String = "investigate") -> Dictionary:
	if not state.run_active or state.current_room_kind() != "event":
		return {}
	var room: Dictionary = state.floors[state.floor_index][state.room_position]
	if room.get("event_resolved", false):
		return {}
	var event: Dictionary = definition(str(room.get("event_id", "")))
	if event.is_empty():
		return {}
	state.ensure_run_heroes()
	var option: Dictionary = state.Mechanics.event_option(str(room.get("event_id", "")), hero_id) if action == "class" else {}
	if action == "class" and (option.is_empty() or int(state.run_heroes.get(hero_id, {}).get("hp", 0)) <= int(option.get("cost", 0))):
		return {}
	if not leave and (not state.party.has(hero_id) or state.run_heroes[hero_id].get("dead", false) or int(state.run_heroes[hero_id]["hp"]) <= 0):
		return {}
	if str(room.get("event_id", "")) == "crusader_coffin":
		if leave:
			return {}
		var rescue_rng := RandomNumberGenerator.new()
		rescue_rng.seed = int(room["event_seed"])
		var cost: int = rescue_rng.randi_range(2, 3)
		if int(state.run_heroes[hero_id]["hp"]) <= cost:
			return {}
		state.load_progression()
		if state.crusader_unlocked:
			return {}
		state.run_heroes[hero_id]["hp"] -= cost
		state.crusader_unlocked = true
		state.save_progression()
		var rescued: Dictionary = {"hero": hero_id, "gold": 0, "item": "", "status": "", "left": false, "damage": cost, "text": "%s loses %d HP to the barbed lock. The Penitent Crusader is free and awaits you in the Barracks." % [state.hero(hero_id)["name"], cost]}
		room["event_resolved"] = true
		room["cleared"] = true
		room["event_result"] = rescued
		return rescued
	# Use a room-specific seed so reopening or retreating cannot reroll this event.
	var rng := RandomNumberGenerator.new()
	rng.seed = int(room["event_seed"])
	var result: Dictionary = {"hero": hero_id, "gold": 0, "item": "", "status": "", "left": leave}
	if leave:
		result["text"] = "You leave the object untouched. The party passes safely."
	else:
		var roll: float = rng.randf()
		if not option.is_empty():
			state.run_heroes[hero_id]["hp"] -= int(option["cost"])
		var rewards: Array[String] = []
		# 50% reward, 25% reward with a curse, 25% curse alone.
		if roll < 0.75 or not option.is_empty():
			if rng.randf() < 0.55:
				result["gold"] = rng.randi_range(5, 12)
				state.gold += int(result["gold"])
				rewards.append("Recovered %d Gold." % result["gold"])
			else:
				var id: String = state.Items.roll_scroll(rng) if str(room["event_id"]) in ["bandit_supplies", "beast_reliquary"] else state.Items.roll_equipment(rng, state.party)
				if id != "":
					state.add_item(id)
					result["item"] = id
					rewards.append("Found %s." % state.Items.item(id)["name"])
		if (roll >= 0.5 if option.is_empty() else rng.randf() < float(option["curse_chance"])):
			result["status"] = str(event["status"])
			if state.try_hero_status(hero_id, state.run_heroes[hero_id]["statuses"], str(result["status"]), 1.0, rng.randf() * 100.0):
				rewards.append("%s suffers %s for the next two combat rounds." % [state.hero(hero_id)["name"], str(result["status"]).capitalize()])
			else:
				rewards.append("%s resists %s." % [state.hero(hero_id)["name"], str(result["status"]).capitalize()])
				result["status"] = ""
		result["text"] = "\n".join(rewards)
		if not option.is_empty():
			result["text"] = "%s · Pay %d HP\n" % [option["name"], int(option["cost"])] + str(result["text"])
	room["event_resolved"] = true
	room["cleared"] = true
	room["event_result"] = result
	return result
