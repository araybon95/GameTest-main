extends RefCounted
## Cosmetic identity and factual memories. Never consumes encounter or loot RNG.
const VOICES = {
 "warden":[{"name":"Quiet guardian","camp":"Sleep. I will hear anything that comes near the fire.","loss":"I promised to bring you home. I will carry your name instead."},{"name":"Weary oathkeeper","camp":"One more road. Then we find somewhere worth staying.","loss":"There was supposed to be a place for you at the end of this road."}],
 "ranger":[{"name":"Patient wanderer","camp":"I kept enough food for the way home. I always do.","loss":"You always walked where I could see you. The road feels wrong now."},{"name":"Homesick scout","camp":"There is a hill at home where nothing can follow you.","loss":"I wanted to show you that hill. I should have told you."}],
 "occultist":[{"name":"Sardonic scholar","camp":"If anything whispers from the dark, tell it we are full.","loss":"I know a hundred names for the dead. None of them should be yours."},{"name":"Gentle heretic","camp":"The fire asks nothing of us. That is a rare kindness.","loss":"No bargain. No incantation. Just an empty place beside the fire."}],
 "healer":[{"name":"Stubborn caregiver","camp":"You can complain about the bandages when we get home.","loss":"I still have the bandages I set aside for you."},{"name":"Soft-spoken pilgrim","camp":"You do not have to earn a little kindness tonight.","loss":"You deserved another morning. I will remember that."}],
 "crusader":[{"name":"Penitent sentinel","camp":"The pain is quieter when I can hear you breathing.","loss":"You called me a person when I had forgotten. I will not forget you."},{"name":"Scarred companion","camp":"Let the iron complain. Tonight we are more than our wounds.","loss":"These barbs were easier to bear while you were beside me."}]
}
static func ensure(state, id: String) -> Dictionary:
 if state.hero_journals.has(id): return state.hero_journals[id]
 if state.run_heroes.get(id,{}).get("dead",false):
  for index in range(state.graves.size()-1,-1,-1):
   if state.graves[index].get("hero","") == id: return state.graves[index].get("story",{})
 var generation: int = state.graves.filter(func(grave): return grave.get("hero","") == id).size()
 var voices: Array = VOICES.get(id,VOICES.warden)
 var entry := {"voice":generation%voices.size(),"generation":generation,"memories":[],"keys":[],"ties":{}}
 state.hero_journals[id] = entry
 return entry
static func personality(state, id: String) -> Dictionary:
 var journal: Dictionary = ensure(state,id)
 var voices: Array = VOICES.get(id,VOICES.warden)
 return voices[int(journal.get("voice",0))%voices.size()]
static func remember(state, id: String, key: String, text: String) -> void:
 if state.run_heroes.get(id,{}).get("dead",false): return
 var journal: Dictionary = ensure(state,id)
 if journal.keys.has(key): return
 journal.keys.append(key)
 journal.memories.append(text)
 if journal.memories.size() > 12: journal.memories.pop_front()
static func aid(state, source: String, target: String, saved: bool = false, warded: bool = false) -> void:
 if source == target or source.is_empty() or not state.party.has(source) or not state.party.has(target): return
 var first: Dictionary = ensure(state,source)
 var second: Dictionary = ensure(state,target)
 first.ties[target] = mini(9,int(first.ties.get(target,0))+1)
 second.ties[source] = mini(9,int(second.ties.get(source,0))+1)
 var action: String = "Raised a ward for" if warded else "Pulled back from Death's Door:" if saved else "Tended the wounds of"
 remember(state,source,"aid:%s:%d:%s" % [target,second.generation,action],"%s %s." % [action,state.hero(target)["name"]])
 remember(state,target,"help:%s:%d:%s" % [source,first.generation,action],"%s %s." % [state.hero(source)["name"],"stood guard over me" if warded else "brought me back from Death's Door" if saved else "tended my wounds"])
static func farewell(state, id: String) -> Dictionary:
 var journal: Dictionary = ensure(state,id).duplicate(true)
 var speaker: String = ""
 var strongest: int = -1
 for ally in state.party:
  if ally == id or state.run_heroes.get(ally,{}).get("dead",false): continue
  var weight: int = int(journal.get("ties",{}).get(ally,0))
  if weight > strongest:
   strongest = weight
   speaker = ally
 var quote: String = str(personality(state,speaker)["loss"]) if not speaker.is_empty() else "No companion remained to speak. The hamlet will keep this name."
 return {"story":journal,"personality":personality(state,id)["name"],"speaker":speaker,"speaker_name":state.hero(speaker)["name"] if not speaker.is_empty() else "The hamlet","tribute":quote}
static func camp_line(state) -> String:
 for index in range(state.graves.size()-1,-1,-1):
  var grave: Dictionary = state.graves[index]
  if str(grave.get("id","")).begins_with(state.run_id+":") and grave.has("tribute"):
   if state.run_heroes.get(str(grave.get("speaker","")),{}).get("dead",false):
    return "Remembering %s. %s once said: “%s”" % [grave.name,grave.get("speaker_name","A companion"),grave.tribute]
   return "%s, remembering %s: “%s”" % [grave.get("speaker_name","The party"),grave.name,grave.tribute]
 var living: Array = state.party.filter(func(id): return not state.run_heroes.get(id,{}).get("dead",false))
 if living.is_empty(): return "The fire burns without a voice beside it."
 var id: String = living[state.floor_index%living.size()]
 return "%s: “%s”" % [state.hero(id)["name"],personality(state,id)["camp"]]
static func biography(state, id: String) -> String:
 var journal: Dictionary = ensure(state,id)
 return "Disposition: %s\n\n%s" % [personality(state,id)["name"],"\n\n".join(journal.get("memories",[])) if not journal.get("memories",[]).is_empty() else "Their story is still being written."]
