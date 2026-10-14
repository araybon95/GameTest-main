extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize(): call_deferred("run")
func run():
 assert(ResourceLoader.exists("res://experiments/warden_weapon_preview.tscn"), "Approved weapon swap preview must exist")
 var preview = load("res://experiments/warden_weapon_preview.tscn").instantiate()
 root.add_child(preview)
 await process_frame
 preview.configure("original","warden_sword")
 var coat_point: Vector2 = preview.body.to_global(Vector2(560,770))
 var hidden: bool = false
 if preview.hand is Sprite2D:
  hidden = preview.hand.get_rect().has_point(preview.hand.to_local(coat_point))
 elif preview.hand is Polygon2D:
  hidden = Geometry2D.is_point_in_polygon(preview.hand.to_local(coat_point),preview.hand.polygon)
 assert(not hidden, "The gauntlet overlay must not hide the handle with surrounding coat pixels")
 var body = preview.body.texture
 var plain_weapon = preview.weapon.texture
 assert(not preview.wisps.visible, "Ordinary weapons do not emit elemental wisps")
 preview.configure("original","warden_frostblade")
 assert(preview.body.texture == body, "Weapon swaps preserve armour and body proportions")
 assert(preview.weapon.texture != plain_weapon, "Equipped weapon changes its visible silhouette")
 assert(preview.wisps.visible and preview.element == "chill", "Frost weapon continuously emits faint frost wisps")
 var emission: Vector2 = preview.smoke.position+Vector2(preview.smoke.size.x/2.0,preview.smoke.size.y*0.88)
 var emitted_pixel: Vector2 = preview.weapon.to_local(preview.wisps.to_global(emission))-preview.weapon.offset
 assert(emitted_pixel.y <= preview.weapon.texture.get_height()*0.06, "Blade smoke must originate at its point, clear of the shield")
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
 for chosen_outfit in ["original","ashen_wolf"]:
  for chosen_pose in ["idle","attack"]:
   for item_id in ["warden_sword","preview_mace","warden_frostblade"]:
    preview.configure(chosen_outfit,item_id)
    preview.set_pose(chosen_pose)
    assert(Geometry2D.is_point_in_polygon(preview.hand.to_local(preview.weapon.global_position),preview.hand.polygon), "Handle pivot stays within the actual gauntlet silhouette")
    var span: Vector2 = {"warden_sword":Vector2(720,905),"preview_mace":Vector2(326,872),"warden_frostblade":Vector2(768,904)}[item_id]
    var up_handle: float = (span.y+preview.weapon.offset.y)/(span.y-span.x)
    assert(up_handle >= 0.72 and up_handle <= 0.78, "The hand grips three quarters up the handle, near the guard")
    var pixels: Image = preview.weapon.texture.get_image()
    var grip_pixel: Vector2i = Vector2i(-preview.weapon.offset)
    assert(pixels.get_pixelv(grip_pixel).a > 0.9, "Measured grip must land on the opaque weapon handle")
 preview.free()
 print("PASS: independent Warden weapons, armour preservation, attack grips and intrinsic elemental wisps")
 quit()
