extends SceneTree
## Deterministic native-rendered movement clip: idle, walk, pause, retrace, arrive.
const State = preload("res://scripts/game_data.gd")
const Travel = preload("res://scenes/expedition/hallway_travel.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var args := OS.get_cmdline_user_args()
	var directory: String = args[0]
	DirAccess.make_dir_recursive_absolute(directory)
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://quiet_walk_preview.cfg"
	State.party.assign(["warden","ranger","healer"])
	State.hero_colors.warden = "blue"
	State.select_expedition("old_road")
	State.start_run(42)
	State.add_item("warden_epic")
	State.equip_item("warden","warden_epic")
	State.room_position = Vector2i.RIGHT
	State.floors[0][Vector2i.RIGHT] = {"kind":"camp","cleared":false,"seen":true}
	var travel := Travel.new()
	travel.duration = 6.0
	travel.route_origin = Vector2i.ZERO
	travel.route_steps = [Vector2i.RIGHT]
	root.add_child(travel)
	current_scene = travel
	travel.set_process(false)
	for i in range(6): await process_frame
	for frame in range(156):
		var clock: float = frame/12.0
		if frame == 12 or frame == 84:
			travel.set_walking(false)
			travel.set_walking(true)
		if frame == 48: travel.set_walking(false)
		if frame == 72:
			travel.set_walking(false)
			travel.manual_direction = -1
			travel.manual_walking = true
		travel._process(1.0/12.0)
		await RenderingServer.frame_post_draw
		assert(root.get_texture().get_image().save_png(directory+"/frame_%04d.png" % frame) == OK)
		if frame%24 == 0: print("FRAME ",frame," · ",clock," seconds")
	print("PREVIEW_COMPLETE ",directory)
	quit()
