extends SceneTree
const Visual = preload("res://scripts/visual_overlays.gd")
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var rng := State.loot_rng.state
 var host := Control.new()
 root.add_child(host)
 var detached := Button.new()
 Visual.frame(detached,"crusader")
 assert(detached.get_node("IronFittings").hero_id == "crusader")
 host.add_child(detached)
 for id in State.HEROES:
  var card := Button.new()
  card.size = Vector2(245,300)
  host.add_child(card)
  Visual.frame(card,id)
  Visual.frame(card,id)
  var trim = card.get_node("IronFittings")
  assert(card.get_child_count() == 1 and trim.hero_id == id)
  assert(trim.mouse_filter == Control.MOUSE_FILTER_IGNORE)
  assert(trim.class_color(id) != trim.class_color("unknown"))
  card.disabled = true
  trim.queue_redraw()
 var screen = load("res://scenes/expedition/region_select.tscn").instantiate()
 State.progress_loaded = true
 root.add_child(screen)
 await process_frame
 assert(screen.get_node("Expedition_village/IronFittings").visible == false)
 assert(screen.get_node("Expedition_path/IronFittings").visible == false)
 assert(screen.get_node("Dungeon_old_road/IronFittings").hero_id == "warden")
 screen.choose_region(1)
 await process_frame
 assert(screen.get_node("Dungeon_path_beast/IronFittings").hero_id == "occultist")
 assert(not screen.get_node("EmbarkButton").disabled)
 screen.choose(1,1)
 await process_frame
 assert(screen.get_node("EmbarkButton").disabled)
 assert(screen.get_node("StageEdgeOverlay").mouse_filter == Control.MOUSE_FILTER_IGNORE)
 assert(State.loot_rng.state == rng)
 print("PASS: five class borders, stable repeated decoration, input-transparent map overlay and unchanged dungeon locks/RNG")
 quit()
