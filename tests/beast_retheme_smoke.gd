extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
const Matchups = preload("res://scripts/creature_matchups.gd")
func _initialize(): call_deferred("run")
func run():
 State.progress_loaded = true
 State.progress_path = "user://beast-retheme.cfg"
 assert(State.CREATURES.anguish_penitent.name == "Supplicant of the Path","Approved Beast names replace Remade names")
 assert(State.CREATURES.coterie_cantor.name == "The Horned Priest: Choir Aspect")
 assert(Rules.MOVES.coterie_cantor[1].name == "Hymn of Hollow Throats")
 assert(Rules.MOVES.coterie_cantor[1].stress == 4 and Rules.MOVES.coterie_cantor[0].status == "chill")
 assert(Matchups.class_of({"creature_class":"The Remade","tags":["Remade","Cult"]}) == "The Beast","Older saved taxonomy remains compatible")
 assert(Matchups.offense_stat({"tags":["Remade"]}) == "damage_vs_remade")
 State.select_expedition("path_beast")
 State.start_run(42)
 assert(State.selected_expedition.floor_names == ["The Moonlit Warrens","The Revel of Runes","The Altar of the Beast"])
 for id in ["anguish_penitent","anguish_vessel","harrowed_giant","coterie_seamkeeper","coterie_cantor","coterie_matron","howling_head"]:
  var enemy: Dictionary = State.creature(id)
  assert(enemy.creature_class == "The Beast" and not enemy.undead)
  assert(enemy.hp == {"anguish_penitent":48,"anguish_vessel":54,"harrowed_giant":76,"coterie_seamkeeper":28,"coterie_cantor":34,"coterie_matron":40,"howling_head":84}[id])
  var texture: Texture2D = load(enemy.art)
  assert(texture != null and texture.get_meta("pose_id","") == id)
 var scene = load("res://scenes/combat/combatscene.tscn").instantiate()
 State.floors[0][Vector2i.ZERO] = {"kind":"boss","creature":"coterie_seamkeeper","enemies":["coterie_seamkeeper"],"boss_phases":["coterie_seamkeeper","coterie_cantor","coterie_matron"],"seen":true,"cleared":false}
 root.add_child(scene)
 for i in range(5): await process_frame
 assert(scene.enemies[0].name == "The Horned Priest: Wolf Aspect")
 scene._deal_enemy_damage(999,true)
 scene._check_battle_over()
 assert(scene.enemies[0].name == "The Horned Priest: Choir Aspect")
 scene._deal_enemy_damage(999,true)
 scene._check_battle_over()
 assert(scene.enemies[0].name == "The Horned Priest: Goat Aspect")
 scene.free()
 print("PASS: approved Beast lore/names, unchanged stats and attack rules, legacy taxonomy and all Priest phases")
 quit()
