extends RefCounted
const Items = preload("res://scripts/item_data.gd")
const Events = preload("res://scripts/dungeon_events.gd")
const Mechanics = preload("res://scripts/expedition_mechanics.gd")
static var graves: Array = []
static var run_deeds: Dictionary = {}
static var run_id: String = ""
static var hero_names: Dictionary = {}
static var hero_progress: Dictionary = {}
const HERO_LEVEL_CAP: int = 10
const TRAINING_STATS: Dictionary = {
 "max_hp": {"name": "Vitality", "amount": 3, "description": "+3 maximum HP"},
 "damage_percent": {"name": "Might", "amount": 4, "description": "+4% skill damage"},
 "block": {"name": "Guard", "amount": 1, "description": "+1 block from block skills"},
 "heal": {"name": "Restoration", "amount": 1, "description": "+1 healing from healing skills"},
 "debuff_resist": {"name": "Resolve", "amount": 3, "description": "+3% resistance to debuff application"}
}
static var hero_colors: Dictionary = {}
static var formation: Dictionary = {}
static var hero_positions: Dictionary = {}
static var journey: Dictionary = {}
static var last_report: Dictionary = {}
const Depth = preload("res://scripts/dungeon_depth.gd")
static var modifications: Dictionary = {}
static var pending_service: String = "watchtower"
static var scout_uses: int = 2
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
 "pc_strike": {"name": "Barbed Strike", "cost": 1, "effect": "attack", "damage": 6},
 "pc_guard": {"name": "Iron Penance", "cost": 1, "effect": "block", "block": 6},
 "pc_pain": {"name": "Rapture of Pain", "cost": 1, "effect": "pain_heal", "self_damage": 2, "heal_percent": 15},
 "pc_charge": {"name": "Thornbound Charge", "cost": 2, "effect": "barbed_charge", "damage": 8, "block": 6, "status": "bleed"},
 "pc_verdict": {"name": "Crimson Verdict", "cost": 2, "effect": "attack", "damage": 12},
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
 "crusader": {"name": "Penitent Crusader", "max_hp": 50, "art": "res://assets/generated/hero_crusader.tres", "camp_art": "res://assets/generated/hero_crusader_camp.tres", "abilities": ["pc_strike", "pc_guard", "pc_pain", "pc_charge", "pc_verdict"], "lore": "During the Hell Crusades, a demon of pain cursed him with an unending hunger for sensation. Barbs beneath his armor pull at his flesh with every breath. He calls each wound a sacrament, and each moment of relief a debt."},
	"warden": {
		"name": "Warden", "max_hp": 55, "art": "res://assets/generated/hero_warden.png",
		"camp_art": "res://assets/generated/hero_warden_camp.png",
		"abilities": ["wd_slash", "wd_guard", "wd_bash", "wd_rally", "wd_heavy"],
	},
	"ranger": {
		"name": "Ranger", "max_hp": 38, "art": "res://assets/generated/hero_ranger.tres",
		"camp_art": "res://assets/generated/hero_ranger_camp.png",
		"abilities": ["rg_quick", "rg_dodge", "rg_mark", "rg_pierce", "rg_volley"],
	},
	"occultist": {
		"name": "Occultist", "max_hp": 34, "art": "res://assets/generated/hero_occultist.tres",
		"camp_art": "res://assets/generated/hero_occultist_camp.png",
		"abilities": ["oc_hex", "oc_veil", "oc_weak", "oc_drain", "oc_blast"],
	},
	"healer": {
		"name": "Healer", "max_hp": 42, "art": "res://assets/generated/hero_healer.tres",
		"camp_art": "res://assets/generated/hero_healer_camp.png",
		"abilities": ["hl_smite", "hl_turn", "hl_mend", "hl_blessing", "hl_ward", "hl_solace"],
	},
}

## The active party (hero ids, in slot order). Changed in the Barracks.
static var party: Array[String] = ["warden", "ranger", "occultist"]

## --- Creatures (the bestiary) -------------------------------------------------
## Lore and stats for every enemy. `undead` heroes take bonus damage from the
## Healer's holy attacks.
const CREATURES: Dictionary = {
	"moth_metamorph": {"name": "Moth Acolyte Metamorph", "hp": 42, "attack": 6, "art": "res://assets/generated/enemy_moth_metamorph.png", "undead": false, "tags": ["Moth", "Cultist"], "lore": "A patient remade by the dispensary's luminous infestation. Beneath the rags, humanity has become a hunger with wings."},
	"moth_oleander": {"name": "Moth Knight Oleander", "hp": 54, "attack": 6, "art": "res://assets/generated/enemy_moth_oleander.png", "undead": false, "tags": ["Moth", "Knight", "Boss"], "lore": "The queen's sworn guardian keeps vigil over the ruined surgical ward, his broken chivalry surviving in a body stripped of humanity."},
	"moth_exuvia": {"name": "Moth Queen Exuvia", "hp": 75, "attack": 7, "art": "res://assets/generated/enemy_moth_exuvia.png", "undead": false, "tags": ["Moth", "Boss"], "lore": "A swollen sovereign of luminous dust and discarded flesh. The apothecary's patients became offerings to her endless metamorphosis."},
 "keep_footman": {"name": "Revenant Footman", "hp": 54, "attack": 8, "undead": true, "tags": ["Revenant", "Keep"], "art": "res://assets/generated/enemy_keep_footman.tres", "lore": "The road gangs pay tribute to dead masters. Beneath their stolen banners, these ancient footmen march again, the wounds of the keep's fall still open."},
 "keep_crossbow": {"name": "Grave Crossbowman", "hp": 48, "attack": 9, "undead": true, "tags": ["Revenant", "Keep"], "art": "res://assets/generated/enemy_keep_crossbow.tres", "lore": "A wrapped face gives no warning as the bolt leaves its string. Rusted steel carries the cold of the crypt through living flesh."},
 "keep_wolfguard": {"name": "Wolfguard Reaver", "hp": 62, "attack": 9, "undead": true, "tags": ["Revenant", "Elite", "Keep"], "art": "res://assets/generated/enemy_keep_wolfguard.tres", "lore": "A noble guard beneath a ragged wolf mantle. Its poleaxe answers the lord's summons, and the gaps in its armor reveal what loyalty has cost."},
 "keep_son": {"name": "The Last Honorable Son", "hp": 70, "attack": 8, "undead": true, "tags": ["Revenant", "Knight", "Boss"], "art": "res://assets/generated/enemy_keep_son.png", "lore": "The last scion of the ruined keep still bars the stair to his father's court. A beast's howl escapes where an honorable oath once lived."},
 "undying_lord": {"name": "The Undying Lord", "hp": 90, "attack": 8, "undead": true, "tags": ["Revenant", "Monstrosity", "Boss"], "art": "res://assets/generated/enemy_undying_lord.png", "lore": "An ancestral tyrant wears his household's relics as a crown. Many hands clutch the instruments of his reign, and no wound has taught him to release them."},
	"anguish_penitent": {"name": "Creation of Anguish: Penitent", "hp": 48, "attack": 7, "undead": false, "tags": ["Remade", "Cult"], "art": "res://assets/generated/enemy_anguish_penitent.png", "lore": "The faithful call each new wound a doorway. This supplicant begs to be remade again."},
	"anguish_vessel": {"name": "Creation of Anguish: Vessel", "hp": 54, "attack": 8, "undead": false, "tags": ["Remade", "Cult"], "art": "res://assets/generated/enemy_anguish_vessel.png", "lore": "Several prayers inhabit one body. None can finish a sentence without another mouth answering."},
	"harrowed_giant": {"name": "Harrowed Slave Giant", "hp": 76, "attack": 8, "undead": false, "tags": ["Remade", "Boss"], "art": "res://assets/generated/enemy_harrowed_giant.png", "lore": "A living reliquary kneels beneath the weight of the congregation. Its chains are sacred to those who forged them."},
	"coterie_seamkeeper": {"name": "The Coterie: Seamkeeper", "hp": 28, "attack": 5, "undead": false, "tags": ["Remade", "Boss"], "art": "res://assets/generated/enemy_coterie_seamkeeper.png", "lore": "The first master stitches devotion into unwilling flesh."},
	"coterie_cantor": {"name": "The Coterie: Bone Cantor", "hp": 34, "attack": 6, "undead": false, "tags": ["Remade", "Boss"], "art": "res://assets/generated/enemy_coterie_cantor.png", "lore": "The second master conducts a choir through the pipes of a remade chest."},
	"coterie_matron": {"name": "The Coterie: Matron of Remaking", "hp": 40, "attack": 7, "undead": false, "tags": ["Remade", "Boss"], "art": "res://assets/generated/enemy_coterie_matron.png", "lore": "The last master blesses the congregation with another shape, and another grief."},
	"howling_head": {"name": "The Howling Head", "hp": 84, "attack": 8, "undead": false, "tags": ["Remade", "Boss"], "art": "res://assets/generated/enemy_howling_head.png", "lore": "At the end of the pilgrimage, every prayer becomes a single unending howl."},

	"ash_raider": {
		"name": "Ash Raider", "tags": ["Human", "Bandit"], "undead": false,
		"hp": 58, "attack": 8, "art": "res://assets/generated/enemy_ash_raider.png",
		"lore": "A butcher of the ruined road, wrapped in stolen leather and rusted iron. Their toll is paid in blood.",
	},
	"gallows_scout": {
		"name": "Gallows Scout", "tags": ["Human", "Bandit"], "undead": false,
		"hp": 46, "attack": 10, "art": "res://assets/generated/enemy_gallows_scout.tres",
		"lore": "The gang's watchful hunter waits beneath the gallows, marking travelers for the cleaver.",
	},
	"ash_chieftain": {
		"name": "Gallows Chieftain", "tags": ["Human", "Bandit", "Boss"], "undead": false,
		"hp": 82, "attack": 10, "art": "res://assets/generated/enemy_ash_bandit_captain.tres",
		"lore": "A scarred tyrant who binds the road gangs through terror. His shield is patched with the possessions of those who refused to kneel.",
	},
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

## Gold earned from expeditions; spent in the Forge to upgrade cards.
static var gold: int = 0

## Card upgrade levels (card id -> level). Applied through card_stats().
static var card_levels: Dictionary = {}

const MAX_CARD_LEVEL := 3
const UPGRADE_BONUS := 2

## --- Expeditions --------------------------------------------------------------
const EXPEDITIONS: Array[Dictionary] = [
	{"id": "restore_watchtower", "name": "The Occupied Watchtower", "region": "The Hamlet", "difficulty": "Apprentice", "creature": "gallows_scout", "faction": "human", "reward": 8, "floor_count": 1, "internal": true, "restoration": "watchtower", "blurb": "Three rooms: scouts, camp, chieftain. Restore the watchtower."},
	{"id": "restore_infirmary", "name": "The Abandoned Sickhouse", "region": "The Hamlet", "difficulty": "Initiate", "creature": "moth_metamorph", "faction": "moth", "reward": 8, "floor_count": 1, "internal": true, "restoration": "infirmary", "combat_background": "res://assets/generated/apothecary_interior.png", "camp_background": "res://assets/generated/apothecary_interior.png", "blurb": "Three rooms: infestation, camp, guardian. Restore the infirmary."},
	{"id": "restore_workshop", "name": "The Seized Workshop", "region": "The Hamlet", "difficulty": "Apprentice", "creature": "ash_raider", "faction": "human", "reward": 8, "floor_count": 1, "internal": true, "restoration": "workshop", "blurb": "Three rooms: raiders, camp, chieftain. Restore the workshop."},
	{"id": "infested_apothecary", "name": "The Infested Apothecary", "region": "The Hamlet", "difficulty": "Initiate · Apprentice–Adept", "faction": "moth", "creature": "moth_metamorph", "reward": 10, "locked": false, "floor_count": 1, "internal": true, "floor_names": ["The Infested Medical Ward"], "combat_background": "res://assets/generated/apothecary_interior.png", "camp_background": "res://assets/generated/apothecary_interior.png", "blurb": "Four chambers. Three fights. One refuge. Clear the infestation to restore the hamlet's apothecary."},
	{"id": "path_beast", "name": "Path of the Beast", "region": "The Path", "difficulty": "Veteran", "faction": "remade", "creature": "anguish_penitent", "reward": 15, "locked": false, "floor_count": 3,
	"combat_background": "res://assets/generated/beast_sanctuary.png", "camp_background": "res://assets/generated/beast_camp.png",
	"blurb": "Descend a pilgrimage of despair. The faithful worship being remade; their blessings leave no body whole.",
	"floor_bosses": ["harrowed_giant", "coterie_seamkeeper", "howling_head"], "floor_names": ["The Halls of Anguish", "The Choir of Remaking", "The Altar of the Beast"]},
	{"id": "village_chapel", "name": "The Hollow Chapel", "region": "The Abandoned Village", "floor_count": 3, "released": false, "requires": "old_road", "blurb": "A sealed chapel beyond the bandit road. Coming in a future release."},
	{"id": "village_keep", "name": "The Forsaken Keep", "region": "The Abandoned Village", "floor_count": 3, "released": false, "requires": "village_chapel", "blurb": "The abandoned lord's fortress. Coming in a future release."},
	{"id": "path_lament", "name": "Path of Lament", "region": "The Path", "floor_count": 3, "released": false, "requires": "path_beast", "blurb": "A mourning procession beyond the sanctuary. Coming in a future release."},
	{"id": "path_ascension", "name": "Path of Ascension", "region": "The Path", "floor_count": 3, "released": false, "requires": "path_lament", "blurb": "The final sealed pilgrimage. Coming in a future release."},

	{
		"id": "old_road", "name": "The Old Road", "floor_count": 3, "region": "The Abandoned Village", "combat_background": "res://assets/generated/bandit_combat.png", "camp_background": "res://assets/generated/bandit_camp.png", "difficulty": "Apprentice",
		"blurb": "Follow the bandits' tribute into a ruined keep. Break its last son's vigil, then end the Undying Lord's reign.",
		"floor_names": ["The Bandit Road", "The Keep's Outer Ward", "The Undying Court"],
		"floor_enemy_pools": [["ash_raider", "gallows_scout"], ["keep_footman", "keep_crossbow"], ["keep_wolfguard", "keep_footman", "keep_crossbow"]],
		"floor_bosses": ["", "keep_son", "undying_lord"],
		"floor_combat_backgrounds": ["res://assets/generated/bandit_combat.png", "res://assets/generated/keep_hall.png", "res://assets/generated/keep_hall.png"],
		"floor_camp_backgrounds": ["res://assets/generated/bandit_camp.png", "res://assets/generated/keep_hall.png", "res://assets/generated/keep_hall.png"],
		"creature": "ash_raider", "faction": "human", "reward": 5, "locked": false,
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
static var completed_expeditions: Array[String] = []
static var crusader_unlocked: bool = false
static var progress_loaded: bool = false
static var progress_path: String = "user://expedition_progress.cfg"

static func expedition_by_id(id: String) -> Dictionary:
	for expedition in EXPEDITIONS:
		if expedition["id"] == id:
			return expedition
	return {}

static func can_embark(id: String) -> bool:
	var expedition := expedition_by_id(id)
	return not expedition.is_empty() and expedition.get("released", true) and not expedition.get("locked", false) and (not expedition.has("requires") or completed_expeditions.has(str(expedition["requires"])))

static func load_progression() -> void:
	if progress_loaded:
		return
	progress_loaded = true
	var config := ConfigFile.new()
	if config.load(progress_path) == OK:
		modifications = config.get_value("progress", "modifications", {})
		last_report = config.get_value("progress", "last_report", {})
		hero_progress = config.get_value("progress", "hero_progress", {})
		hero_names = config.get_value("progress", "hero_names", {})
		hero_colors = config.get_value("progress", "hero_colors", {})
		graves = config.get_value("progress", "graves", [])
		crusader_unlocked = bool(config.get_value("progress", "crusader_unlocked", false))
		for id in config.get_value("progress", "completed", []):
			if not expedition_by_id(str(id)).is_empty() and not completed_expeditions.has(str(id)):
				completed_expeditions.append(str(id))

static func save_progression() -> void:
	if not progress_loaded:
		return
	var config := ConfigFile.new()
	config.set_value("progress", "last_report", last_report)
	config.set_value("progress", "hero_progress", hero_progress)
	config.set_value("progress", "graves", graves)
	config.set_value("progress", "hero_names", hero_names)
	config.set_value("progress", "hero_colors", hero_colors)
	config.set_value("progress", "crusader_unlocked", crusader_unlocked)
	config.set_value("progress", "completed", completed_expeditions)
	config.set_value("progress", "modifications", modifications)
	config.save(progress_path)

static func floor_title() -> String:
	var names: Array = selected_expedition.get("floor_names", [])
	return str(names[floor_index]) if floor_index < names.size() else "Floor %d" % (floor_index + 1)

static func can_descend() -> bool:
	if not run_active or floor_index >= floor_count - 1:
		return false
	var room: Dictionary = floors[floor_index][room_position]
	return room["kind"] == "stairs" or (room.get("exit_after_boss", false) and room["cleared"])



# --- Helpers ------------------------------------------------------------------

static func select_expedition(expedition_id: String) -> bool:
	if not can_embark(expedition_id):
		return false
	for expedition in EXPEDITIONS:
		if str(expedition.get("id", "")) == expedition_id:
			selected_expedition = expedition
			return true
	return false


static func hero(hero_id: String) -> Dictionary:
	var result: Dictionary = HEROES.get(hero_id, {}).duplicate(true)
	if not result.is_empty():
		result["class"] = result["name"]
		result["name"] = hero_names.get(hero_id, result["name"])
	return result


static func creature(creature_id: String) -> Dictionary:
	var result: Dictionary = CREATURES.get(creature_id, {}).duplicate(true)
	var extra: String = preload("res://scripts/world_lore.gd").CREATURE_NOTES.get(creature_id, "")
	if not result.is_empty() and not extra.is_empty(): result["lore"] = str(result.get("lore", "")) + "\n\n" + extra
	return result


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
	if gold < cost:
		return false
	gold -= cost
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
		"pain_heal":
			return "Pay 2 HP; heal 15% max HP. Needs >2 HP."
		"barbed_charge":
			return "%d damage + %d Block. Hit: Bleed 2/t for 2 turns." % [int(card["damage"]), int(card["block"])]
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


# Abilities use the existing illustrated definitions and Forge upgrades.
static func hero_abilities(hero_id: String) -> Array:
	var result: Array = []
	for ability_id in hero(hero_id).get("abilities", []):
		if not result.has(ability_id):
			result.append(ability_id)
	return result

static func ability_cooldown(ability_id: String) -> int:
	var ability: Dictionary = card_stats(ability_id)
	if str(ability.get("effect", "")) in ["heal", "team_heal", "stress_heal", "team_block", "weaken", "drain", "pain_heal", "barbed_charge"]:
		return 2
	return 1 if int(ability.get("cost", 1)) > 1 else 0

static var run_active: bool = false
static var run_complete: bool = false
static var floor_index: int = 0
static var floor_count: int = 2
static var floors: Array = []
static var room_position: Vector2i = Vector2i.ZERO
static var run_heroes: Dictionary = {}
static var navigation_voters: Array[String] = ["local"]
static var navigation_votes: Dictionary = {}
static var run_seed: int = 0

static func start_run(seed_value: int = -1) -> void:
	preload("res://scripts/settlement_music.gd").stop()
	load_progression()
	run_id = str(Time.get_unix_time_from_system()) + "-" + str(randi())
	run_deeds.clear()
	Depth.normalize_positions(load("res://scripts/game_data.gd"))
	journey = Depth.begin_journey(load("res://scripts/game_data.gd"))
	run_seed = seed_value if seed_value >= 0 else randi()
	var rng := RandomNumberGenerator.new()
	rng.seed = run_seed
	loot_rng.seed = run_seed + 104729
	run_active = true
	run_complete = false
	floor_index = 0
	floor_count = int(selected_expedition.get("floor_count", rng.randi_range(2, 3)))
	room_position = Vector2i.ZERO
	run_heroes.clear()
	navigation_votes.clear()
	floors.clear()
	scout_uses = 3 if service_unlocked("watchtower") else 2
	if selected_expedition.has("restoration"):
		var service: Dictionary = Mechanics.SERVICES[selected_expedition["restoration"]]
		floors.append({
			Vector2i.ZERO: {"kind": "battle", "enemies": [service["enemy"], service["enemy"]], "creature": service["enemy"], "cleared": false, "seen": true},
			Vector2i(1, 0): {"kind": "camp", "cleared": false, "seen": true},
			Vector2i(2, 0): {"kind": "boss", "enemies": [service["boss"]], "creature": service["boss"], "cleared": false, "seen": true, "final_boss": true}
		})
		ensure_run_heroes()
		return
	if selected_expedition.get("id", "") == "infested_apothecary":
		floors.append({
			Vector2i(0, 0): {"kind": "battle", "creature": "moth_metamorph", "enemies": ["moth_metamorph", "moth_metamorph", "moth_metamorph"], "enemy_health_scale": 0.65, "enemy_damage_scale": 0.7, "cleared": false, "seen": true, "name": "The Infested Dispensary"},
			Vector2i(1, 0): {"kind": "camp", "cleared": false, "seen": true, "name": "The Sealed Sickroom"},
			Vector2i(2, 0): {"kind": "boss", "creature": "moth_oleander", "enemies": ["moth_oleander"], "final_boss": false, "cleared": false, "seen": true, "name": "Oleander's Ward"},
			Vector2i(3, 0): {"kind": "boss", "creature": "moth_exuvia", "enemies": ["moth_exuvia"], "final_boss": true, "cleared": false, "seen": true, "name": "The Queen's Theatre"}
		})
		ensure_run_heroes()
		return
	for depth in range(floor_count):
		var rooms: Dictionary = {Vector2i.ZERO: {"kind": "entry", "cleared": true, "seen": true}}
		var cursor := Vector2i.ZERO
		# A monotonic backbone guarantees a reachable exit; branches add exploration.
		while cursor != Vector2i(4, 3):
			if cursor.x < 4 and (cursor.y == 3 or rng.randf() < 0.55):
				cursor += Vector2i.RIGHT
			else:
				cursor += Vector2i.DOWN
			rooms[cursor] = {"kind": "battle", "cleared": false, "seen": false}
		var backbone: Array = rooms.keys()
		for origin in backbone:
			var branch: Vector2i = origin + [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT][rng.randi_range(0, 3)]
			if branch.x >= 0 and branch.x <= 4 and branch.y >= 0 and branch.y <= 3 and not rooms.has(branch):
				rooms[branch] = {"kind": "treasure" if rng.randf() < 0.5 else "camp", "cleared": false, "seen": false}
		# Grow extra connected chambers so the floor reads as a dungeon rather
		# than a single route. All branches remain reachable from the entrance.
		for attempt in range(24):
			if rooms.size() >= 15:
				break
			var origins: Array = rooms.keys()
			var origin: Vector2i = origins[rng.randi_range(0, origins.size() - 1)]
			var branch: Vector2i = origin + [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT][rng.randi_range(0, 3)]
			if branch.x >= 0 and branch.x <= 4 and branch.y >= 0 and branch.y <= 3 and not rooms.has(branch):
				var roll: float = rng.randf()
				rooms[branch] = {"kind": "battle" if roll < 0.5 else ("treasure" if roll < 0.8 else "camp"), "cleared": false, "seen": false}
		rooms[Vector2i(4, 3)]["kind"] = "boss" if depth == floor_count - 1 else "stairs"
		var enemy_pool: Array = floor_enemy_pool(depth)
		if selected_expedition.get("faction", "") == "human":
			for location in rooms:
				rooms[location]["creature"] = "ash_chieftain" if rooms[location]["kind"] == "boss" else str(enemy_pool[rng.randi_range(0, enemy_pool.size() - 1)])
			var guardians: Array = selected_expedition.get("floor_bosses", [])
			if depth < guardians.size() and str(guardians[depth]) != "":
				var guardian: Dictionary = rooms[Vector2i(4, 3)]
				guardian["kind"] = "boss"
				guardian["creature"] = str(guardians[depth])
				guardian["final_boss"] = depth == floor_count - 1
				guardian["exit_after_boss"] = depth < floor_count - 1
		if selected_expedition.get("faction", "") == "remade":
			for location in rooms:
				rooms[location]["creature"] = ["anguish_penitent", "anguish_vessel"][rng.randi_range(0, 1)]
			var guardian: Dictionary = rooms[Vector2i(4, 3)]
			guardian["kind"] = "boss"
			guardian["creature"] = selected_expedition["floor_bosses"][depth]
			guardian["final_boss"] = depth == floor_count - 1
			guardian["exit_after_boss"] = depth < floor_count - 1
			if depth == 1:
				guardian["boss_phases"] = ["coterie_seamkeeper", "coterie_cantor", "coterie_matron"]
		for location in rooms:
			var room: Dictionary = rooms[location]
			var primary: String = str(room.get("creature", selected_expedition.get("creature", "hollow_villager")))
			if room["kind"] == "boss":
				room["enemies"] = [primary]
				room["support_creature"] = str(enemy_pool[enemy_pool.size() - 1]) if selected_expedition.get("faction", "") == "human" else str(selected_expedition.get("creature", "hollow_villager"))
				if selected_expedition.get("faction", "") == "remade":
					room["support_creature"] = "anguish_penitent"
					if room.has("boss_phases"):
						room.erase("support_creature")
			elif room["kind"] == "battle":
				room["enemies"] = [primary]
				for extra in range(rng.randi_range(0, 2)):
					room["enemies"].append(str(enemy_pool[rng.randi_range(0, enemy_pool.size() - 1)]) if selected_expedition.get("faction", "") == "human" else primary)
		# Guarantee a camp and exactly one orb room on every floor.
		var camps: Array = []
		var battles: Array = []
		for location in rooms:
			if rooms[location]["kind"] == "camp":
				camps.append(location)
			elif rooms[location]["kind"] == "battle":
				battles.append(location)
		if camps.is_empty() and battles.size() > 1:
			var campsite: Vector2i = battles.pop_back()
			rooms[campsite]["kind"] = "camp"
		var orb_room: Vector2i = battles[rng.randi_range(0, battles.size() - 1)]
		rooms[orb_room]["merchant_orb"] = true
		# Add 3–5 room/corridor events without replacing camps, exits or orbs.
		var event_candidates: Array = []
		for location in rooms:
			if rooms[location]["kind"] == "treasure":
				event_candidates.append(location)
		for location in battles:
			if location != orb_room:
				event_candidates.append(location)
		var event_pool: Array = Events.pool(str(selected_expedition.get("faction", "")))
		for event_index in range(mini(rng.randi_range(3, 5), event_candidates.size())):
			var choice: int = rng.randi_range(0, event_candidates.size() - 1)
			var location: Vector2i = event_candidates.pop_at(choice)
			rooms[location]["kind"] = "event"
			rooms[location]["event_id"] = event_pool[rng.randi_range(0, event_pool.size() - 1)]
			rooms[location]["event_seed"] = rng.randi()
			rooms[location]["event_layout"] = "corridor" if rng.randf() < 0.5 else "room"
			if rooms[location]["event_layout"] == "corridor":
				var corridor_roll: float = rng.randf()
				rooms[location]["corridor_encounter"] = "gold" if corridor_roll < 0.40 else ("roamer" if corridor_roll < 0.65 else "object")
				rooms[location]["small_gold"] = rng.randi_range(1, 4)
		if depth == 1 and selected_expedition.get("id", "") == "old_road" and not crusader_unlocked:
			for location in rooms:
				if rooms[location]["kind"] == "event":
					rooms[location]["event_id"] = "crusader_coffin"
					rooms[location]["event_layout"] = "room"
					rooms[location].erase("corridor_encounter")
					break
		floors.append(rooms)
	ensure_run_heroes()
	reveal_neighbors()

static func current_room_kind() -> String:
	return str(floors[floor_index][room_position]["kind"]) if run_active else ""

static func enter_corridor() -> Dictionary:
	if not run_active:
		return {}
	var room: Dictionary = floors[floor_index][room_position]
	if room.get("event_layout", "") != "corridor" or room.get("cleared", false):
		return {}
	var encounter: String = str(room.get("corridor_encounter", "object"))
	if encounter == "gold" and not room.get("corridor_claimed", false):
		room["corridor_claimed"] = true
		room["event_resolved"] = true
		room["cleared"] = true
		var amount: int = int(room["small_gold"])
		gold += amount
		return {"kind": "gold", "amount": amount}
	if encounter == "roamer":
		room["kind"] = "battle"
		room["enemies"] = [str(room.get("creature", selected_expedition.get("creature", "hollow_villager")))]
		room["corridor_surprise"] = true
		room.erase("support_creature")
		return {"kind": "roamer"}
	return {}

static func reveal_neighbors() -> void:
	var rooms: Dictionary = floors[floor_index]
	rooms[room_position]["seen"] = true
	for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		if rooms.has(room_position + direction):
			rooms[room_position + direction]["seen"] = true
	if service_unlocked("watchtower"):
		for location in rooms:
			if abs(location.x - room_position.x) + abs(location.y - room_position.y) <= 2:
				rooms[location]["seen"] = true
				rooms[location]["scouted"] = true

# Every participant must agree on the same adjacent destination. Networking
# can feed player IDs into this authority without changing dungeon rules.
static func vote_move(voter_id: String, destination: Vector2i) -> bool:
	if not run_active or run_complete or not navigation_voters.has(voter_id):
		return false
	if not bool(floors[floor_index][room_position]["cleared"]):
		return false
	if abs(destination.x - room_position.x) + abs(destination.y - room_position.y) != 1 or not floors[floor_index].has(destination):
		return false
	navigation_votes[voter_id] = destination
	for voter in navigation_voters:
		if navigation_votes.get(voter, Vector2i(-1, -1)) != destination:
			return false
	room_position = destination
	navigation_votes.clear()
	reveal_neighbors()
	Depth.explore(load("res://scripts/game_data.gd"), floors[floor_index][room_position])
	return true

static func finish_encounter() -> void:
	floors[floor_index][room_position]["cleared"] = true
	if current_room_kind() == "boss" and floors[floor_index][room_position].get("final_boss", true):
		if selected_expedition.get("id", "") == "infested_apothecary" or selected_expedition.has("restoration"):
			for room in floors[0].values():
				if room["kind"] in ["battle", "boss"] and not room["cleared"]:
					return
		run_complete = true
		var id: String = str(selected_expedition.get("id", ""))
		if id != "" and not completed_expeditions.has(id):
			completed_expeditions.append(id)
			save_progression()

static func descend() -> bool:
	if not can_descend():
		return false
	floor_index += 1
	scout_uses = 3 if service_unlocked("watchtower") else 2
	room_position = Vector2i.ZERO
	navigation_votes.clear()
	reveal_neighbors()
	return true

static func end_run() -> void:
	if run_active:
		last_report = Depth.aftermath(load("res://scripts/game_data.gd"))
		save_progression()
	run_active = false
	run_heroes.clear()
	navigation_votes.clear()


# Party inventory/equipment persist across expeditions during this game session.
static var inventory: Dictionary = {}
static var equipment: Dictionary = {}
static var loot_rng: RandomNumberGenerator = RandomNumberGenerator.new()
static var shop_return_scene: String = "res://scenes/hub/settlement.tscn"
const APOTHECARY_CATALOG: Array[String] = ["healing_potion", "cleansing_potion", "solace_potion", "healing_scroll", "might_tonic", "focus_tonic", "ward_tonic"]

static func purchase_apothecary_item(item_id: String) -> bool:
	return apothecary_unlocked() and APOTHECARY_CATALOG.has(item_id) and purchase_item(item_id)

static func add_item(item_id: String, amount: int = 1) -> void:
	if not Items.item(item_id).is_empty() and amount > 0:
		inventory[item_id] = int(inventory.get(item_id, 0)) + amount
		if run_active:
			var found: Dictionary = journey.get("loot", {})
			found[item_id] = int(found.get(item_id, 0)) + amount
			journey["loot"] = found

static func consume_scroll(item_id: String) -> bool:
	return consume_item(item_id) if Items.SCROLLS.has(item_id) else false

static func consume_item(item_id: String) -> bool:
	if Items.item(item_id).get("kind", "") not in ["scroll", "potion", "provision"] or int(inventory.get(item_id, 0)) <= 0:
		return false
	inventory[item_id] = int(inventory[item_id]) - 1
	if inventory[item_id] <= 0:
		inventory.erase(item_id)
	return true

static func purchase_scroll(item_id: String) -> bool:
	if not Items.SCROLLS.has(item_id) or Items.item(item_id).get("rarity", "") == "legendary":
		return false
	var price: int = int(Items.SCROLLS[item_id]["price"])
	if gold < price:
		return false
	gold -= price
	add_item(item_id)
	return true

# XP belongs to the hero, independently of equipment and forge upgrades.
static func leveling(hero_id: String) -> Dictionary:
	var raw: Dictionary = hero_progress.get(hero_id, {})
	return {"level": clampi(int(raw.get("level", 1)), 1, HERO_LEVEL_CAP), "xp": maxi(0, int(raw.get("xp", 0))), "points": maxi(0, int(raw.get("points", 0))), "stats": raw.get("stats", {}).duplicate(true)}

static func xp_required(level: int) -> int:
	return 40 + (level - 1) * 25

static func gain_hero_xp(hero_id: String, amount: int) -> int:
	if not HEROES.has(hero_id) or amount <= 0 or (hero_id == "crusader" and not crusader_unlocked):
		return 0
	var progress: Dictionary = leveling(hero_id)
	var previous: int = int(progress["level"])
	progress["xp"] += amount
	while int(progress["level"]) < HERO_LEVEL_CAP and int(progress["xp"]) >= xp_required(int(progress["level"])):
		progress["xp"] -= xp_required(int(progress["level"]))
		progress["level"] += 1
		progress["points"] += 2
	if int(progress["level"]) == HERO_LEVEL_CAP:
		progress["xp"] = 0
	hero_progress[hero_id] = progress
	if run_heroes.has(hero_id):
		# Growth increases capacity, without restoring lost health.
		run_heroes[hero_id]["max_hp"] = hero_max_hp(hero_id)
	save_progression()
	return int(progress["level"]) - previous

static func training_bonus(hero_id: String, stat: String) -> int:
	var progress: Dictionary = leveling(hero_id)
	var bonus: int = (int(progress["level"]) - 1) * 2 if stat == "max_hp" else 0
	if TRAINING_STATS.has(stat):
		bonus += clampi(int(progress["stats"].get(stat, 0)), 0, 6) * int(TRAINING_STATS[stat]["amount"])
	return bonus

static func hero_bonus(hero_id: String, stat: String) -> int:
	return equipment_bonus(hero_id, stat) + training_bonus(hero_id, stat)

static func train_hero(hero_id: String, stat: String) -> bool:
	# Train in the settlement, never change combat stats during a run.
	if run_active or not HEROES.has(hero_id) or not TRAINING_STATS.has(stat) or (hero_id == "crusader" and not crusader_unlocked):
		return false
	var progress: Dictionary = leveling(hero_id)
	if int(progress["points"]) <= 0 or int(progress["stats"].get(stat, 0)) >= 6:
		return false
	progress["points"] -= 1
	progress["stats"][stat] = int(progress["stats"].get(stat, 0)) + 1
	hero_progress[hero_id] = progress
	save_progression()
	return true

static func award_victory_xp() -> Dictionary:
	var rewards: Dictionary = {}
	if not run_active or floors.is_empty():
		return rewards
	var room: Dictionary = floors[floor_index][room_position]
	if room.get("xp_awarded", false) or room.get("cleared", false) or room.get("kind", "") not in ["battle", "boss"]:
		return rewards
	room["xp_awarded"] = true
	var amount: int = (35 if room["kind"] == "boss" else 12) + floor_index * 4
	if room.get("corridor_surprise", false):
		amount = 6 + floor_index * 2
	for hero_id in party:
		var state: Dictionary = run_heroes.get(hero_id, {})
		if state.is_empty() or state.get("dead", false) or int(state.get("hp", 0)) <= 0:
			continue
		var gained: int = gain_hero_xp(str(hero_id), amount)
		rewards[hero_id] = {"xp": amount, "levels": gained}
		var earned: Dictionary = journey.get("xp", {})
		earned[hero_id] = int(earned.get(hero_id, 0)) + amount
		journey["xp"] = earned
	return rewards

static func equipment_bonus(hero_id: String, stat: String) -> int:
	var total: int = 0
	for item_id in equipment.get(hero_id, {}).values():
		total += int(Items.item(str(item_id)).get(stat, 0))
		if modifications.get(item_id, "") == "keen" and stat == "damage":
			total += 1
		if modifications.get(item_id, "") == "fortified" and stat == "block":
			total += 2
	return total

static func hero_accuracy(hero_id: String, state: Dictionary = {}) -> float:
	var penalty: int = 10 if state.get("statuses", {}).has("chill") else 0
	if state.get("resolve_type", "") == "affliction":
		penalty += 10
	return clampf(100.0 - penalty + equipment_bonus(hero_id, "accuracy") + buff_bonus(state, "focus"), 0.0, 100.0)

static func try_hero_status(hero_id: String, statuses: Dictionary, status: String, potency: float = 1.0, roll: float = -1.0, extra_resistance: int = 0) -> bool:
	# Poison resistance already reduces poison tick damage; generic resistance
	# prevents application of any debuff. Bleed resistance prevents Bleed.
	var resistance: int = hero_bonus(hero_id, "debuff_resist") + extra_resistance
	if status == "bleed":
		resistance += equipment_bonus(hero_id, "bleed_resist")
	if (randf() * 100.0 if roll < 0.0 else roll) < clampi(resistance, 0, 100):
		return false
	Events.Rules.apply_status(statuses, status, potency)
	if statuses.has(status) and status in ["burn", "bleed", "poison"]:
		statuses[status]["damage"] += equipment_bonus(hero_id, "curse_dot")
	return Events.Rules.STATUS.has(status)

static func rank_of(hero_id: String) -> String:
	if hero_positions.has(hero_id): return "front" if int(hero_positions[hero_id]) == 1 else "rear"
	return str(formation.get(hero_id, Mechanics.default_rank(hero_id)))

static func service_unlocked(service: String) -> bool:
	return Mechanics.SERVICES.has(service) and completed_expeditions.has(Mechanics.SERVICES[service]["quest"])

static func modify_equipment(item_id: String, mode: String) -> bool:
	if not service_unlocked("workshop") or mode not in ["keen", "fortified"] or not Items.EQUIPMENT.has(item_id) or modifications.has(item_id) or gold < 12:
		return false
	var owned: bool = int(inventory.get(item_id, 0)) > 0
	for loadout in equipment.values():
		owned = owned or loadout.values().has(item_id)
	if not owned:
		return false
	gold -= 12
	modifications[item_id] = mode
	save_progression()
	return true

static func scout_area() -> bool:
	if not run_active or scout_uses <= 0 or not floors[floor_index][room_position]["cleared"]:
		return false
	scout_uses -= 1
	for location in floors[floor_index]:
		if abs(location.x - room_position.x) + abs(location.y - room_position.y) <= (3 if service_unlocked("watchtower") else 2):
			floors[floor_index][location]["seen"] = true
			floors[floor_index][location]["scouted"] = true
	return true

static func scouting_description(room: Dictionary) -> String:
	if not room.get("scouted", false):
		return ""
	var text: String = "Scouted: "
	if room["kind"] in ["battle", "boss"]:
		for id in room.get("enemies", [room.get("creature", "hollow_villager")]):
			text += str(creature(str(id)).get("name", id)) + " · "
	elif room["kind"] == "event":
		text += str(Events.definition(str(room.get("event_id", ""))).get("risk", "Unknown object"))
	else:
		text += str(room["kind"]).capitalize()
	return text

static func hero_max_hp(hero_id: String) -> int:
	return int(floor((int(hero(hero_id).get("max_hp", 40)) + hero_bonus(hero_id, "max_hp")) * (1.0 + equipment_bonus(hero_id, "max_hp_percent") / 100.0)))

static func sync_equipped_health(hero_id: String) -> void:
	if run_heroes.has(hero_id):
		run_heroes[hero_id]["max_hp"] = hero_max_hp(hero_id)
		run_heroes[hero_id]["hp"] = mini(int(run_heroes[hero_id]["hp"]), hero_max_hp(hero_id))

static func equip_item(hero_id: String, item_id: String) -> bool:
	var entry: Dictionary = Items.EQUIPMENT.get(item_id, {})
	if entry.is_empty() or not entry.has("slot") or (entry.has("hero") and entry["hero"] != hero_id) or not party.has(hero_id) or int(inventory.get(item_id, 0)) <= 0:
		return false
	if not equipment.has(hero_id):
		equipment[hero_id] = {}
	var slot: String = str(entry["slot"])
	var previous: String = str(equipment[hero_id].get(slot, ""))
	inventory[item_id] = int(inventory[item_id]) - 1
	if inventory[item_id] <= 0:
		inventory.erase(item_id)
	if previous != "":
		add_item(previous)
	equipment[hero_id][slot] = item_id
	sync_equipped_health(hero_id)
	return true

static func unequip_item(hero_id: String, slot: String) -> void:
	if equipment.get(hero_id, {}).has(slot):
		add_item(str(equipment[hero_id][slot]))
		equipment[hero_id].erase(slot)
		sync_equipped_health(hero_id)

static func claim_room_loot() -> Array[String]:
	var result: Array[String] = []
	if not run_active:
		return result
	var room: Dictionary = floors[floor_index][room_position]
	if room.get("loot_claimed", false):
		return result
	var kind: String = current_room_kind()
	if kind not in ["battle", "boss", "treasure"]:
		return result
	room["loot_claimed"] = true
	if kind in ["boss", "treasure"] or loot_rng.randf() < Items.GEAR_CHANCE:
		var item_id: String = Items.roll_equipment(loot_rng, party, kind == "boss")
		if item_id != "":
			add_item(item_id)
			result.append(item_id)
	# Scrolls are an independent 15% bonus roll, including on bosses.
	if loot_rng.randf() < Items.SCROLL_CHANCE:
		var item_id: String = Items.roll_scroll(loot_rng)
		add_item(item_id)
		result.append(item_id)
	if loot_rng.randf() < 0.20:
		var potion_ids: Array = Items.POTIONS.keys()
		var potion_id: String = str(potion_ids[loot_rng.randi_range(0, potion_ids.size() - 1)])
		add_item(potion_id)
		result.append(potion_id)
	return result


static func ensure_run_heroes() -> void:
	for hero_id in party:
		if not run_heroes.has(hero_id):
			run_heroes[hero_id] = {
				"hp": hero_max_hp(hero_id), "max_hp": hero_max_hp(hero_id),
				"stress": 0, "dead": false, "deaths_door": false,
				"statuses": {}, "damage_mod": 0, "stress_per_turn": 0,
				"resolved": false, "resolve_tag": "", "resolve_type": ""
			}

static func rest_at_camp() -> bool:
	if not run_active or current_room_kind() != "camp":
		return false
	var room: Dictionary = floors[floor_index][room_position]
	if room.get("camp_used", false):
		return false
	ensure_run_heroes()
	for hero_id in party:
		var state: Dictionary = run_heroes[hero_id]
		if state.get("dead", false):
			continue
		state["max_hp"] = hero_max_hp(hero_id)
		state["hp"] = state["max_hp"]
		# Leave at most 10% of current stress, rounding to a whole point.
		state["stress"] = int(floor(int(state.get("stress", 0)) * 0.1))
		state["statuses"] = {}
		state["deaths_door"] = false
		state["damage_mod"] = maxi(0, int(state.get("damage_mod", 0)))
		state["stress_per_turn"] = 0
		if state.get("resolve_type", "") == "affliction":
			state["resolved"] = false
			state["resolve_tag"] = ""
			state["resolve_type"] = ""
	room["camp_used"] = true
	room["cleared"] = true
	return true

static func merchant_orb_available() -> bool:
	if not run_active:
		return false
	var room: Dictionary = floors[floor_index][room_position]
	return bool(room.get("merchant_orb", false)) and bool(room["cleared"])

static func item_price(item_id: String) -> int:
	var entry: Dictionary = Items.item(item_id)
	if entry.is_empty():
		return 0
	return int(entry.get("price", {"common": 8, "rare": 18, "epic": 30, "unique": 38, "legendary": 40}.get(entry.get("rarity", "common"), 8)))

static func purchase_item(item_id: String) -> bool:
	var entry: Dictionary = Items.item(item_id)
	if entry.get("apothecary", false) and not apothecary_unlocked():
		return false
	if entry.is_empty() or entry.get("rarity", "") == "legendary" or (entry.has("hero") and not party.has(entry["hero"])):
		return false
	var price: int = item_price(item_id)
	if gold < price:
		return false
	gold -= price
	add_item(item_id)
	return true

static func apply_potion(hero_id: String, item_id: String, heroes: Dictionary) -> bool:
	if not is_restorative(item_id) or not heroes.has(hero_id) or heroes[hero_id].get("dead", false):
		return false
	if not consume_item(item_id):
		return false
	var hero: Dictionary = heroes[hero_id]
	var potion: Dictionary = Items.item(item_id)
	match str(potion["effect"]):
		"heal":
			hero["hp"] = mini(hero_max_hp(hero_id), int(hero["hp"]) + int(potion["amount"]))
			hero["deaths_door"] = false
		"cleanse":
			hero["statuses"] = {}
		"cleanse_one":
			hero["statuses"].erase(potion["status"])
		"solace":
			hero["stress"] = maxi(0, int(hero["stress"]) - int(potion["amount"]))
		"buff":
			if not hero.has("buffs"):
				hero["buffs"] = {}
			# Refresh rather than stack duplicate tonics; expires after two party turns.
			hero["buffs"][potion["buff"]] = {"turns": 2, "amount": int(potion["amount"])}
	return true

static func is_restorative(item_id: String) -> bool:
	return Items.POTIONS.has(item_id) or Items.item(item_id).get("effect", "") == "heal"

static func apothecary_unlocked() -> bool:
	return completed_expeditions.has("infested_apothecary")

static func buff_bonus(hero: Dictionary, buff: String) -> int:
	return int(hero.get("buffs", {}).get(buff, {}).get("amount", 0))

static func tick_buffs(hero: Dictionary) -> void:
	var buffs: Dictionary = hero.get("buffs", {})
	for buff in buffs.keys():
		buffs[buff]["turns"] -= 1
		if buffs[buff]["turns"] <= 0:
			buffs.erase(buff)

static func buff_text(hero: Dictionary) -> String:
	var parts: PackedStringArray = []
	for buff in hero.get("buffs", {}):
		parts.append("%s +%d%s · %dt" % [str(buff).capitalize(), buff_bonus(hero, buff), "%" if buff != "ward" else " Block", int(hero["buffs"][buff]["turns"])])
	return " · ".join(parts)

static func floor_enemy_pool(depth: int) -> Array:
	var pools: Array = selected_expedition.get("floor_enemy_pools", [])
	if depth < pools.size():
		return pools[depth]
	return ["ash_raider", "gallows_scout"] if selected_expedition.get("faction", "") == "human" else [str(selected_expedition.get("creature", "hollow_villager"))]

static func floor_background(scene_kind: String) -> String:
	var backgrounds: Array = selected_expedition.get("floor_" + scene_kind + "_backgrounds", [])
	if floor_index < backgrounds.size():
		return str(backgrounds[floor_index])
	return str(selected_expedition.get(scene_kind + "_background", "res://assets/generated/camp_ruins.png" if scene_kind == "camp" else "res://assets/generated/bandit_combat.png"))

static func next_floor_entrance() -> Dictionary:
	if floor_index >= floor_count - 1:
		return {}
	var next_depth: int = floor_index + 1
	var names: Array = selected_expedition.get("floor_names", [])
	var next_name: String = str(names[next_depth]) if next_depth < names.size() else "Floor %d" % (next_depth + 1)
	var result: Dictionary = {"name": "The Descent", "description": "A passage opens beneath the defeated guardian. The party may press on, or explore this floor before leaving.", "floor": next_name, "art": floor_background("combat")}
	var backgrounds: Array = selected_expedition.get("floor_combat_backgrounds", [])
	if next_depth < backgrounds.size():
		result["art"] = str(backgrounds[next_depth])
	match str(selected_expedition.get("id", "")):
		"old_road":
			result["name"] = "The Broken Portcullis" if next_depth == 1 else "The Lord's Stair"
			result["description"] = "Beyond the outlaws' road, a broken gate reveals cold stone halls beneath the wolf banners." if next_depth == 1 else "The Last Honorable Son's vigil is broken. Bloodied steps lead down to the Undying Lord's ancestral court."
		"path_beast":
			result["name"] = "The Sutured Gate" if next_depth == 1 else "The Throat of the Sanctuary"
			result["description"] = "The giant falls silent. A gate bound in sacred stitches parts before the Choir of Remaking." if next_depth == 1 else "The Coterie's final form lies still. Beneath its altar, a breathing passage opens toward the Howling Head."
	return result

static func customize_hero(id: String, chosen_name: String, color: String) -> bool:
	if not service_unlocked("workshop") or not HEROES.has(id) or color not in ["original", "red", "green", "blue", "gold"]:
		return false
	var clean: String = chosen_name.strip_edges().replace("\n", " ").replace("\r", " ").left(20)
	if clean.is_empty(): hero_names.erase(id)
	else: hero_names[id] = clean
	hero_colors[id] = color
	if run_heroes.has(id): run_heroes[id]["name"] = hero(id)["name"]
	save_progression()
	return true

static func add_deed(id: String, kind: String, amount: int = 1) -> void:
	if not run_deeds.has(id): run_deeds[id] = {"battles": 0, "damage": 0, "healing": 0}
	run_deeds[id][kind] = int(run_deeds[id].get(kind, 0)) + maxi(0, amount)

static func record_death(id: String, cause: String) -> void:
	var memorial_id: String = run_id + ":" + id
	for grave in graves:
		if grave.get("id", "") == memorial_id: return
	graves.append({"id": memorial_id, "hero": id, "name": hero(id)["name"], "class": HEROES[id]["name"], "dungeon": selected_expedition.get("name", "The wilderness"), "floor": floor_index + 1, "cause": cause, "date": Time.get_date_string_from_system(), "deeds": run_deeds.get(id, {"battles": 0, "damage": 0, "healing": 0}).duplicate(true)})
	save_progression()
