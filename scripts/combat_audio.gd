extends Node
## Replace the WAVs independently without changing combat code.
const SOUNDS = {
	"sword": preload("res://assets/audio/combat/sword.wav"),
	"bow": preload("res://assets/audio/combat/bow.wav"),
	"spell": preload("res://assets/audio/combat/spell.wav"),
	"block": preload("res://assets/audio/combat/block.wav"),
	"stress": preload("res://assets/audio/combat/stress.wav"),
	"virtue": preload("res://assets/audio/combat/virtue.wav")
}
var last_sound: String = ""
var voices: Array[AudioStreamPlayer] = []
func play_effect(kind: String) -> void:
	if not SOUNDS.has(kind): return
	last_sound = kind
	var player: AudioStreamPlayer
	for voice in voices:
		if not voice.playing:
			player = voice
			break
	if player == null:
		if voices.size() >= 8:
			player = voices[0]
			voices.pop_front()
			voices.append(player)
		else:
			player = AudioStreamPlayer.new()
			add_child(player)
			voices.append(player)
	player.stream = SOUNDS[kind]
	player.volume_db = -10.0
	player.bus = "Effects" if AudioServer.get_bus_index("Effects") >= 0 else "Master"
	player.play()

func _exit_tree() -> void:
	for voice in voices:
		voice.stop()
	voices.clear()
