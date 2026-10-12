extends RefCounted
## Visual signatures describe the weapon, never a successful status proc.
static func resolve(state, hero: String) -> String:
	var id: String = str(state.equipment.get(hero,{}).get("weapon",""))
	var weapon: Dictionary = state.Items.item(id)
	if weapon.is_empty(): return ""
	if weapon.has("unique_chill"): return "frost"
	if weapon.has("unique_poison") or weapon.has("poison_chance"): return "venom"
	if weapon.has("life_drain"): return "blood"
	if weapon.has("heal") or weapon.has("regeneration"): return "holy"
	var mode: String = str(state.Items.histories.get(id,{}).get("transformation",""))
	return {"corrupted":"blood","consecrated":"holy"}.get(mode,"")
