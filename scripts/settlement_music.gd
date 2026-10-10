extends RefCounted
## Root-owned player survives building changes without restarting the track.
static func player() -> AudioStreamPlayer:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null: return null
	return tree.root.get_node_or_null("SettlementMusic") as AudioStreamPlayer

static func play() -> void:
	var music := player()
	if music == null:
		var tree := Engine.get_main_loop() as SceneTree
		if tree == null: return
		music = AudioStreamPlayer.new()
		music.name = "SettlementMusic"
		music.tree_exiting.connect(music.stop)
		var stream := load("res://assets/audio/settlement_music.mp3") as AudioStreamMP3
		stream.loop = true
		music.stream = stream
		music.volume_db = -14.0
		music.bus = "Music" if AudioServer.get_bus_index("Music") >= 0 else "Master"
		tree.root.add_child(music)
	if not music.playing: music.play()

static func stop() -> void:
	var music := player()
	if music != null: music.stop()
