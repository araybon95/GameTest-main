extends RefCounted
## Presentation-only timing; damage and resource costs remain in the controller.
const PROFILES: Dictionary = {
 "light":{"duration":0.66,"release":0.12,"impact":0.25,"hold":0.055,"travel":45.0,"pullback":9.0,"tilt":0.11,"recoil":15.0},
 "heavy":{"duration":1.06,"release":0.36,"impact":0.50,"hold":0.16,"travel":78.0,"pullback":24.0,"tilt":0.17,"recoil":30.0},
 "charge":{"duration":1.00,"release":0.23,"impact":0.39,"hold":0.13,"travel":165.0,"pullback":16.0,"tilt":0.09,"recoil":27.0},
 "bow":{"duration":0.86,"release":0.31,"impact":0.46,"hold":0.065,"travel":0.0,"pullback":18.0,"tilt":0.045,"recoil":18.0},
 "spell":{"duration":0.97,"release":0.35,"impact":0.51,"hold":0.10,"travel":10.0,"pullback":4.0,"tilt":0.045,"recoil":20.0},
 "heal":{"duration":0.82,"release":0.24,"impact":0.38,"hold":0.09,"travel":0.0,"pullback":0.0,"tilt":0.025,"recoil":0.0},
 "guard":{"duration":0.68,"release":0.14,"impact":0.25,"hold":0.09,"travel":5.0,"pullback":0.0,"tilt":0.03,"recoil":0.0},
 "object":{"duration":0.80,"release":0.23,"impact":0.36,"hold":0.08,"travel":42.0,"pullback":12.0,"tilt":0.12,"recoil":0.0}
}
const SKILLS: Dictionary = {"wd_heavy":"heavy","wd_bash":"heavy","pc_verdict":"heavy","pc_charge":"charge","rg_quick":"bow","rg_volley":"bow","rg_pierce":"bow","oc_hex":"spell","oc_drain":"spell","oc_blast":"spell","hl_smite":"spell","hl_turn":"spell"}

static func resolve(kind: String, title: String, options: Dictionary, boss: bool = false, legacy_duration: float = 0.76) -> Dictionary:
 if options.is_empty():
  var duration: float = 1.04 if boss else legacy_duration
  var factor: float = duration/legacy_duration
  return {"id":"legacy","duration":duration,"release":0.13*factor,"impact":0.28*factor,"hold":0.10*factor,"canonical_duration":legacy_duration}
 var chosen: String = str(options.get("profile",""))
 if not PROFILES.has(chosen):
  chosen = str(SKILLS.get(str(options.get("skill_id","")),""))
 if chosen.is_empty():
  var effect: String = str(options.get("effect",""))
  var caption: String = title.to_lower()
  chosen = "heal" if kind == "heal" else "guard" if kind == "block" else "object" if kind == "object" else "bow" if kind in ["bow","arrow"] else "spell" if kind == "spell" else "charge" if effect == "barbed_charge" or caption.contains("charge") else "heavy" if caption.contains("heavy") or caption.contains("verdict") or caption.contains("crushing") else "light"
 var result: Dictionary = PROFILES[chosen].duplicate()
 # Giants and armored floor guardians commit to a heavier swing, not a light jab.
 if boss and chosen == "light" and str(options.get("creature","")) in ["harrowed_giant","keep_son","undying_lord","moth_oleander"]:
  chosen = "heavy"
  result = PROFILES[chosen].duplicate()
 result["id"] = chosen
 if boss:
  for key in ["duration","release","impact","hold"]: result[key] = float(result[key])*1.12
 return result

static func sample(timing: Dictionary, age: float) -> Dictionary:
 var release: float = timing["release"]
 var contact: float = timing["impact"]
 var hold_end: float = contact+float(timing["hold"])
 var duration: float = timing["duration"]
 var windup: float = clampf(age/maxf(0.001,release),0,1)
 var flight: float = clampf((age-release)/maxf(0.001,contact-release),0,1)
 var recovery: float = clampf((age-hold_end)/maxf(0.001,duration-hold_end),0,1)
 var phase: String = "windup" if age < release else "release" if age < contact else "hold" if age < hold_end else "recover" if age < duration else "complete"
 var clock: float
 if timing.get("id","") == "legacy":
  clock = age*float(timing.get("canonical_duration",0.76))/duration
 elif age < release: clock = windup*0.11
 elif age < contact: clock = 0.13+flight*0.15
 elif age < hold_end: clock = 0.28+clampf((age-contact)/maxf(0.001,hold_end-contact),0,1)*0.10
 else: clock = 0.38+recovery*0.38
 return {"phase":phase,"clock":clock,"windup":windup,"flight":flight,"recovery":recovery,"contact":age >= contact,"hold_end":hold_end}

static func motion(timing: Dictionary, age: float) -> Dictionary:
 var frame: Dictionary = sample(timing,age)
 var phase: String = frame["phase"]
 var windup: float = frame["windup"]
 var flight: float = frame["flight"]
 var recovery: float = frame["recovery"]
 var pullback: float = timing["pullback"]
 var travel: float = timing["travel"]
 var tilt: float = timing["tilt"]
 var profile: String = timing["id"]
 var source_x: float = -pullback*sin(windup*PI*0.5)
 var rotation: float = -tilt*0.55*windup
 if phase == "release":
  var forward: float = pow(flight,1.65 if profile == "charge" else 0.65)
  source_x = lerpf(-pullback,travel,forward)
  rotation = lerpf(-tilt*0.55,tilt,forward)
 elif phase in ["hold","recover","complete"]:
  source_x = travel*pow(1.0-recovery,2.0)
  rotation = tilt*(1.0-recovery)
 if profile == "bow":
  if phase == "release":
   source_x = -pullback*(1.0-flight)-14*sin(flight*PI)
   rotation = -tilt+0.09*sin(flight*PI)
  elif phase in ["hold","recover","complete"]:
   source_x = -4*(1.0-recovery)
   rotation = -0.012*(1.0-recovery)
 var contact: float = clampf((age-float(timing["impact"]))/0.025,0,1)*pow(1.0-recovery,1.6)
 return {"source_x":source_x,"rotation":rotation,"reaction":contact,"recoil":float(timing["recoil"])*contact}
