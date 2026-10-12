extends RefCounted
static func ally(combat, hero: String, afflicted: bool = false, others: bool = false) -> String:
	var candidates: Array = combat._standing_heroes().filter(func(id): return not others or id != hero)
	if candidates.is_empty(): return ""
	candidates.sort_custom(func(a,b):
		var first: Dictionary = combat.hero_state[a]
		var second: Dictionary = combat.hero_state[b]
		if afflicted and first.statuses.size() != second.statuses.size(): return first.statuses.size() > second.statuses.size()
		return float(first.hp)/maxi(1,first.max_hp) < float(second.hp)/maxi(1,second.max_hp))
	return str(candidates[0])
static func resolve(combat, hero: String, card: Dictionary) -> void:
	var state: Script = load("res://scripts/game_data.gd")
	match str(card.effect):
		"relic_guard":
			var target: String = ally(combat,hero,false,true)
			if target.is_empty(): return
			combat.hero_state[hero]["oath_target"] = target
			combat.hero_state[hero]["oath_retaliated"] = false
			combat._gain_block(hero,int(card.block))
			if combat.presentation != null: combat.presentation.strike(combat.hero_portraits[hero],combat.hero_portraits[target],"block",str(card.name),true,{"effect":"block","relic_fx":"relic_guard"})
			state.Stories.aid(state,hero,target,false,true)
			combat._add_log("%s guards %s until the next party turn." % [combat._name_of(hero),combat._name_of(target)])
		"relic_volley":
			var original: int = combat.selected_enemy_index
			for index in combat._living_enemies().duplicate():
				combat._load_enemy(index)
				var phase: int = combat.enemies[index].get("phase_index",0)
				var dealt: int = combat._attack_with_equipment(hero,card)
				if dealt > 0 and combat.enemies[index].hp > 0 and combat.enemies[index].get("phase_index",0) == phase: combat._apply_enemy_status(index,"poison")
			var living: Array = combat._living_enemies()
			if not living.is_empty(): combat._load_enemy(original if living.has(original) else living[0])
		"relic_drain":
			var dealt: int = combat._attack_with_equipment(hero,card)
			var target: String = ally(combat,hero,false,true)
			if target.is_empty(): target = hero
			if dealt > 0:
				combat._heal_hero(target,mini(dealt,int(card.heal)),hero)
				if combat.presentation != null: combat.presentation.strike(combat.hero_portraits[hero],combat.hero_portraits[target],"heal","Gravetide's Gift",true,{"relic_fx":"drain_return","effect":"heal"})
		"relic_cleanse":
			var target: String = ally(combat,hero,true)
			if target.is_empty(): return
			for debuff in ["burn","bleed","poison","chill"]: combat.hero_state[target].statuses.erase(debuff)
			combat._gain_block(target,int(card.block))
			state.Stories.aid(state,hero,target,false,true)
			if combat.presentation != null: combat.presentation.strike(combat.hero_portraits[hero],combat.hero_portraits[target],"heal",str(card.name),true,{"effect":"heal","relic_fx":"relic_cleanse"})
			combat._play_attack_sound("spell")
			combat._add_log("%s cleanses and wards %s." % [combat._name_of(hero),combat._name_of(target)])
		"relic_charge":
			combat.hero_state[hero].hp -= int(card.self_damage)
			state.Depth.move_hero(state,hero,1)
			combat._arrange_party(true)
			combat._attack_with_equipment(hero,card)
			combat._gain_block(hero,int(card.block))
static func intercept(combat, target: String) -> String:
	for hero in combat._standing_heroes():
		if combat.hero_state[hero].get("oath_target","") == target: return str(hero)
	return target
static func retaliate(combat, hero: String) -> void:
	var fighter: Dictionary = combat.hero_state[hero]
	if fighter.get("dead",false) or fighter.get("oath_retaliated",true): return
	fighter.oath_retaliated = true
	if combat.presentation != null: combat.presentation.strike(combat.hero_portraits[hero],combat.enemy_art,"sword","Oath's Return",true,{"weapon_signature":preload("res://scripts/weapon_signatures.gd").resolve(load("res://scripts/game_data.gd"),hero)})
	combat._play_attack_sound("sword")
	var target_index: int = combat.selected_enemy_index
	var damage: int = combat._deal_enemy_damage(6,false,hero)
	# Keep the enemy action attached to its attacker even when the return hit
	# kills it; normal hero attacks may automatically select another enemy.
	combat._load_enemy(target_index)
	var state: Script = load("res://scripts/game_data.gd")
	state.add_deed(hero,"damage",damage)
	combat._add_log("%s's oath retaliates: %d damage." % [combat._name_of(hero),damage])
