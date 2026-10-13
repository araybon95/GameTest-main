extends Resource
## The established experiment IDs, limited to the combinations authored here.
signal appearance_changed
const VALID = {"weapon": ["mace", "axe"], "helmet": ["original", "wolf"], "cloak": ["original", "crown"]}
var weapon: String = "mace"
var helmet: String = "original"
var cloak: String = "original"
var reward_available: bool = false

func set_slot(slot: String, id: String) -> bool:
	if not VALID.has(slot) or id not in VALID[slot]:
		return false
	if not reward_available and ((slot == "helmet" and id == "wolf") or (slot == "cloak" and id == "crown")):
		return false
	if get(slot) != id:
		set(slot, id)
		appearance_changed.emit()
	return true

func set_reward_available(value: bool) -> void:
	reward_available = value
	if not value:
		helmet = "original"
		cloak = "original"
	appearance_changed.emit()

func to_dict() -> Dictionary:
	return {"schema": 1, "prototype_only": true, "hero": "warden", "weapon": weapon, "helmet": helmet, "cloak": cloak, "offhand": "shield"}
