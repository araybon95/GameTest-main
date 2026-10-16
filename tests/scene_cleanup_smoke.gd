extends SceneTree
## Observe resource lifetime without suppressing the engine's normal logger.
const State = preload("res://scripts/game_data.gd")
var failures: Array[String] = []
class FontErrors extends Logger:
 var count: int = 0
 func _log_error(_function: String, _file: String, _line: int, code: String, _rationale: String, _editor_notify: bool, _error_type: int, _script_backtraces: Array[ScriptBacktrace]) -> void:
  if code.contains('Parameter "fd"'): count += 1
func _initialize() -> void: call_deferred("run")
func check(value: bool, message: String) -> void:
 if not value: failures.append(message)
func battle_lifetime(kind: String) -> void:
 State.select_expedition("old_road")
 State.start_run(516)
 State.floors[0][Vector2i.ZERO] = {"kind":"boss","creature":"undying_lord","seen":true,"cleared":false} if kind == "boss" else {"kind":"battle","enemies":["ash_raider"],"seen":true,"cleared":false}
 var battle = load("res://scenes/combat/combatscene.tscn").instantiate()
 root.add_child(battle)
 var material: WeakRef = weakref(battle.get_node("StageFooterShade").material)
 var node: WeakRef = weakref(battle)
 if kind == "skill": battle._reveal_skill(battle.hand_container.get_child(0))
 battle.free()
 for frame in range(3): await process_frame
 check(material.get_ref() == null,kind+": freed scene releases layout shader material")
 check(node.get_ref() == null,kind+": pending layout/reveal cannot retain the scene")
func run() -> void:
 State.progress_loaded = true
 State.progress_path = "user://scene-cleanup-progress.cfg"
 var errors := FontErrors.new()
 OS.add_logger(errors)
 State.map_travel_mode = false
 State.select_expedition("old_road")
 State.start_run(516)
 State.floors[0][Vector2i.ZERO] = {"kind":"event","event_id":"bandit_strongbox","seen":true,"cleared":false,"event_result":{}}
 var scope = load("res://scenes/expedition/event_room.tscn").instantiate()
 root.add_child(scope)
 scope.refresh()
 OS.remove_logger(errors)
 check(errors.count == 0,"Replacing heading fonts must not query freed font data")
 scope.free()
 for kind in ["ordinary","boss","skill"]: await battle_lifetime(kind)
 if failures.is_empty(): print("PASS: heading replacement retains valid font data; freed ordinary/boss/skill scenes release pending layout resources")
 else:
  for message in failures: print("FAIL: ",message)
 quit(0 if failures.is_empty() else 1)
