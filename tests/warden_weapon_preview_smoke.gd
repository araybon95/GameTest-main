extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize(): call_deferred("run")
func run():
 assert(ResourceLoader.exists("res://experiments/warden_weapon_preview.tscn"), "Approved weapon swap preview must exist")
 var preview = load("res://experiments/warden_weapon_preview.tscn").instantiate()
 root.add_child(preview)
 await process_frame
 preview.configure("original","warden_sword")
 var body = preview.body.texture
 var plain_weapon = preview.weapon.texture
 assert(not preview.wisps.visible, "Ordinary weapons do not emit elemental wisps")
 preview.configure("original","warden_frostblade")
 assert(preview.body.texture == body, "Weapon swaps preserve armour and body proportions")
 assert(preview.weapon.texture != plain_weapon, "Equipped weapon changes its visible silhouette")
 assert(preview.wisps.visible and preview.element == "chill", "Frost weapon continuously emits faint frost wisps")
 var idle_grip = preview.weapon.position
 preview.set_pose("attack")
 assert(preview.weapon.position != idle_grip, "Weapon follows the attack grip")
 assert(preview.wisps.position == preview.weapon.position, "Wisps follow the equipped weapon")
 assert(preview.effect_for({"bleed_resist":20}) == "", "Resistance alone is not an offensive property")
 assert(preview.effect_for({"unique_bleed":30}) == "bleed")
 assert(preview.effect_for({"poison_chance":15}) == "poison")
 assert(preview.effect_for({"unique_burn":30}) == "burn")
 State.equipment.warden = {"weapon":"warden_sword","charm":"venom_heart"}
 preview.configure_equipped(State,"warden","original")
 assert(not preview.wisps.visible, "A poison charm must not colour an ordinary weapon")
 preview.configure("ashen_wolf","warden_frostblade")
 assert(preview.body.texture != body, "Outfit selection remains independent of weapon selection")
 preview.set_pose("attack")
 assert(preview.weapon.position != idle_grip, "Alternate armour also supports the attack grip")
 preview.motion_enabled = false
 var stopped_clock = preview.elapsed
 await process_frame
 assert(preview.elapsed == stopped_clock, "Disabling motion freezes breathing and wisps")
 preview.configure("original","venom_heart")
 assert(not preview.wisps.visible, "Unsupported charm IDs cannot become enchanted weapon visuals")
 preview.configure("original","missing_weapon")
 assert(preview.weapon.visible and not preview.wisps.visible, "Unknown weapon safely falls back to the plain weapon")
 preview.free()
 print("PASS: independent Warden weapons, armour preservation, attack grips and intrinsic elemental wisps")
 quit()
