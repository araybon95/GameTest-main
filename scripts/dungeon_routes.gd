extends RefCounted
## Routes may cross cleared rooms only; a new encounter is always the final step.
static func find(rooms: Dictionary, start: Vector2i, target: Vector2i) -> Array:
	if not rooms.has(start) or not rooms.has(target) or start == target or not rooms[start].get("cleared", false): return []
	var queue: Array = [start]
	var previous: Dictionary = {start: start}
	while not queue.is_empty():
		var position: Vector2i = queue.pop_front()
		for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var next: Vector2i = position + direction
			if not rooms.has(next) or previous.has(next) or not rooms[next].get("seen", false): continue
			if next != target and not rooms[next].get("cleared", false): continue
			previous[next] = position
			if next == target:
				var route: Array = []
				var cursor: Vector2i = target
				while cursor != start:
					route.push_front(cursor)
					cursor = previous[cursor]
				return route
			queue.append(next)
	return []
