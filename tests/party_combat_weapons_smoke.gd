extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Poses = preload("res://scripts/combat_poses.gd")
const WEAPONS = {"ranger":["ranger_bow","ranger_epic","ranger_venombow","ranger_legend"],"occultist":["occultist_staff","occultist_epic","occultist_plaguestaff","occultist_legend"],"healer":["healer_mace","healer_epic","healer_frostmace","healer_legend"]}
func _initialize(): call_deferred("run")
func run():
 State.progress_loaded = true
 State.progress_path = "user://party-weapons.cfg"
 State.select_expedition("old_road")
 State.party.assign(["ranger","occultist","healer"])
 State.start_run(41)
 for hero in WEAPONS:
  State.add_item(WEAPONS[hero][2])
  assert(State.equip_item(hero,WEAPONS[hero][2]))
 State.floors[0][Vector2i.ZERO] = {"kind":"combat","creature":"ash_raider","enemies":["ash_raider"],"seen":true,"cleared":false}
 State.room_position = Vector2i.ZERO
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 for i in range(5): await process_frame
 for hero in WEAPONS:
  var initial: Texture2D = battle.hero_portraits[hero].texture
  assert(initial.get_meta("weapon_element","") == ("chill" if hero == "healer" else "poison"),"First combat frame retains equipped elemental identity")
  assert(initial.has_meta("painted_bounds"),"Scene-entry priming measures the painted figure before cinematics")
 for hero in WEAPONS:
  State.unequip_item(hero,"armor")
  State.hero_outfits[hero] = "original"
  var actor: TextureRect = battle.hero_portraits[hero]
  for id in WEAPONS[hero]:
   State.add_item(id)
   assert(State.equip_item(hero,id))
   battle._refresh_all()
   assert(actor.texture.get_meta("equipped_weapon","") == id,"Combat must show the equipped %s weapon" % hero)
   assert(actor.texture.get_meta("equipment_outfit","") == "original","Weapon rarity must preserve selected armour")
   var expected: String = "poison" if id in ["ranger_epic","ranger_venombow","ranger_legend","occultist_plaguestaff"] else "chill" if id == "healer_frostmace" else ""
   assert(actor.texture.get_meta("weapon_element","") == expected,"Only intrinsic offensive elements emit wisps")
   for pose in ["attack","cast","windup","hurt","guard"]:
    var texture = Poses.state_pose(actor.texture,pose)
    assert(texture.get_meta("equipped_weapon","") == id and texture.get_meta("combat_state","") == pose)
  for outfit in ["alternate","relic"]:
   State.hero_outfits[hero] = outfit
   battle._refresh_all()
   assert(actor.texture.get_meta("equipment_outfit","") == outfit)
  var armour_id: String = "ranger_armor" if hero == "ranger" else hero+"_faction_armor"
  State.add_item(armour_id)
  assert(State.equip_item(hero,armour_id))
  battle._refresh_all()
  assert(actor.texture.get_meta("equipment_outfit","") == "alternate","Equipped armour takes priority over manual relic selection")
  var named: String = "named_"+hero
  State.Items.histories[named] = {"base":WEAPONS[hero][2],"name":"Remembered by the Ward"}
  State.add_item(named)
  assert(State.equip_item(hero,named))
  battle._refresh_all()
  assert(actor.texture.get_meta("equipped_weapon","") == named)
  assert(actor.texture.get_meta("weapon_element","") == ("chill" if hero == "healer" else "poison"))
  var snapshot: Texture2D = actor.texture
  battle.presentation.set_process(false)
  battle.presentation.strike(actor,battle.enemy_views[0].get_node("EnemyArt"),"spell","Equipment pose",true,{"effect":"attack"})
  battle.presentation.apply_pose(0,"source",true)
  assert(is_equal_approx(battle.presentation.fighters[0].size.y,battle.presentation.active.source_size.y),"Transparent render margins must not shrink the attacking hero: %s %s %s" % [hero,battle.presentation.fighters[0].size,battle.presentation.active.source_size])
  battle.presentation._process(2.0)
  var dead = Poses.state_pose(snapshot,"death")
  var renderer = dead.get_meta("weapon_renderer")
  for viewport in renderer.get_children():
   if viewport.get_texture() == dead: assert(not viewport.get_child(0).wisps.visible)
  State.unequip_item(hero,"weapon")
  battle._refresh_all()
  assert(actor.texture.get_meta("equipped_weapon","missing") == "")
  assert(Poses.state_pose(snapshot,"attack").get_meta("equipped_weapon") == named,"Queued attack retains weapon snapshot")
 battle.free()
 print("PASS: Three classes, twelve weapon identities, selected armour, attack snapshots, offensive effects and safe unequip")
 quit()
