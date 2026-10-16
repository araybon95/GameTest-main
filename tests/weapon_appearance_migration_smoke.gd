extends SceneTree
var State = load("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var looks = load("res://scripts/equipment_looks.gd")
 if not looks.get_script_method_list().any(func(entry): return entry.name == "migrate_weapon_costumes"):
  print("FAIL: missing legacy weapon appearance migration")
  quit(1)
  return
 var old := {"equipment":{"warden":{"weapon":"warden_legend"}},"hero_outfits":{"warden":"original"},"equipment_appearance":true,"item_histories":{}}
 assert(looks.migrate_weapon_costumes(State,old) == {"warden":"relic"})
 var armored: Dictionary = old.duplicate(true)
 armored.equipment.warden.armor = "warden_armor"
 assert(looks.migrate_weapon_costumes(State,armored).is_empty())
 var disabled: Dictionary = old.duplicate(true)
 disabled.equipment_appearance = false
 assert(looks.migrate_weapon_costumes(State,disabled).is_empty())
 var named: Dictionary = old.duplicate(true)
 named.equipment.warden.weapon = "old-keepsake"
 named.item_histories = {"old-keepsake":{"base":"warden_legend"}}
 assert(looks.migrate_weapon_costumes(State,named) == {"warden":"relic"})
 var wolf: Dictionary = old.duplicate(true)
 wolf.hero_outfits.warden = "ashen_wolf"
 wolf.completed = ["old_road"]
 assert(looks.migrate_weapon_costumes(State,wolf).is_empty())
 assert(looks.valid_weapon_costumes({}) and looks.valid_weapon_costumes({"warden":"relic"}))
 for invalid in [false,{"unknown":"relic"},{"warden":"alternate"},{"warden":4}]: assert(not looks.valid_weapon_costumes(invalid))
 State.progress_loaded = true
 State.progress_path = "user://weapon-appearance-progress.cfg"
 Saves.directory = "user://weapon-appearance-saves/"
 State.party.assign(["warden","ranger","occultist"])
 State.select_expedition("old_road")
 State.start_run(404)
 State.hero_outfits = {"warden":"original"}
 State.equipment.clear()
 State.inventory.clear()
 State.equipment_appearance = true
 State.legacy_weapon_costumes = {"warden":"relic"}
 State.add_item("warden_legend")
 State.add_item("warden_sword")
 assert(State.equip_item("warden","warden_legend"))
 var hp: int = State.run_heroes.warden.hp
 assert(looks.choice(State,"warden") == "relic")
 assert(State.equip_item("warden","warden_sword") and looks.choice(State,"warden") == "relic")
 assert(State.run_heroes.warden.hp <= hp)
 State.add_item("warden_armor")
 assert(State.equip_item("warden","warden_armor") and looks.choice(State,"warden") == "original")
 State.unequip_item("warden","armor")
 State.unequip_item("warden","weapon")
 assert(looks.choice(State,"warden") == "relic" and State.equipment_bonus("warden","damage") == 0)
 var manual: Dictionary = State.hero_outfits.duplicate(true)
 State.equipment_appearance = false
 assert(looks.choice(State,"warden") == "original")
 State.equipment_appearance = true
 assert(Saves.save(1))
 State.legacy_weapon_costumes.clear()
 assert(Saves.load_slot(1) and State.legacy_weapon_costumes == {"warden":"relic"})
 assert(Saves.save(1) and Saves.load_slot(1) and State.hero_outfits == manual)
 var cfg := ConfigFile.new()
 assert(cfg.load(Saves.path(1)) == OK)
 var data: Dictionary = cfg.get_value("save","data")
 data.legacy_weapon_costumes = {"warden":"not-a-style"}
 cfg.set_value("save","data",data)
 assert(cfg.save(Saves.path(1)) == OK)
 assert(not Saves.load_slot(1) and State.legacy_weapon_costumes == {"warden":"relic"})
 State.save_progression()
 State.legacy_weapon_costumes.clear()
 State.progress_loaded = false
 State.load_progression()
 assert(State.legacy_weapon_costumes == {"warden":"relic"})
 State.legacy_weapon_costumes.clear()
 State.add_item("warden_legend")
 assert(State.equip_item("warden","warden_legend") and looks.choice(State,"warden") == "original","New weapon swaps cannot change armor")
 print("PASS: legacy legendary body migration, saved named copies, explicit armor/manual priority, opt-out, no healing, empty-slot stats and validated idempotent persistence")
 quit()
