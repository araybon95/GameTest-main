extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://weapon-swapping.cfg"
 State.equipment.clear()
 State.inventory.clear()
 State.hero_outfits.clear()
 State.legacy_weapon_costumes.clear()
 State.equipment_appearance = true
 State.party.assign(["warden","ranger","occultist"])
 State.select_expedition("old_road")
 State.start_run(935)
 State.add_item("warden_sword")
 State.add_item("warden_legend")
 assert(State.equip_item("warden","warden_sword"))
 State.run_heroes.warden.hp = 20
 var sheet = load("res://scenes/ui/hero_sheet.gd").new()
 sheet.hero_id = "warden"
 sheet.inventory_mode = true
 root.add_child(sheet)
 await process_frame
 sheet.choose_item("warden_legend")
 var comparison = sheet.get_node("EquipmentComparison")
 assert(comparison.get_node("CurrentAppearance").texture.get_meta("weapon_id","") == "warden_sword","Current panel must show equipped weapon")
 assert(comparison.get_node("ProposedAppearance").texture.get_meta("weapon_id","") == "warden_legend","Preview must show candidate weapon before equip")
 assert(State.equipment.warden.weapon == "warden_sword")
 comparison.request_equip()
 await process_frame
 assert(State.equipment.warden.weapon == "warden_legend")
 assert(State.inventory.get("warden_sword",0) == 1 and State.inventory.get("warden_legend",0) == 0)
 assert(State.run_heroes.warden.hp == 20,"Changing weapons cannot heal")
 assert(sheet.get_node("SheetPortrait").texture.get_meta("weapon_id","") == "warden_legend")
 var visual = load("res://scripts/weapon_visuals.gd")
 var idle: Texture2D = visual.selected(State,"warden")
 var foot: Vector2 = idle.get_meta("foot_anchor")
 assert(foot.y == idle.get_height() and foot.x == idle.get_width()/2.0,"Runtime canvas feet must meet bottom-centre")
 for pose in ["attack","hurt","guard","idle"]:
  var frame: Texture2D = load("res://scripts/combat_poses.gd").state_pose(idle,pose)
  assert(frame.get_meta("weapon_id") == "warden_legend" and frame.get_meta("foot_anchor") == foot)
 assert(visual.selected(State,"warden","camp").get_meta("weapon_id") == "warden_legend")
 for frame in visual.walks(State,"warden"):
  assert(frame.get_meta("weapon_id") == "warden_legend" and frame.get_meta("foot_anchor").y == frame.get_height())
 var standing = load("res://scripts/standing_party.gd").create("warden",Vector2(300,600),200)
 root.add_child(standing)
 assert(standing.texture.get_meta("weapon_id") == "warden_legend")
 assert(is_equal_approx(standing.position.y+standing.size.y,600))
 State.add_item("warden_epic")
 assert(State.equip_item("warden","warden_epic"))
 standing.update_motion(0)
 assert(standing.texture.get_meta("weapon_id") == "warden_epic","Same-armor weapon swaps must refresh standing cache")
 var saves = load("res://scripts/save_files.gd")
 saves.directory = "user://weapon-swapping-saves/"
 assert(saves.save(1))
 sheet.remove_equipment("weapon")
 assert(not State.equipment.warden.has("weapon"))
 assert(sheet.get_node("SheetPortrait").texture.get_meta("weapon_id") == "warden_sword")
 assert(saves.load_slot(1) and State.equipment.warden.weapon == "warden_epic")
 sheet.refresh()
 assert(sheet.get_node("SheetPortrait").texture.get_meta("weapon_id") == "warden_epic")
 State.run_heroes.warden.dead = true
 sheet.choose_item("warden_sword")
 assert(sheet.get_node("EquipmentComparison/ConfirmEquip").disabled)
 sheet.get_node("EquipmentComparison").dismiss()
 await process_frame
 State.run_heroes.warden.dead = false
 State.equipment_appearance = false
 assert(visual.selected(State,"warden") == null,"Explicit cosmetic override preserves manual art")
 assert("override" in load("res://scripts/equipment_comparison.gd").text(State,"warden","warden_sword").to_lower())
 standing.free()
 sheet.free()
 print("PASS: actual equipment preview/equip, consistent weapon-aware poses, travel/camp, grounded standing refresh and cosmetic override")
 quit()
