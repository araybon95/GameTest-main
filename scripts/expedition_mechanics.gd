extends RefCounted

const SERVICES = {
	"watchtower": {"name": "The Watchtower", "quest": "restore_watchtower", "description": "Reclaim the occupied watchtower. Restored scouts reveal two rooms ahead and grant one extra scouting use per floor.", "enemy": "gallows_scout", "boss": "ash_chieftain"},
	"infirmary": {"name": "The Infirmary", "quest": "restore_infirmary", "description": "Clear the abandoned sickhouse. Restored physicians offer discounted healing and cleansing supplies.", "enemy": "moth_metamorph", "boss": "moth_oleander"},
	"workshop": {"name": "The Workshop", "quest": "restore_workshop", "description": "Drive raiders from the craftsmen's quarter. Restored artisans add one permanent modification to each equipment design.", "enemy": "ash_raider", "boss": "ash_chieftain"}
}

static func default_rank(hero_id: String) -> String:
	return "front" if hero_id in ["warden", "crusader"] else "rear"

static func event_option(id: String, hero: String) -> Dictionary:
	if id == "bandit_strongbox" and hero == "warden":
		return {"name": "Force the lock", "cost": 2, "risk": "Pay 2 HP. Guaranteed reward; 10% Bleed risk.", "curse_chance": 0.10}
	if id == "bandit_strongbox" and hero == "ranger":
		return {"name": "Disarm the trap", "cost": 0, "risk": "Guaranteed reward; 10% Bleed risk.", "curse_chance": 0.10}
	if id in ["bandit_supplies", "beast_reliquary"] and hero == "healer":
		return {"name": "Purify the supplies", "cost": 0, "risk": "Guaranteed reward; 10% debuff risk.", "curse_chance": 0.10}
	if id in ["beast_reliquary", "beast_offering"] and hero == "occultist":
		return {"name": "Interpret the rite", "cost": 0, "risk": "Guaranteed reward; 15% debuff risk.", "curse_chance": 0.15}
	if id == "beast_offering" and hero == "crusader":
		return {"name": "Offer a blood tithe", "cost": 2, "risk": "Pay 2 HP. Guaranteed reward; 10% Chill risk.", "curse_chance": 0.10}
	return {}

static func boss_hint(creature: String, round_number: int) -> String:
	if creature == "moth_oleander":
		return "Guarding: 50% damage reduction" if round_number % 3 == 1 else ("Heavy strike → exposed next round" if round_number % 3 == 2 else "Exposed: +50% incoming damage")
	if creature == "moth_exuvia":
		return "Weaves a cocoon · destroy it before its second enemy turn"
	if creature == "keep_son":
		return "Oathguard: 50% damage reduction" if round_number % 3 == 1 else ("Greatsword → exposed next round" if round_number % 3 == 2 else "Exposed: +50% incoming damage")
	if creature == "undying_lord":
		return "Living support heals lord 8 HP/turn"
	return ""
