extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 State.progress_loaded = true
 var chapel_count: int = 0
 for building in preload("res://scenes/hub/settlement.gd").BUILDINGS:
  if building.get("scene", "") == "res://scenes/hub/bestiary.tscn": chapel_count += 1
 assert(chapel_count == 1)
 var book = load("res://scenes/hub/bestiary.tscn").instantiate()
 root.add_child(book)
 await process_frame
 assert(book.entries().size() == 8 and book.page == -1)
 for expedition in State.EXPEDITIONS:
  book.open_volume(expedition["id"])
  for id in book.entries():
   assert(State.CREATURES.has(id) and not State.creature(id).get("lore", "").is_empty())
  book.turn_page(999)
  assert(book.page == book.entries().size()-1)
 State.discovered.append("undying_lord")
 book.open_volume("old_road")
 book.turn_page(7)
 await process_frame
 if not DisplayServer.get_name() == "headless":
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("C:/GAME/Ashen/bestiary-book.png")
 book.open_volume("path_beast")
 await process_frame
 if not DisplayServer.get_name() == "headless":
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("C:/GAME/Ashen/bestiary-contents.png")
 print("PASS: single chapel, dungeon volumes, lore coverage, unknown pages and navigation bounds")
 quit()
