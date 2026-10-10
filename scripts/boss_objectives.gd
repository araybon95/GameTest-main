extends RefCounted
## Optional battlefield actions. State belongs to the boss, not to the prop UI.
const DEFINITIONS = {
	"harrowed_giant": {"kind":"chains", "name":"Sacred Chains", "action":"SEVER A CHAIN", "uses":2, "icon":"res://assets/ui/boss_chain_anchor.svg"},
	"coterie_seamkeeper": {"kind":"rite", "name":"The Stitching Rite", "action":"BREAK THE RITE", "uses":1, "icon":"res://assets/ui/boss_ritual.svg"},
	"coterie_cantor": {"kind":"rite", "name":"The Bone Canticle", "action":"BREAK THE RITE", "uses":1, "icon":"res://assets/ui/boss_ritual.svg"},
	"coterie_matron": {"kind":"rite", "name":"The Remaking Rite", "action":"BREAK THE RITE", "uses":1, "icon":"res://assets/ui/boss_ritual.svg"},
	"howling_head": {"kind":"idol", "name":"Choir Idol", "action":"SILENCE THE IDOL", "uses":1, "icon":"res://assets/ui/boss_choir_idol.svg"}
}

static func create(creature: String) -> Dictionary:
	if not DEFINITIONS.has(creature): return {}
	var state: Dictionary = DEFINITIONS[creature].duplicate(true)
	state["spent"] = 0
	state["suppression_pending"] = false
	return state

static func available(state: Dictionary) -> bool:
	return not state.is_empty() and int(state.get("spent",0)) < int(state.get("uses",0))

static func interact(state: Dictionary) -> bool:
	if not available(state): return false
	state["spent"] = int(state["spent"])+1
	if state["kind"] == "rite": state["suppression_pending"] = true
	return true

static func incoming_multiplier(state: Dictionary) -> float:
	if state.get("kind","") == "chains":
		return 1.0-0.05*(int(state["uses"])-int(state["spent"]))
	return 1.0

static func attack_multiplier(state: Dictionary) -> float:
	return 1.0-0.10*int(state.get("spent",0)) if state.get("kind","") == "chains" else 1.0

static func modify_move(state: Dictionary, original: Dictionary) -> Dictionary:
	var move: Dictionary = original.duplicate(true)
	if state.get("suppression_pending",false):
		if move.get("effect","") in ["lament","remake"]:
			return {"name":"Interrupted " + str(move["name"]), "effect":"falter"}
		move["name"] = "Broken Rite: " + str(move["name"])
		move["scale"] = float(move.get("scale",1.0))*0.5
		move.erase("status")
	if state.get("kind","") == "idol" and move.get("effect","") == "lament":
		move["stress"] = maxi(0,int(move.get("stress",6))+(2 if int(state["spent"]) == 0 else -2))
		if int(state["spent"]) > 0: move.erase("status")
	return move

static func consume_action(state: Dictionary) -> void:
	state["suppression_pending"] = false

static func hint(state: Dictionary) -> String:
	match str(state.get("kind","")):
		"chains":
			var remaining: int = int(state["uses"])-int(state["spent"])
			return "Chains %d/2 · %d%% damage reduction. Each severed chain lowers the Giant's attack by 10%%." % [remaining,remaining*5]
		"rite":
			if state.get("suppression_pending",false): return "Rite broken · next ritual canceled, or next strike halved with no debuff."
			return "Once per form: cancel the next ritual, or halve its next strike and remove its debuff." if available(state) else "This form's rite has been broken. The next form brings a new rite."
		"idol":
			return "Idol intact · Prayer causes 8 Stress + Chill. Silence it: 4 Stress, no Chill." if available(state) else "Choir silenced · Prayer causes 4 Stress with no Chill."
	return ""

static func result_text(state: Dictionary) -> String:
	match str(state.get("kind","")):
		"chains": return "A sacred chain snaps. The Giant's attack falls by 10%; one armor bond is removed."
		"rite": return "The rite is broken. The next ritual fails, or the next strike is halved without a debuff."
		"idol": return "The choir idol falls silent. Unending Prayer causes 4 Stress and cannot inflict Chill."
	return ""
