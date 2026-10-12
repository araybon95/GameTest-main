extends RefCounted
## Cosmetic hall data is independent of campaign checkpoints and gameplay RNG.
const PATH = "user://guild_hall.cfg"
const VERSION: int = 1
const DEFAULTS = {"name":"The Ashen Fellowship", "banner":"wine", "emblem":"lantern", "lighting":"hearth", "furnishing":"tavern", "pinned_expedition":"old_road"}
const CHOICES = {"banner":["wine","forest","slate","ochre"], "emblem":["lantern","blades","star"], "lighting":["hearth","moonlit","candlelit"], "furnishing":["tavern","armory","archive"]}
static func clean(source: Dictionary) -> Dictionary:
	var result: Dictionary = DEFAULTS.duplicate(true)
	var title: Variant = source.get("name",DEFAULTS.name)
	if title is String:
		var safe: String = title.strip_edges().replace("\n"," ").replace("\r"," ").replace("\t"," ").substr(0,32)
		if not safe.is_empty(): result.name = safe
	for key in CHOICES:
		if source.get(key) in CHOICES[key]: result[key] = source[key]
	var expedition: Variant = source.get("pinned_expedition",DEFAULTS.pinned_expedition)
	if expedition is String and not preload("res://scripts/game_data.gd").expedition_by_id(expedition).is_empty(): result.pinned_expedition = expedition
	return result
static func read_profile(path: String = PATH) -> Dictionary:
	var cfg := ConfigFile.new()
	if cfg.load(path) != OK or cfg.get_value("hall","version",0) != VERSION: return DEFAULTS.duplicate(true)
	var data: Variant = cfg.get_value("hall","profile",{})
	return clean(data) if data is Dictionary else DEFAULTS.duplicate(true)
static func write_profile(source: Dictionary, path: String = PATH) -> Error:
	# Do not overwrite a future-version or unreadable profile.
	if FileAccess.file_exists(path):
		var old := ConfigFile.new()
		var loaded: Error = old.load(path)
		if loaded != OK: return loaded
		if old.get_value("hall","version",0) != VERSION: return ERR_FILE_UNRECOGNIZED
	var cfg := ConfigFile.new()
	cfg.set_value("hall","version",VERSION)
	cfg.set_value("hall","profile",clean(source))
	var staging: String = path+".tmp"
	var saved: Error = cfg.save(staging)
	if saved != OK: return saved
	var replaced: Error = DirAccess.rename_absolute(staging,path)
	if replaced != OK: DirAccess.remove_absolute(staging)
	return replaced
