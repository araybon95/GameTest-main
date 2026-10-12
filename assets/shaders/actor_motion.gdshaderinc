// Shared by the portrait and its equipment trim so layered art stays registered.
uniform bool actor_motion = false;
uniform vec2 actor_size = vec2(1.0);
uniform vec3 actor_profile = vec3(0.8,0.7,0.0);
uniform float actor_clock = 0.0;
uniform float actor_stride = 0.0;
uniform float actor_walking = 0.0;
vec2 animate_actor_vertex(vec2 point) {
	if (!actor_motion) return point;
	float upper = 1.0-clamp(point.y/max(actor_size.y,1.0),0.0,1.0);
	float phase = actor_profile.z;
	float breath = sin(actor_clock*1.55+phase)*0.85*actor_profile.x;
	float idle = sin(actor_clock*0.72+phase)*0.28;
	float step = sin(actor_stride+phase)*0.9*actor_walking;
	float lift = sin(actor_stride*2.0+phase)*0.30*actor_walking;
	float height_scale = actor_size.y/280.0;
	point.x += upper*(idle+step)*actor_profile.y*height_scale;
	point.y -= upper*(breath+lift)*height_scale;
	return point;
}
