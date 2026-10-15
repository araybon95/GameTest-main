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

static func cleaver(age: float, reduced: bool, dimensions: Vector2) -> Dictionary:
 var flight: float = 1.0 if reduced else clampf((age-0.52)/0.30,0,1)
 var settle: float = 1.0 if reduced else smoothstep(0.82,0.94,age)
 var rotation: float = lerpf(0.85,0.10,flight)+lerpf(0.0,-0.10,settle)
 var depth: float = lerpf(1.0,0.30,smoothstep(0.65,0.88,age)) if not reduced else 0.30
 var extent: float = (absf(sin(rotation))*dimensions.x+absf(cos(rotation))*dimensions.y*depth)*0.5
 var floor_y: float = 580.0-extent
 var center := Vector2(lerpf(1000,1040,flight),lerpf(480,floor_y,flight*flight))
 if not reduced and age >= 0.82 and age < 0.94:
  center.y = floor_y-sin(settle*PI)*4.0
 center.y = minf(center.y,floor_y)
 return {"center":center,"rotation":rotation,"depth":depth}
