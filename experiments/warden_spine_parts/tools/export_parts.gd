extends SceneTree
func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	assert(args.size() == 1,"Pass the absolute handoff directory")
	var directory := args[0]
	var manifest = JSON.parse_string(FileAccess.get_file_as_string(directory+"/parts.json"))
	var sheet := Image.load_from_file(directory+"/source/warden_parts.png")
	assert(sheet != null and sheet.get_format() == Image.FORMAT_RGBA8)
	for part in manifest.parts:
		var r: Array = part.source_region
		var region := Rect2i(int(r[0]),int(r[1]),int(r[2]),int(r[3]))
		assert(Rect2i(Vector2i.ZERO,sheet.get_size()).encloses(region))
		var image := Image.create(region.size.x,region.size.y,false,Image.FORMAT_RGBA8)
		image.fill(Color(0,0,0,0))
		for span in part.source_spans:
			for x in range(int(span[1]),int(span[2])):
				image.set_pixel(x,int(span[0]),sheet.get_pixel(region.position.x+x,region.position.y+int(span[0])))
		var filename: String = directory+"/images/"+part.name+".png"
		assert(image.save_png(filename) == OK)
		var exported := Image.load_from_file(filename)
		assert(exported.get_data() == image.get_data(),"Export changed source pixels: "+part.name)
		part["sha256"] = FileAccess.get_sha256(filename)
	var file := FileAccess.open(directory+"/parts.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(manifest,"\t")+"\n")
	print("WARDEN_PARTS_EXPORT_OK: 20 lossless RGBA region exports")
	quit()
