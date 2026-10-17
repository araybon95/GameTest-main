extends RefCounted
## Shared, side-effect-free equipment eligibility for UI, exchange and saves.
const FAMILIES = {"warden":"one_handed_melee","ranger":"bow","crusader":"two_handed_hammer","occultist":"staff","healer":"one_handed_melee"}
const HANDS = {"warden":1,"ranger":2,"crusader":2,"occultist":1,"healer":1}
const SLOTS = ["weapon","off_hand","head","armor","trinket","charm"]
static func base_id(state, item_id: String) -> String:
 return state.Items.base_id(item_id)

static func _entry(state, item_id: String, histories: Variant = null) -> Dictionary:
 if histories == null: return state.Items.item(item_id)
 # A candidate save must not resolve against (or temporarily replace) live history.
 var history: Dictionary = histories.get(item_id,{})
 var base: String = str(history.get("base",item_id))
 var entry: Dictionary = state.Items.EQUIPMENT.get(base,{}).duplicate()
 if history.has("hero"): entry["hero"] = history.hero
 return entry

static func reason(state, hero_id: String, item_id: String, loadout: Dictionary) -> String:
 var entry: Dictionary = _entry(state,item_id)
 if entry.is_empty() or not entry.has("slot"): return "This item cannot be equipped."
 var candidate: Dictionary = loadout.duplicate()
 candidate[entry.slot] = item_id
 return loadout_error(state,hero_id,candidate)

static func loadout_error(state, hero_id: String, loadout: Dictionary, histories: Variant = null) -> String:
 if not state.HEROES.has(hero_id): return "Unknown hero equipment owner."
 for slot in loadout:
  if (not slot is String and not slot is StringName) or not SLOTS.has(slot) or not loadout[slot] is String: return "Invalid equipment slot."
  var entry: Dictionary = _entry(state,loadout[slot],histories)
  if entry.is_empty() or entry.get("slot","") != slot: return "This item does not belong in that equipment slot."
  if entry.has("hero") and entry.hero != hero_id: return "Cannot equip: this belongs to another class."
  if slot == "weapon":
   var hands: Variant = entry.get("hands",0)
   var valid_hands: bool = hands is int and (hands in [1,2] if hero_id == "occultist" else hands == HANDS.get(hero_id,0))
   if entry.get("weapon_family","") != FAMILIES.get(hero_id,"") or not valid_hands:
    return "This weapon is not compatible with this class."
   if int(entry.hands) == 2 and loadout.has("off_hand"): return "A two-handed weapon requires an empty off-hand slot."
 return ""
