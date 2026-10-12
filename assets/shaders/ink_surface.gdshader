shader_type canvas_item;
uniform bool illustrated = false;
uniform vec4 accent : source_color = vec4(0.6,0.5,0.35,1.0);
uniform vec2 surface_size = vec2(400.0,300.0);
uniform float active = 0.0;
varying vec4 modulation;
void vertex() { modulation = COLOR; }
void fragment() {
	vec2 p = floor(UV*surface_size);
	float grain = fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);
	float brush = sin(p.y*0.11+p.x*0.008)*0.5+0.5;
	float edge = pow(abs(UV.x-0.5)*2.0,4.0);
	if (illustrated) {
		vec3 art = texture(TEXTURE,UV).rgb;
		float shade = mix(0.44,0.10,smoothstep(0.15,0.88,UV.y));
		vec3 color = art*shade*(1.0-edge*0.42)+accent.rgb*(0.012+active*0.012);
		COLOR = vec4(color+grain*0.008,0.96);
	} else {
		COLOR = vec4(vec3(0.09,0.068,0.047)+accent.rgb*active*0.035,0.10+edge*0.10+grain*0.025+brush*0.025);
	}
	COLOR *= modulation;
}
