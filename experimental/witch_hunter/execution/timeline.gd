extends RefCounted
## Presentation only: no damage, rewards, game state or random numbers.
const UPPERCUT = 0.40
const CRUSH = 1.03
const FALL_END = 1.50
const DURATION = 2.50
static func sample(age: float) -> Dictionary:
 var source: int = -1 if age < 0.18 else 0 if age < 0.60 else 1 if age < CRUSH else 2 if age < 1.72 else -1
 var target: int = -1 if age < UPPERCUT else 0 if age < CRUSH else 1 if age < FALL_END else 2
 var phase: String = "CLOSE / LOAD" if age < 0.18 else "HAMMER UPPERCUT" if age < 0.60 else "OVERHEAD WINDUP" if age < CRUSH else "CRUSH / BODY BUCKLES" if age < FALL_END else "FINISHED"
 return {"source":source,"target":target,"phase":phase,"dead":age >= CRUSH,"complete":age >= DURATION}
