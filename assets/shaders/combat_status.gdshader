shader_type canvas_item;
uniform float burn = 0.0;
uniform float bleed = 0.0;
uniform float poison = 0.0;
uniform float chill = 0.0;
uniform float wounded = 0.0;
uniform float impact = 0.0;
uniform float slain = 0.0;

void fragment() {
	// Fragment COLOR already includes the texture and vertex tint.
	vec4 base = COLOR;
	float pulse = 0.5 + 0.5 * sin(TIME * 4.0);
	float grain = fract(sin(dot(floor(UV * 95.0), vec2(12.9898, 78.233))) * 43758.5453);
	vec3 color = base.rgb;
	// Effects stay inside the original sprite's alpha silhouette.
	float charred = burn * (0.13 + grain * 0.12);
	color *= 1.0 - charred;
	color = mix(color, vec3(1.0, 0.32, 0.05), burn * (0.18 + pulse * 0.16) * (0.4 + UV.y * 0.6));
	float cut_a = (1.0 - smoothstep(0.004, 0.014, abs(UV.y - 0.44 + (UV.x - 0.5) * 0.22))) * smoothstep(0.28, 0.36, UV.x) * (1.0 - smoothstep(0.59, 0.68, UV.x));
	float cut_b = (1.0 - smoothstep(0.006, 0.018, abs(UV.y - 0.61 - (UV.x - 0.5) * 0.13))) * smoothstep(0.4, 0.47, UV.x) * (1.0 - smoothstep(0.65, 0.74, UV.x));
	float scratch = max(cut_a, cut_b) * (0.65 + grain * 0.35);
	color = mix(color, vec3(0.55, 0.015, 0.035), scratch * max(bleed * 0.88, wounded * 0.65));
	color = mix(color, vec3(0.22, 0.7, 0.13), poison * (0.17 + pulse * 0.08));
	float frost = step(0.92, grain) * (0.45 + pulse * 0.2);
	color = mix(color, vec3(0.6, 0.89, 1.0), chill * (0.2 + frost * 0.25));
	color = mix(color, vec3(1.0, 0.12, 0.08), impact * 0.6);
	float gray = dot(color, vec3(0.299, 0.587, 0.114));
	color = mix(color, vec3(gray * 0.55), slain);
	COLOR = vec4(color, base.a);
}
