extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
class FixtureItems extends RefCounted:
 static func item(id: String) -> Dictionary:
  if id == "test_staff_two": return {"hero":"occultist","slot":"weapon","weapon_family":"staff","hands":2}
  if id == "test_focus": return {"hero":"occultist","slot":"off_hand"}
  if id == "test_bow": return {"hero":"ranger","slot":"weapon","weapon_family":"bow","hands":2}
  if id == "test_quiver": return {"hero":"ranger","slot":"off_hand"}
  return State.Items.item(id)
 static func base_id(id: String) -> String: return State.Items.base_id(id)
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var baseline: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://experimental/weapon_swapping/coverage.json")).weapon_numeric_baseline
 var families := {"warden":["one_handed_melee",1],"ranger":["bow",2],"crusader":["two_handed_hammer",2],"occultist":["staff",1],"healer":["one_handed_melee",1]}
 for id in baseline:
  var entry: Dictionary = State.Items.item(id)
  if entry.get("weapon_family","") != families[entry.hero][0] or entry.get("hands",0) != families[entry.hero][1]:
   print("FAIL: explicit weapon family and handedness missing for ",id)
   quit(1)
   return
  var numbers: Dictionary = {}
  for key in entry:
   if (entry[key] is int or entry[key] is float) and key != "hands": numbers[key] = entry[key]
  assert(numbers.size() == baseline[id].size(),"No numerical effect may be added or removed")
  for key in numbers:
   assert(baseline[id].has(key) and float(numbers[key]) == float(baseline[id][key]),"Weapon metadata must not change existing numerical effects")
 var hammer_text: String = State.Items.description("crusader_axe")
 assert("Witch Hunter only" in hammer_text and "Hammer" in hammer_text and "Two-handed" in hammer_text,"Weapon details must show current class name, family and handedness")
 var rules = load("res://scripts/weapon_rules.gd")
 var fixture := {"Items":FixtureItems,"HEROES":State.HEROES}
 assert(not rules.reason(fixture,"ranger","test_bow",{"off_hand":"test_quiver"}).is_empty())
 assert(not rules.reason(fixture,"ranger","test_quiver",{"weapon":"test_bow"}).is_empty())
 assert(rules.reason(fixture,"ranger","test_bow",{}).is_empty())
 assert(rules.reason(fixture,"occultist","test_staff_two",{}).is_empty(),"Future explicitly two-handed staves are legal with empty off-hand")
 assert(not rules.reason(fixture,"occultist","test_staff_two",{"off_hand":"test_focus"}).is_empty())
 assert(not rules.reason(fixture,"occultist","test_focus",{"weapon":"test_staff_two"}).is_empty())
 State.progress_loaded = true
 State.progress_path = "user://weapon-rules-progress.cfg"
 Saves.directory = "user://weapon-rules-saves/"
 State.party.assign(["warden","ranger","occultist"])
 State.select_expedition("old_road")
 State.start_run(982)
 State.inventory.clear()
 State.equipment.clear()
 State.Items.histories.clear()
 State.add_item("ranger_bow")
 var before: Dictionary = State.inventory.duplicate(true)
 assert(not State.equip_item("warden","ranger_bow") and State.inventory == before and State.equipment.is_empty())
 assert(not preload("res://scripts/equipment_comparison.gd").compare(State,"warden","ranger_bow").compatible)
 var copy: String = "warden_sword#weapon-test"
 var history := {"base":"warden_sword","name":"Last Vigil","transformation":"restored","deeds":[],"keys":[],"owners":[]}
 State.Items.histories[copy] = history.duplicate(true)
 State.Items.favourites[copy] = true
 State.modifications[copy] = "keen"
 State.add_item(copy)
 assert(rules.base_id(State,copy) == "warden_sword")
 assert(State.equip_item("warden",copy))
 var hp: int = State.run_heroes.warden.hp
 for cycle in range(3):
  State.unequip_item("warden","weapon")
  assert(State.inventory[copy] == 1)
  assert(State.equip_item("warden",copy))
 assert(not State.inventory.has(copy) and State.equipment.warden.weapon == copy)
 assert(State.run_heroes.warden.hp <= hp and State.Items.histories[copy] == history)
 assert(State.Items.favourites[copy] and State.modifications[copy] == "keen")
 State.equipment.occultist = {"weapon":"occultist_staff","off_hand":"occultist_focus"}
 assert(rules.loadout_error(State,"occultist",State.equipment.occultist).is_empty())
 assert(Saves.save(1))
 var cfg := ConfigFile.new()
 assert(cfg.load(Saves.path(1)) == OK)
 var data: Dictionary = cfg.get_value("save","data")
 State.Items.histories.clear()
 var saved_error: String = Saves.validation_error(data)
 if not saved_error.is_empty(): print("Saved validation: ",saved_error)
 assert(saved_error.is_empty(),"Saved copies resolve against saved history, not live globals")
 assert(Saves.load_slot(1) and State.equipment.warden.weapon == copy and State.Items.item(copy).name == "Last Vigil")
 # Gear that no longer fits is returned to the pack; the rest of the save still loads.
 var bows: int = int(data.inventory.get("ranger_bow",0))
 data.equipment.warden.weapon = "ranger_bow"
 data.equipment.occultist.weapon = "retired_item_id"
 data.equipment.ranger = {"weapon":"ranger_bow","off_hand":"occultist_focus"}
 cfg.set_value("save","data",data)
 assert(cfg.save(Saves.path(1)) == OK)
 assert(Saves.slot_info(1).loadable,"An incompatible item must not make the save unloadable")
 assert(Saves.load_slot(1))
 assert(not State.equipment.warden.has("weapon") and State.inventory.ranger_bow == bows+1)
 assert(not State.equipment.occultist.has("weapon") and not State.inventory.has("retired_item_id") and State.equipment.occultist.off_hand == "occultist_focus")
 assert(State.equipment.ranger == {"weapon":"ranger_bow"} and State.inventory.occultist_focus >= 1,"Another class's off-hand returns to the pack while the weapon stays")
 for hero_id in State.equipment: assert(rules.loadout_error(State,hero_id,State.equipment[hero_id]).is_empty())
 assert(not rules.loadout_error(State,"warden",{"armor":"warden_sword"}).is_empty())
 print("PASS: all class weapon families/hands, unchanged effects, two-way off-hand conflicts, copy conservation, saved history and incompatible gear returned on load")
 quit()
