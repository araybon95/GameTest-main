extends RefCounted
## Test-only teardown: wait for the audio thread, not an arbitrary frame count.
static func players_below(node: Node, players: Array[AudioStreamPlayer]) -> void:
 if node is AudioStreamPlayer: players.append(node)
 for child in node.get_children(): players_below(child,players)

static func finish(tree: SceneTree, fixtures: Array[Node]) -> bool:
 var players: Array[AudioStreamPlayer] = []
 players_below(tree.root,players)
 var playbacks: Array[WeakRef] = []
 for player in players:
  if player.has_stream_playback(): playbacks.append(weakref(player.get_stream_playback()))
  player.stop()
 for fixture in fixtures:
  if is_instance_valid(fixture): fixture.queue_free()
 players.clear()
 # Process queued frees even when there were no active audio voices.
 await tree.process_frame
 await tree.process_frame
 var deadline: int = Time.get_ticks_msec()+2000
 while playbacks.any(func(reference): return reference.get_ref() != null):
  if Time.get_ticks_msec() >= deadline:
   push_error("Audio playback resources did not release within the teardown deadline")
   return false
  await tree.create_timer(0.01).timeout
 return true
