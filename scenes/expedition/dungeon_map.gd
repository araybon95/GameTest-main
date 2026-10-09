extends Control

const State = preload("res://scripts/game_data.gd")

func room_rect(location: Vector2i) -> Rect2:
	var variation: int = posmod(location.x * 17 + location.y * 31 + State.run_seed, 3)
	var size := Vector2(150 + variation * 30, 94 + (2 - variation) * 16)
	return Rect2(Vector2(170 + location.x * 295, 95 + location.y * 150) - size * 0.5, size)

func _draw() -> void:
	var rooms: Dictionary = State.floors[State.floor_index]
	for location in rooms:
		if not rooms[location]["seen"]:
			continue
		for direction in [Vector2i.RIGHT, Vector2i.DOWN]:
			var other: Vector2i = location + direction
			if rooms.has(other) and rooms[other]["seen"]:
				var start: Vector2 = room_rect(location).get_center()
				var end: Vector2 = room_rect(other).get_center()
				draw_line(start, end, Color("#151316"), 38)
				draw_line(start, end, Color("#504743"), 27)
				var length: float = start.distance_to(end)
				for step in range(0, int(length), 22):
					var point := start.lerp(end, float(step) / length)
					var cross := Vector2(0, 12) if direction == Vector2i.RIGHT else Vector2(12, 0)
					draw_line(point - cross, point + cross, Color("#312C2C"), 1)
	for location in rooms:
		var room: Dictionary = rooms[location]
		if not room["seen"]:
			continue
		var rect: Rect2 = room_rect(location)
		var current: bool = location == State.room_position
		var fill := Color("#62564A") if current else (Color("#403936") if room["cleared"] else Color("#292529"))
		draw_rect(rect, fill)
		for x in range(int(rect.position.x), int(rect.end.x), 24):
			for y in range(int(rect.position.y), int(rect.end.y), 22):
				var tile := Rect2(Vector2(x, y), Vector2(mini(23, int(rect.end.x) - x), mini(21, int(rect.end.y) - y)))
				draw_rect(tile, Color(0.1, 0.07, 0.09, 0.25), false, 1)
		draw_rect(rect, Color("#D3AF72") if current else Color("#171417"), false, 3)
		var center: Vector2 = rect.get_center()
		var tint := Color("#B7736B") if not room["cleared"] else Color("#8F8271")
		match str(room["kind"]):
			"battle", "boss":
				for sign_value in [-1, 1]:
					var axis := Vector2(16 * sign_value, -18)
					draw_line(center - axis, center + axis, tint, 4)
					var grip := center - axis * 0.6
					draw_line(grip + Vector2(-7, -6 * sign_value), grip + Vector2(7, 6 * sign_value), tint, 3)
				if room["kind"] == "boss":
					draw_circle(center, 29, Color("#C5A363"), false, 2)
			"treasure":
				draw_rect(Rect2(center - Vector2(19, 13), Vector2(38, 26)), Color("#A7864F"), false, 3)
				draw_line(center + Vector2(-19, -3), center + Vector2(19, -3), tint, 3)
				draw_rect(Rect2(center - Vector2(3, 4), Vector2(6, 10)), tint)
			"camp":
				draw_colored_polygon(PackedVector2Array([center + Vector2(-18, 16), center + Vector2(0, -22), center + Vector2(18, 16)]), Color("#B0784E"))
				draw_line(center + Vector2(-23, 21), center + Vector2(23, 21), tint, 4)
			"stairs":
				for step in range(4):
					draw_rect(Rect2(center + Vector2(-22 + step * 11, -20 + step * 11), Vector2(13, 9)), tint)
			"entry":
				draw_circle(center, 20, tint, false, 3)
		if room.get("merchant_orb", false):
			var orb := center + Vector2(48, 0)
			draw_circle(orb, 15, Color(0.2, 0.65, 0.85, 0.15))
			draw_circle(orb, 10, Color("#598FA9"), false, 2)
			draw_circle(orb, 5, Color("#B2E1EF") if room["cleared"] else Color("#406575"))
		if current:
			var marker := center + Vector2(0, -rect.size.y * 0.5 - 14)
			draw_colored_polygon(PackedVector2Array([marker + Vector2(-10, -8), marker + Vector2(10, -8), marker + Vector2(0, 8)]), Color("#D9BC7F"))
