extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
 var visual = load("res://scripts/weapon_visuals.gd")
 var manifest = load("res://assets/art_library/weapons/manifest.gd")
 # Hits refresh an entry, so frames in use survive while new ones are composed.
 var store: Dictionary = {}
 for i in range(4): visual._remember(store,i,i,4)
 assert(visual._recall(store,0) == 0)
 visual._remember(store,4,4,4)
 assert(store.has(0) and not store.has(1) and store.size() == 4,"The least recently used entry is evicted first")
 # Every starter pose, the ten-frame Warden walk and its execution fit together.
 visual.clear_cache()
 var used: Array[Texture2D] = []
 for hero in manifest.STARTERS:
  for pose in manifest.POSES: used.append(visual.runtime_frame(hero,"original",pose,manifest.STARTERS[hero]))
 for i in range(4,10): used.append(visual.runtime_frame("warden","original","walk_"+str(i),"warden_sword"))
 for phase in ["execution_0","execution_1","execution_2","execution_3","execution_4","execution_contact"]: used.append(visual.runtime_frame("warden","original",phase,"warden_sword"))
 assert(not used.has(null) and used.size() <= visual.MAX_RUNTIME)
 # A preview of every other weapon must not push the party's frames out.
 for hero in manifest.STARTERS:
  for id in visual.Items.EQUIPMENT:
   if visual.Items.EQUIPMENT[id].get("hero","") == hero and visual.Items.EQUIPMENT[id].get("slot","") == "weapon" and id != manifest.STARTERS[hero]:
    visual.runtime_frame(hero,"original","idle",id)
 assert(visual.runtime_frame("warden","original","idle","warden_sword") == used[0],"A frame in use is not recomposed after previews")
 assert(visual.cache.size() <= visual.MAX_COMPOSITES)
 print("PASS: weapon frame caches keep frames in use and fit a full party")
 quit()
