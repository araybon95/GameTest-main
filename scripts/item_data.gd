extends RefCounted
## Original Ashen equipment and consumables; licensed icons credited in assets/items/CREDITS.md.
const Matchups = preload("res://scripts/creature_matchups.gd")

const SCROLL_CHANCE: float = 0.15
const GEAR_CHANCE: float = 0.40
const RARITY_WEIGHTS: Dictionary = {"common": 57, "rare": 25, "epic": 10, "unique": 3, "legendary": 5}
const RARITY_COLORS: Dictionary = {"common": "#B4EF78", "rare": "#47CAFF", "epic": "#C475FF", "unique": "#FF779C", "legendary": "#FFD34D"}
const SCROLLS: Dictionary = {
	"healing_scroll": {"name": "Healing Scroll", "rarity": "rare", "kind": "scroll", "effect": "heal", "amount": 30, "price": 14, "apothecary": true, "description": "Restore 30 HP to the selected living hero. Universal, single use; 1 AP in combat."},
	"storm_lance_scroll": {"name": "Storm Lance Scroll", "rarity": "epic", "kind": "scroll", "effect": "pierce", "damage": 22, "cost": 1, "price": 20, "description": "Deal 22 damage, ignoring Block. Single use; any hero. Costs 1 AP."},
	"fire_bolt_scroll": {"name": "Fire Bolt Scroll", "rarity": "common", "kind": "scroll", "effect": "attack", "damage": 12, "cost": 1, "price": 6, "description": "Deal 12 damage. Burn: 3 damage for 2 turns. Single use; any hero. Costs 1 AP."},
	"lightning_bolt_scroll": {"name": "Lightning Bolt Scroll", "rarity": "rare", "kind": "scroll", "effect": "pierce", "damage": 18, "cost": 1, "price": 12, "description": "Deal 18 damage, ignoring Block. Single use; any hero. Costs 1 AP."},
	"sunfire_scroll": {"name": "Sunfire Scroll", "rarity": "legendary", "kind": "scroll", "effect": "pierce", "damage": 28, "cost": 1, "price": 24, "description": "Deal 28 damage, ignoring Block. Burn: 3 damage for 2 turns. Single use; any hero. Costs 1 AP."},
}
const POTIONS: Dictionary = {
	"bandage": {"name": "Field Bandage", "rarity": "common", "kind": "potion", "effect": "cleanse_one", "status": "bleed", "price": 4, "description": "Remove Bleed from the selected living hero. Single use; 1 AP in combat."},
	"antidote": {"name": "Field Antidote", "rarity": "common", "kind": "potion", "effect": "cleanse_one", "status": "poison", "price": 4, "description": "Remove Poison from the selected living hero. Single use; 1 AP in combat."},
	"calming_incense": {"name": "Calming Incense", "rarity": "common", "kind": "potion", "effect": "solace", "amount": 8, "price": 4, "description": "Reduce the selected living hero's Stress by 8. Single use; 1 AP in combat."},
	"might_tonic": {"name": "Tonic of Might", "rarity": "rare", "kind": "potion", "effect": "buff", "buff": "might", "amount": 20, "price": 14, "apothecary": true, "description": "+20% skill damage for 2 party turns. Refreshes; does not stack. Selected living hero; single use, 1 AP in combat."},
	"focus_tonic": {"name": "Tonic of Focus", "rarity": "rare", "kind": "potion", "effect": "buff", "buff": "focus", "amount": 15, "price": 12, "apothecary": true, "description": "+15% accuracy for 2 party turns, capped at 100%. Refreshes; does not stack. Selected living hero; single use, 1 AP in combat."},
	"ward_tonic": {"name": "Tonic of Warding", "rarity": "rare", "kind": "potion", "effect": "buff", "buff": "ward", "amount": 4, "price": 12, "apothecary": true, "description": "Gain 4 Block now and at the next party turn. Lasts 2 party turns. Refreshes; does not stack. Single use, 1 AP in combat."},
 "healing_potion": {"name": "Healing Potion", "rarity": "common", "kind": "potion", "effect": "heal", "amount": 20, "price": 8, "description": "Restore 20 HP to the selected living hero. Single use; 1 AP in combat."},
 "cleansing_potion": {"name": "Cleansing Potion", "rarity": "rare", "kind": "potion", "effect": "cleanse", "price": 12, "description": "Remove Burn, Bleed, Poison and Chill from the selected living hero. Single use; 1 AP in combat."},
 "solace_potion": {"name": "Solace Potion", "rarity": "common", "kind": "potion", "effect": "solace", "amount": 15, "price": 8, "description": "Reduce the selected living hero's Stress by 15. Single use; 1 AP in combat."},
}
const EQUIPMENT: Dictionary = {
	"warden_armor":{"name":"Roadwatch Cuirass","rarity":"common","hero":"warden","slot":"armor","max_hp":4,"block":1,"equipment_look":"original","lore":"Iron patched by three generations of roadwardens. Its dents are older than the current watch."},
	"warden_faction_armor":{"move_cost":2,"name":"Calden Sentinel Plate","rarity":"epic","hero":"warden","slot":"armor","max_hp":6,"debuff_resist":10,"equipment_look":"alternate","lore":"A dead keep's plate, reforged for a living oath."},
	"warden_relic_armor":{"move_cost":2,"name":"Oathkeeper's Last Watch","rarity":"legendary","hero":"warden","slot":"armor","max_hp":8,"block":2,"bleed_resist":15,"equipment_look":"relic","lore":"A pale oath burns beneath the breastplate. Its bearer stands where the watch ended."},
	"ranger_common_armor":{"free_move":1,"block":-1,"name":"Trailwarden Jack","rarity":"common","hero":"ranger","slot":"armor","accuracy":5,"bleed_resist":10,"equipment_look":"original","lore":"Waxed leather and careful stitching. It was made for returning home."},
	"ranger_relic_armor":{"free_move":1,"block":-1,"name":"Thornsong Mantle","rarity":"legendary","hero":"ranger","slot":"armor","max_hp":5,"accuracy":8,"debuff_resist":15,"equipment_look":"relic","lore":"Thorns guard the seams; a green clasp holds the woodland's last vow."},
	"occultist_armor":{"name":"Gravecloth Wraps","rarity":"common","hero":"occultist","slot":"armor","max_hp":2,"poison_resist":20,"equipment_look":"original","lore":"Burial cloth washed clean of names, but not of whispers."},
	"occultist_faction_armor":{"block":-1,"name":"Seamkeeper's Vestments","rarity":"epic","hero":"occultist","slot":"armor","max_hp":6,"damage_percent":6,"equipment_look":"alternate","lore":"Stolen from the choir, these bindings keep their wearer whole."},
	"occultist_relic_armor":{"block":-1,"name":"Gravetide Ribmantle","rarity":"legendary","hero":"occultist","slot":"armor","damage_percent":10,"debuff_resist":15,"equipment_look":"relic","lore":"An ivory cage worn outside the flesh. Each rib binds a promise that should have remained buried."},
	"healer_armor":{"name":"Pilgrim's Apron","rarity":"common","hero":"healer","slot":"armor","max_hp":4,"poison_resist":15,"equipment_look":"original","lore":"The stains survive every washing. Its pockets still hold clean thread."},
	"healer_faction_armor":{"damage_percent":-5,"name":"Sickhouse Half-Plate","rarity":"epic","hero":"healer","slot":"armor","heal":1,"block":1,"debuff_resist":10,"equipment_look":"alternate","lore":"A physician's apron reinforced for wards where mercy needs armour."},
	"healer_relic_armor":{"damage_percent":-5,"name":"Dawnmantle of Mercy","rarity":"legendary","hero":"healer","slot":"armor","heal":2,"max_hp":6,"debuff_resist":10,"equipment_look":"relic","lore":"Its candle clasp burns for patients whose names the ward has forgotten."},
	"crusader_common_armor":{"name":"Penitent's Iron Shirt","rarity":"common","hero":"crusader","slot":"armor","max_hp":4,"bleed_resist":15,"equipment_look":"original","lore":"A shirt of iron rings. Pain waits between every link."},
	"crusader_relic_armor":{"move_cost":2,"name":"Sacrament of Iron","rarity":"legendary","hero":"crusader","slot":"armor","max_hp":8,"damage_percent":8,"debuff_resist":10,"equipment_look":"relic","lore":"The barbs turn outward. For once, the curse has something else to wound."},
	"chieftain_trophy": {"name":"Gallows King's Signet","rarity":"legendary","kind":"trinket","slot":"charm","boss_only":true,"damage_vs_human":15,"accuracy":5,"lore":"A stolen crown hammered into a ring. Its notches count the travellers who never returned."},
	"son_trophy": {"name":"The Last Oath","rarity":"legendary","kind":"trinket","slot":"charm","boss_only":true,"block":2,"bleed_resist":20,"lore":"A broken sword bound with an oath-ribbon. Even death failed to loosen its owner's grip."},
	"lord_trophy": {"name":"Calden's Deathless Seal","rarity":"legendary","kind":"trinket","slot":"charm","boss_only":true,"max_hp_percent":12,"damage_vs_corrupted":15,"lore":"A blackened seal that outlived its kingdom. Beneath the wax, something still beats."},
	"giant_trophy": {"name":"The Harrowed Shackle","rarity":"legendary","kind":"trinket","slot":"charm","boss_only":true,"max_hp":6,"bleed_resist":25,"lore":"An iron restraint cut from the giant's wrist. Its inner barbs bear a lifetime of prayers."},
	"coterie_trophy": {"name":"Threefold Suture","rarity":"legendary","kind":"trinket","slot":"charm","boss_only":true,"debuff_resist":20,"damage_vs_remade":15,"lore":"Three needles, one endless thread. The hymn ended; the stitches remember its rhythm."},
	"head_trophy": {"name":"The Silenced Litany","rarity":"legendary","kind":"trinket","slot":"charm","boss_only":true,"damage_percent":12,"debuff_resist":15,"lore":"A reliquary clasped around a voiceless tongue. Silence is the only mercy its altar ever offered."},
	"oleander_trophy": {"name":"Oleander's Vigil","rarity":"legendary","kind":"trinket","slot":"charm","boss_only":true,"block":2,"poison_resist":30,"lore":"A wing-shaped shield fragment. The knight kept his watch long after he forgot whom he guarded."},
	"exuvia_trophy": {"name":"The Queen's Empty Crown","rarity":"legendary","kind":"trinket","slot":"charm","boss_only":true,"heal":2,"debuff_resist":20,"lore":"A crown woven from discarded chitin. Its soft glow remembers every body sacrificed to the queen."},
	"outlaw_tally": {"name":"Outlaw's Tally", "rarity":"rare", "kind":"trinket", "slot":"trinket", "damage_vs_human":10},
	"warden_gravewatch": {"name":"Gravewatch Medal", "rarity":"epic", "kind":"trinket", "slot":"trinket", "hero":"warden", "damage_vs_corrupted":15},
	"occultist_severed_litany": {"name":"Severed Litany", "rarity":"epic", "kind":"trinket", "slot":"trinket", "hero":"occultist", "damage_vs_remade":15},
	"ranger_chitin_lens": {"name":"Chitin Hunter's Lens", "rarity":"epic", "kind":"trinket", "slot":"trinket", "hero":"ranger", "damage_vs_insect":15},
	"roadward_seal": {"name":"Roadward Seal", "rarity":"rare", "kind":"trinket", "slot":"charm", "ward_vs_human":10},
	"graveward_locket": {"name":"Graveward Locket", "rarity":"rare", "kind":"trinket", "slot":"charm", "ward_vs_corrupted":10},
	"crusader_penitent_stitch": {"name":"Penitent's Stitch", "rarity":"epic", "kind":"trinket", "slot":"charm", "hero":"crusader", "ward_vs_remade":15},
	"healer_chrysalis_rosary": {"name":"Chrysalis Rosary", "rarity":"epic", "kind":"trinket", "slot":"charm", "hero":"healer", "ward_vs_insect":15},
	"cursed_thorn_relic": {"name": "Thornbound Reliquary", "rarity": "unique", "kind": "trinket", "slot": "charm", "damage_percent": 25, "curse_stress": 2},
	"cursed_physician_seal": {"name": "Septic Physician's Seal", "rarity": "unique", "kind": "trinket", "slot": "charm", "heal": 4, "curse_dot": 1},
 "crusader_axe": {"name": "Penitent's Axe", "rarity": "common", "hero": "crusader", "slot": "weapon", "damage": 1},
 "crusader_armor": {"move_cost":2,"name": "Barbed Cuirass", "rarity": "rare", "hero": "crusader", "slot": "armor", "block": 2, "max_hp": 4,"equipment_look":"alternate"},
 "crusader_epic": {"name": "Agony's Edge", "rarity": "epic", "hero": "crusader", "slot": "weapon", "damage": 3, "bleed_resist": 20},
 "crusader_unique": {"name": "Winter Penance", "rarity": "unique", "hero": "crusader", "slot": "weapon", "damage": 2, "unique_chill": 30},
 "crusader_legend": {"name": "Unending Sacrament", "rarity": "legendary", "hero": "crusader", "slot": "weapon", "damage": 4, "max_hp": 6, "life_drain": 15},
 "venom_heart": {"name": "Venom Heart", "rarity": "unique", "kind": "trinket", "slot": "trinket", "unique_poison": 30},
 "winter_shard": {"name": "Winter Shard", "rarity": "unique", "kind": "trinket", "slot": "charm", "unique_chill": 30},
 "warden_frostblade": {"name": "Vigil of Winter", "rarity": "unique", "hero": "warden", "slot": "weapon", "damage": 2, "unique_chill": 30},
 "ranger_venombow": {"name": "Adder's Requiem", "rarity": "unique", "hero": "ranger", "slot": "weapon", "damage": 2, "unique_poison": 30},
 "occultist_plaguestaff": {"name": "Septic Covenant", "rarity": "unique", "hero": "occultist", "slot": "weapon", "damage": 2, "unique_poison": 30},
 "healer_frostmace": {"name": "Cold Benediction", "rarity": "unique", "hero": "healer", "slot": "weapon", "heal": 2, "unique_chill": 30},
	"clotting_seal": {"name": "Clotting Seal", "rarity": "common", "kind": "trinket", "slot": "trinket", "bleed_resist": 30},
	"vitality_locket": {"name": "Vitality Locket", "rarity": "rare", "kind": "trinket", "slot": "trinket", "max_hp_percent": 10},
	"warding_eye": {"name": "Warding Eye", "rarity": "rare", "kind": "trinket", "slot": "trinket", "debuff_resist": 20},
	"hunters_compass": {"name": "Hunter's Compass", "rarity": "epic", "kind": "trinket", "slot": "trinket", "accuracy": 10, "damage_percent": 10},
	"warden_bastion": {"name": "Bastion Medal", "rarity": "epic", "kind": "trinket", "slot": "trinket", "hero": "warden", "max_hp_percent": 15, "bleed_resist": 25},
	"ranger_sight": {"name": "Falcon Sight", "rarity": "epic", "kind": "trinket", "slot": "trinket", "hero": "ranger", "accuracy": 15, "damage_percent": 15},
	"occultist_sigil": {"name": "Veiled Sigil", "rarity": "epic", "kind": "trinket", "slot": "trinket", "hero": "occultist", "damage_percent": 15, "debuff_resist": 20},
	"healer_beads": {"name": "Merciful Beads", "rarity": "epic", "kind": "trinket", "slot": "trinket", "hero": "healer", "heal": 2, "debuff_resist": 25},
	"warden_relic": {"name": "Last Watch Relic", "rarity": "legendary", "kind": "trinket", "slot": "charm", "hero": "warden", "max_hp_percent": 20, "debuff_resist": 25},
	"ranger_relic": {"name": "Unerring Talon", "rarity": "legendary", "kind": "trinket", "slot": "charm", "hero": "ranger", "accuracy": 20, "damage_percent": 20},
	"occultist_relic": {"name": "Black Covenant", "rarity": "legendary", "kind": "trinket", "slot": "charm", "hero": "occultist", "damage_percent": 25, "debuff_resist": 25},
	"healer_relic": {"name": "Dawn Reliquary", "rarity": "legendary", "kind": "trinket", "slot": "charm", "hero": "healer", "heal": 3, "max_hp_percent": 15, "debuff_resist": 25},

	"warden_epic": {"name": "Dreadsteel Longsword", "rarity": "epic", "hero": "warden", "slot": "weapon", "damage": 3, "max_hp": 4, "reflection": 10},
	"ranger_epic": {"name": "Nightthorn Bow", "rarity": "epic", "hero": "ranger", "slot": "weapon", "damage": 3, "poison_chance": 15},
	"occultist_epic": {"name": "Sanguine Bonewood", "rarity": "epic", "hero": "occultist", "slot": "weapon", "damage": 3, "life_drain": 15},
	"healer_epic": {"name": "Emberlight Mace", "rarity": "epic", "hero": "healer", "slot": "weapon", "damage": 1, "heal": 3, "regeneration": 1},
	"warden_sword": {"name": "Iron Longsword", "rarity": "common", "hero": "warden", "slot": "weapon", "damage": 1},
	"warden_shield": {"name": "Sentinel Shield", "rarity": "rare", "hero": "warden", "slot": "off_hand", "block": 3},
	"warden_legend": {"name": "Oathkeeper", "rarity": "legendary", "hero": "warden", "slot": "weapon", "damage": 4, "max_hp": 8, "reflection": 25},
	"ranger_bow": {"name": "Hunting Bow", "rarity": "common", "hero": "ranger", "slot": "weapon", "damage": 1},
	"ranger_armor": {"free_move":1,"block":-1,"name": "Soothing Stalker Leathers", "rarity": "rare", "hero": "ranger", "slot": "armor", "max_hp": 8, "regeneration": 1,"equipment_look":"alternate"},
	"ranger_legend": {"name": "Venomous Thornsong", "rarity": "legendary", "hero": "ranger", "slot": "weapon", "damage": 5, "poison_chance": 25},
	"occultist_staff": {"name": "Bonewood Staff", "rarity": "common", "hero": "occultist", "slot": "weapon", "damage": 1},
	"occultist_focus": {"name": "Purifying Gravebound Grimoire", "rarity": "rare", "hero": "occultist", "slot": "off_hand", "damage": 2, "heal": 2, "poison_resist": 50},
	"occultist_legend": {"name": "Vampiric Gravetide", "rarity": "legendary", "hero": "occultist", "slot": "weapon", "damage": 4, "heal": 3, "life_drain": 25},
	"healer_mace": {"name": "Pilgrim Mace", "rarity": "common", "hero": "healer", "slot": "weapon", "damage": 1},
	"healer_symbol": {"name": "Consecrated Symbol", "rarity": "rare", "hero": "healer", "slot": "off_hand", "heal": 3},
	"healer_legend": {"name": "Dawn's Mercy", "rarity": "legendary", "hero": "healer", "slot": "weapon", "damage": 2, "heal": 4, "regeneration": 2},
}
const PROVISIONS: Dictionary = {
 "trail_food": {"name": "Trail Rations", "kind": "provision", "rarity": "common", "price": 2, "description": "One party ration. Automatically used after six newly visited map spaces; restores 3 HP to survivors. Three basic rations accompany every departure."},
 "lock_tools": {"name": "Locksmith Tools", "kind": "provision", "rarity": "common", "price": 4, "description": "Use at a strongbox for a guaranteed reward without a trap. Consumed once."},
 "cleansing_herbs": {"name": "Cleansing Herbs", "kind": "provision", "rarity": "common", "price": 3, "description": "Purify tainted supplies or a votive reliquary for a safe guaranteed reward. Consumed once."}
}
const SLOTS: Array[String] = ["weapon", "off_hand", "head", "armor", "trinket", "charm"]
const LEGEND_LORE: Dictionary = {
	"warden_legend":"The watch ended without a bell. Its last keeper left this blade across the doorway, an oath that another might survive.",
	"ranger_legend":"The grove fell silent, but its thorns remembered every trespass. Draw the bow and the woodland answers in a bitter chorus.",
	"occultist_legend":"A grave need not keep everything it takes. This staff draws warmth from the condemned and lends it, briefly, to the living.",
	"healer_legend":"One candle remained in the plague ward. The hand that carried it is gone; the mercy it offered has not yet guttered out.",
	"crusader_legend":"The curse demands another wound. Its bearer turns the barbs outward, offering his own blood before taking the enemy's."
}

static var histories: Dictionary = {}
static var favourites: Dictionary = {}

static func base_id(item_id: String) -> String:
	return str(histories.get(item_id, {}).get("base", item_id))

static func item(item_id: String) -> Dictionary:
	var base: String = base_id(item_id)
	var entry: Dictionary = SCROLLS.get(base, POTIONS.get(base, PROVISIONS.get(base, EQUIPMENT.get(base, {}))))
	if LEGEND_LORE.has(base):
		entry = entry.duplicate(true)
		entry["lore"] = LEGEND_LORE[base]
	if histories.has(item_id):
		entry = entry.duplicate(true)
		if not str(histories[item_id].get("name", "")).is_empty(): entry["name"] = histories[item_id].name
		if histories[item_id].has("hero"): entry["hero"] = histories[item_id].hero
		var mode: String = str(histories[item_id].get("transformation",""))
		var bonuses: Dictionary = {"restored":{"max_hp":4},"consecrated":{"debuff_resist":10},"corrupted":{"damage_percent":8,"curse_stress":1}}.get(mode,{})
		for stat in bonuses: entry[stat] = int(entry.get(stat,0)) + int(bonuses[stat])
	return entry

static func description(item_id: String) -> String:
	var entry: Dictionary = item(item_id)
	if entry.is_empty():
		return ""
	if entry.has("description"):
		return str(entry["description"])
	var text: String = (str(entry["hero"]).capitalize() + " only" if entry.has("hero") else "Any hero") + " · " + str(entry["slot"]).replace("_", " ")
	if entry.has("equipment_look"): text += " · " + str({"original":"Practical costume","alternate":"Faction costume","relic":"Relic costume"}.get(entry.equipment_look,"Equipment costume"))
	for stat in ["damage", "block", "heal", "max_hp"]:
		if entry.has(stat):
			text += " · %+d %s" % [int(entry[stat]), stat.replace("_", " ")]
	for stat in ["reflection", "life_drain", "poison_chance", "poison_resist", "bleed_resist", "debuff_resist", "max_hp_percent", "damage_percent", "accuracy"]:
		if entry.has(stat):
			var names: Dictionary = {"max_hp_percent": "maximum health", "damage_percent": "skill damage", "accuracy": "accuracy bonus", "bleed_resist": "chance to resist Bleed", "debuff_resist": "chance to resist any debuff", "poison_resist": "poison damage reduction"}
			text += " · %+d%% %s" % [int(entry[stat]), names.get(stat, stat.replace("_", " "))]
	if entry.has("regeneration"):
		text += " · Restore %d HP each party turn" % int(entry["regeneration"])
	for category in Matchups.CLASS_KEYS:
		var key: String = str(Matchups.CLASS_KEYS[category])
		if entry.has("damage_vs_" + key):
			text += " · +%d%% direct damage against %s (combined hunt cap %d%%; excludes damage-over-time)" % [int(entry["damage_vs_" + key]),category,Matchups.OFFENSE_CAP]
		if entry.has("ward_vs_" + key):
			text += " · %d%% less direct damage from %s (combined ward cap %d%%; excludes damage-over-time)" % [int(entry["ward_vs_" + key]),category,Matchups.WARD_CAP]
	if entry.has("curse_stress"):
		text += " · CURSED: +%d Stress each party turn while equipped" % int(entry.curse_stress)
	if entry.has("curse_dot"):
		text += " · CURSED: harmful Burn/Bleed/Poison deal +1 damage per tick"
	for effect in ["poison", "chill"]:
		if entry.has("unique_" + effect):
			text += " · %d%% on damaging skill hit: stacking %s (max 3 stacks / 2 turns; combined chance capped at 50%%)" % [int(entry["unique_" + effect]), effect.capitalize()]
	if entry.has("unique_poison"):
		text += " · Poison: 2 damage per stack per turn (max 6)"
	if entry.has("unique_chill"):
		text += " · Chill: reduces damage by 25% / 35% / 45%"
	if entry.has("move_cost"): text += " · Formation moves cost %d AP" % int(entry.move_cost)
	if entry.has("free_move"): text += " · First formation move each party turn is free; later moves cost 1 AP"
	var signature: String = {"warden_legend":"The Last Oath", "ranger_legend":"Thornsong Volley", "occultist_legend":"Gravetide Offering", "healer_legend":"Dawn's Absolution", "crusader_legend":"Unending Charge"}.get(base_id(item_id),"")
	if not signature.is_empty(): text += " · Grants " + signature + " while equipped (3-turn cooldown)"
	return text

static func icon_path(item_id: String) -> String:
	# A per-item PNG override takes priority. SVGs remain editable source assets.
	var base: String = "res://assets/items/" + base_id(item_id)
	return base + ".png" if ResourceLoader.exists(base + ".png") else base + ".svg"

static func tooltip(item_id: String) -> String:
	var entry: Dictionary = item(item_id)
	if entry.is_empty():
		return "Empty slot"
	var text: String = "%s\n%s\n%s" % [entry["name"], str(entry["rarity"]).to_upper(), description(item_id).replace(" · ", "\n")]
	if entry.has("lore"): text += "\n\n" + str(entry.lore)
	if favourites.get(item_id,false): text += "\n★ Favourite · protected from sale"
	if histories.has(item_id):
		var record: Dictionary = histories[item_id]
		if record.has("transformation"): text += "\nWorkshop: " + str(record.transformation).capitalize()
		if record.has("milestone"): text += "\nCosmetic milestone: " + str(record.milestone)
		if record.has("origin"): text += "\nTaken from " + str(record.origin)
		text += "\n\n" + str(EQUIPMENT[base_id(item_id)]["name"])
		for owner in record.get("owners", []): text += "\nHeirloom of " + str(owner)
		for deed in record.get("deeds", []): text += "\n• " + str(deed)
	return text

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
	var pool: Array[String] = []
	for item_id in SCROLLS:
		if SCROLLS[item_id]["rarity"] == rarity:
			pool.append(str(item_id))
	return "fire_bolt_scroll" if pool.is_empty() else pool[rng.randi_range(0, pool.size() - 1)]

static func roll_equipment(rng: RandomNumberGenerator, active_party: Array, guaranteed_legendary: bool = false) -> String:
	var rarity: String = "legendary" if guaranteed_legendary else roll_rarity(rng)
	var pool: Array[String] = []
	for item_id in EQUIPMENT:
		var entry: Dictionary = EQUIPMENT[item_id]
		if entry.get("boss_only",false): continue
		if entry["rarity"] == rarity and (active_party.has(entry.get("hero", "")) or (not guaranteed_legendary and not entry.has("hero"))):
			pool.append(str(item_id))
	return "" if pool.is_empty() else pool[rng.randi_range(0, pool.size() - 1)]
