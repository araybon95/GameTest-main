extends RefCounted
const Items = preload("res://scripts/item_data.gd")
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
		"camp_art": "res://assets/generated/hero_warden_camp.png",
		"abilities": ["wd_slash", "wd_guard", "wd_bash", "wd_rally", "wd_heavy"],
	},
	"ranger": {
		"name": "Ranger", "max_hp": 38, "art": "res://assets/generated/hero_ranger.png",
		"camp_art": "res://assets/generated/hero_ranger_camp.png",
		"abilities": ["rg_quick", "rg_dodge", "rg_mark", "rg_pierce", "rg_volley"],
	},
	"occultist": {
		"name": "Occultist", "max_hp": 34, "art": "res://assets/generated/hero_occultist.png",
		"camp_art": "res://assets/generated/hero_occultist_camp.png",
		"abilities": ["oc_hex", "oc_veil", "oc_weak", "oc_drain", "oc_blast"],
	},
	"healer": {
		"name": "Healer", "max_hp": 42, "art": "res://assets/generated/hero_healer.png",
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
		"hp": 46, "attack": 10, "art": "res://assets/generated/enemy_gallows_scout.png",
		"lore": "The gang's watchful hunter waits beneath the gallows, marking travelers for the cleaver.",
	},
	"ash_chieftain": {
		"name": "Gallows Chieftain", "tags": ["Human", "Bandit", "Boss"], "undead": false,
		"hp": 82, "attack": 10, "art": "res://assets/generated/enemy_ash_bandit_captain.png",
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
		"blurb": "Human outlaws haunt the ruined road. Hunt their chieftain beneath the black gallows.",
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
		for id in config.get_value("progress", "completed", []):
			if not expedition_by_id(str(id)).is_empty() and not completed_expeditions.has(str(id)):
				completed_expeditions.append(str(id))

static func save_progression() -> void:
	if not progress_loaded:
		return
	var config := ConfigFile.new()
	config.set_value("progress", "completed", completed_expeditions)
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
	if str(ability.get("effect", "")) in ["heal", "team_heal", "stress_heal", "team_block", "weaken", "drain"]:
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
		if selected_expedition.get("faction", "") == "human":
			for location in rooms:
				rooms[location]["creature"] = "ash_chieftain" if rooms[location]["kind"] == "boss" else (["ash_raider", "gallows_scout"][rng.randi_range(0, 1)])
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
				room["support_creature"] = "gallows_scout" if selected_expedition.get("faction", "") == "human" else str(selected_expedition.get("creature", "hollow_villager"))
				if selected_expedition.get("faction", "") == "remade":
					room["support_creature"] = "anguish_penitent"
					if room.has("boss_phases"):
						room.erase("support_creature")
			elif room["kind"] == "battle":
				room["enemies"] = [primary]
				for extra in range(rng.randi_range(0, 2)):
					room["enemies"].append(["ash_raider", "gallows_scout"][rng.randi_range(0, 1)] if selected_expedition.get("faction", "") == "human" else primary)
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
		floors.append(rooms)
	ensure_run_heroes()
	reveal_neighbors()

static func current_room_kind() -> String:
	return str(floors[floor_index][room_position]["kind"]) if run_active else ""

static func reveal_neighbors() -> void:
	var rooms: Dictionary = floors[floor_index]
	rooms[room_position]["seen"] = true
	for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		if rooms.has(room_position + direction):
			rooms[room_position + direction]["seen"] = true

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
	return true

static func finish_encounter() -> void:
	floors[floor_index][room_position]["cleared"] = true
	if current_room_kind() == "boss" and floors[floor_index][room_position].get("final_boss", true):
		run_complete = true
		var id: String = str(selected_expedition.get("id", ""))
		if id != "" and not completed_expeditions.has(id):
			completed_expeditions.append(id)
			save_progression()

static func descend() -> bool:
	if not can_descend():
		return false
	floor_index += 1
	room_position = Vector2i.ZERO
	navigation_votes.clear()
	reveal_neighbors()
	return true

static func end_run() -> void:
	run_active = false
	run_heroes.clear()
	navigation_votes.clear()


# Party inventory/equipment persist across expeditions during this game session.
static var inventory: Dictionary = {}
static var equipment: Dictionary = {}
static var loot_rng: RandomNumberGenerator = RandomNumberGenerator.new()
static var shop_return_scene: String = "res://scenes/hub/settlement.tscn"

static func add_item(item_id: String, amount: int = 1) -> void:
	if not Items.item(item_id).is_empty() and amount > 0:
		inventory[item_id] = int(inventory.get(item_id, 0)) + amount

static func consume_scroll(item_id: String) -> bool:
	if not Items.SCROLLS.has(item_id) or int(inventory.get(item_id, 0)) <= 0:
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

static func equipment_bonus(hero_id: String, stat: String) -> int:
	var total: int = 0
	for item_id in equipment.get(hero_id, {}).values():
		total += int(Items.item(str(item_id)).get(stat, 0))
	return total

static func hero_max_hp(hero_id: String) -> int:
	return int(hero(hero_id).get("max_hp", 40)) + equipment_bonus(hero_id, "max_hp")

static func sync_equipped_health(hero_id: String) -> void:
	if run_heroes.has(hero_id):
		run_heroes[hero_id]["max_hp"] = hero_max_hp(hero_id)
		run_heroes[hero_id]["hp"] = mini(int(run_heroes[hero_id]["hp"]), hero_max_hp(hero_id))

static func equip_item(hero_id: String, item_id: String) -> bool:
	var entry: Dictionary = Items.EQUIPMENT.get(item_id, {})
	if entry.is_empty() or entry["hero"] != hero_id or not party.has(hero_id) or int(inventory.get(item_id, 0)) <= 0:
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
	return int(entry.get("price", {"common": 8, "rare": 18, "epic": 30, "legendary": 40}.get(entry.get("rarity", "common"), 8)))

static func purchase_item(item_id: String) -> bool:
	var entry: Dictionary = Items.item(item_id)
	if entry.is_empty() or entry.get("rarity", "") == "legendary" or (entry.has("hero") and not party.has(entry["hero"])):
		return false
	var price: int = item_price(item_id)
	if gold < price:
		return false
	gold -= price
	add_item(item_id)
	return true
