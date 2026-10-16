extends SceneTree
const Cleanup = preload("res://tests/support/audio_cleanup.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var owner := Node.new()
 root.add_child(owner)
 var player := AudioStreamPlayer.new()
 player.stream = load("res://assets/audio/combat/sword.wav")
 owner.add_child(player)
 var retired: Array[WeakRef] = []
 for index in range(20):
  player.play()
  retired.append(weakref(player.get_stream_playback()))
  player.stop()
 var released: bool = await Cleanup.finish(self,[owner])
 var count: int = retired.filter(func(reference): return reference.get_ref() != null).size()
 print("RETIRED remaining=",count)
 if not released or count != 0:
  print("FAIL: cleanup must also drain voices stopped before teardown")
  quit(1)
  return
 print("PASS: stopped/replaced audio playbacks release before shutdown")
 quit()
