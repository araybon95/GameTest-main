extends RefCounted
## Each independently replaceable image contains an attack and a hurt pose.
const POSES = {
 "hero_warden.png":"warden", "hero_ranger.png":"ranger", "hero_occultist.png":"occultist",
 "hero_healer.png":"healer", "hero_crusader.tres":"crusader",
 "enemy_ash_raider.png":"raider", "enemy_gallows_scout.png":"scout", "enemy_ash_bandit_captain.png":"captain",
 "enemy_keep_footman.tres":"footman", "enemy_keep_crossbow.tres":"crossbow", "enemy_keep_wolfguard.tres":"wolfguard",
 "enemy_keep_son.png":"son", "enemy_undying_lord.png":"lord", "enemy_anguish_penitent.png":"penitent",
 "enemy_anguish_vessel.png":"vessel", "enemy_harrowed_giant.png":"giant", "enemy_coterie_seamkeeper.png":"seamkeeper",
 "enemy_hollow_villager.png":"villager", "enemy_bone_rabble.png":"skeleton"
}
static var cache: Dictionary = {}
const Regions = preload("res://scripts/combat_pose_regions.gd")
static func pose(original: Texture2D, hurt: bool = false) -> Texture2D:
 if original == null: return null
 var key: String = original.resource_path.get_file()
 if not POSES.has(key): return original
 var pose_key: String = key + ("/hurt" if hurt else "/attack")
 if cache.has(pose_key): return cache[pose_key]
 var id: String = POSES[key]
 var path: String = "res://assets/generated/combat_pose_%s.png" % id
 if not ResourceLoader.exists(path): return original
 var sheet: Texture2D = load(path)
 var split: int = int(sheet.get_width()*float(Regions.SPLITS.get(id,0.5)))
 var region := Rect2i(Vector2i(split if hurt else 0,0),Vector2i(sheet.get_width()-split if hurt else split,sheet.get_height()))
 var bounds: Rect2i = sheet.get_image().get_region(region).get_used_rect()
 if bounds.size.x == 0 or bounds.size.y == 0: return original
 var texture := AtlasTexture.new()
 texture.atlas = sheet
 texture.region = Rect2(region.position + bounds.position,bounds.size)
 texture.filter_clip = true
 cache[pose_key] = texture
 return texture
