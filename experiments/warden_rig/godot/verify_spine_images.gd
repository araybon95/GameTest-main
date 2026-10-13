extends SceneTree
## Compare raw source pixels, including RGB underneath transparent pixels.
func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1: quit(2); return
	var manifest = JSON.parse_string(FileAccess.get_file_as_string(args[0]+"/attachments.json"))
	var failures := 0
	for entry in manifest.images:
		var source_path: String = ProjectSettings.globalize_path("res://assets/"+entry.source_file)
		var output_path: String = args[0]+"/images/"+entry.path+".png"
		var rect := Rect2i(int(entry.source_region[0]),int(entry.source_region[1]),int(entry.source_region[2]),int(entry.source_region[3]))
		var expected := Image.load_from_file(source_path).get_region(rect)
		var actual := Image.load_from_file(output_path)
		expected.convert(Image.FORMAT_RGBA8)
		actual.convert(Image.FORMAT_RGBA8)
		if expected.get_size() != actual.get_size() or expected.get_data() != actual.get_data():
			push_error("Source pixels changed: "+entry.path)
			failures += 1
		if FileAccess.get_sha256(source_path) != entry.source_sha256 or FileAccess.get_sha256(output_path) != entry.sha256:
			push_error("Provenance hash mismatch: "+entry.path)
			failures += 1
	if failures == 0: print("SPINE_IMAGES_OK: 24 raw PNG regions and provenance verified")
	quit(0 if failures == 0 else 1)
