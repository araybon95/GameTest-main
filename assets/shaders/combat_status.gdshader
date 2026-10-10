shader_type canvas_item;
uniform vec3 ambient = vec3(1.0);
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
	vec3 color = base.rgb * ambient;
 // Keep bright faces readable while reducing smooth gradients to inked washes.
 float ink_luma = dot(color, vec3(0.299,0.587,0.114));
 float bands = floor(ink_luma * 10.0 + 0.5) / 10.0;
 color *= mix(1.0, bands / max(ink_luma,0.025), 0.2);
 color = clamp((color - 0.5) * 1.06 + 0.52,0.0,1.0);
	// Effects stay inside the original sprite's alpha silhouette.
	float charred = burn * (0.10 + step(0.64, grain) * 0.18);
	color *= 1.0 - charred;
	// Ash dominates; only isolated coals catch the light, rather than an orange wash.
	float coal = step(0.982, grain) * smoothstep(0.25, 0.8, UV.y);
	color = mix(color, vec3(0.69, 0.25, 0.09), burn * coal * (0.32 + pulse * 0.22));
	float cut_a = (1.0 - smoothstep(0.004, 0.014, abs(UV.y - 0.44 + (UV.x - 0.5) * 0.22))) * smoothstep(0.28, 0.36, UV.x) * (1.0 - smoothstep(0.59, 0.68, UV.x));
	float cut_b = (1.0 - smoothstep(0.006, 0.018, abs(UV.y - 0.61 - (UV.x - 0.5) * 0.13))) * smoothstep(0.4, 0.47, UV.x) * (1.0 - smoothstep(0.65, 0.74, UV.x));
	float scratch = max(cut_a, cut_b) * (0.65 + grain * 0.35);
	color = mix(color, vec3(0.32, 0.035, 0.055), scratch * max(bleed * 0.90, wounded * 0.65));
	float blotch = smoothstep(0.25, 0.77, sin(UV.x * 32.0 + sin(UV.y * 21.0) * 2.0) * 0.5 + 0.5);
	color = mix(color, vec3(0.25, 0.31, 0.16), poison * (0.10 + blotch * 0.12 + pulse * 0.025));
	float frost = step(0.967, grain) * (0.5 + pulse * 0.15);
	color = mix(color, vec3(0.47, 0.61, 0.65), chill * (0.13 + frost * 0.28));
	// Brief bruised recoil remains distinct from a bright spell or a healing flash.
	color *= 1.0 - impact * 0.08;
	color = mix(color, vec3(0.53, 0.32, 0.27), impact * (0.14 + scratch * 0.30));
	float gray = dot(color, vec3(0.299, 0.587, 0.114));
	color = mix(color, vec3(gray * 0.55), slain);
	COLOR = vec4(color, base.a);
}
