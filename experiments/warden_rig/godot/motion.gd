extends RefCounted
const PERIOD: float = 1.3
const STANCE: float = 0.62
const STRIDE: float = 40.0
const SPEED: float = STRIDE/STANCE/PERIOD
static func foot(seconds: float, offset: float) -> Vector2:
	var phase: float = fposmod(seconds/PERIOD+offset,1.0)
	if phase < STANCE: return Vector2(20.0-STRIDE*phase/STANCE,0)
	var swing: float = (phase-STANCE)/(1.0-STANCE)
	# Match the stance's backward velocity at both joins, avoiding a foot snap.
	var derivative: float = -STRIDE*(1.0-STANCE)/STANCE
	var t2: float = swing*swing
	var t3: float = t2*swing
	var x: float = (2*t3-3*t2+1)*-20.0+(t3-2*t2+swing)*derivative+(-2*t3+3*t2)*20.0+(t3-t2)*derivative
	return Vector2(x,-11.0*pow(sin(PI*swing),2))
static func solve(origin: Vector2, target: Vector2, upper: float, lower: float, bend: float = -1.0) -> Vector2:
	var delta := target-origin
	var distance: float = clampf(delta.length(),absf(upper-lower)+0.001,upper+lower-0.001)
	var base: float = delta.angle()-PI/2.0
	var spread: float = acos(clampf((upper*upper+distance*distance-lower*lower)/(2.0*upper*distance),-1,1))
	var first: float = base+bend*spread
	var knee: Vector2 = origin+Vector2.DOWN.rotated(first)*upper
	return Vector2(first,(target-knee).angle()-PI/2.0-first)
