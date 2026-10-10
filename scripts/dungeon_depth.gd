extends RefCounted
## Tactical positions and journey systems; no light, quirks or persistent injuries.
const SKILL_RANKS = {
 "wd_slash": {"use": [1,2], "target": [1,2]}, "wd_bash": {"use": [1,2], "target": [1,2]}, "wd_heavy": {"use": [1,2], "target": [1,2]},
 "rg_quick": {"use": [2,3], "target": [1,2,3]}, "rg_pierce": {"use": [2,3], "target": [1,2,3]}, "rg_volley": {"use": [2,3], "target": [1,2,3]},
 "oc_drain": {"use": [1,2], "target": [1,2,3]}, "oc_blast": {"use": [2,3], "target": [1,2,3]},
 "hl_smite": {"use": [1,2], "target": [1,2]},
 "pc_strike": {"use": [1,2], "target": [1,2]}, "pc_verdict": {"use": [1,2], "target": [1,2]}, "pc_charge": {"use": [2,3], "target": [1,2]}
}
const CAMP_CHOICES = {
 "watch": {"name": "Keep Watch", "cost": 2, "description": "Prevent this camp's ambush."},
 "ward": {"name": "Protective Rite", "cost": 1, "description": "+15% debuff resistance next battle."},
 "sharpen": {"name": "Ready Weapons", "cost": 1, "description": "+10% skill damage next battle."},
 "scout": {"name": "Study the Route", "cost": 1, "description": "Reveal nearby rooms without spending a scouting use."}
}
const EVENT_SUPPLIES = {"bandit_strongbox":"lock_tools", "bandit_supplies":"cleansing_herbs", "beast_reliquary":"cleansing_herbs", "beast_offering":"bandage", "crusader_coffin":"bandage"}
static func position_of(state, id: String) -> int:
	var order: Array = state.party.duplicate()
	order.sort_custom(func(a,b): return int(state.formation.get(a,state.Mechanics.default_rank(a)) == "rear") < int(state.formation.get(b,state.Mechanics.default_rank(b)) == "rear"))
	return int(state.hero_positions.get(id, order.find(id) + 1))
static func normalize_positions(state) -> void:
	var used: Array = []
	var valid: bool = state.hero_positions.size() == state.party.size()
	for id in state.party:
		var rank: int = int(state.hero_positions.get(id,0))
		if rank < 1 or rank > state.party.size() or used.has(rank): valid = false
		used.append(rank)
	if valid: return
	state.hero_positions.clear()
	var order: Array = state.party.duplicate()
	order.sort_custom(func(a,b): return int(state.rank_of(str(a)) == "rear") < int(state.rank_of(str(b)) == "rear"))
	for index in range(order.size()): state.hero_positions[order[index]] = index + 1
static func move_hero(state, id: String, destination: int) -> bool:
	if not state.party.has(id) or destination < 1 or destination > state.party.size(): return false
	normalize_positions(state)
	var previous: int = position_of(state,id)
	if previous == destination: return false
	for other in state.party:
		if other != id and position_of(state,str(other)) == destination:
			state.hero_positions[other] = previous
			state.formation[other] = "front" if previous == 1 else "rear"
			break
	state.hero_positions[id] = destination
	state.formation[id] = "front" if destination == 1 else "rear"
	return true
static func skill_rule(id: String) -> Dictionary:
	return SKILL_RANKS.get(id, {"use": [1,2,3], "target": [1,2,3]})
static func skill_allowed(state, hero_id: String, skill: String, target: int) -> bool:
	var rule: Dictionary = skill_rule(skill)
	return rule["use"].has(position_of(state,hero_id)) and rule["target"].has(target)
static func rank_text(id: String) -> String:
	var rule: Dictionary = skill_rule(id)
	return "Use %s · Reach %s" % [str(rule["use"]).replace(" ",""),str(rule["target"]).replace(" ","")]
static func role(creature: String, support: bool = false) -> String:
	if support: return "Support"
	if creature in ["ash_raider","keep_footman","keep_wolfguard"]: return "Defender"
	if creature in ["gallows_scout","keep_crossbow"]: return "Marksman"
	if creature in ["anguish_vessel","moth_metamorph","coterie_seamkeeper"]: return "Zealot"
	return "Striker"
static func begin_journey(state) -> Dictionary:
	var levels: Dictionary = {}
	for id in state.party: levels[id] = state.leveling(str(id))["level"]
	return {"start_gold": state.gold, "steps": 0, "rations": 3, "kills": 0, "loot": {}, "xp": {}, "levels": levels, "boons": {}}
static func explore(state, room: Dictionary) -> void:
	if room.get("travel_counted",false): return
	room["travel_counted"] = true
	state.journey["steps"] = int(state.journey.get("steps",0)) + 1
	if int(state.journey["steps"]) % 6 != 0: return
	var fed: bool = false
	if int(state.journey.get("rations",0)) > 0:
		state.journey["rations"] -= 1
		fed = true
	elif int(state.inventory.get("trail_food",0)) > 0:
		fed = state.consume_item("trail_food")
	if fed:
		room["travel_text"] = "The party shares a ration. Hunger passes; each survivor recovers 3 HP."
	else:
		room["travel_text"] = "No rations remain. Hunger adds 6 Stress to each survivor."
	for id in state.party:
		var hero: Dictionary = state.run_heroes.get(id,{})
		if hero.is_empty() or hero.get("dead",false): continue
		if fed:
			hero["hp"] = mini(state.hero_max_hp(str(id)),int(hero["hp"]) + 3)
			hero["deaths_door"] = false
		else: hero["stress"] = mini(100,int(hero.get("stress",0)) + 6)
static func prepare_camp(state, choice: String) -> bool:
	if not state.run_active or state.current_room_kind() != "camp" or not CAMP_CHOICES.has(choice): return false
	var room: Dictionary = state.floors[state.floor_index][state.room_position]
	var spent: Array = room.get("camp_choices",[])
	var points: int = int(room.get("camp_points",3))
	var cost: int = int(CAMP_CHOICES[choice]["cost"])
	if not room.get("camp_used",false) or spent.has(choice) or points < cost: return false
	spent.append(choice)
	room["camp_choices"] = spent
	room["camp_points"] = points - cost
	if choice in ["ward","sharpen"]:
		var boons: Dictionary = state.journey.get("boons",{})
		boons[choice] = true
		state.journey["boons"] = boons
	elif choice == "scout":
		var before: int = state.scout_uses
		state.scout_uses = maxi(1,before)
		state.scout_area()
		state.scout_uses = before
	return true
static func camp_ambush(state) -> bool:
	var room: Dictionary = state.floors[state.floor_index][state.room_position]
	if not room.get("camp_used",false) or room.get("camp_departed",false): return false
	room["camp_departed"] = true
	if room.get("camp_choices",[]).has("watch"): return false
	var rng := RandomNumberGenerator.new()
	rng.seed = state.run_seed + state.floor_index * 991 + state.room_position.x * 97 + state.room_position.y * 41
	if rng.randf() >= 0.15: return false
	var enemy: String = str(state.selected_expedition.get("creature","ash_raider"))
	var pool: Array = state.selected_expedition.get("floor_enemy_pools",[])
	if state.floor_index < pool.size() and not pool[state.floor_index].is_empty(): enemy = str(pool[state.floor_index][0])
	room["kind"] = "battle"
	room["enemies"] = [enemy]
	room["creature"] = enemy
	room["cleared"] = false
	room["camp_ambush"] = true
	room["enemy_health_scale"] = 0.55
	room["enemy_damage_scale"] = 0.6
	return true
static func aftermath(state) -> Dictionary:
	var survivors: Array = []
	var fallen: Array = []
	for id in state.party:
		var hero: Dictionary = state.run_heroes.get(id,{})
		var entry: Dictionary = {"id": id, "name": state.hero(str(id))["name"], "class": state.hero(str(id))["class"], "level": state.leveling(str(id))["level"], "old_level": state.journey.get("levels",{}).get(id,1), "xp": state.journey.get("xp",{}).get(id,0), "hp": hero.get("hp",0), "stress": hero.get("stress",0), "deeds": state.run_deeds.get(id,{}).duplicate(true)}
		if hero.get("dead",false): fallen.append(entry)
		else: survivors.append(entry)
	return {"dungeon": state.selected_expedition.get("name","Expedition"), "complete": state.run_complete, "floor": state.floor_index + 1, "gold": state.gold - int(state.journey.get("start_gold",state.gold)), "kills": state.journey.get("kills",0), "rooms": state.journey.get("steps",0), "loot": state.journey.get("loot",{}).duplicate(true), "survivors": survivors, "fallen": fallen}
