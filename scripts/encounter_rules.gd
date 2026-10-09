extends RefCounted

const STATUS: Dictionary = {
	"burn": {"damage": 3, "turns": 2},
	"bleed": {"damage": 2, "turns": 2},
	"poison": {"damage": 2, "turns": 2},
	"chill": {"damage": 0, "turns": 2},
}
const MOVES: Dictionary = {
	"ash_raider": [
		{"name": "Cleaver Slash", "scale": 1.0, "status": "bleed"},
		{"name": "Twin Cuts", "scale": 0.6, "hits": 2},
		{"name": "Burning Brand", "scale": 0.8, "status": "burn"},
	],
	"gallows_scout": [
		{"name": "Poison Arrow", "scale": 0.8, "status": "poison"},
		{"name": "Quick Shots", "scale": 0.6, "hits": 2},
		{"name": "Frost-tipped Arrow", "scale": 0.8, "status": "chill"},
	],
	"ash_chieftain": [
		{"name": "Executioner's Cut", "scale": 1.0, "status": "bleed"},
		{"name": "Axe Flurry", "scale": 0.55, "hits": 2},
		{"name": "Scorching Blow", "scale": 0.85, "status": "burn"},
	],
	"bone_rabble": [
		{"name": "Rusty Blade", "scale": 1.0, "status": "bleed"},
		{"name": "Grave Chill", "scale": 0.8, "status": "chill"},
		{"name": "Bone Flurry", "scale": 0.55, "hits": 2},
	],
	"hollow_villager": [
		{"name": "Raking Claws", "scale": 1.0, "status": "bleed"},
		{"name": "Plague Strike", "scale": 0.8, "status": "poison"},
		{"name": "Wild Swings", "scale": 0.55, "hits": 2},
	],
}

static func make_enemy(state: Dictionary, creature_id: String, depth: int, boss: bool = false, support: bool = false) -> Dictionary:
	var hp: int = int(state.get("hp", 68)) + depth * 10
	var attack: int = int(state.get("attack", 7)) + depth * 2
	var normal_hp: int = hp
	var normal_attack: int = attack
	if boss:
		hp *= 2
		attack += 3
	elif support:
		hp = maxi(1, int(round(normal_hp * 0.3)))
		attack = maxi(1, int(round(normal_attack * 0.3)))
	return {"creature": creature_id, "name": ("Support " if support else ("Dread " if boss else "")) + str(state.get("name", "Enemy")),
		"max_hp": hp, "hp": hp, "attack": attack, "normal_hp": normal_hp, "normal_attack": normal_attack,
		"support": support, "boss": boss, "art": str(state.get("art", "")), "undead": bool(state.get("undead", false)),
		"block": 0, "mark": 0, "weak": 0, "statuses": {}, "moves": MOVES.get(creature_id, MOVES["hollow_villager"]).duplicate(true)}

static func apply_status(statuses: Dictionary, status_id: String, potency: float = 1.0) -> void:
	if not STATUS.has(status_id):
		return
	var previous_damage: int = int(statuses.get(status_id, {}).get("damage", 0))
	# Reapplication refreshes duration; it never creates unlimited stacks.
	statuses[status_id] = STATUS[status_id].duplicate(true)
	if int(statuses[status_id]["damage"]) > 0:
		statuses[status_id]["damage"] = maxi(previous_damage, maxi(1, int(round(int(statuses[status_id]["damage"]) * potency))))

static func damage_after_chill(amount: int, statuses: Dictionary) -> int:
	return maxi(0, int(floor(amount * 0.75))) if statuses.has("chill") else maxi(0, amount)

static func status_text(statuses: Dictionary) -> String:
	var parts: PackedStringArray = []
	for status_id in statuses:
		parts.append("%s %d" % [str(status_id).capitalize(), int(statuses[status_id]["turns"])])
	return " · ".join(parts)
