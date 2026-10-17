extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Visuals = preload("res://scripts/weapon_visuals.gd")
const Manifest = preload("res://assets/art_library/weapons/manifest.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://class-weapons.cfg"
 State.equipment.clear(); State.inventory.clear(); State.hero_outfits.clear(); State.legacy_weapon_costumes.clear()
 State.Items.histories.clear(); State.Items.favourites.clear()
 State.equipment_appearance = true
 State.crusader_unlocked = true
 State.party.assign(["warden","ranger","occultist"])
 State.select_expedition("old_road"); State.start_run(936)
 Saves.directory = "user://class-weapons-saves/"
 for hero in ["ranger","crusader","occultist"]:
  State.party.assign([hero,"warden","healer"])
  State.start_run(936)
  assert(Manifest.ENABLED[hero],"Completed class must be enabled: "+hero)
  var ids: Array = []
  for id in State.Items.EQUIPMENT:
   if State.Items.EQUIPMENT[id].get("hero","") == hero and State.Items.EQUIPMENT[id].get("slot","") == "weapon": ids.append(id)
  for id in ids: State.add_item(id)
  State.run_heroes[hero].hp = 12
  for id in ids+ids:
   var before: int = count_weapons(ids,hero)
   assert(State.equip_item(hero,id))
   assert(count_weapons(ids,hero) == before,"Swaps conserve owned instances")
   assert(State.run_heroes[hero].hp == 12,"Swaps cannot heal")
   var idle: Texture2D = Visuals.selected(State,hero)
   assert(idle.get_meta("weapon_id") == id)
   assert(State.hero(hero).equipment_look == "original","Weapons cannot select a different armor set")
   for pose in ["idle","windup","attack","guard","cast","hurt","death","camp","portrait"]:
    var texture: Texture2D = Visuals.selected(State,hero,pose)
    assert(texture != null and texture.get_meta("weapon_id") == id)
    assert(texture.get_meta("foot_anchor").y == texture.get_height())
   for texture in Visuals.walks(State,hero): assert(texture.get_meta("weapon_id") == id)
  var base: String = State.equipment[hero].weapon
  var instance: String = "test-keepsake-"+hero
  State.Items.histories[instance] = {"base":base,"name":"The Last Oath","transformation":"restored","deeds":[],"keys":[],"owners":[]}
  State.equipment[hero].weapon = instance
  State.Items.favourites[instance] = true
  assert(Visuals.selected(State,hero).get_meta("weapon_id") == base)
  assert(Saves.save(1)); State.unequip_item(hero,"weapon")
  assert(Visuals.selected(State,hero).get_meta("weapon_id") == Manifest.STARTERS[hero])
  assert(State.equipment_bonus(hero,"damage") == 0)
  assert(Saves.load_slot(1) and State.equipment[hero].weapon == instance)
  assert(State.Items.histories[instance].name == "The Last Oath" and State.Items.favourites[instance])
  assert(State.run_heroes[hero].hp == 12)
  assert(Visuals.selected(State,hero).get_meta("weapon_id") == base)
  if hero == "crusader": assert("Hammer" in str(State.Items.item(instance).name) or State.Items.item(instance).name == "The Last Oath")
 print("PASS: all remaining classes swap and preview every weapon, conserve copies, retain armor and named/transformed saves without healing")
 quit()
func count_weapons(ids: Array, hero: String) -> int:
 var count: int = 1 if State.equipment.get(hero,{}).has("weapon") else 0
 for id in ids: count += int(State.inventory.get(id,0))
 return count
