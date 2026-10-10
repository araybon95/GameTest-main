extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
const Routes = preload("res://scripts/dungeon_routes.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 await process_frame
 await process_frame
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://settings_test_progress.cfg"
 Saves.directory = "user://settings_test_saves/"
 State.completed_expeditions.clear()
 assert(not State.customize_hero("warden","Alden","green"))
 State.completed_expeditions.append("restore_workshop")
 assert(State.customize_hero("warden","Alden","green"))
 assert(State.hero("warden")["name"] == "Alden" and State.hero("warden")["class"] == "Warden")
 State.select_expedition("old_road")
 State.start_run(31)
 State.gold = 47
 State.add_item("healing_potion",3)
 State.run_heroes["warden"]["hp"] = 17
 State.floors[0][Vector2i.ZERO]["cleared"] = true
 assert(Saves.save(1))
 assert(Saves.save(1), "Overwriting a slot succeeds")
 var saved_rng: int = State.loot_rng.state
 State.gold = 0
 State.hero_names.clear()
 State.inventory.clear()
 State.end_run()
 assert(Saves.load_slot(1))
 assert(State.gold == 47 and State.run_active and State.run_heroes["warden"]["hp"] == 17)
 assert(State.hero_names["warden"] == "Alden" and State.hero_colors["warden"] == "green")
 assert(State.inventory["healing_potion"] == 3 and State.loot_rng.state == saved_rng)
 assert(not Saves.load_slot(3))
 var rooms: Dictionary = {Vector2i(0,0):{"seen":true,"cleared":true},Vector2i(1,0):{"seen":true,"cleared":true},Vector2i(2,0):{"seen":true,"cleared":false},Vector2i(3,0):{"seen":true,"cleared":true}}
 assert(Routes.find(rooms,Vector2i.ZERO,Vector2i(2,0)).size() == 2)
 assert(Routes.find(rooms,Vector2i.ZERO,Vector2i(3,0)).is_empty())
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await settle()
 assert(current_scene.hero_buttons["warden"].get_node("HeroClass").text == "Warden · Lv 1")
 assert(current_scene.hero_name_labels["warden"].text.contains("ALDEN"))
 var settings = root.get_node("GameSettings")
 settings.settings_path = "user://settings_test.cfg"
 settings.set_value("music",0)
 assert(AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")))
 settings.set_value("music",0.8)
 settings.set_value("brightness",1.15)
 assert(not settings.safe_to_save())
 settings.open_settings()
 await settle()
 assert(settings.overlay != null)
 if DisplayServer.get_name() != "headless":
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("C:/GAME/Ashen/settings-preview.png")
 settings.close_settings()
 State.end_run()
 change_scene_to_file("res://scenes/hub/customization.tscn")
 await settle()
 current_scene.change_color("blue")
 assert(current_scene.preview.material != null)
 if DisplayServer.get_name() != "headless":
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("C:/GAME/Ashen/customization-preview.png")
 print("PASS: save overwrite/roundtrip, hero identity, locked customization, palette, settings buses/brightness, combat save gate and safe routes")
 quit()
