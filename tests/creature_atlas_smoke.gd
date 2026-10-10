extends SceneTree
## Generated atlas regression: production resource routing and measured alpha geometry.
const State = preload("res://scripts/game_data.gd")
const Ink = preload("res://scripts/ink_sprite_regions.gd")
const Poses = preload("res://scripts/combat_poses.gd")
const CREATURES = ["keep_footman", "keep_crossbow", "keep_wolfguard", "keep_son", "undying_lord", "anguish_penitent", "anguish_vessel", "harrowed_giant", "coterie_seamkeeper", "coterie_cantor", "coterie_matron", "howling_head", "moth_metamorph", "moth_oleander", "moth_exuvia", "hollow_villager", "bone_rabble"]

func _initialize() -> void:
	call_deferred("run")

func measured_region(image: Image, pixels: PackedByteArray, cell: Rect2i) -> Rect2i:
	var first: Vector2i = cell.end
	var last: Vector2i = Vector2i(-1, -1)
	for y in range(cell.position.y, cell.end.y):
		var alpha_index: int = (y * image.get_width() + cell.position.x) * 4 + 3
		for x in range(cell.position.x, cell.end.x):
			if pixels[alpha_index] >= 48:
				first.x = mini(first.x, x)
				first.y = mini(first.y, y)
				last.x = maxi(last.x, x)
				last.y = maxi(last.y, y)
			alpha_index += 4
	assert(last.x >= first.x and last.y >= first.y, "Every pose cell contains a figure")
	var start: Vector2i = Vector2i(maxi(cell.position.x, first.x - 3), maxi(cell.position.y, first.y - 3))
	var end: Vector2i = Vector2i(mini(cell.end.x, last.x + 4), mini(cell.end.y, last.y + 4))
	return Rect2i(start, end - start)

func run() -> void:
	State.progress_loaded = true
	Poses.cache.clear()
	var provenance: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/creature_art_provenance.json"))
	assert(provenance["assets"].size() == CREATURES.size())
	var seen: Array[String] = []
	var total_poses: int = 0
	for entry in provenance["assets"]:
		var id: String = entry["creature_id"]
		assert(CREATURES.has(id) and not seen.has(id))
		seen.append(id)
		var count: int = 4 if entry["boss"] else 3
		assert(Ink.COMBAT[id].size() == count and entry["regions"].size() == count)
		assert(Ink.SHEETS[id] == entry["sheet"] and State.creature(id)["art"] == entry["idle"])
		assert(entry["alpha_threshold"] == 48 and entry["margin_pixels"] == 3)
		assert(not str(entry["prompt"]).is_empty())
		assert(ResourceLoader.exists("res://assets/generated/" + entry["original"]), "Original artwork remains replaceable")
		assert(FileAccess.get_sha256(entry["sheet"]) == entry["sheet_sha256"])
		assert(entry["sheet_sha256"] == entry["source_sha256"], "PNG is a byte-for-byte generated source copy")
		var idle: AtlasTexture = load(entry["idle"])
		assert(idle != null and idle.get_meta("pose_id") == id and idle.filter_clip)
		assert(idle.atlas.resource_path == Ink.SHEETS[id])
		assert(idle.region == Ink.COMBAT[id][0] and idle.get_meta("idle_pixel_height") == idle.region.size.y)
		assert(Poses.state_pose(idle, "idle") == idle)
		var states: Dictionary = {"attack": 1, "hurt": 2, "guard": 0, "cast": 3 if count == 4 else 1, "roar": 3 if count == 4 else 0, "reveal": 3 if count == 4 else 0}
		for state in states:
			var pose: AtlasTexture = Poses.state_pose(idle, state)
			assert(pose != null and pose.region == Ink.COMBAT[id][states[state]])
			assert(pose.filter_clip and pose.get_meta("pose_id") == id)
			assert(pose.get_meta("idle_pixel_height") == idle.region.size.y)
			assert(Poses.state_pose(idle, state) == pose, "Pose cache is stable")
		var image: Image = idle.atlas.get_image()
		assert(not image.is_empty() and image.get_format() == Image.FORMAT_RGBA8)
		var pixels: PackedByteArray = image.get_data()
		var full: Rect2i = Rect2i(Vector2i.ZERO, image.get_size())
		var cell_area: int = 0
		var cells: Array[Rect2i] = []
		var regions: Array[Rect2i] = []
		for index in range(count):
			var values: Array = entry["cells"][index]
			var cell := Rect2i(int(values[0]), int(values[1]), int(values[2]), int(values[3]))
			var region := Rect2i(Ink.COMBAT[id][index])
			assert(full.encloses(cell) and cell.encloses(region))
			for previous in cells:
				assert(not previous.intersects(cell), "Pose cells do not overlap")
			for previous in regions:
				assert(not previous.intersects(region), "Sprite crops cannot sample another pose")
			assert(region == measured_region(image, pixels, cell), "Tight alpha-48 bounds plus three pixels preserve each complete figure")
			cells.append(cell)
			regions.append(region)
			cell_area += cell.size.x * cell.size.y
		assert(cell_area == full.size.x * full.size.y, "Cells cover the full sheet; no opaque figure pixels are omitted")
		total_poses += count
	assert(seen.size() == CREATURES.size() and total_poses == 60)
	print("PASS: 17 independently replaceable creature atlases, 60 measured poses, boss roars, metadata routing, exact PNG provenance and alpha-48 coverage without interpose sampling")
	quit()
