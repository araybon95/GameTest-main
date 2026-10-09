extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
func _initialize() -> void:
	call_deferred("verify")
func verify() -> void:
	State.select_expedition("old_road")
	State.start_run(5)
	State.floors[0][Vector2i.ZERO]["enemies"] = ["ash_raider", "gallows_scout", "ash_raider"]
	var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
	root.add_child(battle)
	Rules.apply_status(battle.hero_state["warden"]["statuses"], "burn")
	Rules.apply_status(battle.hero_state["ranger"]["statuses"], "bleed")
	Rules.apply_status(battle.enemies[1]["statuses"], "poison")
	Rules.apply_status(battle.enemies[2]["statuses"], "chill")
	battle.hero_state["warden"]["hp"] = 12
	battle.enemies[1]["weak"] = 2
	battle._refresh_all()
	var warden = battle.hero_portraits["warden"].get_node("StatusVisual")
	var ranger = battle.hero_portraits["ranger"].get_node("StatusVisual")
	var foe0 = battle.enemy_views[0].get_node("EnemyArt/StatusVisual")
	var foe1 = battle.enemy_views[1].get_node("EnemyArt/StatusVisual")
	var foe2 = battle.enemy_views[2].get_node("EnemyArt/StatusVisual")
	assert(warden.effect_material != ranger.effect_material and foe1.effect_material != foe2.effect_material)
	assert(warden.effect_material.get_shader_parameter("burn") == 1.0)
	assert(ranger.effect_material.get_shader_parameter("bleed") == 1.0)
	assert(foe0.statuses.is_empty() and foe1.statuses.has("poison") and foe1.statuses.has("weaken"))
	assert(foe2.effect_material.get_shader_parameter("chill") == 1.0)
	assert(battle.selected_portrait.get_node("StatusVisual").statuses.has("burn"))
	assert(warden.effect_material.get_shader_parameter("wounded") > 0.0)
	warden._process(0.01)
	assert(warden.portrait.rotation != 0.0 and warden.portrait.scale.y < 1.0)
	var hp: int = battle.hero_state["ranger"]["hp"]
	battle._apply_damage("ranger", 1)
	assert(ranger.impact_remaining > 0.0 and battle.hero_state["ranger"]["hp"] == hp - 1)
	ranger._process(0.5)
	assert(ranger.impact_remaining == 0.0)
	# Natural expiry removes both the model effect and its status marker.
	battle._tick_hero_statuses("warden")
	battle._tick_hero_statuses("warden")
	battle._heal_hero("warden", 100)
	battle._refresh_all()
	warden._process(0.5)
	assert(not warden.statuses.has("burn") and warden.effect_material.get_shader_parameter("burn") == 0.0)
	assert(warden.effect_material.get_shader_parameter("wounded") == 0.0)
	assert(warden.portrait.rotation == 0.0 and warden.portrait.scale == Vector2.ONE)
	assert(foe1.statuses.has("poison"))
	for hero_id in State.HEROES:
		assert(ResourceLoader.exists(State.HEROES[hero_id]["camp_art"]))
	battle.queue_free()
	await process_frame
	print("PASS: separate hero/enemy materials, selected-hero effects, simultaneous debuffs, wounded stance, damage recoil, natural status expiry and healing cleanup, four camp pose assets")
	quit()
