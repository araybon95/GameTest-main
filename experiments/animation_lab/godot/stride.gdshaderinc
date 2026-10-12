uniform vec2 actor_size = vec2(330.0);
uniform vec4 leg_profile = vec4(0.7,0.25,0.7,1.0);
uniform float clock = 0.0;
uniform float gait = 0.0;
uniform float phase = 0.0;
uniform float walking = 0.0;
uniform float animated = 1.0;
uniform float stride_length = 12.0;
uniform float foot_lift = 5.0;
uniform float cloth_sway = 2.0;
uniform float body_bob = 0.8;
vec2 deform_actor(vec2 point) {
	vec2 n = point/max(actor_size,vec2(1.0));
	float upper = 1.0-clamp(n.y,0.0,1.0);
	float scale = actor_size.y/280.0;
	float step = gait+phase;
	point.x += upper*(sin(clock*0.72+phase)*0.28+sin(step)*0.7*walking)*scale;
	point.y -= upper*sin(clock*1.55+phase)*0.85*scale;
	float amount = walking*animated;
	float leg = smoothstep(leg_profile.z,0.97,n.y);
	float across = smoothstep(leg_profile.x-leg_profile.y-0.07,leg_profile.x-leg_profile.y,n.x)
		*(1.0-smoothstep(leg_profile.x+leg_profile.y,leg_profile.x+leg_profile.y+0.07,n.x));
	float side = smoothstep(leg_profile.x-0.025,leg_profile.x+0.025,n.x)*2.0-1.0;
	float swing = sin(step)*side;
	point.x += swing*stride_length*leg*across*amount*leg_profile.w*scale;
	point.y -= max(swing,0.0)*foot_lift*leg*across*amount*leg_profile.w*scale;
	float cloth = smoothstep(0.22,0.72,n.y)*(1.0-smoothstep(0.86,1.0,n.y))
		*(1.0-smoothstep(0.34,0.56,n.x));
	point.x += sin(step-0.7+n.y*1.8)*cloth_sway*cloth*amount*scale;
	point.y += sin(step*2.0-0.25)*body_bob*upper*amount*scale;
	return point;
}
