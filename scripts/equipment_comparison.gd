extends RefCounted
const STATS: Array[String] = ["move_cost","free_move","damage","block","heal","max_hp","max_hp_percent","damage_percent","accuracy","debuff_resist","bleed_resist","poison_resist","regeneration","life_drain","reflection","unique_poison","unique_chill","poison_chance","curse_stress","curse_dot","damage_vs_human","damage_vs_corrupted","damage_vs_remade","damage_vs_insect","ward_vs_human","ward_vs_corrupted","ward_vs_remade","ward_vs_insect"]
const NAMES: Dictionary = {"move_cost":"AP per formation move","free_move":"free formation move per turn","max_hp":"maximum HP","max_hp_percent":"maximum HP %","damage_percent":"skill damage %","accuracy":"accuracy %","debuff_resist":"debuff resistance %","bleed_resist":"bleed resistance %","poison_resist":"poison damage resistance %","unique_poison":"stacking poison chance %","unique_chill":"stacking chill chance %","poison_chance":"poison chance %","life_drain":"life drain %","reflection":"damage reflection %","regeneration":"HP per party turn","curse_stress":"Stress per party turn","curse_dot":"damage per harmful tick"}
static func values(state, id: String) -> Dictionary:
	var result: Dictionary = state.Items.item(id).duplicate(true)
	if state.modifications.get(id,"") == "keen": result["damage"] = int(result.get("damage",0))+1
	if state.modifications.get(id,"") == "fortified": result["block"] = int(result.get("block",0))+2
	return result
static func compare(state, hero: String, id: String) -> Dictionary:
	var item: Dictionary = values(state,id)
	if not item.has("slot"): return {}
	var old_id: String = str(state.equipment.get(hero,{}).get(item.slot,""))
	var old: Dictionary = values(state,old_id)
	if item.get("slot","") == "armor":
		item["move_cost"] = int(item.get("move_cost",1))
		old["move_cost"] = int(old.get("move_cost",1))
	var changes: Array = []
	for stat in STATS:
		var delta: int = int(item.get(stat,0))-int(old.get(stat,0))
		if delta != 0: changes.append({"stat":stat,"delta":delta,"good":delta < 0 if (stat.begins_with("curse_") or stat == "move_cost") else delta > 0})
	return {"hero":hero,"compatible":preload("res://scripts/weapon_rules.gd").reason(state,hero,id,state.equipment.get(hero,{})).is_empty(),"old":old_id,"changes":changes,"art":state.hero(hero,id).art,"name":state.Items.item(id).name}
static func text(state, hero: String, id: String) -> String:
	var result: Dictionary = compare(state,hero,id)
	if result.is_empty(): return ""
	if not result.compatible: return preload("res://scripts/weapon_rules.gd").reason(state,hero,id,state.equipment.get(hero,{}))
	var old_name: String = str(state.Items.item(result.old).get("name","Empty slot"))
	var text: String = "COMPARE · %s\nReplacing %s" % [state.hero(hero).name,old_name]
	for change in result.changes:
		text += "\n%s %s%d %s" % ["GAIN" if change.good else "LOSS","+" if change.delta > 0 else "",change.delta,NAMES.get(change.stat,str(change.stat).replace("_"," "))]
	if result.changes.is_empty(): text += "\nNo stat changes."
	text += "\nCosmetic preview · Equipping does not heal."
	text += "\nChanges are equipment bonuses; accuracy caps at 100%, combined stacking status chance at 50%."
	return text
