extends RefCounted
## Creature classes inform direct-hit equipment and small status application chances.
## Existing faction tags and undead traits remain separate and are never changed here.
const CLASS_KEYS: Dictionary = {"Human":"human", "Corrupted":"corrupted", "The Remade":"remade", "Insect":"insect"}
const OFFENSE_CAP: int = 25
const WARD_CAP: int = 20
const INNATE_RESISTANCES: Dictionary = {
	"Human": {},
	"Corrupted": {"bleed":20},
	"The Remade": {"chill":15},
	"Insect": {"poison":20}
}

static func class_of(creature: Dictionary) -> String:
	var declared: String = str(creature.get("creature_class",""))
	if CLASS_KEYS.has(declared): return declared
	# Older saves and test fixtures can still carry only the existing faction tags.
	var tags: Array = creature.get("tags",[])
	if tags.has("Human"): return "Human"
	if tags.has("Remade"): return "The Remade"
	if tags.has("Moth") or tags.has("Insect"): return "Insect"
	return "Corrupted"

static func offense_stat(creature: Dictionary) -> String:
	return "damage_vs_" + str(CLASS_KEYS[class_of(creature)])

static func ward_stat(creature: Dictionary) -> String:
	return "ward_vs_" + str(CLASS_KEYS[class_of(creature)])

static func offense_multiplier(total_percent: int) -> float:
	return 1.0 + clampi(total_percent,0,OFFENSE_CAP)/100.0

static func ward_multiplier(total_percent: int) -> float:
	return 1.0 - clampi(total_percent,0,WARD_CAP)/100.0

static func status_resistance(creature: Dictionary, status: String) -> int:
	return clampi(int(INNATE_RESISTANCES[class_of(creature)].get(status,0)),0,25)

static func status_resisted(creature: Dictionary, status: String, roll: float) -> bool:
	# Roll is a percentage in [0,100). Even the most resistant class accepts most applications.
	return roll >= 0.0 and roll < status_resistance(creature,status)

static func resistance_text(creature: Dictionary) -> String:
	var innate: Dictionary = INNATE_RESISTANCES[class_of(creature)]
	if innate.is_empty(): return "Innate status resistance: none."
	var effects: Array[String] = []
	for status in innate:
		effects.append("%s %d%%" % [str(status).capitalize(),int(innate[status])])
	return "Resist application: " + ", ".join(effects) + "."

static func tactics(creature: Dictionary) -> String:
	var category: String = class_of(creature)
	var advice: String = {
		"Human":"Burn, Bleed, Poison and Chill apply normally against Humans. Human hunt trinkets improve direct damage; Human wards reduce direct hits. Damage-over-time is unaffected.",
		"Corrupted":"Resists Bleed application 20% of the time. Burn, Poison and Chill apply normally. Corrupted hunt and ward trinkets affect direct hits only.",
		"The Remade":"Chill has a 15% chance to be resisted on application. Burn, Bleed and Poison apply normally. The Remade hunt and ward trinkets affect direct hits only; damage-over-time is unaffected.",
		"Insect":"Poison has a 20% chance to be resisted on application. Burn, Bleed and Chill apply normally. Insect hunt and ward trinkets affect direct hits only; damage-over-time is unaffected."
	}[category]
	if creature.get("undead",false): advice += " Holy attacks keep their undead bonus."
	return advice
