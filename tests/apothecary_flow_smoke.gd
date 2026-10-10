extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void:
	call_deferred("run")
func settle() -> void:
	await process_frame
	await process_frame
func win_fight(final: bool = false) -> void:
	var battle = current_scene
	for enemy in battle.enemies:
		enemy["hp"] = 0
	battle.enemy_hp = 0
	battle._check_battle_over()
	battle._on_end_turn_button_pressed()
	await settle()
	assert(current_scene.scene_file_path == "res://scenes/expedition/aftermath.tscn" if final else current_scene.has_node("DungeonMap"))
func run() -> void:
	State.progress_loaded = true
	State.progress_path = "user://apothecary_flow_test.cfg"
	State.completed_expeditions.clear()
	State.select_expedition("infested_apothecary")
	State.start_run(20)
	change_scene_to_file("res://scenes/combat/combatscene.tscn")
	await settle()
	assert(current_scene.enemies.size() == 3)
	await win_fight()
	assert(not State.apothecary_unlocked())
	await current_scene.move_to(Vector2i(1, 0))
	await settle()
	assert(current_scene.has_node("RestButton"))
	State.run_heroes["warden"]["hp"] = 3
	current_scene.rest_party()
	assert(State.run_heroes["warden"]["hp"] == State.hero_max_hp("warden"))
	current_scene.prepare("watch")
	current_scene.leave_camp()
	await settle()
	await current_scene.move_to(Vector2i(2, 0))
	await settle()
	assert(current_scene.enemies.size() == 1 and current_scene.enemy_name == "Moth Knight Oleander")
	await win_fight()
	assert(not State.apothecary_unlocked())
	await current_scene.move_to(Vector2i(3, 0))
	await settle()
	assert(current_scene.enemies.size() == 2 and current_scene.enemy_name == "Moth Queen Exuvia")
	assert(current_scene.enemies[1].get("cocoon", false))
	await win_fight(true)
	assert(State.apothecary_unlocked() and State.run_complete)
	assert(current_scene.scene_file_path == "res://scenes/expedition/aftermath.tscn")
	assert(State.last_report["complete"] and State.last_report["kills"] == 5)
	current_scene.return_home()
	await settle()
	assert(current_scene.has_node("MapView/apothecary"))
	current_scene._on_building_pressed({"scene": "res://scenes/hub/apothecary.tscn"})
	await settle()
	assert(current_scene.apothecary_mode)
	print("PASS: real scene flow through three fights, camp, victory, settlement and reclaimed shop")
	quit()
