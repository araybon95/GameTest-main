extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func shot(path: String) -> void:
 await process_frame
 await process_frame
 await create_timer(0.4).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func run() -> void:
 root.content_scale_size = Vector2i(1920,1080)
 root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 State.progress_loaded = true
 State.select_expedition("old_road")
 State.start_run(20)
 State.floors[0][Vector2i.ZERO] = {"kind":"battle","enemies":["ash_raider","ash_raider"],"cleared":false,"seen":true}
 change_scene_to_file("res://scenes/combat/combatscene.tscn")
 await shot("C:/GAME/Ashen/ink-combat-preview.png")
 var battle = current_scene
 battle._attack_with_equipment("warden",{"damage":1,"name":"Ink strike"})
 await create_timer(0.3).timeout
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("C:/GAME/Ashen/ink-impact-preview.png")
 await create_timer(0.7).timeout
 var travel = preload("res://scenes/expedition/hallway_travel.gd").new()
 travel.duration = 10
 battle.add_child(travel)
 await shot("C:/GAME/Ashen/ink-travel-preview.png")
 travel.finish()
 await process_frame
 battle.queue_free()
 await process_frame
 var gallery := Control.new()
 root.add_child(gallery)
 var bg := ColorRect.new()
 bg.color = Color("#100D13")
 bg.size = Vector2(1920,1080)
 gallery.add_child(bg)
 var ids: Array = State.Items.EQUIPMENT.keys()+State.Items.POTIONS.keys()+State.Items.SCROLLS.keys()+State.Items.PROVISIONS.keys()
 for index in range(ids.size()):
  var id: String = ids[index]
  var icon = preload("res://scenes/ui/item_icon_button.gd").new()
  icon.configure(id,3 if State.Items.item(id).get("kind","") in ["potion","scroll","provision"] else 1)
  icon.position = Vector2(55+(index%12)*155,55+(index/12)*195)
  icon.size = Vector2(108,108)
  gallery.add_child(icon)
  var label := Label.new()
  label.text = State.Items.item(id)["name"]
  label.position = icon.position+Vector2(0,117)
  label.size = Vector2(140,60)
  label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
  label.add_theme_font_size_override("font_size",17)
  gallery.add_child(label)
 await shot("C:/GAME/Ashen/ink-items-preview.png")
 preload("res://scripts/settlement_music.gd").stop()
 await create_timer(0.12).timeout
 quit()
