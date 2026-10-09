extends RefCounted
## Shared game data + state. Each scene loads it by path:
##     const GameState := preload("res://scripts/game_data.gd")
## Static members keep it shared across scenes without an autoload.
## Shared state and game data that survives scene changes. A plain class_name
## with static members — no autoload required. The title, settlement, barracks,
## bestiary and combat scenes all read from here.

## --- Card data ----------------------------------------------------------------
## Effects: attack, block, attack_block, team_block, mark, pierce, weaken, drain,
##          stress_attack, heal, team_heal, stress_heal.
## `undead_bonus` adds damage against Undead enemies.
const CARDS: Dictionary = {
	"wd_slash": {"name": "Slash", "cost": 1, "effect": "attack", "damage": 6, "description": "Deal 6 damage."},
	"wd_guard": {"name": "Guard", "cost": 1, "effect": "block", "block": 6, "description": "Gain 6 Block."},
	"wd_bash": {"name": "Shield Bash", "cost": 2, "effect": "attack_block", "damage": 8, "block": 4, "description": "Deal 8 damage. Gain 4 Block."},
	"wd_rally": {"name": "Rally", "cost": 1, "effect": "team_block", "block": 3, "description": "All standing heroes gain 3 Block."},
	"wd_heavy": {"name": "Heavy Strike", "cost": 2, "effect": "attack", "damage": 13, "description": "Deal 13 damage."},
	"rg_quick": {"name": "Quick Shot", "cost": 1, "effect": "attack", "damage": 5, "description": "Deal 5 damage."},
	"rg_dodge": {"name": "Dodge", "cost": 1, "effect": "block", "block": 5, "description": "Gain 5 Block."},
	"rg_mark": {"name": "Mark Target", "cost": 1, "effect": "mark", "bonus": 4, "description": "Next hit deals +4 damage."},
	"rg_pierce": {"name": "Piercing Arrow", "cost": 2, "effect": "pierce", "damage": 10, "description": "Deal 10 damage. Ignore Block."},
	"rg_volley": {"name": "Volley", "cost": 2, "effect": "attack", "damage": 9, "description": "Deal 9 damage."},
	"oc_hex": {"name": "Hex Bolt", "cost": 1, "effect": "attack", "damage": 5, "description": "Deal 5 damage."},
	"oc_veil": {"name": "Veil", "cost": 1, "effect": "block", "block": 5, "description": "Gain 5 Block."},
	"oc_weak": {"name": "Withering Hex", "cost": 1, "effect": "weaken", "description": "Reduce enemy attack by 3 for 2 turns."},
	"oc_drain": {"name": "Soul Drain", "cost": 2, "effect": "drain", "damage": 8, "heal": 4, "description": "Deal 8 damage. Heal 4 HP."},
	"oc_blast": {"name": "Dark Blast", "cost": 2, "effect": "stress_attack", "damage": 14, "stress": 8, "description": "Deal 14 damage. Gain 8 Stress."},
	"hl_smite": {"name": "Smite", "cost": 1, "effect": "attack", "damage": 5, "undead_bonus": 4, "description": "Deal 5 damage. +4 vs Undead."},
	"hl_turn": {"name": "Turn Undead", "cost": 2, "effect": "attack", "damage": 6, "undead_bonus": 9, "description": "Deal 6 damage. +9 vs Undead."},
	"hl_mend": {"name": "Mend", "cost": 1, "effect": "heal", "heal": 7, "description": "Heal yourself for 7 HP."},
	"hl_blessing": {"name": "Blessing", "cost": 2, "effect": "team_heal", "heal": 5, "description": "All standing heroes heal 5 HP."},
	"hl_ward": {"name": "Sanctuary", "cost": 1, "effect": "block", "block": 6, "description": "Gain 6 Block."},
	"hl_solace": {"name": "Solace", "cost": 1, "effect": "stress_heal", "amount": 12, "description": "All standing heroes lose 12 Stress."},
}

## --- Heroes -------------------------------------------------------------------
## The roster the player draws a party of three from. Add a hero by appending an
## entry here (and dropping a portrait at `art`). `deck` lists card ids.
const HEROES: Dictionary = {
	"warden": {
		"name": "Warden", "max_hp": 55, "art": "res://assets/generated/hero_warden.png",
		"deck": ["wd_slash", "wd_slash", "wd_slash", "wd_slash", "wd_guard", "wd_guard", "wd_guard", "wd_bash", "wd_rally", "wd_heavy"],
	},
	"ranger": {
		"name": "Ranger", "max_hp": 38, "art": "res://assets/generated/hero_ranger.png",
		"deck": ["rg_quick", "rg_quick", "rg_quick", "rg_quick", "rg_dodge", "rg_dodge", "rg_dodge", "rg_mark", "rg_pierce", "rg_volley"],
	},
	"occultist": {
		"name": "Occultist", "max_hp": 34, "art": "res://assets/generated/hero_occultist.png",
		"deck": ["oc_hex", "oc_hex", "oc_hex", "oc_hex", "oc_veil", "oc_veil", "oc_veil", "oc_weak", "oc_drain", "oc_blast"],
	},
	"healer": {
		"name": "Healer", "max_hp": 42, "art": "res://assets/generated/hero_healer.png",
		"deck": ["hl_smite", "hl_smite", "hl_smite", "hl_turn", "hl_mend", "hl_mend", "hl_blessing", "hl_ward", "hl_ward", "hl_solace"],
	},
}

## The active party (hero ids, in slot order). Changed in the Barracks.
static var party: Array[String] = ["warden", "ranger", "occultist"]

## --- Creatures (the bestiary) -------------------------------------------------
## Lore and stats for every enemy. `undead` heroes take bonus damage from the
## Healer's holy attacks.
const CREATURES: Dictionary = {
	"hollow_villager": {
		"name": "Hollow Villager", "tags": ["Mortal"], "undead": false,
		"hp": 68, "attack": 7, "art": "res://assets/generated/enemy_hollow_villager.png",
		"lore": "An ashen plague hollowed this peasant out and left the body walking. It remembers the road it died on, and bars the way to any who pass.",
	},
	"bone_rabble": {
		"name": "Bone Rabble", "tags": ["Undead"], "undead": true,
		"hp": 58, "attack": 9, "art": "res://assets/generated/enemy_bone_rabble.png",
		"lore": "The ossuary's tenants do not rest. Bound by an old curse, they rise as a clattering rank of bone — swift, spiteful, and quick to turn from the light.",
	},
	"weald_stalker": {
		"name": "Weald Stalker", "tags": ["Beast"], "undead": false,
		"hp": 74, "attack": 8, "art": "",
		"lore": "Something old moves beneath the tangled boughs. None who entered the Weald have described it plainly, and fewer still returned to try.",
	},
}

## Creature ids the party has faced. The Archive reveals entries as they fill in.
static var discovered: Array[String] = []

## Embers earned from expeditions; spent in the Forge to upgrade cards.
static var embers: int = 0

## Card upgrade levels (card id -> level). Applied through card_stats().
static var card_levels: Dictionary = {}

const MAX_CARD_LEVEL := 3
const UPGRADE_BONUS := 2

## --- Expeditions --------------------------------------------------------------
const EXPEDITIONS: Array[Dictionary] = [
	{
		"id": "old_road", "name": "The Old Road", "region": "The Ruins", "difficulty": "Apprentice",
		"blurb": "A hollowed peasant blocks the ruined approach. A gentle first test.",
		"creature": "hollow_villager", "reward": 5, "locked": false,
	},
	{
		"id": "bone_warrens", "name": "The Bone Warrens", "region": "The Ossuary", "difficulty": "Apprentice",
		"blurb": "Restless bones claw free of the ossuary. Swift, and it strikes harder.",
		"creature": "bone_rabble", "reward": 7, "locked": false,
	},
	{
		"id": "tangled_weald", "name": "The Tangled Weald", "region": "The Weald", "difficulty": "Veteran",
		"blurb": "The forest has not yet been charted. New expeditions will be added here.",
		"creature": "weald_stalker", "reward": 12, "locked": true,
	},
]

static var selected_expedition: Dictionary = {}


# --- Helpers ------------------------------------------------------------------

static func select_expedition(expedition_id: String) -> bool:
	for expedition in EXPEDITIONS:
		if str(expedition.get("id", "")) == expedition_id:
			selected_expedition = expedition
			return true
	return false


static func hero(hero_id: String) -> Dictionary:
	return HEROES.get(hero_id, {})


static func creature(creature_id: String) -> Dictionary:
	return CREATURES.get(creature_id, {})


static func discover_creature(creature_id: String) -> void:
	if creature_id != "" and CREATURES.has(creature_id) and not discovered.has(creature_id):
		discovered.append(creature_id)


static func is_discovered(creature_id: String) -> bool:
	return discovered.has(creature_id)


# --- Card upgrades (the Forge) ------------------------------------------------

static func card_level(card_id: String) -> int:
	return int(card_levels.get(card_id, 0))


static func upgrade_cost(card_id: String) -> int:
	return 4 + card_level(card_id) * 3


static func can_upgrade(card_id: String) -> bool:
	return card_level(card_id) < MAX_CARD_LEVEL


static func upgrade_card(card_id: String) -> bool:
	if not can_upgrade(card_id):
		return false
	var cost := upgrade_cost(card_id)
	if embers < cost:
		return false
	embers -= cost
	card_levels[card_id] = card_level(card_id) + 1
	return true


## The card's numbers with its upgrade levels applied.
static func card_stats(card_id: String) -> Dictionary:
	var base: Dictionary = (CARDS.get(card_id, {}) as Dictionary).duplicate(true)
	var level := card_level(card_id)
	if level > 0:
		for key in ["damage", "block", "heal", "undead_bonus", "amount", "bonus"]:
			if base.has(key):
				base[key] = int(base[key]) + level * UPGRADE_BONUS
	return base


## Human-readable text built from the (upgraded) numbers.
static func card_description(card: Dictionary) -> String:
	match str(card.get("effect", "")):
		"attack":
			var text := "Deal %d damage." % int(card.get("damage", 0))
			if card.has("undead_bonus"):
				text += "  +%d vs Undead." % int(card["undead_bonus"])
			return text
		"pierce":
			return "Deal %d damage. Ignore Block." % int(card.get("damage", 0))
		"block":
			return "Gain %d Block." % int(card.get("block", 0))
		"attack_block":
			return "Deal %d damage. Gain %d Block." % [int(card.get("damage", 0)), int(card.get("block", 0))]
		"team_block":
			return "All standing heroes gain %d Block." % int(card.get("block", 0))
		"heal":
			return "Heal yourself for %d HP." % int(card.get("heal", 0))
		"team_heal":
			return "All standing heroes heal %d HP." % int(card.get("heal", 0))
		"stress_heal":
			return "All standing heroes lose %d Stress." % int(card.get("amount", 0))
		"mark":
			return "Next hit deals +%d damage." % int(card.get("bonus", 0))
		"weaken":
			return "Reduce enemy attack by 3 for 2 turns."
		"drain":
			return "Deal %d damage. Heal %d HP." % [int(card.get("damage", 0)), int(card.get("heal", 0))]
		"stress_attack":
			return "Deal %d damage. Gain %d Stress." % [int(card.get("damage", 0)), int(card.get("stress", 0))]
	return str(card.get("description", ""))