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
	if weapon.get("rarity","") == "legendary": return "relic"
	return manual
