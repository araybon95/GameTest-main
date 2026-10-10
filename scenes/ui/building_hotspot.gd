extends Button
## Building contours avoid rectangular hover zones over neighboring structures.
var silhouette: PackedVector2Array = []
func _has_point(point: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(point, silhouette) if not silhouette.is_empty() else Rect2(Vector2.ZERO, size).has_point(point)
