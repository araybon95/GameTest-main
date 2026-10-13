extends Resource
## The same IDs drive every presentation; no inventory, stats or campaign state.
signal appearance_changed
const VALID = {"weapon":["sword","axe","mace"],"helmet":["original","wolf"],"cloak":["original","crown"],"offhand":["none","shield"]}
var weapon: String = "sword"
var helmet: String = "wolf"
var cloak: String = "crown"
var offhand: String = "none"
func set_slot(slot: String, id: String) -> bool:
	if not VALID.has(slot) or id not in VALID[slot]: return false
	if get(slot) != id:
		set(slot,id)
		appearance_changed.emit()
	return true
func to_dict() -> Dictionary:
	return {"schema":1,"prototype_only":true,"hero":"warden","weapon":weapon,"helmet":helmet,"cloak":cloak,"offhand":offhand}
func apply_data(data: Dictionary) -> bool:
	if typeof(data.get("schema")) not in [TYPE_INT,TYPE_FLOAT]: return false
	if typeof(data.get("prototype_only")) != TYPE_BOOL or typeof(data.get("hero")) != TYPE_STRING: return false
	if data.get("schema") != 1 or data.get("prototype_only") != true or data.get("hero") != "warden": return false
	var candidate: Dictionary = data.duplicate()
	# Old three-slot lab exports implicitly carried a shield.
	if not candidate.has("offhand"): candidate.offhand = "shield"
	for slot in VALID:
		if typeof(candidate.get(slot)) != TYPE_STRING: return false
		if candidate.get(slot) not in VALID[slot]: return false
	for slot in VALID: set(slot,candidate[slot])
	appearance_changed.emit()
	return true
