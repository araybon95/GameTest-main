extends SceneTree
const State = preload("res://scripts/game_data.gd")
func _initialize() -> void: call_deferred("run")
func settle() -> void:
 for frame in range(3): await process_frame
func click(point: Vector2) -> void:
 var motion := InputEventMouseMotion.new()
 motion.position = point
 root.push_input(motion,true)
 for down in [true,false]:
  var event := InputEventMouseButton.new()
  event.button_index = MOUSE_BUTTON_LEFT
  event.position = point
  event.global_position = point
  event.pressed = down
  root.push_input(event,true)
  await process_frame
 await settle()
func run() -> void:
 root.size = Vector2i(1920,1080)
 root.content_scale_size = root.size
 State.progress_loaded = true
 State.party.assign(["warden","ranger","occultist"])
 State.gold = 99
 var rng: int = State.loot_rng.state
 var screen = load("res://scenes/expedition/region_select.tscn").instantiate()
 root.add_child(screen)
 current_scene = screen
 await create_timer(0.5).timeout
 var dossier: Control = screen.get_node("DungeonDossier")
 assert(not dossier.route_open and not dossier.get_node("FloorSummary_0").visible)
 assert(not dossier.get_node("EntrancePlate").visible,"The estate layout prioritizes mission text over a second map image")
 await click(dossier.get_node("RouteToggle").get_global_rect().get_center())
 assert(dossier.route_open and dossier.get_node("FloorSummary_2").visible)
 await click(dossier.get_node("RouteToggle").get_global_rect().get_center())
 assert(not dossier.route_open)
 await click(screen.get_node("PartyHero_ranger").get_global_rect().get_center())
 var controls = root.get_node("GameControls")
 assert(controls.hero_sheet != null and controls.current_hero == "ranger")
 controls.close_hero_sheet()
 screen.choose_region(1)
 await settle()
 assert(not screen.get_node("EmbarkButton").disabled)
 assert(not screen.get_node("Dungeon_path_lament/IronFittings").visible)
 assert(screen.get_node("Dungeon_path_beast").size.is_equal_approx(Vector2(84,84)))
 screen.choose(1,1)
 await settle()
 assert(screen.get_node("EmbarkButton").disabled)
 screen.get_node("FutureExpedition_0").pressed.emit()
 assert(screen.has_node("FutureNotice"))
 assert(State.gold == 99 and State.loot_rng.state == rng)
 print("PASS: native route toggle, party inspection, compact choices, region selection, future locks and unchanged gold/RNG")
 quit()
