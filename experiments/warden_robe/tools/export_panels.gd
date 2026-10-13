extends SceneTree
func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	assert(args.size() == 1)
	var directory: String = args[0]
	var manifest = JSON.parse_string(FileAccess.get_file_as_string(directory+"/parts.json"))
	var source := Image.load_from_file(directory+"/source/robe_panels.png")
	for part in manifest.parts:
		if not part.name.begins_with("robe_"): continue
		var r: Array = part.source_region
		var image := source.get_region(Rect2i(int(r[0]),int(r[1]),int(r[2]),int(r[3])))
		var file: String = directory+"/images/"+part.name+".png"
		assert(image.save_png(file) == OK)
		part["sha256"] = FileAccess.get_sha256(file)
	FileAccess.open(directory+"/parts.json",FileAccess.WRITE).store_string(JSON.stringify(manifest,"\t")+"\n")
	print("WARDEN_ROBE_EXPORT_OK: 2 lossless transparent panels")
	quit()
