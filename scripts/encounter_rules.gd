extends RefCounted

const STATUS: Dictionary = {
	"burn": {"damage": 3, "turns": 2},
	"bleed": {"damage": 2, "turns": 2},
	"poison": {"damage": 2, "turns": 2},
	"chill": {"damage": 0, "turns": 2},
}
const MOVES: Dictionary = {
	"moth_metamorph": [{"name": "Proboscis Wound", "scale": 1.0, "status": "bleed"}, {"name": "Septic Dust", "scale": 0.75, "status": "poison"}, {"name": "Ragged Claws", "scale": 0.5, "hits": 2}],
	"moth_oleander": [{"name": "Knight's Incision", "scale": 1.0, "status": "bleed"}, {"name": "Cold Wingbeat", "scale": 0.8, "status": "chill"}, {"name": "Broken Chivalry", "scale": 0.55, "hits": 2}],
	"moth_exuvia": [{"name": "Queen's Kiss", "scale": 0.85, "status": "poison"}, {"name": "Rapture of the Lamp", "effect": "lament", "stress": 4}, {"name": "Silken Flensing", "scale": 0.55, "hits": 2, "status": "bleed"}],
 "keep_footman": [{"name": "Rusted Cleaver", "scale": 1.0, "status": "bleed"}, {"name": "Shield Rush", "scale": 0.8, "status": "chill"}, {"name": "Deadman's Flurry", "scale": 0.55, "hits": 2}],
 "keep_crossbow": [{"name": "Gravebolt", "scale": 1.0, "status": "chill"}, {"name": "Septic Quarrel", "scale": 0.8, "status": "poison"}, {"name": "Double Reload", "scale": 0.55, "hits": 2}],
 "keep_wolfguard": [{"name": "Wolf's Cleave", "scale": 1.0, "status": "bleed"}, {"name": "Rending Poleaxe", "scale": 0.6, "hits": 2}, {"name": "Winter's Hunt", "scale": 0.85, "status": "chill"}],
 "keep_son": [{"name": "Broken Oath", "scale": 1.0, "status": "bleed"}, {"name": "Howl of the Last Son", "effect": "lament", "stress": 4}, {"name": "Moonlit Greatsword", "scale": 0.9, "status": "chill"}],
 "undying_lord": [{"name": "Tyrant's Verdict", "scale": 1.0, "status": "bleed"}, {"name": "Grasp of the Court", "scale": 0.55, "hits": 2, "status": "chill"}, {"name": "Unending Dominion", "effect": "lament", "stress": 5}],
	"anguish_penitent": [{"name": "Supplicant's Hook", "scale": 1.0, "status": "bleed"}, {"name": "Cauterizing Prayer", "scale": 0.8, "status": "burn"}, {"name": "Litany of Submission", "effect": "lament", "stress": 3}],
	"anguish_vessel": [{"name": "Graft Lash", "scale": 0.55, "hits": 2}, {"name": "Septic Offering", "scale": 0.8, "status": "poison"}, {"name": "Numbing Touch", "scale": 0.8, "status": "chill"}],
	"harrowed_giant": [{"name": "Chain Litany", "scale": 1.0, "status": "bleed"}, {"name": "Crushing Benediction", "scale": 1.2}, {"name": "Kneeling Hymn", "effect": "lament", "stress": 4}],
	"coterie_seamkeeper": [{"name": "Sacred Incision", "scale": 1.0, "status": "bleed"}, {"name": "Needle Psalm", "scale": 0.55, "hits": 2}, {"name": "Purifying Brand", "scale": 0.8, "status": "burn"}],
	"coterie_cantor": [{"name": "Cold Chorus", "scale": 0.85, "status": "chill"}, {"name": "Hymn of Unmaking", "effect": "lament", "stress": 4}, {"name": "Rib Flurry", "scale": 0.55, "hits": 2}],
	"coterie_matron": [{"name": "Septic Blessing", "scale": 0.85, "status": "poison"}, {"name": "Blessed Remaking", "effect": "remake", "heal": 12}, {"name": "Candle Communion", "scale": 0.9, "status": "burn"}],
	"howling_head": [{"name": "Unending Prayer", "effect": "lament", "stress": 6, "status": "chill"}, {"name": "Choir of Teeth", "scale": 1.1, "status": "bleed"}, {"name": "Tendon Lash", "scale": 0.6, "hits": 2}],

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
	return {"creature": creature_id, "name": ("Support " if support else ("Dread " if boss and not state.get("tags", []).has("Remade") and not state.get("tags", []).has("Revenant") and not state.get("tags", []).has("Moth") else "")) + str(state.get("name", "Enemy")),
		"max_hp": hp, "hp": hp, "attack": attack, "normal_hp": normal_hp, "normal_attack": normal_attack,
		"support": support, "boss": boss, "art": str(state.get("art", "")), "undead": bool(state.get("undead", false)),
		"block": 0, "mark": 0, "weak": 0, "statuses": {}, "moves": MOVES.get(creature_id, MOVES["hollow_villager"]).duplicate(true)}

static func apply_status(statuses: Dictionary, status_id: String, potency: float = 1.0, stacking: bool = false) -> void:
	if not STATUS.has(status_id):
		return
	var previous: Dictionary = statuses.get(status_id, {})
	var stacks: int = mini(3, int(previous.get("stacks", 1)) + 1) if stacking and not previous.is_empty() else int(previous.get("stacks", 1))
	var base_damage: int = maxi(int(previous.get("base_damage", 0)), maxi(1, int(round(int(STATUS[status_id]["damage"]) * potency))))
	statuses[status_id] = {"turns": 2, "stacks": stacks, "base_damage": base_damage, "damage": base_damage * stacks if int(STATUS[status_id]["damage"]) > 0 else 0}

static func damage_after_chill(amount: int, statuses: Dictionary) -> int:
	if not statuses.has("chill"):
		return maxi(0, amount)
	var stacks: int = clampi(int(statuses["chill"].get("stacks", 1)), 1, 3)
	return maxi(0, int(floor(amount * (0.75 - (stacks - 1) * 0.10))))

static func status_text(statuses: Dictionary) -> String:
	var parts: PackedStringArray = []
	for status_id in statuses:
		var stacks: int = int(statuses[status_id].get("stacks", 1))
		parts.append("%s%s · %dt" % [str(status_id).capitalize(), " ×%d" % stacks if stacks > 1 else "", int(statuses[status_id]["turns"])])
	return " · ".join(parts)
