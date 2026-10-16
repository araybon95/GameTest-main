extends RefCounted
const Items = preload("res://scripts/item_data.gd")
static func choice(state, hero: String, preview_item: String = "") -> String:
	var manual: String = str(state.hero_outfits.get(hero,"original"))
	if hero == "warden" and manual == "ashen_wolf" and state.completed_expeditions.has("old_road"): return manual
	if not state.equipment_appearance: return manual
	var gear: Dictionary = state.equipment.get(hero,{}).duplicate()
	if not preview_item.is_empty() and Items.item(preview_item).has("slot"): gear[Items.item(preview_item).slot] = preview_item
	var armor: Dictionary = Items.item(str(gear.get("armor","")))
	if armor.has("equipment_look"): return str(armor.equipment_look)
	var weapon: Dictionary = Items.item(str(gear.get("weapon","")))
	if hero == "healer" and weapon.get("rarity","") == "legendary": return "relic"
	if state.legacy_weapon_costumes.get(hero,"") == "relic": return "relic"
	return manual

static func valid_weapon_costumes(value: Variant) -> bool:
	if not value is Dictionary: return false
	for hero in value:
		if (not hero is String and not hero is StringName) or not value[hero] is String: return false
		if hero not in ["warden","ranger","crusader","occultist"] or value[hero] != "relic": return false
	return true

static func migrate_weapon_costumes(state, saved: Dictionary) -> Dictionary:
	if saved.has("legacy_weapon_costumes"):
		return saved.legacy_weapon_costumes.duplicate() if valid_weapon_costumes(saved.legacy_weapon_costumes) else {}
	var result: Dictionary = {}
	if not saved.get("equipment_appearance",true): return result
	var histories: Dictionary = saved.get("item_histories",{})
	for hero in saved.get("equipment",{}):
		if hero not in ["warden","ranger","crusader","occultist"] or not state.HEROES.has(hero): continue
		if hero == "warden" and saved.get("hero_outfits",{}).get(hero,"") == "ashen_wolf" and saved.get("completed",[]).has("old_road"): continue
		var gear: Dictionary = saved.equipment[hero]
		var armor_id: String = str(gear.get("armor",""))
		var armor_base: String = str(histories.get(armor_id,{}).get("base",armor_id))
		if Items.EQUIPMENT.get(armor_base,{}).has("equipment_look"): continue
		var weapon_id: String = str(gear.get("weapon",""))
		var weapon_base: String = str(histories.get(weapon_id,{}).get("base",weapon_id))
		if Items.EQUIPMENT.get(weapon_base,{}).get("rarity","") == "legendary": result[hero] = "relic"
	return result
