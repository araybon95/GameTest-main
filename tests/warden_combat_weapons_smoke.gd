extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Poses = preload("res://scripts/combat_poses.gd")
func _initialize(): call_deferred("run")
func run():
 State.progress_loaded = true
 State.progress_path = "user://live-warden.cfg"
 State.select_expedition("old_road")
 State.party.assign(["warden","ranger","occultist"])
 State.start_run(41)
 State.add_item("warden_armor")
 assert(State.equip_item("warden","warden_armor"))
 State.add_item("warden_sword")
 assert(State.equip_item("warden","warden_sword"))
 State.floors[0][Vector2i.ZERO] = {"kind":"combat","creature":"ash_raider","enemies":["ash_raider"],"seen":true,"cleared":false}
 State.room_position = Vector2i.ZERO
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(5): await process_frame
 var actor: TextureRect = battle.hero_portraits.warden
 assert(actor.texture.get_meta("equipped_weapon","") == "warden_sword", "Combat must show the equipped Warden weapon")
 var initial_renderer = actor.texture.get_meta("weapon_renderer")
 for viewport in initial_renderer.get_children():
  if viewport.get_texture() == actor.texture:
   var model = viewport.get_child(0)
   assert(absf(model.body.position.y+1219*model.body.scale.y) < 0.01, "Visible Warden soles must meet the combat ground")
 var health: int = State.hero_max_hp("warden")
 for id in ["warden_frostblade","warden_epic","warden_legend"]:
  State.add_item(id)
  assert(State.equip_item("warden",id))
  battle._refresh_all()
  assert(actor.texture.get_meta("equipped_weapon","") == id)
  assert(actor.texture.get_meta("warden_outfit","") == "original", "Weapons preserve equipped armour")
  var attack: Texture2D = Poses.state_pose(actor.texture,"attack")
  assert(attack.get_meta("equipped_weapon","") == id and attack.get_meta("combat_state","") == "attack")
  assert(attack.get_meta("warden_outfit","") == "original")
  assert(actor.texture.get_meta("weapon_element","") == ("chill" if id == "warden_frostblade" else ""))
 State.unequip_item("warden","armor")
 State.hero_outfits.warden = "original"
 battle._refresh_all()
 assert(actor.texture.get_meta("warden_outfit","") == "original", "A legendary weapon must not replace manually selected armour")
 for armor in ["warden_faction_armor","warden_relic_armor"]:
  State.add_item(armor)
  assert(State.equip_item("warden",armor))
  battle._refresh_all()
  assert(actor.texture.get_meta("warden_outfit","") == State.Items.item(armor).equipment_look)
  var renderer = actor.texture.get_meta("weapon_renderer")
  for viewport in renderer.get_children():
   if viewport.get_texture() == actor.texture:
    assert(viewport.get_child(0).outfit == State.Items.item(armor).equipment_look, "Rendered body must preserve the selected armour")
 State.completed_expeditions.append("old_road")
 State.hero_outfits.warden = "ashen_wolf"
 battle._refresh_all()
 assert(actor.texture.get_meta("warden_outfit","") == "ashen_wolf")
 State.Items.histories["named_frost"] = {"base":"warden_frostblade","name":"The North Watch"}
 State.add_item("named_frost")
 assert(State.equip_item("warden","named_frost"))
 battle._refresh_all()
 assert(actor.texture.get_meta("equipped_weapon","") == "named_frost" and actor.texture.get_meta("weapon_element","") == "chill")
 var old_texture: Texture2D = actor.texture
 var dead_texture: Texture2D = Poses.state_pose(old_texture,"death")
 var renderer = dead_texture.get_meta("weapon_renderer")
 for viewport in renderer.get_children():
  if viewport.get_texture() == dead_texture: assert(not viewport.get_child(0).wisps.visible, "Fallen heroes do not emit weapon effects")
 State.unequip_item("warden","weapon")
 battle._refresh_all()
 assert(actor.texture.get_meta("equipped_weapon","") == "" and actor.texture.get_meta("weapon_element","") == "")
 assert(Poses.state_pose(old_texture,"attack").get_meta("equipped_weapon") == "named_frost", "Queued attacks retain the weapon captured before a swap")
 assert(not battle.hero_portraits.ranger.texture.has_meta("equipped_weapon"))
 battle.free()
 print("PASS: Warden equipment-driven combat art, attack snapshots, four outfits, named gear and safe unequip")
 quit()
