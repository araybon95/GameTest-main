extends RefCounted
## Original Ashen equipment and consumables; licensed icons credited in assets/items/CREDITS.md.

const SCROLL_CHANCE: float = 0.15
const GEAR_CHANCE: float = 0.40
const RARITY_WEIGHTS: Dictionary = {"common": 60, "rare": 25, "epic": 10, "legendary": 5}
const RARITY_COLORS: Dictionary = {"common": "#C6B9AB", "rare": "#83A9CF", "epic": "#BA88E3", "legendary": "#E3B85D"}
const SCROLLS: Dictionary = {
	"storm_lance_scroll": {"name": "Storm Lance Scroll", "rarity": "epic", "kind": "scroll", "effect": "pierce", "damage": 22, "cost": 1, "price": 20, "description": "Deal 22 damage, ignoring Block. Single use; any hero. Costs 1 AP."},
	"fire_bolt_scroll": {"name": "Fire Bolt Scroll", "rarity": "common", "kind": "scroll", "effect": "attack", "damage": 12, "cost": 1, "price": 6, "description": "Deal 12 damage. Burn: 3 damage for 2 turns. Single use; any hero. Costs 1 AP."},
	"lightning_bolt_scroll": {"name": "Lightning Bolt Scroll", "rarity": "rare", "kind": "scroll", "effect": "pierce", "damage": 18, "cost": 1, "price": 12, "description": "Deal 18 damage, ignoring Block. Single use; any hero. Costs 1 AP."},
	"sunfire_scroll": {"name": "Sunfire Scroll", "rarity": "legendary", "kind": "scroll", "effect": "pierce", "damage": 28, "cost": 1, "price": 24, "description": "Deal 28 damage, ignoring Block. Burn: 3 damage for 2 turns. Single use; any hero. Costs 1 AP."},
}
const EQUIPMENT: Dictionary = {
	"warden_epic": {"name": "Dreadsteel Longsword", "rarity": "epic", "hero": "warden", "slot": "weapon", "damage": 3, "max_hp": 4, "reflection": 10},
	"ranger_epic": {"name": "Nightthorn Bow", "rarity": "epic", "hero": "ranger", "slot": "weapon", "damage": 3, "poison_chance": 15},
	"occultist_epic": {"name": "Sanguine Bonewood", "rarity": "epic", "hero": "occultist", "slot": "weapon", "damage": 3, "life_drain": 15},
	"healer_epic": {"name": "Emberlight Mace", "rarity": "epic", "hero": "healer", "slot": "weapon", "damage": 1, "heal": 3, "regeneration": 1},
	"warden_sword": {"name": "Iron Longsword", "rarity": "common", "hero": "warden", "slot": "weapon", "damage": 1},
	"warden_shield": {"name": "Sentinel Shield", "rarity": "rare", "hero": "warden", "slot": "off_hand", "block": 3},
	"warden_legend": {"name": "Oathkeeper", "rarity": "legendary", "hero": "warden", "slot": "weapon", "damage": 4, "max_hp": 8, "reflection": 25},
	"ranger_bow": {"name": "Hunting Bow", "rarity": "common", "hero": "ranger", "slot": "weapon", "damage": 1},
	"ranger_armor": {"name": "Soothing Stalker Leathers", "rarity": "rare", "hero": "ranger", "slot": "armor", "max_hp": 8, "regeneration": 1},
	"ranger_legend": {"name": "Venomous Thornsong", "rarity": "legendary", "hero": "ranger", "slot": "weapon", "damage": 5, "poison_chance": 25},
	"occultist_staff": {"name": "Bonewood Staff", "rarity": "common", "hero": "occultist", "slot": "weapon", "damage": 1},
	"occultist_focus": {"name": "Purifying Gravebound Grimoire", "rarity": "rare", "hero": "occultist", "slot": "off_hand", "damage": 2, "heal": 2, "poison_resist": 50},
	"occultist_legend": {"name": "Vampiric Gravetide", "rarity": "legendary", "hero": "occultist", "slot": "weapon", "damage": 4, "heal": 3, "life_drain": 25},
	"healer_mace": {"name": "Pilgrim Mace", "rarity": "common", "hero": "healer", "slot": "weapon", "damage": 1},
	"healer_symbol": {"name": "Consecrated Symbol", "rarity": "rare", "hero": "healer", "slot": "off_hand", "heal": 3},
	"healer_legend": {"name": "Dawn's Mercy", "rarity": "legendary", "hero": "healer", "slot": "weapon", "damage": 2, "heal": 4, "regeneration": 2},
}
const SLOTS: Array[String] = ["weapon", "off_hand", "head", "armor", "trinket", "charm"]

static func item(item_id: String) -> Dictionary:
	return SCROLLS.get(item_id, EQUIPMENT.get(item_id, {}))

static func description(item_id: String) -> String:
	var entry: Dictionary = item(item_id)
	if entry.is_empty():
		return ""
	if entry.has("description"):
		return str(entry["description"])
	var text: String = "%s only · %s" % [str(entry["hero"]).capitalize(), str(entry["slot"]).replace("_", " ")]
	for stat in ["damage", "block", "heal", "max_hp"]:
		if entry.has(stat):
			text += " · +%d %s" % [int(entry[stat]), stat.replace("_", " ")]
	for stat in ["reflection", "life_drain", "poison_chance", "poison_resist"]:
		if entry.has(stat):
			text += " · %d%% %s" % [int(entry[stat]), stat.replace("_", " ")]
	if entry.has("regeneration"):
		text += " · Restore %d HP each party turn" % int(entry["regeneration"])
	return text

static func icon_path(item_id: String) -> String:
	# A per-item PNG override takes priority. SVGs remain editable source assets.
	var base: String = "res://assets/items/" + item_id
	return base + ".png" if ResourceLoader.exists(base + ".png") else base + ".svg"

static func tooltip(item_id: String) -> String:
	var entry: Dictionary = item(item_id)
	if entry.is_empty():
		return "Empty slot"
	return "%s\n%s\n%s" % [entry["name"], str(entry["rarity"]).to_upper(), description(item_id).replace(" · ", "\n")]

static func roll_rarity(rng: RandomNumberGenerator) -> String:
	var roll: int = rng.randi_range(1, 100)
	var cumulative: int = 0
	for rarity in RARITY_WEIGHTS:
		cumulative += int(RARITY_WEIGHTS[rarity])
		if roll <= cumulative:
			return str(rarity)
	return "legendary"

static func roll_scroll(rng: RandomNumberGenerator) -> String:
	var rarity: String = roll_rarity(rng)
	for item_id in SCROLLS:
		if SCROLLS[item_id]["rarity"] == rarity:
			return str(item_id)
	return "fire_bolt_scroll"

static func roll_equipment(rng: RandomNumberGenerator, active_party: Array, guaranteed_legendary: bool = false) -> String:
	var rarity: String = "legendary" if guaranteed_legendary else roll_rarity(rng)
	var pool: Array[String] = []
	for item_id in EQUIPMENT:
		var entry: Dictionary = EQUIPMENT[item_id]
		if entry["rarity"] == rarity and active_party.has(entry["hero"]):
			pool.append(str(item_id))
	return "" if pool.is_empty() else pool[rng.randi_range(0, pool.size() - 1)]
