extends SceneTree
## Malformed records must be rejected before changing a live journey.
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
var failures: Array[String] = []

func _initialize() -> void: call_deferred("run")

func check(condition: bool, message: String) -> void:
 if not condition: failures.append(message)

func snapshot() -> Dictionary:
 return {"gold":State.gold,"party":State.party.duplicate(),"inventory":State.inventory.duplicate(true),"equipment":State.equipment.duplicate(true),"heroes":State.run_heroes.duplicate(true),"journey":State.journey.duplicate(true),"run_id":State.run_id,"rng":State.loot_rng.state,"progress":State.hero_progress.duplicate(true)}

func write_payload(data: Dictionary) -> void:
 var config := ConfigFile.new()
 config.set_value("save","version",1)
 config.set_value("save","data",data)
 assert(config.save(Saves.path(2)) == OK)

func malformed(valid: Dictionary, field: String) -> Dictionary:
 var data: Dictionary = valid.duplicate(true)
 match field:
  "run_id": data.run_id = 17
  "boons": data.journey.boons = []
  "boon_value": data.journey.boons = {"ward":[]}
  "loot": data.journey.loot = []
  "journey_number": data.journey.steps = []
  "passages": data.journey.passages = []
  "passage_entry": data.journey.passages = {"hallway":[]}
  "transit": data.journey.transit = {"route":17}
  "transit_missing_done": data.journey.transit = {"run_id":data.run_id,"floor":0,"origin":Vector2i.ZERO,"route":[Vector2i.RIGHT],"index":0,"stage":"walking","event_key":"hallway"}
  "curio_missing_room": data.journey.passages = {"hallway":{"key":"hallway","kind":"curio","resolved":false}}
  "curio_missing_id": data.journey.passages = {"hallway":{"key":"hallway","kind":"curio","resolved":false,"room":{}}}
  "curio_bad_id": data.journey.passages = {"hallway":{"key":"hallway","kind":"curio","resolved":false,"room":{"event_id":17}}}
  "buffs": data.heroes.warden.buffs = []
  "buff_effect": data.heroes.warden.buffs = {"might":[]}
  "buff_turns": data.heroes.warden.buffs = {"might":{"turns":[],"amount":10}}
  "hero_number": data.heroes.warden.damage_mod = []
  "hero_flag": data.heroes.warden.resolved = []
  "hero_text": data.heroes.warden.resolve_tag = []
  "hero_missing": data.heroes.warden.erase("stress_per_turn")
  "status_damage": data.heroes.warden.statuses = {"burn":{"turns":2}}
  "status_turns": data.heroes.warden.statuses = {"poison":{"damage":2}}
  "journal": data.hero_journals.warden = []
  "journal_ties": data.hero_journals.warden.ties = []
  "journal_memories": data.hero_journals.warden.memories = [17]
  "report": data.last_report.survivors = {}
  "report_hero": data.last_report.survivors = [17]
  "report_hero_fields": data.last_report.survivors = [{"id":"warden"}]
  "enemies": data.floors[0][Vector2i.ZERO].enemies = []
  "enemy_id": data.floors[0][Vector2i.ZERO].enemies = [17]
  "item_history": data.item_histories["bad_item"] = {"base":"warden_sword","deeds":17}
 return data

func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://save-runtime-validation-progress.cfg"
 Saves.directory = "user://save-runtime-validation/"
 State.party.assign(["warden","ranger","occultist"])
 State.select_expedition("old_road")
 State.start_run(516)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 State.gold = 19
 State.run_heroes.warden.hp = 11
 State.add_item("healing_potion",2)
 assert(Saves.save(1))
 var valid: Dictionary = Saves.slot_info(1).data.duplicate(true)
 assert(Saves.load_slot(1))
 State.gold = 91
 var before: Dictionary = snapshot()
 var cases := ["run_id","boons","boon_value","loot","journey_number","passages","passage_entry","transit","transit_missing_done","curio_missing_room","curio_missing_id","curio_bad_id","buffs","buff_effect","buff_turns","hero_number","hero_flag","hero_text","hero_missing","status_damage","status_turns","journal","journal_ties","journal_memories","report","report_hero","report_hero_fields","enemies","enemy_id","item_history"]
 for field in cases:
  write_payload(malformed(valid,field))
  var file_before: String = FileAccess.get_file_as_string(Saves.path(2))
  var info: Dictionary = Saves.slot_info(2)
  check(not info.loadable,"Reject malformed "+field+" before advertising the save as loadable")
  # On the unfixed implementation the first assertion already fails. Avoid
  # invoking a known-crashing load; after the fix exercise every rejection.
  if not info.loadable:
   check(not Saves.load_slot(2),"Loading malformed "+field+" must return false")
   check(snapshot() == before,"Rejected "+field+" must preserve the complete active state")
   check(FileAccess.get_file_as_string(Saves.path(2)) == file_before,"Rejected "+field+" must leave the file untouched")
 # Preserve valid version-1 variants: minimal Chill, legacy damage-only DOT,
 # base-damage DOT, and buffs all remain usable.
 var compatible: Dictionary = valid.duplicate(true)
 compatible.heroes.warden.statuses = {"chill":{"turns":2},"burn":{"turns":2,"damage":3},"poison":{"turns":2,"base_damage":2,"stacks":1}}
 compatible.heroes.warden.buffs = {"might":{"turns":3,"amount":10}}
 write_payload(compatible)
 check(Saves.load_slot(2),"Valid version-1 status and buff variants still load")
 check(State.run_heroes.warden.hp == 11 and State.loot_rng.state == valid.rng,"Valid load retains wounds and RNG continuation")
 compatible.journey.passages = {"hallway":{"key":"hallway","kind":"curio","resolved":false,"room":{"event_id":"abandoned_cart"}}}
 compatible.journey.transit = {"run_id":compatible.run_id,"floor":0,"origin":Vector2i.ZERO,"route":[Vector2i.RIGHT],"index":0,"stage":"walking","event_key":"hallway","event_done":false}
 write_payload(compatible)
 check(Saves.load_slot(2),"Complete hallway event and traversal records still load")
 var legacy: Dictionary = valid.duplicate(true)
 for field in ["run_id","hero_positions","journey","last_report","hero_progress","hero_journals","item_histories","item_favourites","hero_outfits","hero_portraits"]: legacy.erase(field)
 write_payload(legacy)
 check(Saves.load_slot(2),"Older saves without later optional records still load")
 check(State.journey.get("rations") == 3 and State.hero_positions.size() == 3,"Legacy load restores existing journey/formation defaults")
 if failures.is_empty():
  print("PASS: 30 malformed save variants rejected before mutation; valid status/buff variants, wounds, RNG and legacy optional fields preserved")
 else:
  for message in failures: print("FAIL: ",message)
 quit(0 if failures.is_empty() else 1)
