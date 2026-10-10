extends SceneTree
## Automated ordinary gameplay. No damage fixtures, health grants, forced loot, or production edits.
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
const EXIT = Vector2i(4, 3)
const DIRECTIONS = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]
var results: Array = []
var report: Dictionary = {}
var route_policy: String = "cautious"
var expedition_id: String = "old_road"
var use_objectives: bool = false
var validation_failed: bool = false

func _initialize() -> void:
	call_deferred("run")

func settle() -> void:
	for index in range(3): await process_frame

func room() -> Dictionary:
	return State.floors[State.floor_index][State.room_position]

func health(heroes: Dictionary = State.run_heroes) -> Dictionary:
	var out: Dictionary = {}
	for id in State.party:
		var h: Dictionary = heroes.get(id,{})
		out[id] = {"hp":h.get("hp",0), "max_hp":State.hero_max_hp(str(id)), "stress":h.get("stress",0), "dead":h.get("dead",false), "statuses":h.get("statuses",{}).duplicate(true), "level":State.leveling(str(id))["level"]}
	return out

func reset_party(third: String, seed_value: int) -> void:
	State.run_active = false
	State.party.assign(["warden", "ranger", third])
	State.hero_progress.clear()
	State.inventory.clear()
	State.equipment.clear()
	State.card_levels.clear()
	State.modifications.clear()
	State.formation.clear()
	State.hero_positions.clear()
	State.completed_expeditions.clear()
	State.graves.clear()
	State.hero_names.clear()
	State.hero_colors.clear()
	State.crusader_unlocked = false
	State.gold = 0
	State.progress_loaded = true
	State.progress_path = "user://ordinary_progress_%s.cfg" % report["id"]
	Saves.directory = "user://ordinary_saves_%s" % report["id"]
	State.navigation_voters.assign(["local"])
	State.navigation_votes.clear()
	assert(State.select_expedition(expedition_id))
	seed(seed_value + 5000)
	State.start_run(seed_value)
	# Legal preparation positions: healing/drain caster in second, archer in third.
	State.Depth.move_hero(State,third,2)
	State.Depth.move_hero(State,"ranger",3)

func finish_cinema(battle) -> void:
	if battle.presentation == null: return
	var cinema = battle.presentation
	cinema.set_process(false)
	if cinema.boss_reveal != null:
		cinema.boss_reveal.finish()
	while not cinema.active.is_empty():
		cinema.age = float(cinema.active.get("duration",cinema.duration)) + 0.1
		cinema._process(0.0)

func incoming(battle) -> Dictionary:
	var out: Dictionary = {}
	for id in battle._standing_heroes(): out[id] = 0.0
	var original: int = battle.selected_enemy_index
	for i in battle._living_enemies():
		battle._load_enemy(i)
		var move: Dictionary = battle._enemy_move(i)
		if not str(move.get("effect","")).is_empty(): continue
		var target: String = battle._enemy_target()
		if target.is_empty(): continue
		var damage: float = round(battle._enemy_attack_power()*float(move.get("scale",1)))
		damage += 2 if int(battle.hero_state[target].get("enemy_mark",0)) > 0 else 0
		damage *= int(move.get("hits",1))
		if battle.enemies[i].get("surprised",false): damage *= float(battle.enemies[i].get("accuracy",100))/100.0
		out[target] += damage
	for id in out:
		for status in ["burn","bleed","poison"]:
			var s: Dictionary = battle.hero_state[id]["statuses"].get(status,{})
			out[id] += float(s.get("damage",0))*int(s.get("stacks",1))
	battle._load_enemy(original)
	return out

func damage_value(battle, hero: String, card: Dictionary, target: int) -> float:
	battle._load_enemy(target)
	var amount: float = battle._attack_damage(hero,card) + battle.enemy_mark_bonus
	if battle.enemies[target]["creature"] in ["keep_son","moth_oleander"]:
		amount *= 0.5 if battle.round_number % 3 == 1 else 1.5 if battle.round_number % 3 == 0 else 1.0
	if card.get("effect","") != "pierce": amount = maxf(0,amount-battle.enemy_block)
	amount = minf(amount,battle.enemy_hp)
	amount *= State.hero_accuracy(hero,battle.hero_state[hero])/100.0
	var value: float = amount
	if amount >= battle.enemy_hp and amount > 0:
		var move: Dictionary = battle._enemy_move(target)
		value += 5 + (battle._enemy_attack_power()*float(move.get("scale",1))*int(move.get("hits",1)) if not move.has("effect") else 4)
		if battle.enemies[target].get("support",false) and battle.enemies.any(func(e): return e["creature"]=="undying_lord" and e["hp"]>0): value += 8
	elif hero == "occultist" and amount > 0 and not battle.enemies[target]["statuses"].has("poison"):
		value += 4
	return value

func heal_value(battle, hero: String, amount: int, pressure: Dictionary) -> float:
	var h: Dictionary = battle.hero_state[hero]
	var missing: int = State.hero_max_hp(hero)-int(h["hp"])
	var value: float = minf(missing,amount)*0.95
	var danger: float = maxf(0,float(pressure.get(hero,0))-int(h["block"]))
	if int(h["hp"]) <= danger + 4 and missing > 0: value += minf(missing,amount)*0.65 + 5
	return value

func block_value(battle, hero: String, amount: int, pressure: Dictionary) -> float:
	var h: Dictionary = battle.hero_state[hero]
	var prevent: float = minf(amount,maxf(0,float(pressure.get(hero,0))-int(h["block"])))
	var value: float = prevent*0.8
	if int(h["hp"]) <= float(pressure.get(hero,0))-int(h["block"])+3: value += prevent*0.7
	return value

func choose_action(battle) -> Dictionary:
	var best: Dictionary = {}
	var best_score: float = 0.1
	var pressure: Dictionary = incoming(battle)
	var targets: Array[int] = battle._living_enemies()
	for raw_hero in battle._standing_heroes():
		var hero: String = str(raw_hero)
		var h: Dictionary = battle.hero_state[hero]
		for index in range(h["abilities"].size()):
			var skill: String = str(h["abilities"][index])
			var card: Dictionary = State.card_stats(skill)
			var cost: int = int(card["cost"])
			if cost > int(h["ap"]) or int(h["cooldowns"].get(skill,0)) > 0: continue
			for target in targets:
				if not State.Depth.skill_allowed(State,hero,skill,battle.enemy_position(target)): continue
				battle._load_enemy(target)
				var score: float = 0.0
				var effect: String = str(card["effect"])
				if effect in ["attack","pierce","attack_block","drain","stress_attack"]:
					score = damage_value(battle,hero,card,target)
					if effect == "attack_block": score += block_value(battle,hero,int(card["block"])+State.hero_bonus(hero,"block"),pressure)
					if effect == "drain": score += heal_value(battle,hero,int(card["heal"])+State.hero_bonus(hero,"heal"),pressure)
					if effect == "stress_attack": score -= 2.0 if int(h["stress"]) < 50 else 6.0
				elif effect == "block": score = block_value(battle,hero,int(card["block"])+State.hero_bonus(hero,"block"),pressure)
				elif effect == "team_block":
					for ally in battle._standing_heroes(): score += block_value(battle,str(ally),int(card["block"])+State.hero_bonus(hero,"block"),pressure)
				elif effect == "heal": score = heal_value(battle,hero,int(card["heal"])+State.hero_bonus(hero,"heal"),pressure)
				elif effect == "team_heal":
					for ally in battle._standing_heroes():
						score += heal_value(battle,str(ally),int(card["heal"])+State.hero_bonus(hero,"heal"),pressure)
						if battle.hero_state[ally]["statuses"].has("bleed"): score += 3
				elif effect == "stress_heal":
					for ally in battle._standing_heroes(): score += minf(int(card["amount"]),int(battle.hero_state[ally]["stress"]))*0.16
				elif effect == "weaken" and battle.enemy_weak_rounds == 0:
					var move: Dictionary = battle._enemy_move(target)
					if not move.has("effect"): score = 3*float(move.get("scale",1))*int(move.get("hits",1))*1.6
				elif effect == "mark" and battle.enemy_mark_bonus == 0:
					# Single-hit mark normally loses tempo; use only through a guarded shield.
					score = 5.0 if battle.enemy_block > 8 else 0.0
				score /= cost
				if score > best_score:
					best_score = score
					best = {"hero":hero,"index":index,"skill":skill,"target":target,"score":score}
		if int(h["ap"]) <= 0: continue
		var position: int = State.Depth.position_of(State,hero)
		if (hero=="ranger" and position==1) or (hero=="warden" and position==3):
			if best_score < 8.0:
				best_score=8.0;best={"hero":hero,"move":1 if hero=="ranger" else -1,"target":targets[0],"score":8.0}
		if use_objectives and battle.has_method("_objective_index"):
			var objective_index: int = battle._objective_index()
			if objective_index >= 0:
				var objective: Dictionary = battle.enemies[objective_index].get("objective",{})
				if int(objective.get("spent",0)) < int(objective.get("uses",0)):
					battle._load_enemy(objective_index)
					var move: Dictionary = battle._enemy_move(objective_index)
					var indicated: bool = objective.get("kind","") in ["chains","idol"] or move.get("effect","") in ["remake","lament"] or move.has("status") or battle._enemy_attack_power()*float(move.get("scale",1)) >= 10
					if indicated and best_score < 25.0:
						best_score=25.0;best={"hero":hero,"objective":str(objective["kind"]),"target":objective_index,"score":25.0}
		for item_id in State.inventory:
			var item: Dictionary = State.Items.item(str(item_id))
			if str(item.get("kind","")) not in ["scroll","potion"]: continue
			var score: float = 0.0
			var target: int = targets[0]
			match str(item.get("effect","")):
				"heal": score = heal_value(battle,hero,int(item["amount"]),pressure)-3
				"cleanse", "cleanse_one":
					for status in h["statuses"]:
						if item["effect"]=="cleanse_one" and status!=item["status"]: continue
						var status_data: Dictionary = h["statuses"][status]
						score += int(status_data.get("damage",0))*int(status_data.get("turns",0))*int(status_data.get("stacks",1))
					score -= 2
				"solace": score = minf(int(item["amount"]),int(h["stress"]))*0.16-3
				"attack", "pierce":
					for i in targets:
						battle._load_enemy(i)
						var damage: float = int(item["damage"])
						if item["effect"] != "pierce": damage=maxf(0,damage-battle.enemy_block)
						var candidate: float = minf(damage,battle.enemy_hp)-3
						if damage >= battle.enemy_hp: candidate += 7
						if str(item_id) in ["fire_bolt_scroll","sunfire_scroll"] and not battle.enemies[i]["statuses"].has("burn"): candidate += 5
						if candidate > score: score=candidate;target=i
			if score > best_score:
				best_score=score
				best={"hero":hero,"item":str(item_id),"target":target,"score":score}
	return best

func combat() -> void:
	var battle = current_scene
	finish_cinema(battle)
	var before: Dictionary = health(battle.hero_state)
	var enemies: Array = []
	for enemy in battle.enemies: enemies.append({"id":enemy["creature"],"hp":enemy["hp"],"attack":enemy["attack"],"support":enemy["support"]})
	var trace: Array = []
	for turn in range(32):
		for action in range(12):
			if battle.battle_over: break
			var chosen: Dictionary = choose_action(battle)
			if chosen.is_empty(): break
			var hero: String = chosen["hero"]
			battle._select_hero(hero)
			battle._load_enemy(int(chosen["target"]))
			var ap: int = battle.hero_state[hero]["ap"]
			var event: Dictionary = {"round":battle.round_number,"hero":hero,"action":chosen.get("skill",chosen.get("item",chosen.get("objective","move"))),"target":chosen["target"]}
			if chosen.has("objective"):
				assert(battle._interact_boss_objective())
			elif chosen.has("move"):
				battle.move_position(chosen["move"])
			elif chosen.has("item"):
				battle._use_scroll(chosen["item"])
				report["consumables_used"][chosen["item"]] = int(report["consumables_used"].get(chosen["item"],0))+1
			else: battle._play_card(hero,chosen["index"])
			if int(battle.hero_state[hero]["ap"]) >= ap:
				validation_failed=true
				report["outcome"]="policy_validation_failure"
				push_error("AI selected an illegal/nonexecuting action")
				return
			trace.append(event)
			finish_cinema(battle)
		if battle.battle_over: break
		battle._end_turn()
		finish_cinema(battle)
		if battle.battle_over: break
	var won: bool = battle.battle_over and battle.reward_given
	if won and room().get("final_boss",false): report["floor_summaries"].append({"floor":State.floor_index+1,"health":health(battle.hero_state),"gold":State.gold,"xp":State.hero_progress.duplicate(true),"inventory":State.inventory.duplicate(true)})
	var fight: Dictionary = {"floor":State.floor_index+1,"room":str(State.room_position),"kind":State.current_room_kind(),"enemies":enemies,"before":before,"after":health(battle.hero_state),"rounds":battle.round_number,"won":won,"bounded":not battle.battle_over,"actions":trace,"gold_after":State.gold}
	report["fights"].append(fight)
	report["latest_health"]=fight["after"]
	print("FIGHT ",report["id"]," F",State.floor_index+1," ",enemies," R",battle.round_number," ","WIN" if won else "LOSS", " ",fight["after"])
	if not battle.battle_over:
		report["outcome"]="combat_round_bound"
		return
	if battle.has_node("FloorEntrancePrompt"):
		battle.get_node("FloorEntrancePrompt").stay_here()
	else: battle._on_end_turn_button_pressed()
	await settle()
	if not won: report["outcome"]="defeat"

func gear_score(hero: String, item: Dictionary) -> float:
	var class_key: String = "remade" if expedition_id=="path_beast" else "corrupted" if State.floor_index>0 else "human"
	return int(item.get("damage_vs_"+class_key,0))*0.3 + int(item.get("ward_vs_"+class_key,0))*0.25 + int(item.get("damage",0))*4.0 + int(item.get("damage_percent",0))*0.3 + int(item.get("max_hp",0))*0.5 + int(item.get("max_hp_percent",0))*0.25 + int(item.get("heal",0))*(3 if hero=="healer" else 1.5) + int(item.get("block",0))*2.0 + int(item.get("regeneration",0))*4.0 + int(item.get("life_drain",0))*0.3 + int(item.get("poison_chance",0))*0.2 + int(item.get("unique_poison",0))*0.2 + int(item.get("unique_chill",0))*0.2 + int(item.get("bleed_resist",0))*0.06 + int(item.get("poison_resist",0))*0.05 + int(item.get("debuff_resist",0))*0.05 - int(item.get("curse_dot",0))*4.0 - int(item.get("curse_stress",0))*3.0

func equip_loot() -> void:
	for item_id in State.inventory.keys():
		var item: Dictionary = State.Items.item(str(item_id))
		if not item.has("slot"): continue
		var hero: String = ""
		var improvement: float = 0.0
		for id in State.party:
			if State.run_heroes[id].get("dead",false) or item.get("hero",id)!=id: continue
			var old: String = str(State.equipment.get(id,{}).get(item["slot"],""))
			var gain: float = gear_score(str(id),item)-gear_score(str(id),State.Items.item(old))
			if gain > improvement: improvement=gain;hero=str(id)
		if not hero.is_empty() and State.equip_item(hero,str(item_id)):
			report["equipment_actions"].append({"floor":State.floor_index+1,"hero":hero,"item":item_id})

func visit_shop() -> void:
	if not State.merchant_orb_available(): return
	current_scene.open_shop()
	await settle()
	var purchases: Array = []
	for id in State.party:
		var weapon: String = {"warden":"warden_sword","ranger":"ranger_bow","occultist":"occultist_staff","healer":"healer_mace"}[id]
		if State.equipment.get(id,{}).get("weapon","")=="" and State.gold>=State.item_price(weapon):
			current_scene.purchase(weapon);purchases.append(weapon)
	while State.gold >= State.item_price("healing_potion") and int(State.inventory.get("healing_potion",0)) < 2:
		current_scene.purchase("healing_potion");purchases.append("healing_potion")
	report["shops"].append({"floor":State.floor_index+1,"purchases":purchases,"gold_remaining":State.gold})
	current_scene.return_to_party()
	await settle()
	equip_loot()

func use_map_consumables() -> void:
	for raw_id in State.party:
		var id: String = str(raw_id)
		var h: Dictionary = State.run_heroes[id]
		if h.get("dead",false): continue
		for item_id in State.inventory.keys():
			var item: Dictionary = State.Items.item(str(item_id))
			var should: bool = item.get("effect","")=="heal" and int(h["hp"]) < State.hero_max_hp(id)*0.4
			should = should or (item.get("effect","")=="cleanse" and not h["statuses"].is_empty())
			should = should or (item.get("effect","")=="cleanse_one" and h["statuses"].has(item.get("status","")))
			if should and State.apply_potion(id,str(item_id),State.run_heroes): report["consumables_used"][item_id]=int(report["consumables_used"].get(item_id,0))+1

func resolve_current() -> void:
	match current_scene.scene_file_path:
		"res://scenes/combat/combatscene.tscn": await combat()
		"res://scenes/expedition/camp.tscn":
			var before: Dictionary = health()
			var needs_rest: bool = false
			for id in State.party:
				var h: Dictionary = State.run_heroes[id]
				if not h.get("dead",false) and (int(h["hp"]) < State.hero_max_hp(str(id)) or int(h["stress"])>0 or not h["statuses"].is_empty()): needs_rest=true
			if needs_rest:
				current_scene.rest_party()
				current_scene.prepare("watch")
				current_scene.prepare("sharpen")
			report["camps"].append({"floor":State.floor_index+1,"position":str(State.room_position),"before":before,"after":health(),"rested":needs_rest})
			current_scene.leave_camp()
			await settle()
		"res://scenes/expedition/event_room.tscn":
			var view = current_scene
			var event_id: String = str(room().get("event_id",""))
			var chosen: String = ""
			var best_option: float = 999.0
			for id in State.party:
				var h: Dictionary = State.run_heroes[id]
				if h.get("dead",false) or int(h["hp"])<=0: continue
				var option: Dictionary = State.Mechanics.event_option(event_id,str(id))
				if not option.is_empty() and int(h["hp"])>int(option.get("cost",0)):
					var risk: float = int(option.get("cost",0))+float(option.get("curse_chance",0))*10
					if risk < best_option: best_option=risk;chosen=str(id)
			if chosen.is_empty():
				for id in State.party:
					var h: Dictionary = State.run_heroes[id]
					if h.get("dead",false): continue
					if chosen.is_empty() or int(h["hp"]) > int(State.run_heroes[chosen]["hp"]): chosen=str(id)
			view.select_hero(chosen)
			if not State.Mechanics.event_option(event_id,chosen).is_empty(): view.investigate_as_class()
			elif int(State.run_heroes[chosen]["hp"]) > 8: view.investigate()
			else: view.leave_untouched();await settle();return
			report["events"].append({"floor":State.floor_index+1,"event":event_id,"hero":chosen,"health_after":health()})
			view.return_to_dungeon()
			await settle()
	if not State.run_active or report["outcome"]!="running": return
	if current_scene.scene_file_path=="res://scenes/expedition/dungeon.tscn":
		equip_loot()
		await visit_shop()
		use_map_consumables()

func full_path(goal: Vector2i) -> Array:
	# Geometric planner sees connectivity only, never event seed or random outcomes.
	var rooms: Dictionary = State.floors[State.floor_index]
	var queue: Array = [State.room_position]
	var prev: Dictionary = {State.room_position:State.room_position}
	while not queue.is_empty():
		var at: Vector2i = queue.pop_front()
		if at==goal: break
		for direction in DIRECTIONS:
			var next: Vector2i = at+direction
			if rooms.has(next) and not prev.has(next): prev[next]=at;queue.append(next)
	if not prev.has(goal): return []
	var path: Array = []
	var cursor: Vector2i = goal
	while cursor != State.room_position: path.push_front(cursor);cursor=prev[cursor]
	return path

func next_destination() -> Vector2i:
	var goal: Vector2i = EXIT
	if route_policy=="cautious":
		var wounded: bool = false
		for id in State.party:
			var h: Dictionary = State.run_heroes[id]
			if not h.get("dead",false) and (int(h["hp"]) < State.hero_max_hp(str(id))*0.75 or int(h["stress"])>40): wounded=true
		if wounded:
			var best: int = 999
			for location in State.floors[State.floor_index]:
				var candidate: Dictionary = State.floors[State.floor_index][location]
				if candidate["kind"]!="camp" or candidate.get("camp_used",false): continue
				var length: int = full_path(location).size()
				if length < best: goal=location;best=length
	if goal==State.room_position:
		if room()["kind"]=="camp" and not room().get("camp_used",false): return goal
		goal=EXIT
	var path: Array = full_path(goal)
	for step in path:
		if not State.floors[State.floor_index][step]["cleared"]: return step
	return goal

func move_actual(destination: Vector2i) -> void:
	var dungeon = current_scene
	if destination==State.room_position:
		dungeon.open_camp();await settle();return
	if dungeon.route_to(destination).is_empty():
		validation_failed=true
		report["outcome"]="route_validation_failure"
		push_error("Planner must choose a revealed legal route")
		return
	dungeon.move_to(destination)
	for child in dungeon.get_children():
		if child.get_script()==Travel: child.finish()
	await settle()
	assert(State.room_position==destination)

func one_run(world_seed: int, third: String, policy: String, carryover: bool = false) -> void:
	route_policy=policy
	report={"id":"%s_%s_%s_%s" % [expedition_id,world_seed,third,policy],"expedition":expedition_id,"objectives":use_objectives,"seed":world_seed,"third_hero":third,"route":policy,"outcome":"running","fights":[],"spaces":[],"camps":[],"shops":[],"events":[],"equipment_actions":[],"consumables_used":{},"floor_summaries":[],"starting_gold":0}
	if not carryover: reset_party(third,world_seed)
	else:
		assert(not State.run_active)
		assert(State.select_expedition(expedition_id))
		seed(world_seed+5000)
		State.start_run(world_seed)
		State.Depth.move_hero(State,third,2)
		State.Depth.move_hero(State,"ranger",3)
	report["carryover"]=carryover
	report["starting_gold"]=State.gold
	report["starting_progress"]=State.hero_progress.duplicate(true)
	report["starting_inventory"]=State.inventory.duplicate(true)
	report["starting_equipment"]=State.equipment.duplicate(true)
	assert(change_scene_to_file("res://scenes/expedition/dungeon.tscn")==OK)
	await settle()
	for step in range(100):
		if not State.run_active or report["outcome"]!="running": break
		if State.run_heroes.values().any(func(h): return h.get("dead",false)):
			report["outcome"]="retreat_after_casualty";report["latest_health"]=health();current_scene.retreat();await settle();break
		if State.room_position==EXIT and room()["cleared"]:
			report["floor_summaries"].append({"floor":State.floor_index+1,"health":health(),"gold":State.gold,"xp":State.hero_progress.duplicate(true),"camp_used":report["camps"].size(),"inventory":State.inventory.duplicate(true)})
			if State.can_descend():
				current_scene.descend()
				current_scene.get_node("FloorEntrancePrompt").accept_entrance()
				await settle()
				continue
		var dest: Vector2i = next_destination()
		await move_actual(dest)
		await resolve_current()
		report["spaces"].append({"floor":State.floor_index+1,"position":str(State.room_position),"kind":room()["kind"],"gold":State.gold})
	if report["outcome"]=="running": report["outcome"]="complete" if State.run_complete else "map_step_bound"
	report["ending_floor"]=State.floor_index+1
	report["ending_health"]=health() if State.run_active else report.get("latest_health",health())
	report["ending_gold"]=State.gold
	report["ending_progress"]=State.hero_progress.duplicate(true)
	report["ending_inventory"]=State.inventory.duplicate(true)
	report["ending_equipment"]=State.equipment.duplicate(true)
	report["last_report"]=State.last_report.duplicate(true)
	results.append(report.duplicate(true))
	print("RESULT ",report["id"]," ",report["outcome"]," floor=",report["ending_floor"]," fights=",report["fights"].size()," camps=",report["camps"].size()," gold=",State.gold)
	var file = FileAccess.open("user://ordinary_playthrough_results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"method":"automated actual-action playthrough","results":results},"\t"));file.close()

func run() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	if args.size()>0 and args[0]=="campaign":
		await one_run(2026,"occultist","cautious")
		if report["outcome"]=="complete":
			for id in State.party:
				var count: int = 0
				while int(State.leveling(str(id))["points"])>0:
					var stat: String = "damage_percent" if id=="ranger" else "block" if id=="warden" and count%2==0 else "heal" if id=="occultist" and count%2==0 else "max_hp"
					assert(State.train_hero(str(id),stat))
					count+=1
			expedition_id="path_beast"
			use_objectives=true
			await one_run(2026,"occultist","cautious",true)
	elif args.size()>0 and args[0]=="path_matrix":
		expedition_id="path_beast"
		use_objectives=args.size()>1 and args[1]=="objectives"
		for world_seed in [2026,20]:
			for third in ["occultist","healer"]: await one_run(world_seed,third,"cautious")
	elif args.size()>=3:
		if args.size()>=4: expedition_id=args[3]
		if args.size()>=5: use_objectives=args[4]=="objectives"
		await one_run(int(args[0]),args[1],args[2])
	else:
		for world_seed in [2026,20]:
			for third in ["occultist","healer"]:
				for policy in ["direct","cautious"]: await one_run(world_seed,third,policy)
	print("ORDINARY_PLAYTHROUGH_DONE ",results.size()," cases; report=",ProjectSettings.globalize_path("user://ordinary_playthrough_results.json"))
	if is_instance_valid(current_scene): current_scene.queue_free()
	await settle()
	quit(1 if validation_failed else 0)
