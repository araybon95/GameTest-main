extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Relic = preload("res://scripts/relic_combat.gd")
var battle
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://relic-check.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.equipment.clear()
	State.hero_progress.clear()
	State.select_expedition("old_road")
	State.start_run(968)
	for hero in ["warden","ranger","occultist","healer","crusader"]:
		State.equipment[hero] = {"weapon":hero+"_legend"}
		assert(State.hero_abilities(hero).has("relic_"+hero))
		assert(State.ability_cooldown("relic_"+hero) == 3)
		assert(not State.can_upgrade("relic_"+hero))
	State.Items.histories["oath_copy"] = {"base":"warden_legend"}
	State.equipment.warden.weapon = "oath_copy"
	assert(State.legendary_skill("warden") == "relic_warden")
	State.equipment.warden.weapon = "warden_sword"
	assert(not State.hero_abilities("warden").has("relic_warden"))
	State.equipment.warden.weapon = "warden_legend"
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout","ash_raider"],"cleared":false,"seen":true}
	change_scene_to_file("res://scenes/combat/combatscene.tscn")
	for i in range(3): await process_frame
	battle = current_scene
	battle.presentation.queue_free()
	battle.presentation = null
	for enemy in battle.enemies:
		enemy.hp = 500
		enemy.max_hp = 500
		enemy.block = 0
	battle._load_enemy(0)
	battle.hero_state.ranger.hp = 10
	battle._play_card("warden",battle.hero_state.warden.abilities.find("relic_warden"))
	assert(battle.hero_state.warden.ap == 1 and battle.hero_state.warden.cooldowns.relic_warden == 4)
	assert(Relic.intercept(battle,"ranger") == "warden")
	var hp: int = battle.enemy_hp
	Relic.retaliate(battle,"warden")
	assert(battle.enemy_hp < hp)
	hp = battle.enemy_hp
	Relic.retaliate(battle,"warden")
	assert(battle.enemy_hp == hp,"Retaliation only once")
	battle._resolve_card("ranger",State.card_stats("relic_ranger"))
	for enemy in battle.enemies:
		assert(enemy.hp < 500 and enemy.statuses.has("poison"))
	assert(battle.selected_enemy_index == 0)
	var injured: int = battle.hero_state.ranger.hp
	battle._resolve_card("occultist",State.card_stats("relic_occultist"))
	assert(battle.hero_state.ranger.hp > injured)
	injured = battle.hero_state.ranger.hp
	battle.enemy_block = 1000
	battle._store_enemy()
	battle._resolve_card("occultist",State.card_stats("relic_occultist"))
	assert(battle.hero_state.ranger.hp == injured,"Full block cannot drain")
	battle.hero_state.healer = battle.hero_state.occultist.duplicate(true)
	battle.hero_state.ranger.statuses = {"bleed":{},"poison":{},"burn":{},"chill":{}}
	battle._resolve_card("healer",State.card_stats("relic_healer"))
	assert(battle.hero_state.ranger.statuses.is_empty() and battle.hero_state.ranger.block >= 4)
	battle.hero_state.crusader = battle.hero_state.warden.duplicate(true)
	battle.hero_state.crusader.hp = 2
	assert(battle._skill_availability("crusader","relic_crusader").code != "ready")
	State.equipment.warden.armor = "warden_relic_armor"
	assert(battle.formation_move_cost("warden") == 2)
	State.equipment.ranger.armor = "ranger_common_armor"
	assert(battle.formation_move_cost("ranger") == 0)
	battle._select_hero("ranger")
	battle.move_position(1)
	assert(battle.hero_state.ranger.get("free_move_used",false))
	assert(battle.formation_move_cost("ranger") == 1)
	assert(State.Items.description("ranger_common_armor").contains("-1 block"))
	battle._end_turn()
	assert(battle.hero_state.warden.get("oath_target","").is_empty())
	assert(battle.formation_move_cost("ranger") == 0)
	assert(battle.hero_state.warden.cooldowns.relic_warden == 3)
	battle._load_enemy(0)
	battle.enemy_hp = 1
	battle.enemy_block = 0
	battle._store_enemy()
	battle.hero_state.warden.oath_retaliated = false
	var untouched: int = battle.enemies[1].hp
	Relic.retaliate(battle,"warden")
	assert(battle.selected_enemy_index == 0 and battle.enemy_hp == 0)
	assert(battle.enemies[1].hp == untouched,"Killing retaliation must not retarget the enemy's ongoing action")
	battle.queue_free()
	await process_frame
	State.party.assign(["warden","crusader","ranger"])
	State.hero_positions.clear()
	State.formation.clear()
	State.start_run(968)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","gallows_scout"],"cleared":false,"seen":true}
	change_scene_to_file("res://scenes/combat/combatscene.tscn")
	for i in range(3): await process_frame
	battle = current_scene
	battle._select_hero("crusader")
	State.Depth.move_hero(State,"crusader",2)
	var card_index: int = battle.hero_state.crusader.abilities.find("relic_crusader")
	battle.hero_state.crusader.hp = 2
	assert(battle._skill_availability("crusader","relic_crusader").code == "health")
	battle._play_card("crusader",card_index)
	assert(battle.hero_state.crusader.ap == 2)
	battle.hero_state.crusader.hp = 20
	# Remove the weapon's passive drain to measure the exact health payment.
	State.equipment.crusader.weapon = "crusader_axe"
	battle._play_card("crusader",card_index)
	assert(battle.hero_state.crusader.hp == 18 and battle.hero_state.crusader.ap == 0)
	assert(State.Depth.position_of(State,"crusader") == 1)
	assert(State.Depth.skill_allowed(State,"crusader","relic_crusader",1),"The legendary charge remains usable from the front")
	assert(battle.enemies[0].statuses.has("bleed") and battle.hero_state.crusader.block >= 4)
	battle.queue_free()
	await process_frame
	State.party.assign(["warden","ranger","healer"])
	State.hero_positions.clear()
	State.formation.clear()
	State.start_run(968)
	State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider"],"cleared":false,"seen":true}
	change_scene_to_file("res://scenes/combat/combatscene.tscn")
	for i in range(3): await process_frame
	battle = current_scene
	battle._select_hero("healer")
	assert(battle.quick_select_skill(6))
	for i in range(4): await process_frame
	var scroll: ScrollContainer = battle.hand_container.get_parent()
	var skill: Control = battle.hand_container.get_node("Card_relic_healer")
	assert(scroll.scroll_vertical > 0 and scroll.get_global_rect().encloses(skill.get_global_rect()))
	assert(skill.preview.position.y + skill.preview.size.y <= skill.get_global_rect().position.y)
	print("PASS: five equipment-gated relic skills, cooldowns, named copies, interception, retaliation, volley, blocked drain, cleansing and armour movement costs")
	quit()
