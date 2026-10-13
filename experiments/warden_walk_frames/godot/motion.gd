extends RefCounted
static var frames: Array = []
static var tweens: Array = []
static func frame(index: int) -> Dictionary:
	if frames.is_empty():
		var data = JSON.parse_string(FileAccess.get_file_as_string("res://poses.json"))
		var atlas_size := preload("res://assets/hero_warden_walk.png").get_size()
		for source in data.frames:
			var scale_value: float = 280.0/source.region[3]
			var item := {"size":Vector2(source.region[2],source.region[3])*scale_value,"hand":([Vector2(270,265),Vector2(228,280),Vector2(408,259),Vector2(220,265)][frames.size()]-Vector2(source.region[2]*0.5,source.region[3]))*scale_value,"region_uv":Vector4(source.region[0]/atlas_size.x,source.region[1]/atlas_size.y,source.region[2]/atlas_size.x,source.region[3]/atlas_size.y)}
			for key in ["near_mask","far_mask","gear_mask","shaft_mask"]:
				var points := PackedVector2Array()
				for p in source[key]: points.append((Vector2(p[0],p[1])-Vector2(source.region[2]*0.5,source.region[3]))*scale_value)
				if key in ["near_mask","far_mask"]:
					var outlines = Geometry2D.offset_polygon(points,8.0,Geometry2D.JOIN_MITER)
					if not outlines.is_empty(): points = outlines[0]
				assert(points.size() <= 32)
				item[key] = points
			frames.append(item)
	return frames[index%4]
static func padded(points: PackedVector2Array) -> PackedVector2Array:
	var result := points.duplicate()
	result.resize(32)
	return result
static func tween(index: int) -> Dictionary:
	if tweens.is_empty():
		var data = JSON.parse_string(FileAccess.get_file_as_string("res://tweens.json"))
		var atlas_size := preload("res://assets/warden_leg_inbetweens_clean.png").get_size()
		for source in data.frames:
			tweens.append({"size":Vector2(source.display_size[0],source.display_size[1]),"origin":Vector2(source.origin[0],source.origin[1]),"region_uv":Vector4(source.region[0]/atlas_size.x,source.region[1]/atlas_size.y,source.region[2]/atlas_size.x,source.region[3]/atlas_size.y)})
	return tweens[index%12]
