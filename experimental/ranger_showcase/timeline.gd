extends RefCounted
## Visual probe only. No damage, rewards, combat RNG or game-state dependency.
const SHOT_ONE = 0.34
const HIT_ONE = 0.46
const RENOCK = 0.50
const SHOT_TWO = 0.70
const HIT_TWO = 0.82
const FALL_END = 1.16
const DURATION = 2.2
static func sample(age: float) -> Dictionary:
 var source: int = 0 if age < SHOT_ONE else 1 if age < RENOCK else 2 if age < 0.60 else 3 if age < SHOT_TWO else 4 if age < 1.05 else 5
 var target: int = -1 if age < HIT_ONE else 0 if age < HIT_TWO else 1 if age < 0.90 else 2 if age < 1.00 else 3 if age < FALL_END else 4
 var phase: String = "FIRST DRAW" if age < SHOT_ONE else "STOMACH SHOT" if age < HIT_ONE else "RENOCK / WEAPON DROP" if age < SHOT_TWO else "SECOND SHOT" if age < HIT_TWO else "INSTANT LOSS OF TENSION" if age < FALL_END else "FINISHED"
 return {"source":source,"target":target,"phase":phase,"dropped":age >= HIT_ONE,"dead":age >= HIT_TWO,"complete":age >= DURATION}
