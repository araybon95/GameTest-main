extends RefCounted
## Presentation study only. Does not access combat state, damage, AP or RNG.
const RELEASE = 0.16
const IMPACT = 0.26
const HOLD = 0.065
const DURATION = 0.56
static func sample(age: float) -> Dictionary:
 var phase: String = "READY" if age < 0 or age >= DURATION else "DRAW BACK" if age < RELEASE else "STRIKE" if age < IMPACT else "CONTACT HOLD" if age < IMPACT+HOLD else "RECOVER"
 var shift: float = 0.0
 if phase == "DRAW BACK": shift = -8.0*smoothstep(0,RELEASE,age)
 elif phase == "STRIKE": shift = lerpf(-8,35,smoothstep(RELEASE,IMPACT,age))
 elif phase == "CONTACT HOLD": shift = 35.0
 elif phase == "RECOVER": shift = 35.0*(1-smoothstep(IMPACT+HOLD,DURATION,age))
 var pose: int = -1 if phase == "READY" else 0 if phase == "DRAW BACK" else 1 if phase in ["STRIKE","CONTACT HOLD"] else 2
 return {"phase":phase,"source":pose,"source_x":shift,"contact":age >= IMPACT and age < DURATION,"recover":smoothstep(IMPACT+HOLD,DURATION,age)}
