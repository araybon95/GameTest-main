extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://weapon-preview.cfg"
 State.completed_expeditions.assign(["restore_workshop","old_road"])
 State.equipment_appearance = true
 State.hero_outfits = {"warden":"original"}
 State.equipment = {"warden":{"weapon":"warden_legend"}}
 State.inventory = {"warden_epic":1}
 var workshop = load("res://scenes/hub/customization.gd").new()
 root.add_child(workshop)
 workshop.change_outfit("alternate")
 assert(workshop.preview.texture.get_meta("weapon_id","") == "warden_legend","Draft outfit must retain current weapon")
 assert(workshop.preview.texture.get_meta("weapon_style","") == "alternate","Draft preview must show unsaved style")
 assert(State.hero_outfits.warden == "original","Preview cannot commit outfit")
 assert(workshop.portrait_preview.texture.get_meta("weapon_id","") == "warden_legend")
 workshop.free()
 var keepsakes = load("res://scenes/hub/keepsakes.gd").new()
 keepsakes.selected_item = "warden_epic"
 root.add_child(keepsakes)
 assert(keepsakes.get_node("EquipmentPreview").texture.get_meta("weapon_id","") == "warden_epic","Keepsake candidate must show its own weapon")
 assert(State.equipment.warden.weapon == "warden_legend")
 keepsakes.free()
 State.unequip_item("warden","weapon")
 var sheet = load("res://scenes/ui/hero_sheet.gd").new()
 sheet.hero_id = "warden"
 root.add_child(sheet)
 assert("visual" in sheet.get_node("Equipment_weapon").tooltip_text.to_lower(),"Empty weapon slot explains starter visual without equipment bonuses")
 sheet.free()
 print("PASS: unsaved outfit/current weapon, keepsake candidate and explicit empty-slot starter preview routes")
 quit()
