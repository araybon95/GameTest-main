extends SceneTree
const State = preload("res://scripts/game_data.gd")
const ItemButton = preload("res://scenes/ui/item_icon_button.gd")
const GEAR: Array[String] = ["outlaw_tally","warden_gravewatch","occultist_severed_litany","ranger_chitin_lens","roadward_seal","graveward_locket","crusader_penitent_stitch","healer_chrysalis_rosary"]

func _initialize() -> void: call_deferred("run")

func shot(path: String) -> void:
	await create_timer(0.20).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)

func run() -> void:
	root.content_scale_size = Vector2i(1920,1080)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	State.progress_loaded = true
	State.progress_path = "user://creature_matchups_preview.cfg"
	State.discovered.clear()
	for id in ["gallows_scout","keep_footman","anguish_vessel","moth_metamorph"]: State.discover_creature(id)
	var book = load("res://scenes/hub/bestiary.tscn").instantiate()
	root.add_child(book)
	await process_frame
	for entry in [["old_road",1,"human"],["old_road",3,"corrupted"],["path_beast",1,"remade"],["infested_apothecary",0,"insect"],["path_beast",2,"unknown"]]:
		book.open_volume(entry[0])
		book.turn_page(entry[1])
		await shot("C:/GAME/Ashen/matchups-book-%s.png" % entry[2])
	State.discover_creature("harrowed_giant")
	book.turn_page(2)
	await shot("C:/GAME/Ashen/matchups-book-giant-objective.png")
	(book.book_view.get_node("CreatureNotes") as RichTextLabel).scroll_to_line(3)
	await shot("C:/GAME/Ashen/matchups-book-giant-objective-scrolled.png")
	book.queue_free()
	await process_frame
	if not OS.get_cmdline_user_args().has("--books-only"):
		State.select_expedition("old_road")
		State.start_run(37)
		State.gold = 500
		var shop = load("res://scenes/hub/item_shop.tscn").instantiate()
		shop.category = "Trinkets"
		root.add_child(shop)
		await shot("C:/GAME/Ashen/matchups-shop.png")
		for child in shop.get_children():
			if child is ScrollContainer: child.scroll_vertical = 680
		await shot("C:/GAME/Ashen/matchups-shop-epic.png")
		shop.queue_free()
		await process_frame
		var gallery := Control.new()
		root.add_child(gallery)
		var backdrop := ColorRect.new()
		backdrop.color = Color("#151118")
		backdrop.size = Vector2(1920,1080)
		gallery.add_child(backdrop)
		for index in GEAR.size():
			var origin := Vector2(170+(index%4)*425,100+(index/4)*480)
			var icon := ItemButton.new()
			icon.configure(GEAR[index])
			icon.position = origin
			icon.size = Vector2(160,160)
			gallery.add_child(icon)
			var caption := Label.new()
			caption.position = origin+Vector2(-70,185)
			caption.size = Vector2(340,190)
			caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			caption.text = State.Items.item(GEAR[index])["name"]+"\n\n"+State.Items.description(GEAR[index])
			caption.add_theme_font_size_override("font_size",22)
			gallery.add_child(caption)
		await shot("C:/GAME/Ashen/matchups-icons.png")
		gallery.queue_free()
		await process_frame
	preload("res://scripts/settlement_music.gd").stop()
	await create_timer(0.12).timeout
	quit()
