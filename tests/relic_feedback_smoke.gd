extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Profiles = preload("res://scripts/attack_profiles.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://relic-feedback.cfg"
	State.party.assign(["warden","ranger","occultist"])
	State.select_expedition("old_road")
	State.start_run(42)
	for hero in State.party: State.equipment[hero] = {"weapon":hero+"_legend","armor":hero+"_relic_armor"}
	change_scene_to_file("res://scenes/combat/combatscene.tscn")
	for i in range(3): await process_frame
	var battle = current_scene
	var feedback = battle.get_node("PartyTacticsFeedback")
	assert(feedback.movement_text("warden").contains("2 AP"))
	assert(feedback.movement_text("ranger").contains("FIRST FORMATION MOVE FREE"))
	battle.hero_state.warden.oath_target = "ranger"
	battle.hero_state.warden.oath_retaliated = false
	var before: Dictionary = battle.hero_state.duplicate(true)
	var rng: int = State.loot_rng.state
	assert(feedback.links().size() == 1 and feedback.links()[0].return_ready)
	battle.hero_state.ranger.free_move_used = true
	assert(feedback.movement_text("ranger").contains("FREE MOVE USED"))
	battle.hero_state.ranger.erase("free_move_used")
	assert(before == battle.hero_state and rng == State.loot_rng.state)
	battle.hero_state.ranger.dead = true
	assert(feedback.links().is_empty())
	battle.hero_state.ranger.dead = false
	for pair in [["relic_warden","guard"],["relic_ranger","bow"],["relic_occultist","spell"],["relic_healer","heal"],["relic_crusader","charge"]]:
		assert(Profiles.resolve("sword","Signature",{"skill_id":pair[0]}).id == pair[1])
	battle.presentation.strike(battle.hero_portraits.occultist,battle.enemy_art,"spell","Gravetide",true,{"skill_id":"relic_occultist","relic_fx":"relic_drain"})
	assert(battle.presentation.active.relic_fx == "relic_drain")
	assert(preload("res://scenes/combat/relic_effects.gd").identity(battle.presentation.active) == "relic_drain")
	var inventory: Dictionary = State.inventory.duplicate(true)
	var gold: int = State.gold
	var reveal = load("res://scenes/ui/relic_reveal.gd").new()
	reveal.item_id = "occultist_legend"
	battle.add_child(reveal)
	var details: String = ""
	# Find the content label independently of internal scrollbars.
	for child in reveal.get_node("RelicDetails").get_children():
		if child is Label: details = child.text
	assert(details.contains("Gravetide Offering") and details.contains("3-TURN COOLDOWN"))
	assert(State.Items.item("occultist_legend").lore.contains("grave"))
	assert(State.inventory == inventory and State.gold == gold and State.loot_rng.state == rng)
	reveal.dismiss()
	print("PASS: live guard links, dead ally suppression, formation perk states, deterministic signature profiles/metadata and read-only legendary reveal")
	quit()
