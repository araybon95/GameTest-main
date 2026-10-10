extends SceneTree
const State = preload("res://scripts/game_data.gd")
const Saves = preload("res://scripts/save_files.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 await process_frame
 await process_frame
func shot(path: String) -> void:
 if DisplayServer.get_name() == "headless": return
 await create_timer(0.65).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func run() -> void:
 root.size = Vector2i(1920,1080)
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 State.progress_loaded = true
 State.progress_path = "user://graveyard_test.cfg"
 Saves.directory = "user://graveyard_test_saves/"
 State.graves.clear()
 State.hero_names["warden"] = "Alden"
 State.select_expedition("old_road")
 State.start_run(30)
 State.add_deed("warden","battles",2)
 State.add_deed("warden","damage",31)
 State.add_deed("warden","healing",7)
 assert(Saves.save(1))
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await settle()
 current_scene.hero_state["warden"]["hp"] = 0
 current_scene.hero_state["warden"]["deaths_door"] = true
 current_scene._apply_damage("warden",1,true,"Bleed")
 assert(State.graves.size() == 1)
 var grave: Dictionary = State.graves[0]
 assert(grave["name"] == "Alden" and grave["class"] == "Warden" and grave["deeds"]["damage"] == 31 and grave["cause"] == "Bleed")
 State.record_death("warden","Bleed")
 assert(State.graves.size() == 1)
 assert(Saves.load_slot(1))
 assert(State.graves.size() == 1, "Loading an earlier save retains historical memorials")
 State.graves.clear()
 State.progress_loaded = false
 State.load_progression()
 assert(State.graves.size() == 1, "Memorial survives a fresh progress load")
 State.end_run()
 change_scene_to_file("res://scenes/hub/graveyard.tscn")
 await settle()
 assert(current_scene.get_node("GraveyardBackground").texture.resource_path == "res://assets/generated/graveyard_ink_background.png")
 var record: VBoxContainer = current_scene.get_node("MemorialsScroll/MemorialList/Memorial_0/Record")
 assert(record.get_node("HeroName").text == grave["name"])
 assert(record.get_node("HeroClass").text == str(grave["class"]).to_upper())
 assert(record.get_node("FallenLocation").text.contains(grave["dungeon"]) and record.get_node("FallenLocation").text.contains("Floor %d" % grave["floor"]))
 assert(record.get_node("MemorialDate").text.contains(grave["date"]))
 assert(record.get_node("FinalTrial").text == "Last trial: Bleed")
 assert(record.get_node("MemorialDeeds").text == "Survived 2 battles. Dealt 31 damage. Recovered 7 health.")
 await shot("C:/GAME/Ashen/graveyard-preview.png")
 await inspect_memorial_layouts()
 # Escape preserves the existing return behavior; records never alter memorials.
 var escape := InputEventAction.new()
 escape.action = "ui_cancel"
 escape.pressed = true
 current_scene._unhandled_input(escape)
 await settle()
 assert(current_scene.has_node("MapView/graveyard"))
 var marker: TextureRect = current_scene.get_node("MapView/graveyard/CemeteryMarker")
 assert(marker.texture.resource_path == "res://assets/generated/graveyard_ink_marker.png")
 assert(current_scene.get_node("MapView/graveyard").position == Vector2(252.5,495) and current_scene.get_node("MapView/graveyard").size == Vector2(195,170))
 await shot("C:/GAME/Ashen/settlement-graveyard-preview.png")
 current_scene._on_hotspot_hover(current_scene.get_node("MapView/graveyard"),true)
 await shot("C:/GAME/Ashen/settlement-graveyard-hover-preview.png")
 current_scene._on_building_pressed(current_scene.BUILDINGS[0])
 await settle()
 assert(current_scene.scene_file_path == "res://scenes/hub/graveyard.tscn")
 current_scene.get_node("GraveyardReturn").pressed.emit()
 await settle()
 assert(current_scene.scene_file_path == "res://scenes/hub/settlement.tscn")
 current_scene.queue_free()
 await settle()
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 print("PASS: death memorial names/class/location/date/cause/deeds, duplicate prevention, persistence, empty and long-record layouts/scrolling, illustrated settlement marker footprint and button/Escape navigation")
 quit()

func inspect_memorial_layouts() -> void:
 var historical: Array = State.graves.duplicate(true)
 State.graves.clear()
 current_scene.refresh()
 await settle()
 assert(current_scene.get_node("MemorialCount").text == "0 MEMORIALS")
 assert(current_scene.has_node("MemorialsScroll/MemorialList/EmptyMemorials"))
 await shot("C:/GAME/Ashen/graveyard-empty-preview.png")
 for index in range(6):
  State.graves.append({
   "id":"layout-preview-%d" % index,"hero":"warden",
   "name":"Sir Alden the Last Oathkeeper of the Ashen Road and Forgotten Hamlet %d" % (index+1),
   "class":"Penitent Crusader" if index%2 == 0 else "Warden",
   "dungeon":"Path of the Beast — The Procession Beneath the Cathedral of the Remade",
   "floor":3,"date":"2026-10-10",
   "cause":"Bleed from the Howling Head's final lament, beneath the remaking altar and the broken choir",
   "deeds":{"battles":127+index,"damage":123456+index,"healing":98765+index}})
 var records_before: Array = State.graves.duplicate(true)
 current_scene.refresh()
 await settle()
 var list: VBoxContainer = current_scene.get_node("MemorialsScroll/MemorialList")
 assert(list.get_child_count() == 6 and list.get_child(0).name == "Memorial_5", "Newest records stay first")
 var name_label: Label = list.get_child(0).get_node("Record/HeroName")
 assert(name_label.text == State.graves[5]["name"] and name_label.get_line_count() >= 2,"Long names wrap without losing text")
 var scroll: ScrollContainer = current_scene.get_node("MemorialsScroll")
 assert(scroll.get_v_scroll_bar().max_value > scroll.size.y,"Multiple detailed records remain scrollable")
 assert(scroll.get_h_scroll_bar().visible == false,"Memorial records fit without sideways scrolling")
 assert(State.graves == records_before,"Rendering never rewrites names, deeds or historical data")
 await shot("C:/GAME/Ashen/graveyard-long-records-preview.png")
 scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
 await settle()
 assert(scroll.scroll_vertical > 0)
 await shot("C:/GAME/Ashen/graveyard-scrolled-preview.png")
 State.graves = historical
 current_scene.refresh()
 await settle()
